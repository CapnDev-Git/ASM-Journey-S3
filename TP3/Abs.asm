			; ==============================
			; Vector Initialization
			; ==============================
			
			org 	$4
			
vector_001 	dc.l 	Main

			; ==============================
			; Main Program
			; ==============================

			org 	$500
			
Main 		move.l 	#-4,d0
			jsr 	Abs
			
			move.l 	#-32500,d0
			jsr 	Abs
			
			illegal
			
			; ==============================
			; Subroutines
			; ==============================
			
Abs			tst.l 	d0
			bpl 	\quit
			
			neg.l 	d0
			
\quit		rts
