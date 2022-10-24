			org 	$4

Vector_001 	dc.l 	Main

			org 	$500
			
			; step 1: D1 = $76543120
Main		move.l 	#$76543210,d1
			ror.w 	#4,d1
			rol.b	#4,d1
			rol.w	#4,d1
			
			; step 2: D1 = $75640213
			move.l 	#$76543210,d1
			rol.w 	#4,d1
			ror.b	#4,d1
			ror.w	#4,d1
			
			; D1 = $54231067
			move.l 	#$76543210,d1
			rol.l 	#8,d1
			ror.b	#4,d1
			swap 	d1
			ror.b	#4,d1
			swap 	d1
			
			; D1 = $05634127
			move.l 	#$76543210,d1
			rol.l	#4,d1
			ror.b	#4,d1
			ror.l	#8,d1
			ror.b	#4,d1
			ror.l	#8,d1
			ror.b	#4,d1
			ror.l	#8,d1
			ror.b	#4,d1
			ror.l	#8,d1
			ror.l 	#4,d1
			
			; could surely be optimized
			
			illegal
