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
			jsr 	AlphaCount

			movea.l	#String2,a0
			jsr 	AlphaCount

			illegal

			; ==============================
			; Subroutines
			; ==============================

LowerCount 	movem.l	d4/a0,-(a7) 	; Save A0 on the stack.
			
			clr.l	d1
			
\loop		move.b (a0)+,d4
			beq \quit
			
			cmp.b 	#'a',d4
			blo 	\loop

			cmp.b 	#'z',d4
			bhi 	\loop

			addq.l 	#1,d1
			bra 	\loop

\quit 		movem.l (a7)+,a0/d4		; Restore registers from the stack.
			rts

UpperCount 	movem.l	d5/a0,-(a7) 	; Save A0 on the stack.

			clr.l	d2
			
\loop		move.b (a0)+,d5
			beq \quit
			
			cmp.b 	#'A',d5
			blo 	\loop

			cmp.b 	#'Z',d5
			bhi 	\loop

			addq.l 	#1,d2
			bra 	\loop

\quit 		movem.l (a7)+,a0/d5		; Restore registers from the stack.
			rts


DigitCount 	movem.l	d6/a0,-(a7) 	; Save A0 on the stack.
			
			clr.l	d3
			
\loop		move.b (a0)+,d6
			beq \quit
			
			cmp.b 	#'0',d6
			blo 	\loop

			cmp.b 	#'9',d6
			bhi 	\loop

			addq.l 	#1,d3
			bra 	\loop

\quit 		movem.l (a7)+,a0/d6		; Restore registers from the stack.
			rts

AlphaCount 	movem.l	d1-d3,-(a7) 	; Save A0 on the stack.
			
			clr.l	d0
			
			jsr 	LowerCount
			jsr 	UpperCount
			jsr 	DigitCount
			
			add.l d1,d0
			add.l d2,d0
			add.l d3,d0

\quit 		movem.l (a7)+,d1-d3		; Restore registers from the stack.
			rts

			; ==============================
			; Data
			; ==============================

String1 	dc.b 	"This string contains 42 alphanumeric characters.",0
String2 	dc.b 	"This one only 13.",0
