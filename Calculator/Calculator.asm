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

Main 		lea	sPrompt,a0
		move.b	#0,d1
		move.b	#0,d2
		bsr	Print

		movea.l	#sExpression,a0
		addq.b	#1,d2
		move.l	#300000,d3
		move.l	#40000,d4
		bsr 	GetInput
			
		bsr	GetExpr
		lea	sResult,a0
		addq.b	#1,d2
		bsr	Print
		
		bsr 	Itoa
		addq.b	#1,d2
		bsr	Print
			
		illegal
			
		; ==============================
		; Subroutines
		; ==============================

PrintChar 	incbin 	"PrintChar.bin"
GetInput	incbin	"GetInput.bin"

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

		bra	\loop
			
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
		beq	\false
			
		cmpi.b	#'0',d0
		blo	\true
		
		cmpi.b	#'9',d0
		bls	\loop
			
\true		ori.b 	#%00000100,ccr
		bra	\quit
			
\false		andi.b 	#%11111011,ccr

\quit		movem.l	(a7)+,d0/a0
		rts

		; ==============================

IsMaxError	movem.l	d0/a0,-(a7)
		bsr 	StrLen
			
		cmpi.l	#5,d0
		bhi	\true
		blo	\false
			
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

\false		andi.b 	#%11111011,ccr
		bra	\quit
			
\true		ori.b 	#%00000100,ccr 

\quit		movem.l	(a7)+,d0/a0
		rts

		; ==============================

Convert		tst.b	(a0)
		beq	\false
			
		bsr 	IsCharError
		beq	\false
		
		bsr 	IsMaxError
		beq	\false

		bsr	Atoui
		
\true		ori.b 	#%00000100,ccr 
		jmp	\quit

\false		andi.b 	#%11111011,ccr

\quit		rts

		; ==============================

Print		movem.l	d0-d1/a0,-(a7)

\loop		move.b	(a0)+,d0
		beq	\quit
		
		bsr 	PrintChar
			
		addq.b	#1,d1	
		bra	\loop

\quit		movem.l	(a7)+,d0-d1/a0
		rts

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
		bra	NextOp

\quit		rts

		; ==============================

GetNum		movem.l	d1/a1-a2,-(a7)
		movea.l	a0,a1

		bsr 	NextOp
		movea.l	a0,a2
			
		move.b	(a2),d1
		clr.b	(a2)
			
		movea.l	a1,a0
		bsr 	Convert
		beq	\true
		
\false		move.b 	d1,(a2)
		andi.b 	#%11111011,ccr
		bra 	\quit	
			
\true		move.b 	d1,(a2)
		movea.l	a2,a0
		ori.b 	#%00000100,ccr 

\quit		movem.l	(a7)+,d1/a1-a2
		rts
			
		; ==============================

GetExpr		movem.l	d1-d2/a0,-(a7)
			
		bsr	GetNum
		bne	\false
			
		move.l	d0,d1
			
\loop		move.b	(a0)+,d2
		beq	\true
			
		bsr	GetNum
		bne	\false
			
		cmpi.b	#'+',d2
		beq	\adt
			
		cmpi.b	#'-',d2
		beq	\subtract
		
		cmpi.b	#'*',d2
		beq	\multiply
			
		bra	\divide
			
\adt		add.l	d0,d1
		bra	\loop
			
\subtract	sub.l	d0,d1
		bra	\loop
			
\multiply	mulu.l	d0,d1
		bra	\loop
			
\divide		tst.w	d0
		beq	\false
		divs.w	d0,d1
		ext.l	d1
		bra	\loop

\false		andi.b 	#%11111011,ccr
		bra 	\quit
			
\true		move.l	d1,d0
		ori.b 	#%00000100,ccr 

\quit		movem.l	(a7)+,d1-d2/a0
		rts
			
		; ==============================

Uitoa		movem.l	d0/a0,-(a7)
		clr.w	-(a7)
			
\loop		andi.l #$FFFF,d0
		divu.w	#10,d0
			
		swap	d0
		addi.b	#'0',d0
		move.w	d0,-(a7)
		swap	d0
			
		tst.w	d0
		bne	\loop

\writeChar	move.w	(a7)+,d0
		move.b	d0,(a0)+
		bne	\writeChar

		movem.l	(a7)+,d0/a0
		rts
			
		; ==============================
			
Itoa		tst.w	d0
		bmi	\negative
		bsr	Uitoa
		bra 	\quit
			
\negative	move.b	#'-',(a0)+
		neg.w	d0
		bsr	Uitoa
			
\quit		rts

		; ==============================
		; Data
		; ==============================

sPrompt		dc.b	"Enter an expression:",0
sExpression	ds.b	60
sResult		dc.b	"Result:"
sBufferRes	ds.b	60
