			; ==============================
			; Vector Initialization
			; ==============================

			org 	$4

vector_001 	dc.l 	Main

			; ==============================
			; Main Program
			; ==============================

			org 	$500

Main 		movea.l #String1,a0
			jsr 	Atoui

			movea.l	#String2,a0
			jsr 	Atoui
			
			movea.l	#String3,a0
			jsr 	Atoui

			illegal

			; ==============================
			; Subroutines
			; ==============================

Atoui	 	movem.l	d1/a0,-(a7) 	; Save A0 on the stack.
			
			clr.l	d0
			
\loop		move.b (a0)+,d1
			beq \quit
			
			subi.b 	#'0',d1
			
			mulu	#$0A,d0
			add.l 	d1,d0
			bra 	\loop

\quit 		movem.l (a7)+,a0/d1		; Restore registers from the stack.
			rts

			; ==============================
			; Data
			; ==============================

String1 	dc.b 	"52146",0
String2 	dc.b 	"309",0
String3 	dc.b 	"2570",0
