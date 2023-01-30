;-----------------------------------------------------------------------------------------------------------------------------
    ; @file	    Ejercicio02
    ; @date	    30/01/2023
    ; @author	    ROMERO ROMERO LUIS ANGEL
    ; @ide	    1332020043
    ; @ensamblador  MPLAB X IDE v6.05 para PIC18F57Q84
    ; @brief	    El siguiente programa es una aplicación de interrupciones de alta y baja prioridad, para visualizar dichas 
    ;		    interrupciones he colocado dos pulsadores externos que van a representar las interrupciones de alta 
    ;		    prioridad, he colocado dichos pulsadores en los pines RB4 Y RF2, el pulsador interno de la placa inicia
    ;		    una secuencia de leds como se muestra en la etiqueta table, el pulsador RB4 detiene la secuencia, y el 
    ;		    pulsador de RF2 reinicia el blink led de la placa.
    ;-------------------------------------------------------------------------------------------------------------------------
    
PROCESSOR 18F57Q84
#include "Bit_Config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
;-----------------------------------------------------------------------------------------------------------------------------
; PULSADOR RA3    
PSECT ISRVectBajaPriority,class=CODE,reloc=2
ISRVectBajaPriority:
    BTFSS   PIR1,0,0			 ; ¿Se ha producido la INT0?
    GOTO    Exit0	 
Leds_on:
    BCF	    PIR1,0,0			 ; limpiamos el flag de INT0
    GOTO    Reload			 ; Secuencia de leds
Exit0:
    RETFIE				 ; Fin de la interrupcion
;-----------------------------------------------------------------------------------------------------------------------------
; PULSADOR RF2 Y RB4    
PSECT ISRVectAltaPriority,class=CODE,reloc=2
ISRVectAltaPriority:
    BTFSS   PIR10,0,0			 ; ¿Se ha producido la INT2(RF2)?
    GOTO    ISRVectAltaPriority2	 ; GOTO INT1(RB4)
Leds:
    BCF	    PIR10,0,0			 ; limpiamos el flag de INT2
    GOTO    FINALEXIT			 ; Se resetea
Exit:
    RETFIE
;---------------------------------------------------------------------------------------------------------------------------

PSECT udata_acs
contador1:  DS 1	    
contador2:  DS 1
contador3:  DS 1
offset:	    DS 1
offset1:    DS 1
counter:    DS 1
counter1:   DS 1 
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2,1
    GOTO    Toggle_Led
    
    
Toggle_Led:
   BTFSC   PIR10,0,0			;¿Se ha producido la INT2?
   GOTO	   ISRVectAltaPriority	    
   BTG	   LATF,3,0		    
   CALL    Delay_500ms,1	    
   goto	   Toggle_Led		    

Loop:
    BANKSEL PCLATU		    
    MOVLW   low highword(Table)	    
    MOVWF   PCLATU,1		    
    MOVLW   high(Table)		    
    MOVWF   PCLATH,1		    
    RLNCF   offset,0,0		    
    CALL    Table		    
    MOVWF   LATC,0		    
    CALL    Delay_250ms,1	    
    DECFSZ  counter,1,0		    
    GOTO    Siguiente		    
    
 Comprueba:		;Comprueba si es que ha llegado a 0
    DECFSZ  counter1,1,0	    
    GOTO    Reload2		    
    Goto    Toggle_Led		    
    
 Siguiente:		;Siguiente secuencia de led
    INCF    offset,1,0		    
    GOTO    Loop		    
    
Reload:
    MOVLW   0x05	
    MOVWF   counter1,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    
Reload2:
    MOVLW   0x0A	
    MOVWF   counter,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    GOTO    Loop
    
Table:
    ADDWF   PCL,1,0
    RETLW   10000001B	; offset: 0
    RETLW   01000010B	; offset: 1
    RETLW   00100100B	; offset: 2
    RETLW   00011000B	; offset: 3
    RETLW   00000000B	; offset: 4 -> se apagan todos
    RETLW   00011000B	; offset: 5
    RETLW   00100100B	; offset: 6
    RETLW   01000010B	; offset: 7
    RETLW   10000001B	; offset: 8
    RETLW   00000000B	; offset: 9    
    
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60	    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02	    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
   
Config_Port:	
    ;Config Led
    BANKSEL PORTF	    
    CLRF    PORTF,1	     
    BSF	    LATF,3,1	    ;<PuertoF> = 0
    CLRF    ANSELF,1	    ;PuertoF como digital
    BCF	    TRISF,3,1	    ;RF3 como salida
    
    ;Config User Button
    BANKSEL PORTA	    
    CLRF    PORTA,1	    ;PORTA=0
    CLRF    ANSELA,1	    ;ANSEL digital
    BSF	    TRISA,3,1	    ;RA3 como entrada 
    BSF	    WPUA,3,1	    ;Activamos la resistencia Pull-up del pin RA3
    
    ;Config Ext Button
    BANKSEL PORTB	    
    CLRF    PORTB,1	    ;PORTB=0
    CLRF    ANSELB,1	    ;ANSEL digital
    BSF	    TRISB,4,1	    ;RB4 como entrada 
    BSF	    WPUB,4,1	    ;Activamos la resistencia Pull-up del pin RB4
    
    ;Config Ext Button2
    BANKSEL PORTF
    CLRF    PORTF,1	    ;PORTB=0
    CLRF    ANSELF,1	    ;ANSEL digital
    BSF	    TRISF,2,1	    ;RF2 como entrada 
    BSF	    WPUB,2,1	    ;Activamos la resistencia Pull-up del pin RF2
    
    ;Config PORTC
    BANKSEL PORTC
    CLRF    PORTC,1	    
    CLRF    LATC,1	    ;<PuertoD>=0
    CLRF    ANSELC,1	    ;PuertoD digital
    CLRF    TRISC,1	    ;PuertoD como salida
    RETURN
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	    ; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	    ; INT1 --> RB4
    
    ;Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	    ; INT2 --> RF2
    
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
    
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 --  INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 1 --  INT1 de alta prioridad
    BSF	IPR10,0,1   ; IPR10<INT2IP> = 1 -- INT2 de alta prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT0IE> = 1 -- habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN 
;------------------------------------------------------------------------------------------------------------------------    
; Pulsador de RB4    
ISRVectAltaPriority2:	; Pulsador de RB4
    BTFSS   PIR6,0,0	; ¿Se ha producido la INT1?
    GOTO    Exit	
    GOTO    Toggle_Led	
;-------------------------------------------------------------------------------------------------------------------------    
Delay_250ms:				    ; 2Tcy -- Call
    MOVLW   250				    ; 1Tcy -- k2
    MOVWF   contador2,0			    ; 1Tcy
; T = (6 + 4k)us			    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249				    ; 1Tcy -- k1
    MOVWF   contador1,0			    ; 1Tcy
Int_Loop:
    NOP					    ; k1*Tcy
    DECFSZ  contador1,1,0		    ; (k1-1)+ 3Tcy
    GOTO    Int_Loop			    ; (k1-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop
    RETURN				    ; 2Tcy

Delay_500ms:
    MOVLW 2
    MOVWF contador3,0
    Loop_250ms:				    ;2tcy
    MOVLW 250				    ;1tcy
    MOVWF contador2,0			    ;1tcy
    Loop_1ms8:			     
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
    INT_LOOP8:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		     ;251k TCY 
    Goto    INT_LOOP8			;496k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    Loop_1ms8			    ;(k-1)*2tcy
    DECFSZ  contador3,1,0
    GOTO Loop_250ms
    RETURN  
    
FINALEXIT:     
End resetVect


