			; ==============================
			; Vector Initialization
			; ==============================

			org 	$4
vector_001 	dc.l 	Main

			; ==============================
			; Main Program
			; ==============================

			org 	$500
Main 					
			;movea.l #StringRS1,a0
			;jsr 	RemoveSpace
			
			;movea.l	#StringCE1,a0
			;jsr 	IsCharError
			
			movea.l	#StringME1,a0
			jsr 	IsMaxError
			
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

RemoveSpace	movem.l a0/a1,-(a7)
			movea.l	#StringRS1,a1
			
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
			
			adda.w 	#1,a0
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
			; Data
			; ==============================
			
; Tests
StringRS1 	dc.b 	" 5 +  12 ",0	; a0 contains "5+12",0

StringCE1 	dc.b 	"512",0 		; returns 0
StringCE2 	dc.b 	"5e12",0 		; returns 1

StringME1 	dc.b 	"512",0			; returns 0
StringME1 	dc.b 	"32000",0		; returns 0
StringME1 	dc.b 	"32767",0		; returns 0
StringME1 	dc.b 	"32768",0		; returns 1

; Constants
S32676	 	dc.b 	"32767",0		; returns
