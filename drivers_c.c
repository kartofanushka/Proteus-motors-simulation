#define F_CPU 8000000UL
#include <avr/io.h>
#include <util/delay.h>

// Direction commands (identical for both ports)
#define M_FORWARD    0x1B
#define M_BACKWARD   0x2D
#define M_LEFT       0x1D
#define M_RIGHT      0x2B
#define M_STOP       0x00

void init_system() {
	// Configure pins 0-5 on ports B and C as outputs
	DDRB |= 0x3F;
	DDRC |= 0x3F;
	
	// Configure pins 4-7 on port A as inputs (buttons)
	DDRA &= ~((1 << PA4) | (1 << PA5) | (1 << PA6) | (1 << PA7));
	
	// Stop all motors on startup
	PORTB = M_STOP;
	PORTC = M_STOP;
}

int main(void) {
	init_system();

	while (1) {
		if (!(PINA & (1 << PA7))) {
			// Forward
			PORTB = M_FORWARD;
			PORTC = M_FORWARD;
		}
		else if (!(PINA & (1 << PA6))) {
			// Backward
			PORTB = M_BACKWARD;
			PORTC = M_BACKWARD;
		}
		else if (!(PINA & (1 << PA5))) {
			// Left (tank turn)
			PORTB = M_LEFT;
			PORTC = M_LEFT;
		}
		else if (!(PINA & (1 << PA4))) {
			// Right (tank turn)
			PORTB = M_RIGHT;
			PORTC = M_RIGHT;
		}
		else {
			// Stop nothing is pressed
			PORTB = M_STOP;
			PORTC = M_STOP;
		}
		
		_delay_ms(10);
	}
}
