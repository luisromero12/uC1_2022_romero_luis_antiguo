PROCESSOR 18F57Q84
    
#include "Bit_config.inc"   /* config statements should precede project file includes.*/
#include <xc.inc>
#include "Retardos.inc"
    
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT CODE
;-------------------------------------------------------------------------------------------------------------------------
   ; @file	    P1-Corrimiento_Leds
   ; @date	    14/01/2023
   ; @author	    ROMERO ROMERO LUIS ANGEL
   ; @ide	    1332020043
   ; @ensamblador   MPLAB X IDE v6.05 para PIC18F57Q84
   ; @brief	    El siguiente programa realiza una serie de corrimientos paras e imparea, el corrimiento inicia cuando
   ;		    presionamos el pulsador, y se detiene cuando lo volvemos a presionar, para poder diferenciar el corrimiento
   ;		    par del impar se ha colocado dos LED en RE1 Y RE0 que representan el corrimeinto par e impar, si el pulsador
   ;		    se vuelve a presionar por tercera vez el corrimiento se reinicia.
   ;---------------------------------------------------------------------------------------------------------------------   
Main: 
    
   CALL	    Config_Osc,1
   CALL	    Config_Port,1

   
STAR:					;El corrimiento incia cuando presiono el pulsador
   BANKSEL	PORTA 
   BTFSC        PORTA,3,0		;Buttom press?
   GOTO		OFF			;LEDS off
    
   
PAR:					
    BSF	    LATE,1,1			;Led par encendido
    BCF	    LATE,0,1			;Led impar apagado
    MOVLW   00000010B			
    MOVWF   LATC,1			;Corrimiento a la posicion 2
    CALL    DELAY_500MS,1		;Retardo par
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS1		
    
    MOVLW   000001000B			
    MOVWF   LATC,1			;Corrimiento a la posicion 4
    CALL    DELAY_500MS,1		;Retardo par
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS1		
    
    MOVLW   00100000B			
    MOVWF   LATC,1			;Corrimiento a la posicion 6
    CALL    DELAY_500MS,1		;Retardo par    
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS1		
	
    MOVLW   10000000B			    
    MOVWF   LATC,1			;Corrimiento a la posicion 8    
    CALL    DELAY_500MS,1		;Retardo par    
    BTFSS   PORTA,3,0			;Buttom press?    
    GOTO    BUTTOMPRESS1		    
    
            
IMPAR:
    BSF	    LATE,0,1			;Led impar encendido
    BCF	    LATE,1,1			;Led par apagado
    MOVLW   00000001B			
    MOVWF   LATC,1			;Corrimiento a la posicion 1
    CALL    DELAY_250MS,1		;Retardo impar
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS2		
    
    MOVLW   00000100B			
    MOVWF   LATC,1			;Corrimiento a la posicion 3
    CALL    DELAY_250MS,1		;Retardo impar
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS2		
    
    MOVLW   00010000B			
    MOVWF   LATC,1			;Corrimiento a la posicion 5
    CALL    DELAY_250MS,1		;Retardo impar
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS2		
    
    MOVLW   01000000B			
    MOVWF   LATC,1			;Corrimiento a la posicion 7
    CALL    DELAY_250MS,1		;Retardo impar
    BTFSS   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS2		
    
    GOTO    PAR				
    
    
BUTTOMPRESS1:				;Led stop del corrimiento par
    CALL    DELAY_250MS,1
    CALL    DELAY_500MS,1
    BTFSC   PORTA,3,0			
    GOTO    BUTTOMPRESS1		
    GOTO    PAR	
    
    
BUTTOMPRESS2:				;Led stop del corrimiento impar
    CALL    DELAY_250MS,1		;Retardo 
    CALL    DELAY_500MS,1		;Retardo
    BTFSC   PORTA,3,0			;Buttom press?
    GOTO    BUTTOMPRESS2		
    GOTO    IMPAR			

    
OFF:					;Todos los leds apagados
   CLRF		LATC,1			;PuertoC apagado
   BCF		LATE,0,1		;RE0 apagado
   BCF		LATE,1,1		;RE1 apagado
   BTFSC        PORTA,3,0		;Buttom press?
   GOTO		OFF			
   GOTO		PAR			
    
  
Config_Osc:
    ;Configuracion de un oscilador interno a una frecuencia de 4 MHz
    BANKSEL OSCCON1	
    MOVLW   0X60			;seleccionamos el bloque del osc interno con un div:1
    MOVWF   OSCCON1,1	
    MOVLW   0X02			;seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ,1	
    RETURN     

    
Config_Port:				;PORT-LAT-ANSEL-TRIS	Pulsador: RA3
    ;Config puerto C
    BANKSEL	PORTC
    CLRF	TRISC,1			;Puerto c como salida
    
    ;Config Buttom
    BANKSEL	PORTA
    CLRF	PORTA,1			;PORTA=0
    CLRF	ANSELA,1		;ANSEL digital
    BSF		TRISA,3,1		;RA3 como entrada 
    BSF		WPUA,3,1		;Activamos la resistencia Pull-up del pin RA3
    ;Config puerto E
    BANKSEL	PORTE
    CLRF	PORTE,1			;PORTE=0
    CLRF	ANSELE,1		;ANSELE digital
    BCF		TRISE,0,1		;RE0 como salida
    BCF		TRISE,1,1		;RE1 como salida
    RETURN  
    


END resetVect


