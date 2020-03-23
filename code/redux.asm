//***********************************************************
//		THE LEGEND OF ZELDA REDUX
//***********************************************************


//***********************************************************
//	Table file
//***********************************************************

table code/text.tbl,ltr

//***********************************************************
//	Control codes
//***********************************************************

define	HOLD_PAD_1	$FA

// NES Address conversion

// >> = right shift operator
// % = modulus operator
// | = bitwise OR operator

// bank = (0x06BA5 >> 14) = 1
// addr = (0x06BA5 % 0x4000) = (0x2BA5 | 0x8000) = 0xABA5 - 0x10 = 0xAB95



///***********************************************************
//	File Selection screen
//***********************************************************

// PPU transfer, move "NAME" in the Save Screen one tile to the left
bank 6;
org $A148	// $1A158
	db $21,$09,$06	// Originally 21 0A 06

// Flip heart rows in the File Select Screen:
bank 2;
// Move upper row of hearts next to the Death counter
org $A268	// $0A278
// Move lower row of hearts next to the Player's name
	db $21,$32,$08,$00,$00,$00,$00,$00,$00,$00,$00,$FF	// Change to $21,$32,$08 to move that row of hearts above

//Found the routines, now I just gotta figure out how to invert the heart printing
//A4C6: B9 54 A2  LDA $A254,Y @ $A258 = #$24				// 0xA4D6
//A254: 21 09 11 24 24 24 24 24 24 24 24 2F 00 00 00 00 00 00 00 00	// PPU Transfer for Name and Upper (starting) hearts (0xA264)

//A268: 21 32 08 00 00 00 00 00 00 00 00 FF 				// PPU Transfer for upper Hearts (0xA278)
//         ^ Changing this to 21 12 08 positions the bottom hearts where desired.
// 66F9 -> 6E79

//A520: B9 74 A2  LDA $A274,Y @ $A278 = #$24				// 0xA530
//A274: 21 89 03 24 24 01 21 E9 03 24 24 01 22 49 03 24 24 01 FF	// PPU Transfers for Death counter(s) (0xA284)


// Change all of the "-" that use $62 as their Hex to $2F (to free up one tile)
bank 1;
org $87BD	// $047CD - Dash used for shops and secret caves
	ldx.b #$2F	// Originally LDX #$62
org $89E6	// $049F6 - "+" symbol used for the Money-Making games
	ldx.b #$2B	// Originally LDX #$64
org $89F0	// $04A00 - Dash used for the Money-Making games
	ldx.b #$2F	// Originally LDX #$62

bank 2;
org $9DCD	// $09DDD - Elimination Mode Character detection
	db $2F
org $A25F	// $0A26F - File Select File dashes
	db $2F
org $AD9D	// $0ADAD - 2nd Quest Ending dash
	db $2F

bank 6;
org $9D0C	// $19D1C - Dash for "LEVEL-X" in Dungeons
	db $2F
org $A119	// $1A129 - First dash for "-SELECT-"
	db $2F
org $A127	// $1A137 - Second dash for "-SELECT-"
	db $2F
org $A1DE	// $1A1EE - Dash character for Register Name
	db $2F
org $A2A1 	// $1A2B1 - UNKNOWN - PPU transfer for something like "-100"?
	db $2F
org $A2A9	// $1A2B9 - UNKNOWN - PPU transfer for something like "-1     -5"?
	db $2F
org $A2B0	// $1A2C0 - UNKNOWN - PPU transfer for something like "-1     -5"?
	db $2F
org $A2EF	// $1A2FF - First dash for "-LIFE-" 
	db $2F
org $A2F4	// $1A304 - Second dash for "-LIFE-'
	db $2F
// Following two changes are included in automap.asm
//org $BF0E	// $1BF1E - First dash for "-LIFE-" 
//	db $2F
//org $BF13	// $1BF23 - Second dash for "-LIFE-"
//	db $2F


// Change palette of Link on File Select screen
bank 6; org $9CEB	// $19CFB
	db $0F,$29,$27,$17	// Black, green, beige, brown
	db $0F,$22,$27,$17	// Black, blue, beige, brown
	db $0F,$26,$27,$17	// Black, red, beige, brown


// Change palette for the Inner Heart in Elimination Mode
bank 2; org $9EB0	// $09EC0
	lda.b #$02	// Originally A9 30 (LDA #$30)


//***********************************************************
//	Increase text printing speed
//***********************************************************

bank 1; org $881C	// $482C
	lda.b #$04	// Originally LDA $06


//***********************************************************
//	Implement CAUTION text from version PRG1
//***********************************************************

bank 5;
// (Changes Y position of the "Continue/Save/Retry text)
org $8AE6	// $14AF6
	db $17,$2F,$47	// Originally 4F 67 7F 
// (Changes Y position of the red/white flashing when selecting an option)
org $8AF1	// $14B01
	db $C2,$CB,$D2	// Originally D2 DA E2

// This section still needs rework to match 1:1 the layout of the PRG1 version. Problem here is the flashing takes too much vertical space, hence why the text was moved so far apart from each other)


// New text imported into free space from the PRG1 version

bank 6;
// Pointer change
org $A004	// $1A014
	dw save_text	// Pointer originally B4 A2 ($A2B4), changed to D0 AC ($ACD0)
// Fill with FFs (original location of the Continue/Save/Retry text)
org $A2B4	// $1A2C4-$1A2E2
	fill $1F,$FF

// New location:
org $ACD0	// $1ACE0

save_text:
	db $23,$C0,$7F,$00	// PPU Transfer
	db $20,$6C,$08	// PPU Transfer
	db "CONTINUE"	// 0C 18 17 1D 12 17 1E 0E - CONTINUE
	db $20,$CC,$04	// PPU Transfer
	db "SAVE"	// 1C 0A 1F 0E - SAVE
	db $21,$2C,$05	// PPU Transfer
	db "RETRY"	// 1B 0E 1D 1B 22 - RETRY 
	db $23,$D8,$20	// Text Box Tile attribute PPU transfer - Originally 23 D8 60 55
	db $FF,$5F,$5F,$5F,$5F,$5F,$5F,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $21,$83,$01,$69	// PPU Transfers
	db $21,$84,$58,$6A	// for the box
	db $21,$9C,$01,$6B	// or line tiles
	db $21,$A3,$CB,$6C	// that surround
	db $21,$BC,$CB,$6C	// the Caution
	db $23,$03,$01,$6E	// text
	db $23,$04,$58,$6A	// ...
	db $23,$1C,$01,$6D	// ...
	db $21,$CC,$08	// PPU Transfer
	db "CAUTION!"	// 0C 0A 1E 1D 12 18 17 - CAUTION
	db $22,$05,$16	// PPU Transfer
	db "TO AVOID DAMAGING GAME"	// 1D 18 24 0A 1F 18 12 0D 24 0D 0A 16 0A 10 12 17 10 24 10 0A 16 0E - TO AVOID DAMAGING GAME
	db $22,$45,$16	// PPU Transfer
	db "SAVE DATA, HOLD IN THE"	// 12 17 0F 18 24 24 1C 0A 1F 0E 0D 28 24 24 11 18 15 0D 24 24 12 17 - INFO  SAVED,  HOLD  IN
	db $22,$85,$16	// PPU Transfer
	db "RESET BUTTON WHILE YOU"	// 1B 0E 1C 0E 1D 24 24 0B 1E 1D 1D 18 17 24 24 0A 1C 24 24 22 18 1E - RESET  BUTTON  AS  YOU
	db $22,$C5,$16	// PPU Transfer
	db "TURN OFF THE POWER.   "	// 1D 1E 1B 17 24 19 18 20 0E 1B 24 18 0F 0F 63 - TURN POWER OFF.


//***********************************************************
//	Save with controller 1 (Up+A)
//***********************************************************

bank 5;
org $80DA	// $140EA
	lda.b {HOLD_PAD_1}	// Originally A5 FB (LDA $FB)


//***********************************************************
//	HUD & Subscreen Changes
//***********************************************************

// Change the "X" in the HUD with a custom tile for a new "x"
bank 1;
org $8795	// $047A5
	lda.b #$62	// Originally A9 21 (LDA #$21) - Used for "x" with Rupee icon in secret caves
org $A59D	// $065AD
	lda.b #$62	// Originally A9 21 (LDA #$21) - Used for the Key counter with Infinite symbol
org $A5DB	// $065EB
	ldy.b #$62	// Originally A0 21 (LDY #$21) - Used for main HUD


// Dummy PPU transfer (not applied in-game, can be left without changing)
org $A51D	// $652D
	db $20,$6C,$03,$59,$00,$24	// Originally 20 6C 03 21 00 24
	db $20,$AC,$03,$59,$00,$24	// Originally 20 AC 03 21 00 24
	db $20,$CC,$03,$59,$00,$24	// Originally 20 CC 03 21 00 24


// White outline to hearts in HUD (Also changes the outer line of the CAUTION message):
// 0x19XXX: All the dungeon related data in 0x19XXX with the same palette was modified
bank 6;
org $9307	// $19317
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9403	// $19413
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $94FF	// $1950F
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Changed background color to not collide with Link's (Dungeon 2)
org $95FB	// $1960B
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Changed background color to not collide with Link's (Dungeon 3)
org $9607	// $19617
	db $0F,$29,$27,$17	// Originally 0F 29 37 17 - Change Link's color for Dungeon 3 to not be pale
org $96F7	// $19707
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $97F3	// $19803
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $98EF	// $198FF
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $99EB	// $199FB
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9AE7	// $19AF7
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9BE3	// $19BF3
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9CDF	// $19CEF
	db $0F,$16,$27,$30	// Originally 0F 16 27 36


// Subscreen - "USE B BUTTON" text for "B BUTTON" and blank-out below row
org $A039	// $1A049
	db $A3,$50	// Change pointer to upper B button text, label "b_button"
	db $A3,$5C	// Change pointer to lower B button text, label "blank"
org $A350	// $1A360
b_button:
	db $2A,$45,$08
	db "B BUTTON"	// Originally "USE B BUTTON"
	db $FF
org $A35C	// $1A36C
blank:
	db $2A,$64,$08
	db "        "	// Originally "FOR THIS"
blank_rest:
	db $2A,$6F,$01
	db $6E		// Box bottom-left corner
	db $2A,$70,$4B
	db $6A,$2A,$7B,$01,$6D,$FF	// Other tiles for the box
	fill $04,$FF


//***********************************************************
//	Remove extra staircases
//***********************************************************

// Removes the extra staircases outside Level 5 and 6 (1st Quest) and outside a 30 rupees location (2nd Quest)
// The limitation of only one entrance per screen forces them to be just secondary entrances to the labyrinths no matter what, and if you exit the labyrinth when you have entered it from the secondary entrance, the walking on stairs animation is absent.
bank 4; org $8CBA	// $10CCA
	db $70,$B0,$70	// Originally B0 B0 30


//***********************************************************
//	Cracked Walls Tilemaps 
//***********************************************************

// New tilemaps for bombable walls in Dungeons:

bank 5;
// Dungeon Right Walls:
org $A012	// $16022
	db $DF,$5E,$DF,$DF,$F5,$F5,$5F,$DF,$DF,$DF,$F5,$F5	// Originally DF DF DF DF F5 F5 DF DF DF DF F5 F5
// Dungeon Left Walls:
org $A04E	// $1605E
	db $F5,$F5,$DE,$DE,$DE,$58,$F5,$F5,$DE,$DE,$59,$DE	// Originally F5 F5 DE DE DE DE F5 F5 DE DE DE DE
// Dungeon Bottom Wall:
org $A08A	// $1609A
	db $DD,$DD,$F5,$5B,$DD,$F5,$5D,$DD,$F5,$DD,$DD,$F5	// Originally DD DD F5 DD DD F5 DD DD F5 DD DD F5
// Dungeon Top Wall:
org $A0C7	// $160D7
	db $DC,$DC,$F5,$DC,$5A,$F5,$DC,$5C,$F5,$DC,$DC,$F5	// Originally F5 DC DC F5 DC DC F5 DC DC F5 DC DC



// Overworld Walls:
org $A976	// $16987 (Table for Secret Tiles Codes (6 bytes at $16986)
	db $C8, $D8, $C4, $BC, $C0, $C0		// Originally $D8 - Bombable Wall	(D8 D9 DA DB)
// C8	Pushable Rock	(C8 C9 CA CB)
// D8	Bombable Wall	(D8 D9 DA DB)
// C4	Burnable Tree	(C4 C5 C6 C7)
// BC	Pushable Tomb	(BC BD BE BF)
// C0	Armos Statue	(C0 C1 C2 C3)
// C0	Armos Statue	(C0 C1 C2 C3)

// Fix cracked tiles always appearing regardless of Quest No. (by Trax)
org $AAD0	// $16AE0
	jsr $AC40	// Originally LDA $A976,X
org $AC30	// $16C40
	db $C8, $54, $C4, $BC, $C0, $C0	// Alternate secret tile codes table
// C8	Pushable Rock	(C8 C9 CA CB)
// 54	Bombable Wall	(54 55 56 57)
// C4	Burnable Tree	(C4 C5 C6 C7)
// BC	Pushable Tomb	(BC BD BE BF)
// C0	Armos Statue	(C0 C1 C2 C3)
// C0	Armos Statue	(C0 C1 C2 C3)
org $AC40	// $16C50 - Free space
	ldy.b $EB	// Current Location
	lda.w $6AFE,y	// Screen Attributes - Table 5 (VRAM)
	bmi quest2	// Bit 7 - 2nd Quest ONLY
	asl
	bmi quest1	// Bit 6 - 1st Quest ONLY
	bpl altTile
quest1:
	ldy.b $16	// Selected Save Slot (0-2)
	lda $062D,y	// 2nd Quest Flag (0 = 1st Quest, 1 = 2nd Quest)
	beq altTile
	bne normalTile
quest2:
	ldy.b $16	// Selected Save Slot (0-2)
	lda.w $062D,y	// 2nd Quest Flag
	bne altTile
normalTile:
	lda.w $A976,x
	rts
altTile:
	lda $AC30,x	// Alternate secret tile codes table
	rts

//Fix overworld cracked walls collision:
//org $????



//***********************************************************
//	Modify the Sword beam to stop firing at 3/4 hearts
//***********************************************************

bank 7;
// Default value of fire is at full hearts with damage above $80
// Change it to full hearts above $C0 for 1/4 hearts
// The Sword beam stops firing when it reaches 3/4 of the heart's gauge
org $F879	// $1F889
	cmp.b #$C0	// Originally CMP #$80


//***********************************************************
//	Remove 1 Rupee flashing (and possibly make it green too?)
//***********************************************************

// The color switch is 8 frames, and applies to a few objects, like small hearts, Triforce pieces, etc. I looked for all occurences of RAM $15, which is a frame counter. So, starting at 1E735, there's code that determines which items should be flashing. So replace this code with NOPs (EA):

bank 7;
org $E73D	// $1E74D
	nop	// Originally CPX #$16
	nop	// Originally CPX #$16
	nop	// Originally BEQ $0C -> 1E74D
	nop	// Originally BEQ $0C -> 1E74D

// At 6B5C, there's a table with palette codes for various things. 
// Change value at 6B72 to make the rupee another color if you want.
// 00 - Link, 01 - Orange, 02 - Blue, 03 - Zora/Moblin


//***********************************************************
//	Add 999 rupee counter
//***********************************************************

// (PENDING!!!)
// Code for converting the bytes/Hex to decimal seem to be at 66C5 and 66DE


//***********************************************************
// Reworked Save Selection screen, similar to Zelda 2 Redux
//***********************************************************

// (PENDING, LEAVING FOR LAST)
//bank 2; org $A5A2	// $0A5B2 - File Select screen code
//	and.b #$04		// Originally 29 20 - Changes the button input which moves the cursor in File Select screen
//bank 5; org $8B01	// $14B11
//	and.b #$04		// Originally 29 20 - Changes the button input which moves the cursor in the Continue/Save/Retry screen


//***********************************************************
//	Kill Pols Voice by using the flute and/or arrows
//***********************************************************

// (PENDING)

//***********************************************************
// Select button toggles between selected B button items
//***********************************************************

// Max value is $08. After 08 it jumps to the Raft and other Key items.
// Routine begins at $EC1B (0x1EC2B), ends at $EC79 (0x1EC89)
// Pause check begins at 1EC46, compares if Select has been pressed and then does LDA $00E0, EOR #$01 and STA $00E0 to #$01 (RAM $00E0), which tells the game it is Paused. Bypassing the Pause can be done by NOP'ing the LDA/EOR/STA starting at 0x1EC4C ($EC3C).

bank 7; org $EC3C  // $1EC4C
    // switch to bank 5
    lda.b    #$05
    jsr      $FFAC
    // hijack PAD_SELECT pressed on the overworld
    jsr      quick_select

bank 5; org $BFC0  //$17FD0
quick_select:
    lda.b    #$01   // PAD_RIGHT
    ldy.w    $0656  // current item
    jsr      $B7A8  // get next item $B7C8 (use 'jsr $B7A8' to also play sfx)
    rts


//***********************************************************
// Save Hearts number if last session had 3+ hearts of health
//***********************************************************

// (PENDING)


// Aquamentus color change for Dungeon 7
bank 6;
org $A291	// $1A29E
	db $0F,$13,$16,$35
