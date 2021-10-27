        CSEG    AT      0000H
        
        LJMP    0030H
        
        CSEG    AT      000BH
        LJMP    ISR_TIMER_OVER
        
        
        CSEG    AT      0030H
        
        
        ; --- INIT ---
        LCALL   S_INIT_INTERUP
        LCALL   S_INIT_TIMER_250U
        
        MOV     P1,#00H
        MOV     P0,#00H
        
        LJMP S_ON


        
END_OF_PROGRAM:

        MOV     PCON,#01H
        
        LJMP    END_OF_PROGRAM
        
ISR_TIMER_OVER:
        
        DJNZ    R5, ISR_T0_NOT_OVER
        MOV     R5,#0FAH
        DJNZ    R6, ISR_T0_NOT_OVER
        MOV     R6,#0F0H
        
        LCALL    S_AUTOOFF
        
ISR_T0_NOT_OVER:    
    
        RETI
        
S_INIT_INTERUP:
        
        SETB    EA
        SETB    ET0
        
        RET

S_INIT_TIMER_250U:

        ANL     TMOD, #0FH
        ORL     TMOD, #00000010B
        
        MOV     TH0, #06H
        
        
        MOV     R5,#0FAH  ;250us ESETÉN ÖSSZESEN 240*250 OVERFLOW
        MOV     R6,#0F0H
        
        RET

S_ON:
        MOV     A,P1
        ANL     A, #00001111B
        MOV     P1,#0
        
        MOV     C,ACC.0
        ORL     C,ACC.1
        ORL     C,ACC.2
        ORL     C,ACC.3
        
        CLR     A
        RLC     A
        
        XRL     A,B
        
        CJNE    A,#0,A_NOT_NULL
        LCALL   S_LIGHT_OFF
        LJMP    S_ON
        
A_NOT_NULL:
        LCALL   S_LIGHT_ON
        LJMP    S_ON
        
        
S_LIGHT_ON:
        MOV     P0,#00001111B
        SETB    TR0
        
        SETB    B.0
        
        RET
       
S_LIGHT_OFF:
        MOV     P0,#00H
        CLR     B.0
        CLR     TR0
        MOV     TL0,#0
        
        MOV     R5,#0FAH  ;250us ESETÉN ÖSSZESEN 240*250 OVERFLOW
        MOV     R6,#0F0H
        
        RET
       
S_AUTOOFF:

        CLR     TR0
        MOV     P0,#00H
        CLR     B.0
        MOV     TL0,#0
        
        MOV     R5,#0FAH  ;250us ESETÉN ÖSSZESEN 240*250 OVERFLOW
        MOV     R6,#0F0H
        
        RET
        
        END
    
