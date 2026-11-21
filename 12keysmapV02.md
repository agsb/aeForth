# 12keysMaps

QMK file for minimal keyboard of 12 keys version 0.2

Done with GEMINI, starts 20/11/2026

## include in config.h

```
\#pragma once

#define TAPPING_TERM 175
#define PERMISSIVE_HOLD
#define QUICK_TAP_TERM 110
#define CHORDAL_HOLD
```
## keymap.c

```
#include QMK_KEYBOARD_H

enum custom_layers {
    _L0_BASE = 0,     // Base Layer (Both Hands Active)
    _GRP1_L8_E,       // Hold L8 (E)     -> Remap Right Hand (Letters 2 + Enter)
    _GRP2_L7_A,       // Hold L7 (A)     -> Remap Right Hand (Numbers 0-6)
    _GRP3_L6_I,       // Hold L6 (I)     -> Remap Right Hand (~ 7 8 9 + ) ] })
    _GRP4_L5_O,       // Hold L5 (O)     -> Remap Right Hand (Navigation & Arrows)
    _GRP5_R5_SPC,     // Hold R5 (Space) -> Remap Left Hand (Letters 2 + Mods + Enter)
    _GRP6_R6_H,       // Hold R6 (H)     -> Remap Left Hand (U Y B Esc + ( [ { `)
    _GRP7_R7_L,       // Hold R7 (L)     -> Remap Left Hand (! @ # $ % ^ & *)
    _GRP8_R8_C,       // Hold R8 (C)     -> Remap Left Hand (- _ = + \ | ' ")
    _CROSS_TOP_THUMB  // Tap L4 + R1     -> Remaining Punctuation & Home/End
};

enum custom_keycodes {
    SPC_L0 = SAFE_RANGE // Types Space and immediately returns to Layer 0
};

// Left Lower-Row Group Holds (L5-L8 -> Remap Right Hand)
#define GR_L5 LT(_GRP4_L5_O,   KC_O)
#define GR_L6 LT(_GRP3_L6_I,   KC_I)
#define GR_L7 LT(_GRP2_L7_A,   KC_A)
#define GR_L8 LT(_GRP1_L8_E,   KC_E)

// Right Lower-Row Group Holds (R5-R8 -> Remap Left Hand)
#define GR_R5 LT(_GRP5_R5_SPC, KC_SPC)
#define GR_R6 LT(_GRP6_R6_H,   KC_H)
#define GR_R7 LT(_GRP7_R7_L,   KC_L)
#define GR_R8 LT(_GRP8_R8_C,   KC_C)

// Cross-Hand Top-Thumb Combo (Tap L4 Tab + R1 Backspace -> Section 4 Layer)
const uint16_t PROGMEM combo_cross_top[] = {KC_TAB, KC_BSPC, COMBO_END};
combo_t key_combos[] = {
    COMBO(combo_cross_top, TO(_CROSS_TOP_THUMB)),
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

    /* SECTION 1: LAYER 0 — BASE LAYER (Tap Any Key)
     * ,----------------------------------.   ,----------------------------------.
     * |   R   |   S   |   F   |   Tab    |   |  Bksp  |   T   |   N   |   D   |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * | O/Gr4 | I/Gr3 | A/Gr2 |  E/Gr1   |   |Spc/Gr5 | H/Gr6 | L/Gr7 | C/Gr8 |
     * `----------------------------------'   `----------------------------------'
     */
    [_L0_BASE] = LAYOUT_split_2x4(
        KC_R,    KC_S,    KC_F,    KC_TAB,      KC_BSPC, KC_T,    KC_N,    KC_D,
        GR_L5,   GR_L6,   GR_L7,   GR_L8,       GR_R5,   GR_R6,   GR_R7,   GR_R8
    ),

    /* SECTION 2 — GROUP 1: HOLD L8 ('E') -> REMAP RIGHT HAND
     * ,----------------------------------.   ,----------------------------------.
     * | XXXXX | XXXXX | XXXXX | XXXXX    |   |  Bksp  |   M   |   K   |   J   |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * | XXXXX | XXXXX | XXXXX | [HELD]   |   | Enter  |   G   |   V   |   X   |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP1_L8_E] = LAYOUT_split_2x4(
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     KC_BSPC, KC_M,    KC_K,    KC_J,
        XXXXXXX, XXXXXXX, XXXXXXX, _______,     KC_ENT,  KC_G,    KC_V,    KC_X
    ),

    /* SECTION 2 — GROUP 2: HOLD L7 ('A') -> REMAP RIGHT HAND
     * ,----------------------------------.   ,----------------------------------.
     * | XXXXX | XXXXX | XXXXX | XXXXX    |   |   0    |   1   |   2   |   3   |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * | XXXXX | XXXXX | [HELD]| XXXXX    |   |Spc/L0  |   4   |   5   |   6   |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP2_L7_A] = LAYOUT_split_2x4(
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     KC_0,    KC_1,    KC_2,    KC_3,
        XXXXXXX, XXXXXXX, _______, XXXXXXX,     SPC_L0,  KC_4,    KC_5,    KC_6
    ),

    /* SECTION 2 — GROUP 3: HOLD L6 ('I') -> REMAP RIGHT HAND (~ 7 8 9 on Top)
     * ,----------------------------------.   ,----------------------------------.
     * | XXXXX | XXXXX | XXXXX | XXXXX    |   |   ~    |   7   |   8   |   9   |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * | XXXXX | [HELD]| XXXXX | XXXXX    |   |Spc/L0  |   )   |   ]   |   }   |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP3_L6_I] = LAYOUT_split_2x4(
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     KC_TILD, KC_7,    KC_8,    KC_9,
        XXXXXXX, _______, XXXXXXX, XXXXXXX,     SPC_L0,  KC_RPRN, KC_RBRC, KC_RCBR
    ),

    /* SECTION 2 — GROUP 4: HOLD L5 ('O') -> REMAP RIGHT HAND
     * ,----------------------------------.   ,----------------------------------.
     * | XXXXX | XXXXX | XXXXX | XXXXX    |   |  Del   |  Ins  |  Up   | PgUp  |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * | [HELD]| XXXXX | XXXXX | XXXXX    |   |Spc/L0  | Left  | Down  | Right |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP4_L5_O] = LAYOUT_split_2x4(
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     KC_DEL,  KC_INS,  KC_UP,   KC_PGUP,
        _______, XXXXXXX, XXXXXXX, XXXXXXX,     SPC_L0,  KC_LEFT, KC_DOWN, KC_RGHT
    ),

    /* SECTION 3 — GROUP 5: HOLD R5 ('Space') -> REMAP LEFT HAND
     * ,----------------------------------.   ,----------------------------------.
     * |   Q   |   W   |   P   |    Z     |   | XXXXX  | XXXXX | XXXXX | XXXXX |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * | Shift | Ctrl  |  Alt  |  Enter   |   | [HELD] | XXXXX | XXXXX | XXXXX |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP5_R5_SPC] = LAYOUT_split_2x4(
        KC_Q,    KC_W,    KC_P,    KC_Z,        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        KC_LSFT, KC_LCTL, KC_LALT, KC_ENT,      _______, XXXXXXX, XXXXXXX, XXXXXXX
    ),

    /* SECTION 3 — GROUP 6: HOLD R6 ('H') -> REMAP LEFT HAND (U Y B Esc on Top)
     * ,----------------------------------.   ,----------------------------------.
     * |   U   |   Y   |   B   |   Esc    |   | XXXXX  | XXXXX | XXXXX | XXXXX |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * |   (   |   [   |   {   |    `     |   | XXXXX  | [HELD]| XXXXX | XXXXX |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP6_R6_H] = LAYOUT_split_2x4(
        KC_U,    KC_Y,    KC_B,    KC_ESC,      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        KC_LPRN, KC_LBRC, KC_LCBR, KC_GRV,      XXXXXXX, _______, XXXXXXX, XXXXXXX
    ),

    /* SECTION 3 — GROUP 7: HOLD R7 ('L') -> REMAP LEFT HAND
     * ,----------------------------------.   ,----------------------------------.
     * |   !   |   @   |   #   |    $     |   | XXXXX  | XXXXX | XXXXX | XXXXX |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * |   %   |   ^   |   &   |    *     |   | XXXXX  | XXXXX | [HELD]| XXXXX |
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP7_R7_L] = LAYOUT_split_2x4(
        KC_EXLM, KC_AT,   KC_HASH, KC_DLR,      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        KC_PERC, KC_CIRC, KC_AMPR, KC_ASTR,     XXXXXXX, XXXXXXX, _______, XXXXXXX
    ),

    /* SECTION 3 — GROUP 8: HOLD R8 ('C') -> REMAP LEFT HAND
     * ,----------------------------------.   ,----------------------------------.
     * |   -   |   _   |   =   |    +     |   | XXXXX  | XXXXX | XXXXX | XXXXX |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * |   \   |   |   |   '   |    "     |   | XXXXX  | XXXXX | XXXXX | [HELD]|
     * `----------------------------------'   `----------------------------------'
     */
    [_GRP8_R8_C] = LAYOUT_split_2x4(
        KC_MINS, KC_UNDS, KC_EQL,  KC_PLUS,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        KC_BSLS, KC_PIPE, KC_QUOT, KC_DQUO,     XXXXXXX, XXXXXXX, XXXXXXX, _______
    ),

    /* SECTION 4: CROSS-HAND TOP-THUMB TAP (Tap L4 + R1 -> Both Hands 2x4)
     * ,----------------------------------.   ,----------------------------------.
     * | Home  | PgDn  |  End  |  Meta-1  |   | Meta-2 |   ,   |   .   |   /   |
     * |-------+-------+-------+----------|   |--------+-------+-------+-------|
     * |   ;   |   :   |   <   |    >     |   |Spc/L0  |   ?   |  Del  |  Esc  |
     * `----------------------------------'   `----------------------------------'
     */
    [_CROSS_TOP_THUMB] = LAYOUT_split_2x4(
        KC_HOME, KC_PGDN, KC_END,  KC_LGUI,     KC_RGUI, KC_COMM, KC_DOT,  KC_SLSH,
        KC_SCLN, KC_COLN, KC_LT,   KC_GT,       SPC_L0,  KC_QUES, KC_DEL,  KC_ESC
    )
};

// Chordal Hold Handedness Map: Enforces strict opposite-hand holds across all 16 keys
const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM =
    LAYOUT_split_2x4(
        'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R',
        'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R'
    );

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (keycode == SPC_L0 && record->event.pressed) {
        tap_code(KC_SPC);       // Type Space
        layer_move(_L0_BASE);   // Return immediately to Layer 0
        return false;
    }
    return true;
}

```

