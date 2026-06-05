.include "m32def.inc"

.cseg
.org 0x00
    rjmp reset

reset:
    ; Stack initialization
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

    ; Configure Pins 0-5 on PORTB and PORTC as outputs
    in r16, DDRB
    ori r16, 0x3F
    out DDRB, r16

    in r16, DDRC
    ori r16, 0x3F
    out DDRC, r16

    ; Configure Pins 4-7 on PORTA as inputs
    in r16, DDRA
    andi r16, 0x0F
    out DDRA, r16

    ; Initial state: stop all motors
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16

main_loop:
    ; Polling buttons (Active-Low)
    sbis PINA, 7
    rjmp do_forward

    sbis PINA, 6
    rjmp do_backward

    sbis PINA, 5
    rjmp do_left

    sbis PINA, 4
    rjmp do_right

    rjmp do_stop

; --- Command Handlers ---

do_forward:
    ldi r16, 0x1B
    rjmp output_signals

do_backward:
    ldi r16, 0x2D
    rjmp output_signals

do_left:
    ldi r16, 0x1D
    rjmp output_signals

do_right:
    ldi r16, 0x2B
    rjmp output_signals

do_stop:
    ldi r16, 0x00
    rjmp output_signals

; --- Execution ---

output_signals:
    out PORTB, r16       
    out PORTC, r16       
    
    rcall delay_10ms     
    rjmp main_loop       

; --- Delay ---
delay_10ms:
    ldi r18, 104         
delay_outer:
    ldi r19, 255        
delay_inner:
    dec r19              
    brne delay_inner     
    dec r18              
    brne delay_outer     
    ret
