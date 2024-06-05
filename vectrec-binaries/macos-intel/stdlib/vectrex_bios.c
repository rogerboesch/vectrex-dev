#include "vectrex/bios.h"

// ---------------------------------------------------------------------------
// GCC style functions (Uppercase variants in compatibility.h)

void asm wait_recal() {
  asm {
    // STD_INC_PATH must be defined by Makefile.am
    INCLUDE STD_INC_PATH
  }

  asm {
    JSR Wait_Recal
  }
}

void intensity_a(uint8_t i) {
  asm {
    LDA i
    JSR Intensity_a
  }
}

void reset0ref() {
  asm {
    JSR Reset0Ref
  }
}

void zero_beam() {
  reset0ref();
}

void print_str_d(int8_t y, int8_t x, char *string) {
  asm {
    JSR     DP_to_D0
    LDA     :y 
    LDB     :x 
    PSHS    U
    LDU     string
    JSR     Print_Str_d
    PULS    U
  }
}

void dot_d(int8_t y, int8_t x) {
  asm {
    JSR     DP_to_D0
    LDA     :y
    LDB     :x
    JSR     Dot_d
  }
}

void dot_list(uint8_t nr_dots, int8_t *list) {
  asm {
    JSR     DP_to_D0
    LDA     nr_dots
    STA     $C823
    LDX     list
    JSR     Dot_List
  }
}

void moveto_d(uint8_t y, uint8_t x) {
  asm {
    JSR     DP_to_D0
    LDA     :y
    LDB     :x
    JSR     Moveto_d
  }
}

void draw_line_d(int8_t y, int8_t x) {
  asm {
    CLR     Vec_Misc_Count    ; To draw only 1 line, clear
    LDA     :y
    LDB     :x
    JSR     Draw_Line_d
  }
}

void draw_vl_a(uint8_t nr_lines, int8_t *list) {
  asm {
    JSR     DP_to_D0
    LDA     nr_lines
    DECA
    LDX     list
    JSR     Draw_VL_a
  }
}

void draw_vlc(int8_t *list) {
  asm {
    LDX     list
    JSR     Draw_VLc
  }
}

void draw_pat_vl_a(uint8_t pattern, uint8_t nr_lines, int8_t *list) {
  asm {
    JSR     DP_to_D0
    LDA     pattern
    STA     Vec_Pattern
    LDA     nr_lines
    DECA
    LDX     list
    JSR     Draw_Pat_VL_a
  }
}

void rot_vl_ab(int8_t angle, uint8_t nr_points, int8_t *points, int8_t *out_points) {
  asm {
    PSHS    U,D
    LDA     angle
    LDB     nr_points
    DECB       
    LDX     points
    LDU     out_points
    JSR     Rot_VL_ab  
    PULS    U,D
  }
}

void init_music_chk(int8_t *music) {
  asm {
    PSHS    U
    JSR     DP_to_C8
    LDU     music
    JSR     Init_Music_chk
    PULS    U
  }
}

void do_sound() {
  asm {
    JSR     Do_Sound
  }
}

void clear_sound() {
  asm {
      JSR     Clear_Sound
  }
}

void explosion_sound() {
  asm {
      JSR     Explosion_Snd
  }
}

void asm cold_start() {
  asm {
    JSR   Cold_Start
  }
}

void asm warm_start() {
  asm {
    JSR   Warm_Start
  }
}

void asm init_via() {
  asm {
    JSR   Init_VIA
  }
}

void asm init_os_ram() {
  asm {
    JSR   Init_OS_RAM
  }
}

void asm init_os() {
  asm {
    JSR Init_OS
  }
}

void set_refresh(uint16_t value) {
  asm {
    JSR     DP_to_D0
    LDX     value
	  STX 	  0xc83e
    PSHS    D
	  JSR 	  Set_Refresh
    PULS    D
  }
}

int8_t random() {
  int8_t rnd;

  asm {
    JSR Random
    STA rnd
  }

  return rnd;
}

uint8_t read_btns() {
  uint8_t buttons;

  asm {
    JSR DP_to_D0
    JSR Read_Btns
    STA buttons
  }

  return buttons;
}

void joy_digital() {
  asm {
    JSR Joy_Digital
  }
}

void joy_analog() {
  asm {
    JSR Joy_Analog
  }
}

// ---------------------------------------------------------------------------
// Helper functions to simplyify access to some static ram areas
// All can now also be done by using directly the Vex_xxx variables

void set_text_size(int8_t height, int8_t width) {
  asm {
    LDA     width
    STA     Vec_Text_Width
    LDA     height
    STA     Vec_Text_Height
  }
}

void set_scale(int8_t scale) {
  asm {
    LDA     scale
    STA     <VIA_t1_cnt_lo
  }
}

void music_set_flag(uint8_t flag) {
  asm {
    LDA     flag
    STA     Vec_Music_Flag
  }
}

uint8_t music_get_flag() {
  uint8_t flag;

  asm {
    LDA     Vec_Music_Flag
    STA     flag
  }

  return flag;
}

void random_seed(uint8_t seed1, uint8_t seed2, uint8_t seed3) {
  asm {
     LDA  seed1
     STA  Vec_Seed_Ptr+0   
     LDA  seed2
     STA  Vec_Seed_Ptr+1   
     LDA  seed3
     STA  Vec_Seed_Ptr+2
  }
}

void dp_to_d0() {
  asm {
        JSR DP_to_D0
  }
}

void dp_to_c8() {
  asm {
        JSR DP_to_C8
  }
}

void sound_byte(uint8_t reg, uint8_t value) {
  // Not yet tested
  asm {
    PSHS    X,Y
    LDA reg
    LDB value

    JSR Sound_Byte

    PULS    X,Y
  }
}

void sound_bytes(const void* sound_block) {
  asm {
    PSHS D,X,Y,U
    LDU sound_block
    JSR Sound_Bytes

    PULS D,X,Y,U
  }
}

// ---------------------------------------------------------------------------
// C-style print function

void print_str_c(int8_t y, int8_t x, char *string) {
  asm {
    JSR     DP_to_D0
    LDA     :y 
    LDB     :x 
    PSHS    U
    LDU     string
    
    ; -- Print_Str_d --
    JSR     >Moveto_d_7F
    JSR     Delay_1

    STU     Vec_Str_Ptr     ;Save string pointer
    LDX     #Char_Table-$20 ;Point to start of chargen bitmaps
    LDD     #$1883          ;$8x = enable RAMP?
    CLR     <VIA_port_a     ;Clear D/A output
    STA     <VIA_aux_cntl   ;Shift reg mode = 110, T1 PB7 enabled
    LDX     #Char_Table-$20 ;Point to start of chargen bitmaps
LF4A5:
    STB     <VIA_port_b     ;Update RAMP, set mux to channel 1
    DEC     <VIA_port_b     ;Enable mux
    LDD     #$8081
    NOP                     ;Wait a moment
    INC     <VIA_port_b     ;Disable mux
    STB     <VIA_port_b     ;Enable RAMP, set mux to channel 0
    STA     <VIA_port_b     ;Enable mux
    TST     $C800           ;I think this is a delay only
    INC     <VIA_port_b     ;Enable RAMP, disable mux
    LDA     Vec_Text_Width  ;Get text width
    STA     <VIA_port_a     ;Send it to the D/A
    LDD     #$0100
    LDU     Vec_Str_Ptr     ;Point to start of text string
    STA     <VIA_port_b     ;Disable RAMP, disable mux
    BRA     LF4CB

LF4C7:
    LDA     A,X             ;Get bitmap from chargen table
    STA     <VIA_shift_reg  ;Save in shift register
LF4CB:
    LDA     ,U+             ;Get next character
    ; BPL     LF4C7           ;Go back if not terminator
    BNE     LF4C7           ;Go back if not terminator
    LDA     #$81
    STA     <VIA_port_b     ;Enable RAMP, disable mux
    NEG     <VIA_port_a     ;Negate text width to D/A
    LDA     #$01
    STA     <VIA_port_b     ;Disable RAMP, disable mux
    CMPX    #Char_Table_End-$20 ;     Check for last row
    BEQ     LF50A           ;Branch if last row
    LEAX    $50,X           ;Point to next chargen row
    TFR     U,D             ;Get string length
    SUBD    Vec_Str_Ptr
    SUBB    #$02            ; -  2
    ASLB                    ; *  2
    BRN     LF4EB           ;Delay a moment
LF4EB:
    LDA     #$81
    NOP
    DECB
    BNE     LF4EB           ;Delay some more in a loop
    STA     <VIA_port_b     ;Enable RAMP, disable mux
    LDB     Vec_Text_Height ;Get text height
    STB     <VIA_port_a     ;Store text height in D/A
    DEC     <VIA_port_b     ;Enable mux
    LDD     #$8101
    NOP                     ;Wait a moment
    STA     <VIA_port_b     ;Enable RAMP, disable mux
    CLR     <VIA_port_a     ;Clear D/A
    STB     <VIA_port_b     ;Disable RAMP, disable mux
    STA     <VIA_port_b     ;Enable RAMP, disable mux
    LDB     #$03            ;$0x = disable RAMP?
    BRA     LF4A5           ;Go back for next scan line

LF50A:
    LDA     #$98
    STA     <VIA_aux_cntl   ;T1->PB7 enabled
    JSR     Reset0Ref       ;Reset the zero reference

    ; --
    PULS    U
  }
}

// ---------------------------------------------------------------------------
// Math helpers

uint8_t abs(int8_t value) {
  if (value < 0)
    return -value;

  return value;
}

// ---------------------------------------------------------------------------
// Controller/Joystick helpers

// Initialization, each controller axis can be individually
// switched on or off; for performance reasons, activate only what you really need

int8_t last_horizontal1;
int8_t last_vertical1;

void controller_enable_1_x() {
  asm {
    LDA     1
    STA     Vec_Joy_Mux_1_X
  }
}

void controller_enable_1_y() {
  asm {
    LDA     3
    STA     Vec_Joy_Mux_1_Y
  }
}

void controller_enable_2_x() {
  asm {
    LDA     5
    STA     Vec_Joy_Mux_2_X
  }
}

void controller_enable_2_y() {
  asm {
    LDA     7
    STA     Vec_Joy_Mux_2_Y
  }
}

void controller_disable_1_x() {
  asm {
    LDA     0
    STA     Vec_Joy_Mux_1_X
  }
}

void controller_disable_1_y() {
  asm {
    LDA     0
    STA     Vec_Joy_Mux_1_Y
  }
}

void controller_disable_2_x() {
  asm {
    LDA     0
    STA     Vec_Joy_Mux_2_X
  }
}

void controller_disable_2_y() {
  asm {
    LDA     0
    STA     Vec_Joy_Mux_2_Y
  }
}

// Read controller buttons
// Must be called once each time you want to check the buttons

void controller_check_buttons() {
  read_btns();
}

uint8_t controller_buttons_pressed() {
  uint8_t flag;

  asm {
    LDA     Vec_Buttons
    STA     flag
  }

  return flag;
}

uint8_t controller_buttons_held() {
  uint8_t flag;

  asm {
    LDA     Vec_Btn_State
    STA     flag
  }

  return flag;
}

// call these functions below to check if a specific button is pressed,
// the button must be released before another press is registered,
// return value is 0 or 1, so these functions can be used as check in
// conditional statements

uint8_t controller_button_1_1_pressed() {
  return (controller_buttons_pressed() & 0b00000001);
}

uint8_t controller_button_1_2_pressed() {
  return (controller_buttons_pressed() & 0b00000010);
}

uint8_t controller_button_1_3_pressed() {
  return (controller_buttons_pressed() & 0b00000100);
}

uint8_t controller_button_1_4_pressed() {
  return (controller_buttons_pressed() & 0b00001000);
}

uint8_t controller_button_2_1_pressed() {
  return (controller_buttons_pressed() & 0b00010000);
}

uint8_t controller_button_2_2_pressed() {
  return (controller_buttons_pressed() & 0b00100000);
}
uint8_t controller_button_2_3_pressed() {
  return (controller_buttons_pressed() & 0b01000000);
}

uint8_t controller_button_2_4_pressed() {
  return (controller_buttons_pressed() & 0b10000000);
}

// call these functions below to check if a specific button is held,
// return value is 0 or 1, so these functions can be used as check in conditional statements

uint8_t controller_button_1_1_held() {
  return (controller_buttons_held() & 0b00000001);
}

uint8_t controller_button_1_2_held() {
  return (controller_buttons_held() & 0b00000010);
}

uint8_t controller_button_1_3_held() {
  return (controller_buttons_held() & 0b00000100);
}

uint8_t controller_button_1_4_held() {
  return (controller_buttons_held() & 0b00001000);
}

uint8_t controller_button_2_1_held() {
  return (controller_buttons_held() & 0b00010000);
}

uint8_t controller_button_2_2_held() {
  return (controller_buttons_held() & 0b00100000);
}

uint8_t controller_button_2_3_held() {
  return (controller_buttons_held() & 0b01000000);
}

uint8_t controller_button_2_4_held() {
  return (controller_buttons_held() & 0b10000000);
}

// read controller joysticks
// must be called once each time you want to check the joysticks

void controller_check_joysticks() {
  last_horizontal1 = controller_joystick_1_x();
  last_vertical1 = controller_joystick_1_y();

  joy_digital();
}

int8_t controller_joystick_1_x() {
  int8_t flag;

  asm {
    LDA     Vec_Joy_1_X
    STA     flag
  }

  return flag;
}

int8_t controller_joystick_1_y() {
  int8_t flag;

  asm {
    LDA     Vec_Joy_1_Y
    STA     flag
  }

  return flag;
}

int8_t controller_joystick_2_x() {
  int8_t flag;

  asm {
    LDA     Vec_Joy_2_X
    STA     flag
  }

  return flag;
}

int8_t controller_joystick_2_y() {
  int8_t flag;

  asm {
    LDA     Vec_Joy_2_Y
    STA     flag
  }

  return flag;
}

// call these functions below to check if a joystick is moved in a specific direction,
// return value is 0 or 1, so these functions can be used as check in conditional statements

uint8_t controller_joystick_1_leftChange() {
  return (controller_joystick_1_x() < 0) && (last_horizontal1 >= 0);
}

uint8_t controller_joystick_1_rightChange() {
  return (controller_joystick_1_x() > 0) && (last_horizontal1 <= 0);
}

uint8_t controller_joystick_1_downChange() {
  return (controller_joystick_1_y() < 0) && (last_vertical1 >= 0);
}

uint8_t controller_joystick_1_upChange() {
  return (controller_joystick_1_y() > 0) && (last_vertical1 <= 0);
}

uint8_t controller_joystick_1_left() {
  return (controller_joystick_1_x() < 0);
}

uint8_t controller_joystick_1_right() {
  return (controller_joystick_1_x() > 0);
}

uint8_t controller_joystick_1_down() {
  return (controller_joystick_1_y() < 0);
}

uint8_t controller_joystick_1_up() {
  return (controller_joystick_1_y() > 0);
}

uint8_t controller_joystick_2_left() {
  return (controller_joystick_2_x() < 0);
}

uint8_t controller_joystick_2_right() {
  return (controller_joystick_2_x() > 0);
}

uint8_t controller_joystick_2_down() {
  return (controller_joystick_2_y() < 0);
}

uint8_t controller_joystick_2_up() {
  return (controller_joystick_2_y() > 0);
}

// ---------------------------------------------------------------------------
// Music support (not completely implemented yet)

#define BP(x) *((uint8_t *) x)
#define Vec_Music_Flag BP(0xC856) // Music active flag (0x00=off 0x01=start 0x80=on)
#define Vec_Snd_Shadow BP(0xC800) // Shadow of sound chip registers (15 bytes)

void* g_current_music = 0;
uint8_t g_last_music_flag = Vec_Music_Flag;

void play_music(void* music) {
  Vec_Music_Flag = 1;
  g_current_music = music;
}

void stop_music() {
  if (Vec_Music_Flag != 0) {
      Vec_Music_Flag = 0;
      g_last_music_flag = 0;
      g_current_music = 0;

      clear_sound();
  }
}

int8_t is_music_playing() {
  return Vec_Music_Flag != 0;
}

void play_sound(const void *sound_block) {
  stop_music();
  sound_bytes(sound_block);
}

void stop_sound() {
  clear_sound();
}

void update_audio() {
	if (Vec_Music_Flag != 0) {
		init_music_chk(g_current_music);
	}

	if (Vec_Music_Flag == 0 && g_last_music_flag != 0) {
		clear_sound();
    g_current_music = 0;
	}

  g_last_music_flag = Vec_Music_Flag;
}

void wait_for_beam() {
  update_audio();
  wait_recal();
	do_sound();

  // Maybe include here later reading joystick
}
