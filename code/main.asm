//******************************************************************
// Main assembly file.
// All of the assembly files get linked together and compiled here.
//******************************************************************

//****************************************
// Rom info
//****************************************
arch nes.cpu		// set processor architecture (NES)
banksize $4000		// set the size of each bank
header			// rom has a header

//****************************************
//	iNES Header
//****************************************
	db $4E,$45,$53,$1A	// Header (NES $1A)
	db $08			// 8 x 16k PRG banks
	db $00			// 0 x 8k CHR banks
	db %00010010		// Mirroring: Vertical
	// SRAM: Not used
	// 512k Trainer: Not used
	// 4 Screen VRAM: Not used
	// Mapper: 5
	db %00000000		// RomType: NES
	db $00,$00,$00,$00	// iNES Tail
	db $00,$00,$00,$00

//****************************************
// Mapper conversion
//****************************************

// Convert mapper from MMC1 to MMC3 or MMC5
//incsrc code/MMC3.asm		// Convert Zelda 1 from MMC1 to MMC3

// This will make it possible to have animations in the game, and make a lot of free space for custom graphics and diagonal swing graphics (maybe)

//****************************************
// Redux changes
//****************************************
incsrc code/redux.asm		// Main ASM code for Redux

//****************************************
// Gameplay changes
//****************************************
//incsrc code/file_select.asm	// File Select changes
incsrc code/bombs.asm		// Increase initial max bombs and upgrades to 10
incsrc code/automap.asm		// Disassembly of the Automap Plus hack by snarfblam
incsrc code/arrows.asm		// Arrow counter code by BogaaBogaa
incsrc code/rupee.asm		// Rupee 999 counter code by BogaaBogaa
incsrc code/move_maps.asm	// Change Hearts and Map positions in HUD

//****************************************
// Text changes
//****************************************
incsrc code/text.asm		// Relocalization of the game's script
incsrc code/story.asm		// Rewrite of the game's story and intro texts
incsrc code/credits.asm		// Rewrite of the game's credits sequences

//****************************************
// Visual changes
//****************************************
incsrc code/graphics.asm	// Sprite/graphic changes
incsrc code/title_screen.asm	// Title screen visual changes
incsrc code/tunic_colors.asm	// Make blue tunic more vivid

//****************************************
// Optional patches
// Uncomment the desired Optional patches
//****************************************

// Include optional patches
// Uncomment desired patches inside "optiona.asm" for them to compile
incsrc code/optional.asm

