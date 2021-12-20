// Outputs:
byte data1 =   0; //0b00000000 -> 0b00 X Y B A L R
byte data2 =  64; //0b01000000 -> 0b01 S Bt Ax(4bitsH)
byte data3 = 128; //0b10000000 -> 0b10 Ax(4bitsL) Ay(2bitsH)
byte data4 = 192; //0b11000000 -> 0b11 Ay(6bitsL)

// Inputs:
bool X,Y,B,A,L,R,S,Bt;
byte Ax,Ay;

void setup() {
  Serial.begin(9600);
  pinMode(13, INPUT); // X
  pinMode(12, INPUT); // Y
  pinMode(11, INPUT); // B
  pinMode(10, INPUT); // A
  pinMode(9, INPUT); // L
  pinMode(8, INPUT); // R

  pinMode(7, INPUT); // S
  pinMode(6, INPUT); // Bt

  // A0 = Ax
  // A1 = Ay
}

void loop() {
  // Read the sensors:
  X = digitalRead(13);
  Y = digitalRead(12);
  B = digitalRead(11);
  A = digitalRead(10);
  L = digitalRead(9);
  R = digitalRead(8);

  S = digitalRead(7);
  Bt = digitalRead(6);

  Ax = map(analogRead(A0),0,1023,0,255);
  Ay = map(analogRead(A1),0,1023,0,255);
  
  /*
  // Example:
  X = true;
  Y = false;
  B = false;
  A = true;
  L = true;
  R = false;

  S = true;
  Bt = false;

  Ax = 0b01110101;
  Ay = 0b10101101;
  */
  
  // Preparing data:
  data1 = 0 + (X<<5) + (Y<<4) + (B<<3) + (A<<2) + (L<<1) + R; //0b00000000 -> 0b00 X Y B A L R
  data2 = (0b01000000) + (S<<5) + (Bt<<4) + (Ax>>4); //0b01000000 -> 0b01 S Bt Ax(4bitsH)
  byte Axaux = Ax-((Ax>>4)<<4);
  data3 = (0b10000000) + (Axaux<<2) + (Ay>>6); //0b10000000 -> 0b10 Ax(4bitsL) Ay(2bitsH)
  byte Ayaux = Ay-((Ay>>6)<<6);
  data4 = (0b11000000) + Ayaux; //0b11000000 -> 0b11 Ay(6bitsL)
    
  // Send the data - uart:
  Serial.write(data1); //data1
  _delay_us(400);
  Serial.write(data2); //data2
  _delay_us(400);
  Serial.write(data3); //data3
  _delay_us(400);
  Serial.write(data4); //data4
  _delay_us(400);
}
