
	.equ COEF1, 3483
	.equ COEF2, 11718
	.equ COEF3, 1183
	//.equ COEFDIV, 16384

.global rgb2gray
.global div16384
.global apply_gaussian
	.text
/* Descomentar e implementar estas funciones*/

//start:
rgb2gray:
		PUSH {R4, R5, R6, R7, R8, R9,LR}
		LDR R1, =COEF1
		LDR R2, =COEF2
		LDR R3, =COEF3

		//R
		LDRB R4, [R0] //Cargas el byte del pixel
		MUL R5, R4, R1 //Multiplicas por su coeficiente

		//G
		ADD R0, R0, #1 // Avanzas 1 byte
		LDRB R6, [R0] //Cargas el byte del pixel
		MUL R7, R6, R2 //Multiplicas por su coeficiente

		//B
		ADD R0, R0, #1 // Avanzas 1 byte
		LDRB R8, [R0] //Cargas el byte del pixel
		MUL R9, R8, R3 //Multiplicas por su coeficiente

		ADD R0, R5, R7 //Sumas los 3 pixeles
		ADD R0, R0, R9

		bl div16384
		POP {R4, R5, R6, R7, R8, R9,LR}
		MOV PC, LR
		B .

div16384: 
		PUSH {LR}
		LSR R0, #14 //lsr R0, #14
		POP {LR}
		MOV PC, LR

apply_gaussian:
		PUSH {R4, R5, R6, R7, R8, LR}
		MOV R4, #0 //Inicializamos i
For_i:  CMP R4, R3 //Comparamos i < height(r3)
		BGE FinFor_i
		MOV R5, #0 //Inicializamos j
For_j:  CMP R5, R2 //Comparamos j < width(r2)
		BGE FinFor_j
		PUSH {R0, R1, R2, R3, R4, R5}//DUDA
		MOV R8, R1 //Aseguramos im2 en r8
		MOV R1, R2 //Pasamos widht a r1
		MOV R2, R3 //Pasamos height a r2
		MOV R3, R4 //Pasamos i a r3
		MOV R4, R5 //Pasamos j a r4

		PUSH {R4}
		BL gaussian
		POP {R4}

		MOV R7, R0 //Guardamos el resultado en r7
		POP {R0, R1, R2, R3, R4, R5}//DUDA
		MUL R6, R4, R2 //i * widht
		ADD R6, R6, R5 //Resultado anterior + j
		STRB R7, [R8, R6] //Guardamos en la posicion i*width +j de im2

		ADD R5, R5, #1 //Incrementamos j++
		b For_j

FinFor_j:
		ADD R4, R4, #1 //Incrementamos contador i++
		B For_i
FinFor_i: POP {R4, R5, R6, R7, R8, LR}
		  MOV PC, LR



  		.end


