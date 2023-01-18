PSECT udata_acs
contador1: DS 1	    ;reserva un byte en access ram 
contador2: DS 1     ;reserva un byte en access ram
contador3: DS 1	    ;reserva un byte en access ram

;-------------------------------------------------------------------------------------------------------------------------
    ; @file	    Retardos.inc
    ; @date	    7/01/2023
    ; @author	    ROMERO ROMERO LUIS ANGEL
    ; @ide	    1332020043
    ; @ensamblador  MPLAB X IDE v6.05 para PIC18F57Q84
    ; @brief	    Esta libreria contiene un conjunto de retardos, para poder ver su funcionamiento se puede implementarlos
    ;		    con el led que viene incorporado en el PIC, de tal manera que se va prender y apagar de manera consecutiva
    ;		    dependiendo del tipo de retardo que usemos, para ello hemos configurado el oscilador usando los registros
    ;		    OSCCON1 y OSCFRQ que nos permiten definir el tipo de oscilador, la frecuencia a la que trabaja y el número
    ;		    de divisiones, para todo este proceso se ha usado una frecuencia de oscilador de 4 MHz.
    ;		    En segundo lugar se ha modificado los puertos poniendo en práctica los conocimientos adquiridos en clase, y
    ;		    finalmente viene la creacion de los 15 retardos solicitados con su respectiva verificacion en el Stopwatch.
    ;---------------------------------------------------------------------------------------------------------------------    
    
PSECT code
;T=(6+4k) 
Delay_10us:			 ; 2Tcy --Call
   MOVLW   1			 ; 1Tcy
   MOVWF   contador1,0		 ; 1Tcy 
Delay_loop1:	
    NOP				 ; k1*Tcy
    DECFSZ  contador1,1,0	 ;(k1-1)+3Tcy
    GOTO    Delay_loop1		 ;(k1-1)*2Tcy
    RETURN			 ; 2Tcy



; T = (7 + 3k)us	
Delay_25us:			 ; 2 Tcy --> Call
    MOVLW	6		 ; 1 Tcy
    MOVWF	contador2,0	 ; 1 Tcy 
    NOP				 ; 1 Tcy
Delay_Loop25:
    DECFSZ	contador2,1,0	 ; (k1-1)+3Tcy
    GOTO	Delay_Loop25	 ; (k1-1)*2Tcy
    RETURN			 ; 2 Tcy



 ;T = (6 + 4k)us
Delay_50us:			 ; 2 Tcy --> Call
    MOVLW	11	         ; 1 Tcy
    MOVWF	contador1,0      ; 1 Tcy
Delay_Loop50:
    NOP                          ;  k1*Tcy
    DECFSZ	contador1,1,0    ; (k1-1)+3Tcy
    GOTO	Delay_Loop50	 ; (k1-1)*2Tcy
    RETURN		         ;  2 Tcy   
    
    
    
;T = (7 + 3k)us   
Delay_100us:			 ; 2 tcy --> Call  
    NOP				 ; 1 Tcy
    MOVLW	31	         ; 1 Tcy
    MOVWF	contador1,0      ; 1 Tcy
Delay_Loop100:
    DECFSZ	contador1,1,0    ; (k-1)+3Tcy
    GOTO	Delay_Loop100    ; (k-1)*2Tcy
    RETURN		         ;  2 Tcy    

    
    
Delay_200us:
    ;T = (8 + 3k)us	        ; 2 tcy --> Call  
    NOP				; 1 Tcy
    NOP				; 1 Tcy
    MOVLW	64	        ; 1 Tcy
    MOVWF	contador1,0     ; 1 Tcy
Delay_Loop200:
    DECFSZ	contador1,1,0   ; (k1-1)+3Tcy
    GOTO	Delay_Loop200   ; (k1-1)*2Tcy
    RETURN		        ; 2 Tcy  
    
    
    
;T = (6 + 4k)us
Delay_250us:		        ; 2 tcy --> Call  
    MOVLW	61	        ; 1 Tcy
    MOVWF	contador2,0     ; 1 Tcy
Delay_Loop250:
    NOP                         ;  k1*Tcy
    DECFSZ	contador2,1,0   ; (k1-1)+3Tcy
    GOTO	Delay_Loop250   ; (k1-1)*2Tcy
    RETURN			;  2Tcy 

    
    
;T = (8 + 4k)us
Delay_500us:		        ; 2 tcy --> Call    
    MOVLW	123	        ; 1 Tcy
    MOVWF	contador2,0     ; 1 Tcy
    NOP                         ; 1 Tcy
    NOP                         ; 1 Tcy    
Delay_Loop500: 
    NOP                         ;  k1*Tcy
    DECFSZ	contador2,1,0   ; (k1-1)+3Tcy
    GOTO	Delay_Loop500   ; (k1-1)*2Tcy
    RETURN		        ;  2 Tcy    
    
    
    
; T=1(6+4K)    
Delay_1ms:			;2Tcy --Call
    MOVLW   1			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop:		    
    MOVLW   249		        ;1TCY -- k1
    MOVWF   contador1,0	        ;1Tcy
Int_Loop:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0   
    GOTO    Ext_Loop
    RETURN			;2Tcy    
	
    
; T=5(6+4K)   
Delay_5ms:			;2Tcy --Call
    MOVLW   5			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop5:		    
    MOVLW   249			;1TCY -- k1
    MOVWF   contador1,0		;1Tcy
Int_Loop5:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop5		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0   
    GOTO    Ext_Loop5
    RETURN			;2Tcy     

    
; T=10(6+4K)   
Delay_10ms:			;2Tcy --Call
    MOVLW   10			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop10:		    
    MOVLW   249			;1TCY -- k1
    MOVWF   contador1,0		;1Tcy
Int_Loop10:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop10		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0   
    GOTO    Ext_Loop10
    RETURN			;2Tcy     
    
    
; T=25(6+4K)    
Delay_25ms:			;2Tcy --Call
    MOVLW   25			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop25:		    
    MOVLW   249			;1TCY -- k1
    MOVWF   contador1,0		;1Tcy
Int_Loop25:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop25		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0   
    GOTO    Ext_Loop25
    RETURN			;2Tcy    
 
    
; T=50(6+4K)    
Delay_50ms:			;2Tcy --Call
    MOVLW   50			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop50:		    
    MOVLW   249			;1TCY -- k1
    MOVWF   contador1,0		;1Tcy
Int_Loop50:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop50		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0	
    GOTO    Ext_Loop50		
    RETURN			;2Tcy
    
    
; T=100(6+4K)    
Delay_100ms:			;2Tcy --Call
    MOVLW   100			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop100:		    
    MOVLW   249			;1TCY -- k1
    MOVWF   contador1,0		;1Tcy
Int_Loop100:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop100		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0   
    GOTO    Ext_Loop100
    RETURN			;2Tcy    
    
    
; T=200(6+4K)    
Delay_200ms:			;2Tcy --Call
    MOVLW   200			;1Tcy -- k2
    MOVWF   contador2,0		;1Tcy
; T= (6+4k)us			1Tcy=1us  
Ext_Loop200:		    
    MOVLW   249			;1TCY -- k1
    MOVWF   contador1,0		;1Tcy
Int_Loop200:
    NOP				;k1*Tcy
    DECFSZ  contador1,1,0	;(k1-1)+ 3Tcy
    GOTO    Int_Loop200		;(k1-1)*2Tcy
    DECFSZ  contador2,1,0   
    GOTO    Ext_Loop200
    RETURN			;2Tcy    
    
    
DELAY_250MS:				;2Tcy --Call
    MOVLW   250				;1Tcy -- k2
    MOVWF   contador2,0			;1Tcy
; T= (6+4k)us				1Tcy=1us  
Ext_Loop250:				
    MOVLW   249				;1TCY -- k1
    MOVWF   contador1,0			;1Tcy
Int_Loop250:				
    NOP					;k1*Tcy
    DECFSZ  contador1,1,0		;(k1-1)+ 3Tcy
    GOTO    Int_Loop5			;(k1-1)*2Tcy
    DECFSZ  contador2,1,0		
    GOTO    Ext_Loop5			
    RETURN				;2Tcy 


DELAY_500MS:				;2Tcy --Call
    MOVLW   2				;1Tcy -- k2
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
    DECFSZ  contador2,1,0		
    GOTO    E250ms_Loop			
    DECFSZ  contador3,1,0		
    GOTO    Delay_250ms			
    RETURN				;2Tcy