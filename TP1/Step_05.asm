			org 	$4

Vector_001 	dc.l 	Main

			org 	$500
			
Main 		move.b	#$B4,d0
			add.b	#$4C,d0
			move.w	#$B4,d1
			add.w	#$4C,d1
			move.w	#$4AC9,d2
			add.w	#$D841,d2
			move.l	#$FFFFFFFF,d3
			add.l	#$00000015,d3

			illegal
