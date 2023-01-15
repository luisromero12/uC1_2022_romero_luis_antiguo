PROCESSOR 18F57Q84
    
#include "bit_config.inc"   /* config statements should precede project file includes.*/
#include <xc.inc>  
    
    
PSECT udata_acs
contador1: DS 1	    ;reserva un byte en access ram 
contador2: DS 1     ;reserva un byte en access ram
contador3: DS 1	    ;reserva un byte en access ram
    

    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT CODE
 ;--------------------------------------------------------------------------------------------------------------------------------
    ; @file	    P2-Display_7SEG
    ; @date	    14/01/2023
    ; @author	    ROMERO ROMERO LUIS ANGEL
    ; @ide	    1332020043
    ; @ensamblador  MPLAB X IDE v6.05 para PIC18F57Q84
    ; @brief	    El siguiente programa tiene como objetivo mostrar el conteo hexadecimal del 0 al F, bajo las siguientes 
    ;		    condiciones, cunado el pulsador no este presionado, se obserba el conteo ascendente del 0 al 9, pero cuando
    ;		    se mantiene presionado dicho pulsador, empieza a contar del A al F, para ello hemos usado el puerto D,
    ;		    que representan los leds dentro del display, hemos trabajado con una frecuencia de 4Mz.
    ;--------------------------------------------------------------------------------------------------------------------------- 
Main: 
   CALL	    Config_Osc,1
   CALL	    Config_Port,1
   CALL	    DELAY_1000MS,1

   
   BANKSEL  PORTA		    
   BTFSS    PORTA,3,0		    	;Buttom press?
   GOTO	    CONTEO_A_F			
   
   
CONTEO_0_9:
    MOVLW   01000000B			
    MOVWF   LATD,1			;Display=0
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   01111001B			
    MOVWF   LATD,1			;Display=1
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   00100100B			
    MOVWF   LATD,1			;Display=2
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   00110000B			
    MOVWF   LATD,1			;Display=3
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   00011001B			
    MOVWF   LATD,1			;Display=4
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   00010010B			
    MOVWF   LATD,1			;Display=5
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   00000011B			
    MOVWF   LATD,1			;Display=6
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   01111000B			
    MOVWF   LATD,1			;Display=7
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    MOVLW   00000000B			
    MOVWF   LATD,1			;Display=8
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
	
    MOVLW   00011000B			
    MOVWF   LATD,1			;Display=9
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
	    
    GOTO    CONTEO_0_9			
    
    
CONTEO_A_F:    
    MOVLW   00001000B			
    MOVWF   LATD,1			;Display=A
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_0_9			
	
    MOVLW   000000011B			
    MOVWF   LATD,1			;Display=B
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_0_9			
    
    MOVLW   01000110B			
    MOVWF   LATD,1			;Display=C
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_0_9			
    
    MOVLW   0100001B			
    MOVWF   LATD,1			;Display=D
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_0_9			
	
    MOVLW   00000110B			
    MOVWF   LATD,1			;Display=E
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_0_9			
    
    MOVLW   00001110B			
    MOVWF   LATD,1			;Display=F
    CALL    DELAY_1000MS,1		;Retardo de 1 segundo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    CONTEO_A_F			
    
    GOTO    CONTEO_A_F			
    
    
Config_Osc:
    ;Configuracion de un oscilador interno a una frecuencia de 4 MHz
    BANKSEL OSCCON1	
    MOVLW   0X60			;seleccionamos el bloque del osc interno con un div:1
    MOVWF   OSCCON1,1	
    MOVLW   0X02			;seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ,1	
    RETURN   

Config_Port:				;PORT-LAT-ANSEL-TRIS
    BANKSEL	PORTF
    CLRF	TRISD,0			;Puerto d como salida
    
    ;Config Buttom
    BANKSEL	PORTA
    CLRF	PORTA,1			;PORTA=0
    CLRF	ANSELA,1		;ANSEL digital
    BSF		TRISA,3,1		;RA3 como entrada 
    BSF		WPUA,3,1		;Activamos la resistencia Pull-up del pin RA3
    RETURN  
    
    
DELAY_1000MS:				;2Tcy --Call
    MOVLW   4				;1Tcy -- k3
    MOVWF   contador3,0			;1Tcy

Delay_250ms:				
    MOVLW   250				;1Tcy -- k2
    MOVWF   contador2,0			;1Tcy
; T= (6+4k)us				1Tcy=1us    
E250ms_Loop:				
    MOVLW   249				;1TCY -- k1
    MOVWF   contador1,0			;1Tcy
I250ms_Loop:				
    NOP					;k1*Tcy
    DECFSZ  contador1,1,0		;(k1-1)+ 3Tcy
    GOTO    I250ms_Loop			;(k1-1)*2Tcy
    DECFSZ  contador2,1,0		;1Tcy
    GOTO    E250ms_Loop			;1Tcy
    DECFSZ  contador3,1,0		;1Tcy
    GOTO    Delay_250ms			;1Tcy
    RETURN				;2Tcy
   
 
   
END resetVect


  