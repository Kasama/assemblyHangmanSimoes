; Start Main---------------------------------------------------
jmp main

; Screens------------------------------------------------------
; Start Screen-------------------------------------------------{
startScreen    : string "                                        "
startScreenl1  : string "  +----+                                "
startScreenl2  : string "  |/   )                                "
startScreenl3  : string "  |                                     "
startScreenl4  : string "  |                                     "
startScreenl5  : string "  |                                     "
startScreenl6  : string "  |                                     "
startScreenl7  : string "  |===><====                            "
startScreenl8  : string "  |                                     "
startScreenl9  : string "  |                                     "
startScreenl10 : string "  |                                     "
startScreenl11 : string "  |                                     "
startScreenl12 : string "-----                                   "
startScreenl13 : string "                                        "
startScreenl14 : string "                                        " ; pos 563 on the screen
startScreenl15 : string "                                        "
startScreenl16 : string "        Welcome to the hangman          "
startScreenl17 : string "                 Game                   "
startScreenl18 : string "             Press Enter                "
startScreenl19 : string "               to play                  "
startScreenl20 : string "                                        "
startScreenl21 : string "                                        "
startScreenl22 : string "                                        "
startScreenl23 : string "                                        "
startScreenl24 : string "                                        "
startScreenl25 : string "                                        "
startScreenl26 : string "                                        "
startScreenl27 : string "                                        " ; pos 1084 on the screen
startScreenl28 : string "                                        "
startScreenl29 : string "                                        "
;--------------------------------------------------------------}
; End Screen---------------------------------------------------{
endScreen    : string "                                        "
endScreenl1  : string "  +----+                                "
endScreenl2  : string "  |/   |                                "
endScreenl3  : string "  |    |                                "
endScreenl4  : string "  |    |                                "
endScreenl5  : string "  |    O                                "
endScreenl6  : string "  |   |H|                               "
endScreenl7  : string "  |==> U <==                            "
endScreenl8  : string "  |   | |                               "
endScreenl9  : string "  |                                     "
endScreenl10 : string "  |                                     "
endScreenl11 : string "  |                                     "
endScreenl12 : string "-----                                   "
endScreenl13 : string "                                        "
endScreenl14 : string "   <the word goes here>                 " ; pos 563 on the screen
endScreenl15 : string "                                        "
endScreenl16 : string "           Game Over Newbie             "
endScreenl17 : string "                                        "
endScreenl18 : string "             Press Enter                "
endScreenl19 : string "               to play                  "
endScreenl20 : string "                again                   "
endScreenl21 : string "                                        "
endScreenl22 : string "                                        "
endScreenl23 : string "                                        "
endScreenl24 : string "                                        "
endScreenl25 : string "                                        "
endScreenl26 : string "  Used Letters:                         "
endScreenl27 : string "                                        " ; pos 1084 on the screen
endScreenl28 : string "                                        "
endScreenl29 : string "                                        "
;--------------------------------------------------------------}
;--------------------------------------------------------------

; Messages ----------------------------------------------------{
messageBlank : string "                                        "
messageTypeAWord : string "  Type a word and press enter to start  "
messageGuess : string "          Guess the typed word          "
messageLetterTyped : string " The letter you typed was already used! "
messageLetters : string "  Used Letters:                         "
;--------------------------------------------------------------}

; Global variables -------------------------------------------{
TypedLetters : var #50 ; Array of typed letters
TypedCounter : var #1  ; Number of typed letters
Word : var #41         ; Typed Word
WordSize : var #1      ; Word length
WrongGuesses : var #1  ; Number of wrong guesses
Score : var #1		   ; Player Score
static Score + #0, #0  ; initialize with zero

Hangman : string "OH||U||" ; Hangman figure array
HangmanPos : var #7    ; Hangman position array
static HangmanPos + #0, #127
static HangmanPos + #1, #167
static HangmanPos + #2, #166
static HangmanPos + #3, #168
static HangmanPos + #4, #207
static HangmanPos + #5, #246
static HangmanPos + #6, #248
;-------------------------------------------------------------}

;Main----------------------------------------------------------{
main:
	
	; Initialize global variables {
	loadn r0, #0 ; Initialize both counters with 0
	store TypedCounter, r0
	store WordSize, r0
	;}

	loadn r0, #startScreen			; Screen pointer
	call printScreen				; print the screen pointed by r0
	call waitForEnter			    ; wait until the player presses enter
	call getInitialWord				; get a word to start the game	
	call printInitialGaps           ; print the initial gaps
	call gameLoop					; the game core

halt
;--------------------------------------------------------------}

;==============================================================
;=                                                            =
;=                          Functions                         =
;=                                                            =
;==============================================================
printScreen: ; Print any screen; void (r0 = Message Address) ;{

	push r0
	push r1
	push r2
	push r3
	push r4

	mov r1, r0    ; place the message address into r1
	loadn r0, #0  ; line counter
	loadn r4, #41 ; next address
	loadn r3, #30 ; for counter (30 lines)
	loadn r2, #0  ; white color
	printScreen_loop:
		call printStr
		add r0, r0, r4 ; r0 + 41 - 1 = next line
		dec r0
		add r1, r1, r4 ; r1 + 41 = next Address
		dec r3         ; decrement line number
	jnz printScreen_loop ; if zero, gtfo
	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts
;}
;--------------------------------------------------------------
printStr: ; Print a string until \0; void (r0 = Screen Pos, r1 = message Address, r2 = color) ;{
				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	
	loadn r3, #'\0'	; Criterio de parada

	printStrLoop:	
		loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
		cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
		jeq printStrExit	; goto Final da rotina
		add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
		outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
		inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela
		inc r1				; incrementa o ponteiro para a mensagem na memoria
	jmp printStrLoop		; goto Loop
	
	printStrExit:	
	;---- Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts		; retorno da subrotina
;}
;--------------------------------------------------------------
waitForEnter: ; just wait for a enter; void () ;{
	push r0
	push r1

	loadn r1, #13 ; enter keycode
	waitForEnter_Loop:
		inchar r0
		cmp r0, r1 ; compare with enter
	jne waitForEnter_Loop

	pop r1
	pop r0

rts
;}
;--------------------------------------------------------------
getInitialWord: ; ask for user input of the word; void () ;{

	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	; print screen text
	loadn r0, #640 ; line 16
	loadn r1, #messageBlank ; message to print
	loadn r2, #0 ; message color
	call printStr
	loadn r0, #720 ; line 18
	call printStr
	loadn r0, #760 ; line 19
	call printStr
	loadn r0, #680 ; line 17
	loadn r1, #messageTypeAWord ; message to print
	call printStr

	; actually get input
	loadn r0, #0    ; word size
	loadn r1, #Word ; word pointer
	loadn r2, #13   ; enter value
	loadn r4, #255  ; nothing pressed
	loadn r5, #40   ; max word size

	getInitialWord_Loop:
		inchar r3  ; read a keypress
		cmp r3, r4 ; compare with 255
	jeq getInitialWord_Loop
		cmp r3, r2 ; compare with enter
	jeq getInitialWord_EndLoop
		inc r0     ; increment word size
		storei r1, r3 ; store character to Word
		inc r1     ; increment Word pointer
		cmp r0, r5 ; compare with max word size
	jne getInitialWord_Loop
	getInitialWord_EndLoop:
	store WordSize, r0 ; store word size
	loadn r3, #0 ; add the \0 to the end of the word
	storei r1, r3

	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

rts
;}	
;--------------------------------------------------------------
printInitialGaps: ; print the initial gaps till word size; void () ;{

	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7

	; replace the message on screen
	loadn r0, #680
	loadn r1, #messageGuess
	loadn r2, #0
	call printStr
	loadn r0, #1040
	loadn r1, #messageLetters
	call printStr

	loadn r0, #562		 ; start position
	load r1, WordSize	 ; size of typed word
	loadn r2, #256		 ; brown
	loadn r3, #'_'
	loadn r6, #' '
	loadn r4, #Word		 ; word pointer
	add r3, r3, r2		 ; add color to the char

	load r7, Score		 ; add score to r7
	printInitialGaps_Loop:
		loadi r5, r4	 ; r5 = Word[r4]
		inc r4			 ; r4++
		cmp r5, r6		 ; if r5 != r6
		jne printInitialGaps_Else ; goto
			inc r7			 ; starting score is number of spaces
			outchar r6, r0   ; print a space
			jmp printInitialGaps_EndIf
		printInitialGaps_Else: 
			outchar r3, r0   ; print a underscore on the screen
		printInitialGaps_EndIf:
		inc r0			 ; goes to next screen position
		dec r1			 ; counter-- if counter != 0 go again
	jnz printInitialGaps_Loop
	store Score, r7		 ; save initial score

	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

rts
;}
;--------------------------------------------------------------
gameLoop: ; the main game loop; void () ;{

	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	loadn r0, #255  ; load nothing
	loadn r2, #' '  ; loadn space
	loadn r3, #0	; zero
	gameloop_GetInput:
		inchar r1
		cmp r1, r0  ; if nothing, read again
	jeq gameloop_GetInput
	cmp r1, r2		; if space, read again
	jeq gameloop_GetInput

	call compareTypedLetterWithTrylist
	ceq alreadyTypedMessage
	jeq gameLoop_GetInput
	call compareTypedLetterWithWord
	cz hangTheMan
	call checkGameOver
	cnz gameOverScreen
	jz gameloop_GetInput
	
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	
rts
;}

compareTypedLetterWithTryList: ; compares the typedLetter with try list; fr = alreadyTyped(1 = true|0 = false) (r1 = typed letter) {

	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7

	loadn r0, #TypedLetters
	load r2, TypedCounter
	loadn r3, #0
	loadn r7, #0	; alreadyTyped flag
	cmp r2, r3 ; compare with zero
	jeq compareTypedLetterWithTrylist_Exit
	
	compareTypedLetterWithTrylist_Loop:
		dec r2			; update i
		add r4, r0, r2	; create indexer
		loadi r5, r4	; load letter
		cmp r5, r1		; compare with typed letter
		jeq compareTypedLetterWithTrylist_AlreadyTyped
		cmp r2, r3		; compare with zero
	jne compareTypedLetterWithTrylist_Loop
	load r2, TypedCounter
	add r4, r0, r2		; index to last posion
	storei r4, r1		; save typed letter
	inc r4
	storei r4, r3		; add a \0 to the end
	inc r2				; inc typedcounter
	store TypedCounter, r2 ; save new typedcounter
	
	compareTypedLetterWithTrylist_Exit:
	inc r3
	cmp r7, r3			; compare flag with zero
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
rts

compareTypedLetterWithTrylist_AlreadyTyped:
	loadn r7, #1
jmp compareTypedLetterWithTrylist_Exit
	
;}
;------------------------------------------------------
compareTypedLetterWithWord: ; compare the typed letter with word; fr = score(1 = true|0 = false) (r1 = typedLetter) {
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	loadn r3, #0	; load zero
	loadn r7, #0	; fail flag
	loadn r0, #Word ; typed word vector 
	load r2, WordSize ; typed word size
	load r6, Score		; load the score
	compareTypedLetterWithWord_Loop:
		dec r2			; setup index
		add r4, r0, r2	; create indexer
		loadi r5, r4	; load letter from word
		cmp r5, r1		; compare with typed letter
		ceq compareTypedLetterWithWord_Scored
		cmp r2, r3		; compare index with zero
	jgr compareTypedLetterWithWord_Loop
	
	store Score, r6		; save score back to memory
	compareTypedLetterWithWord_Exit:
	inc r3				; r3 = 1
	cmp r7, r3			; compare score flag with true
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	
rts

compareTypedLetterWithWord_Scored:

	inc r6 ;inc score
	loadn r7, #1 ; set score flag true

rts

;}
;------------------------------------------------------
	
alreadyTyped: ; print message and update try list; void () {
push r0
push r1
push r2
push r3
push r4
push r5
push r6
push r7
push fr

;TODO

pop fr
pop r7
pop r6
pop r5
pop r4
pop r3
pop r2
pop r1
pop r0

rts
;}
;------------------------------------------------------
