; Soul Blazer - Magician Mode
; Version: Alpha
; Author: DentedRazor
; Date: 2025-04-06
; Brief Description: No swords, but magic works better now.
; 
; 1. Updates Title Screen to indicate mode
; 2. 1st Lair is cleared of enemies
; 3. Spells are 0-cost
; 4. Swords no longer do damage, only spells work
; 5. Certain enemies need to be defeated while specific swords are equipped
; 6. Bosses can be damaged with spells, but sword damage is used instead
; 7. Phoenix and Thunder Ring's blasts are not affected
;
; Planned Features for rest of Beta
; 1. Updated story text
; 2. Different method besides 0-gems maybe?
; 3. Ideas from others
; 4. More code cleanup

if not(defined("initialized"))
    arch 65816
    lorom

    check title "SOULBLAZER - 1 USA   "

    !initialized = 1
endif

namespace magician_mode

;Constants

ADDR_ARR_TITLE_TEXT    = $02BB3C

ADDR_1ST_LAIR_MSTR_QTY = $01BA20

ADDR_COST_DESC_FLAME_BALL     = $02D963
ADDR_COST_DESC_LIGHT_ARROW    = $02D999
ADDR_COST_DESC_MAGIC_FLARE    = $02D9D5
ADDR_COST_DESC_ROTATOR        = $02DA14
ADDR_COST_DESC_SPARK_BOMBS    = $02DA46
ADDR_COST_DESC_FLAME_PILLAR_1 = $02DA80
ADDR_COST_DESC_FLAME_PILLAR_2 = $02DA81
ADDR_COST_DESC_TORNADO        = $02DAB3
ADDR_COST_DESC_PHOENIX        = $02DAE2

ADDR_COST_VAL_FLAME_BALL   = $00A16A
ADDR_COST_VAL_LIGHT_ARROW  = $00A17A
ADDR_COST_VAL_MAGIC_FLARE  = $00A18A
ADDR_COST_VAL_ROTATOR      = $00A3F0
ADDR_COST_VAL_SPARK_BOMBS  = $00A1A7
ADDR_COST_VAL_FLAME_PILLAR = $00A1B7
ADDR_COST_VAL_TORNADO      = $00A1C7
ADDR_COST_VAL_PHOENIX      = $009F95

ADDR_MAGIC_ARMOR_INC = $00DB98

ADDR_SWORD_CONTACT = $008B09

ADDR_MAGIC_BOSS_CHECK = $008C82

; 1. Update Title screen
;ALL RIGHTS RESERVED -> Magician Mode Alpha
org ADDR_ARR_TITLE_TEXT 
db $4D, $61, $67, $69, $63, $69, $61, $6E, $20, ;Magician
   $4D, $6F, $64, $65, $20, ;Mode
   $41, $6C, $70, $68, $61  ;Alpha
   
; 2. Update 1st Lair to have no monsters
org ADDR_1ST_LAIR_MSTR_QTY
db $00;

; 3. Spells are 0-cost
; Descriptions in Menu
org ADDR_COST_DESC_FLAME_BALL
db $30; 0

org ADDR_COST_DESC_LIGHT_ARROW
db $30; 0

org ADDR_COST_DESC_MAGIC_FLARE
db $30; 0

org ADDR_COST_DESC_ROTATOR 
db $30; 0

org ADDR_COST_DESC_SPARK_BOMBS
db $30; 0

org ADDR_COST_DESC_FLAME_PILLAR_1
db $30; 0

org ADDR_COST_DESC_FLAME_PILLAR_2
db $40; Blank

org ADDR_COST_DESC_TORNADO
db $30; 0

org ADDR_COST_DESC_PHOENIX
db $30; 0
; Actual Costs
org ADDR_COST_VAL_FLAME_BALL
db $00

org ADDR_COST_VAL_LIGHT_ARROW
db $00

org ADDR_COST_VAL_MAGIC_FLARE
db $00

org ADDR_COST_VAL_ROTATOR
db $00

org ADDR_COST_VAL_SPARK_BOMBS
db $00

org ADDR_COST_VAL_FLAME_PILLAR
db $00

org ADDR_COST_VAL_TORNADO
db $00

org ADDR_COST_VAL_PHOENIX
db $00

;Prevent Magic Armor check from incrementing cost to 0
org ADDR_MAGIC_ARMOR_INC
db $EA

;4. Updates to Sword Contact routine
org ADDR_SWORD_CONTACT
db $60,           ;RTS - If hit with sword, return
   $AD, $5E, $1B, ;LDA $1B5E   -Load Sword Type
   $C9, $08, $00, ;CMP #$0008  -Compare with Soul Blade
   $F0, $27,      ;BEQ #$8B39  -If equal, go to boss check
   $B9, $1A, $00,  ;LDA $001A,Y -Load enemy type 
   $89, $00, $08, ;BIT #$0800  -Check if Spirit Type
   $D0, $0B,      ;BNE $008B25 -If equal, go to Spirit Check
   $89, $00, $04, ;BIT #$0400  -Check if Metal Type
   $D0, $0F,      ;BNE $008B2E -If equal, go to Metal Check
   $89, $00, $02, ;BIT #$0200  -Check if Soul Type
   $F0, $15,      ;BEQ $8B39   -If not, go to boss check
   $60,           ;RTS
;------Spirit Sword Check-----------
   $AD, $5E, $1B, ;LDA $1B5E   -Load Sword Type
   $C9, $06, $00, ;CMP #$0006  -Compare with Spirit Sword
   $F0, $0C,      ;BEQ $008B39 -If equal, go to boss check
   $60,           ;RTS
;-------Metal Sword Check
   $AD, $5E, $1B, ;LDA $1B5E   -Load Sword Type
   $C9, $05, $00, ;CMP #$0006  -Compare with 
   $F0, $03,      ;BEQ $008B39 -Go to boss check
   $00, $4C,      ;BRK $4C     -Metal Ding Noise
   $60,           ;RTS
;-------Boss Check-----
   $CC, $9A, $03, ;CPY $039A   -Compare if Boss
   $F0, $39,      ;BEQ $8B77   -If equal, go to Sword Damage
   $20, $95, $8C, ;JSR $8C95   -Otherwise, go to Magic damage
   $60,           ;RTS
   $EA            ;NOP

;5. Updates to Boss Check in Magic Contact routine
org ADDR_MAGIC_BOSS_CHECK
db $20, $0A, $8B, ;JSR $8B0A - Go to Sword Routine
   $60            ;RTS
