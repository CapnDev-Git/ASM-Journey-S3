VALUE 		equ 	96			; Defines a constant VALUE = $00000060
			
			org 	$4			; Starts at vector001's address

Vector_001 	dc.l 	Main		; Defines constant 'Main' to the address of vector001

			org 	$500		; Starts Main program from the address $500

Main 		move.b 	#VALUE,d1	;  D1.B -> VALUE.B (=$60)
			
			tst.b 	d1			; Updates the N & Z flags according to D1.B's value
			bne 	next1		; Branches to next1 since Z = 0
			move.l 	#200,d0		; D0.L -> $000000C8
			bra 	quit		; Branches to the 'quit' label <=> stops the program
next1 		bmi 	next3		; Branches to next3 if N = 1
			cmp.b 	#$61,d1		; Compares D1.B & $61
			blt 	next2		; Branches to next2 if D1.B < $61 (signed comparison)
			move.l 	#400,d0		; D0.L -> $00000190
			bra 	quit		; Branches to the 'quit' label <=> stops the program
next2 		move.l 	#600,d0		; D0.L -> $00000258
			bra 	quit		; Branches to the 'quit' label <=> stops the program
next3 		move.l 	#800,d0 	; D0.L -> $00000320

quit 		illegal				; Stops the program execution


; 1) For VALUE = 18, 	D0 = $00000258
; 2) For VALUE = -5, 	D0 = $00000320
; 3) For VALUE =  0, 	D0 = $000000C8
; 4) For VALUE = 96, 	D0 = $00000258
