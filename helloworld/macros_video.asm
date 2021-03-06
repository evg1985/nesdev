; Load 32 bytes (background and spite, 1st background) of palette from address
; PARAM1 - address of palette data
; Example: Loadpalette palette
LoadPalette .macro
  LDA #$3F              ; set PPU working address 3F00 - palette 
  STA $2006             
  LDA #$00
  STA $2006             
  LDX #$00              ; reset counter
LoadPaletteLoop\@:
  LDA \1, x             ; load data from address (pallete addr + the value in x)
  STA $2007             
  INX                   
  CPX #$20              ; Compare X to 32, looping if not equal
  BNE LoadPaletteLoop\@
  .endm

; Shorthand, just put 1 tile from param 1 to video memory
; PARAM1 - Tile number in Name Table
; Example: Drawtile #$24
DrawTile .macro
  LDA \1
  STA $2007
  .endm



; Clear background
; PARAM1 - base adress of PPU page, allowed values $20, $24, $28, $2C
; PARAM2 - Tile Id which will fill rect
; Example: Clearscreen #$24
ClearScreen .macro
  MoveTo \1, #0, #0
  LDA \2
  LDY #0
ClearScreenRowLoop\@:
  LDX #0
ClearScreenColLoop\@:
  STA $2007
  INX
  CPX #32
  BNE ClearScreenColLoop\@
  INY
  CPY #30
  BNE ClearScreenRowLoop\@
  LDA #$00
  STA $2006
  STA $2006
  .endm

; Return position in VRAM for column and row parameters
; PARAM1 - column
; PARAM2 - row
; Example: ScreenAddress(5, 7)
ScreenAddress .func (\1) + ((\2) << 5)  

; Set PPU start adress
; PARAM1 - base adress of PPU page, allowed values $2000, $2400, $2800, $2C00
; PARAM2 - X position 
; PARAM3 - Y position 
; Example: MoveTo $20, #10, #7
MoveTo .macro
  LDA #HIGH(\1) ; Load page address
  STA TMP
  LDA \3 ; Load Y position, extract from it bits 3, 4 and store them to bit 2, 3 in high byte
  LSR A
  LSR A
  LSR A
  ADC TMP
  STA $2006

  LDA \3 ; Load Y position, extract from it bits 0, 1 and 2 and store them to bits 5, 6 and 7 in low byte
  AND #%00000111
  ASL A
  ASL A
  ASL A
  ASL A
  ASL A
  LDX \2
  STX TMP
  ADC TMP
  STA $2006
  .endm