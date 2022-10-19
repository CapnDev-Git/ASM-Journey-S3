			; ==============================
			; Vector Initialization
			; ==============================

			org 	$0
			
vector_000 	dc.l 	$ffb500
vector_001 	dc.l 	Main

			; ==============================
			; Main Program
			; ==============================

			org 	$500
Main 					
			;movea.l #StringRS1,a0
			;jsr 	RemoveSpace
			
			;movea.l	#StringCE1-2,a0
			;jsr 	IsCharError
			
			;movea.l	#StringME1-4,a0
			;jsr 	IsMaxError
			
			;movea.l	#StringConv1-5,a0
			;jsr 	Convert
			
			;lea 	StringPrint,a0
			;move.b 	#5,d1
			;move.b 	#20,d2
			;jsr 	Print
			
			movea.l	#StringNO1,a0
			jsr		NextOp
			
			illegal
			
			; ==============================
			; Subroutines
			; ==============================

StrLen 		move.l 	a0,-(a7) ; Save A0 on the stack.
			
			clr.l 	d0
			
\loop 		tst.b 	(a0)+
			beq 	\quit
			
			addq.l	#1,d0
			bra 	\loop
			
\quit 		movea.l (a7)+,a0 ; Restore AO from the stack.
			rts

			; ==============================

Atoui		movem.l d1/a0,-(a7)

			clr.l d0
			clr.l d1

\loop		move.b (a0)+,d1
			beq \quit

			subi.b #'0',d1

			mulu.w #10,d0
			add.l d1,d0

			bra		\loop
\quit		movem.l (a7)+,d1/a0
			rts

			; ==============================

RemoveSpace	movem.l a0/a1,-(a7)
			movea.l	a0,a1
			
\loop		tst.b	(a0)
			beq		\addempty
			
			cmp.b 	#' ',(a0)
			beq 	\space
			move.b	(a0)+,(a1)+
			jmp 	\loop

\space		adda.w 	#1,a0
			jmp 	\loop

\addempty	move.b	#0,(a1)
			beq		\quit
			
\quit 		movem.l (a7)+,a0/a1
			rts

			; ==============================

IsCharError	move.l	a0,-(a7)

\loop		tst.b 	(a0)
			beq		\false
			
			cmp.b	#'0',(a0)
			blo		\true
			cmp.b	#'9',(a0)
			bhi		\true
			
			addq.l 	#1,a0
			jmp 	\loop		

\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).
			jmp		\quit
			
\true		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).
			jmp		\quit

\quit		move.l	(a7)+,a0
			rts

			; ==============================

IsMaxError	movem.l	a0/a1/d0,-(a7)
			jsr 	StrLen
			
			cmp.l	#5,d0
			blo		\lowereq
			bhi		\higher
			
			movea.l	#S32676,a1
			
\loop		tst.b	(a0)
			beq		\lowereq

			cmp.b	(a1)+,(a0)+
			bhi 	\higher
			blo		\lowereq
			jmp		\loop

\lowereq	andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).
			jmp		\quit
			
\higher		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).
			jmp		\quit

\quit		movem.l	(a7)+,a0/a1/d0
			rts

			; ==============================

Convert		move.l	a0,-(a7)
			
			cmpi.b	#0,(a0)
			beq		\false
			
			jsr 	IsCharError
			beq		\false
			
			jsr 	IsMaxError
			beq		\false

			jsr		Atoui
			bra		\true

\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).
			jmp		\quit
			
\true		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).
			jmp		\quit

\quit		move.l	(a7)+,a0
			rts

			; ==============================

Print		movem.l	d0-d2/a0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\quit
			
			jsr 	PrintChar
			
			addq.b	#1,d1	
			bra		\loop

\quit		movem.l	(a7)+,a0/d0-d2
			rts

PrintChar 	incbin 	"PrintChar.bin"

			; ==============================

NextOp		move.l	d0,-(a7)

\loop		move.b	(a0),d0
			beq		\quit

			cmpi.b	#'+',d0
			beq 	\quit
			cmpi.b	#'-',d0
			beq 	\quit
			cmpi.b	#'*',d0
			beq 	\quit
			cmpi.b	#'/',d0
			beq 	\quit

			adda.l	#1,a0
			bra		\loop

\quit		move.l	(a7)+,d0
			rts

			; ==============================
			; Data
			; ==============================
			
; Tests
StringRS1 	dc.b 	" 5 +  12 ",0	; a0 contains "5+12",0

StringCE1 	dc.b 	"512",0 		; returns 0
StringCE2 	dc.b 	"5e12",0 		; returns 1

StringME1 	dc.b 	"512",0			; returns 0
StringME2 	dc.b 	"32000",0		; returns 0
StringME3 	dc.b 	"32767",0		; returns 0
StringME4 	dc.b 	"32768",0		; returns 1

StringConv1 dc.b 	"1568",0		; returns 1 w/ D0 = 1568
StringConv2 dc.b 	"879",0			; returns 1 w/ D0 = 879
StringConv3	dc.b 	"8a9",0			; returns 0
StringConv4 dc.b 	"",0			; returns 0
StringConv5 dc.b 	"40000",0		; returns 0

StringPrint	dc.b	"Hello, World!",0

StringNO1	dc.b	"104+9*2-3",0

; Constants
S32676	 	dc.b 	"32767",0		; constant
