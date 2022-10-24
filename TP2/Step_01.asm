			org 	$4
			
Vector_001 	dc.l 	Main

			org 	$500
			
			clr.l 	d1				; D1 -> $00000000
			move.l 	#$80000007,d0	; D0 -> $80000007
loop1 		addq.l 	#1,d1			; D1.L + 1 -> D1.L
			subq.w 	#1,d0			; D0.W - 1 -> DO.W
			bne 	loop1			; Exits when D0.W = $0000 => when D1.L = $00000007
			; D1 = $00000007
			
			clr.l 	d2				; D2 -> $00000000
			move.l 	#$fe2310,d0		; D0 -> $00fe2310
loop2 		addq.l 	#1,d2			; D2.L + 1 -> D2.L
			subq.b 	#2,d0			; D0.B - 2 -> D0.B
			bne 	loop2			; Exits when D0.B = $00 => D2: $00000008
			; D2 = $00000008

			clr.l 	d3				; D3.L -> $00000000
			moveq.l #125,d0			; 125 -> D0.L (signed over 8b) = $0000007D
loop3 		addq.l 	#1,d3			; D3.L + 1 -> D3.L 
			dbra 	d0,loop3 		; Exits when D0.W != -1
			; D3 = $0000007E
			
Main		clr.l 	d4				; D4.L -> $00000000
			moveq.l #10,d0			; D0.L -> $0000000A
loop4 		addq.l 	#1,d4			; D4.L + 1 -> D4.L
			addq.l 	#1,d0			; D0.L + 1 -> D0.L
			cmpi.l 	#30,d0			; Exits if $0000001F == D0.L
			bne 	loop4
			; D4 = $00000014

			illegal
