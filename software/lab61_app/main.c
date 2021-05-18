//#define key0 (*KEY_PIO & 0b00000001)
//#define key1 (*KEY_PIO & 0b00000010)
#define key0 (*KEY_PIO & 0b00000001)
#define key1 (*KEY_PIO & 0b00000010)
//#define KEY_2 (*KEY_PIO & 0b00000100)
//#define KEY_3 (*KEY_PIO & 0b00001000)

int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x60;
	volatile unsigned int *KEY_PIO = (unsigned int*)0x70;

	*LED_PIO = 0; //clear all LEDs
	unsigned int accumulate = 0;


	while ( (1+1) != 3) //infinite loop
	{
		for (int i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (int i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
//		for (i = 0; i < 100000; i++); //software delay

//		if (!key0){ //reset
//			accumulate = 0;
//			*LED_PIO = accumulate;
//		}
//		while(!key0);

//		if (!key1){
//			accumulate += *SW_PIO;
//			if (accumulate > 255){
//				accumulate = accumulate - 255;
//			}
//			*LED_PIO = accumulate;
//			while(!key1);
//		}
	}
	return 1; //never gets here
}
