#include <math.h>

int sndPin = 9;
int shockPin = 12;
int sndLed = 4;
int shockLed = 5;


void setup()
{

  pinMode(sndPin, OUTPUT);
  pinMode(shockPin, OUTPUT);
  pinMode(sndLed, OUTPUT);
  pinMode(shockLed, OUTPUT);
  digitalWrite(shockPin, HIGH);
  Serial.begin(9600);
  digitalWrite(shockPin, HIGH);
}




void shock_and_awe(int freq, int duration, int shockDuration)
{
    int tonePin = sndPin;
    float del;
    long i;
    del = (int)(500.0*(1000.0/(float)(freq)));
    digitalWrite(sndLed, HIGH);
    digitalWrite(shockLed, LOW);

    int startShock = duration - shockDuration;
    int started=0;
    for (i=0; i < 1000L*duration; i+= del*2)
    {
        digitalWrite(tonePin, HIGH);
        delayMicroseconds(del);
        digitalWrite(tonePin, LOW);
        delayMicroseconds(del);
        if (started <=0 && shockDuration && i > startShock*1000L)
        {
          digitalWrite(shockPin, LOW);
          digitalWrite(shockLed, HIGH);
          started++;
        }
    }
    if (shockDuration > 0)
    {
      digitalWrite(shockPin, HIGH);
      digitalWrite(shockLed, LOW);
    }
    digitalWrite(sndLed, LOW);
}


void  ledBeeps(int total)
{
  for (int i=0; i <total; i++)
  {
    digitalWrite(sndLed, HIGH);
    delay(100);
    digitalWrite(sndLed, LOW);
    delay(100);
  }

}

int soundDuration=4000;
int shockDuration=1000;
void loop()
{
  int i=0;
  char commandbuffer[200];
  int delayBefore, soundDur, shockDur, delayAfter, freq;

  delay(200);
  digitalWrite(shockPin, HIGH);
  if (Serial.available()>0){
    digitalWrite(shockPin, HIGH);
    i=0;
     delay(300);
     while( Serial.available()>0 && i< 199) {
        commandbuffer[i++] = Serial.read();
     }
     commandbuffer[i++]='\0';
     
     int ret = (sscanf(commandbuffer, "SET,%d,%d,%d,%d,K", &delayBefore, &soundDur, &shockDur, &freq) ==   4);
     if (ret>0)
     {
       ledBeeps(1);
       Serial.print("Executing: ");
       Serial.println(commandbuffer);
       delay(delayBefore);
       ////shock_and_awe(freq, soundDur, shockDur);
       //noTone(sndPin);
       digitalWrite(sndLed, HIGH);
       tone(sndPin, freq, soundDur);
       delay(soundDur - shockDur);
       if (shockDur >0) { 
         digitalWrite(shockPin, LOW);
         digitalWrite(shockLed, HIGH);
         delay(shockDur);
         digitalWrite(shockPin, HIGH);
         digitalWrite(shockLed, LOW);
       }
       noTone(sndPin); 
       digitalWrite(sndLed, LOW);
       Serial.println("Done");
     }
     else
     {
       ledBeeps(3);
       Serial.println("Not understood: ");
       Serial.println(commandbuffer);
       digitalWrite(shockPin, HIGH);
       digitalWrite(shockLed, LOW);
     }
  }
  Serial.flush();

}

