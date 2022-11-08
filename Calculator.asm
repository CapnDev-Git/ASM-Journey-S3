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
			move.l	#10825,d0
			movea.l #StringTest,a0
			bsr		Uitoa
			
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

			clr.l 	d0
			clr.l 	d1

\loop		move.b 	(a0)+,d1
			beq 	\quit

			subi.b 	#'0',d1

			mulu.w 	#10,d0
			add.l 	d1,d0

			bra		\loop
			
\quit		movem.l (a7)+,d1/a0
			rts

			; ==============================

RemoveSpace	movem.l d0/a0-a1,-(a7)
			
			movea.l	a0,a1
			
\loop		move.b	(a0)+,d0
			
			cmpi.b 	#' ',d0
			beq 	\loop
			
			move.b	d0,(a1)+
			bne 	\loop
			
\quit 		movem.l (a7)+,d0/a0-a1
			rts

			; ==============================

IsCharError	movem.l	d0/a0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\false
			
			cmpi.b	#'0',d0
			blo		\true
			
			cmpi.b	#'9',d0
			bls		\loop
			
\true		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).
			bra		\quit
			
\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).

\quit		movem.l	(a7)+,d0/a0
			rts

			; ==============================

IsMaxError	movem.l	d0/a0,-(a7)
			bsr 	StrLen
			
			cmpi.l	#5,d0
			bhi		\true
			blo		\false
			
			cmpi.b 	#'3',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'2',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'7',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'6',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'7',(a0)
			bhi 	\true

\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).
			bra		\quit
			
\true		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).

\quit		movem.l	(a7)+,d0/a0
			rts

			; ==============================

Convert		tst.b	(a0)
			beq		\false
			
			bsr 	IsCharError
			beq		\false
			
			bsr 	IsMaxError
			beq		\false

			bsr		Atoui
		
\true		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).
			jmp		\quit

\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).

\quit		rts

			; ==============================

Print		movem.l	d0-d1/a0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\quit
			
			bsr 	PrintChar
			
			addq.b	#1,d1	
			bra		\loop

\quit		movem.l	(a7)+,d0-d1/a0
			rts

PrintChar 	incbin 	"PrintChar.bin"

			; ==============================

NextOp		tst.b	(a0)
			beq 	\quit
			
			cmpi.b	#'+',(a0)
			beq 	\quit

			cmpi.b	#'-',(a0)
			beq 	\quit

			cmpi.b	#'*',(a0)
			beq 	\quit

			cmpi.b	#'/',(a0)
			beq 	\quit

			adda.l	#1,a0
			bra		NextOp

\quit		rts

			; ==============================

GetNum		movem.l	d1/a1-a2,-(a7)
			movea.l	a0,a1

			bsr 	NextOp
			movea.l	a0,a2
			
			move.b	(a2),d1
			move.b	#0,(a2)
			
			movea.l	a1,a0
			bsr 	Convert
			bne		\false
			
			movea.l	a2,a0
			move.b 	d1,(a2)
			bra 	\true
			
\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).
			movea.l	a1,a0
			move.l	#$AAAAAAAA,a6
			bra 	\quit			
			
\true		ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).

\quit		movem.l	(a7)+,d1/a1-a2
			rts
			
			; ==============================

GetExpr		movem.l	d1-d2/a0,-(a7)
			
			clr.l	d2
			
			bsr		GetNum
			bne		\false
			
			move.l	d0,d1
			
\loop		move.b	(a0)+,d2

			tst.b	d2
			beq		\true
			
			bsr		GetNum
			bne		\false
			
			cmpi.b	#'+',d2
			beq		\plop
			
			cmpi.b	#'-',d2
			beq		\miop
			
			cmpi.b	#'*',d2
			beq		\muop
			
			cmpi.b	#'/',d2
			beq		\diop
			
\plop		add.l	d0,d1
			bra		\loop
			
\miop		sub.l	d0,d1
			bra		\loop
			
\muop		mulu.l	d0,d1
			bra		\loop
			
\diop		tst.l	d0
			beq		\false
			divu.l	d0,d1
			swap	d1
			clr.w	d1
			swap	d1
			bra		\loop

\false		andi.b 	#%11111011,ccr ; Set the Z flag to 0 (false).
			bra 	\quit
			
\true		move.l	d1,d0
			ori.b 	#%00000100,ccr ; Set the Z flag to 1 (true).

\quit		movem.l	(a7)+,d1-d2/a0
			rts
			
			; ==============================

Uitoa		movem.l	d1/a0,-(a7)
			clr.l	d1

			move.w	#0,-(a7)
			
\loop		divu.w	#10,d0
			
			swap	d0
			add.w	#'0',d0
			move.w	d0,-(a7)
			clr.w	d0
			swap	d0
			
			beq		\loop2
			bra		\loop

\loop2		move.w	(a7)+,d1
			beq		\quit
			move.b	d1,(a0)+
			bra		\loop2

\quit		move.b	#0,(a0)
			movem.l	(a7)+,d1/a0
			rts

			; ==============================
			; Data
			; ==============================
			
; Tests
StringTest	dc.b	"       ",0
