//StorySpell App - Activity for children between 4-6 years old based on storytelling
//Group project Members: Teresa Paulino and Jorge Díaz
//Programmed by Teresa Paulino
//26-05-2014
//v.2.0

import processing.serial.*;
import cc.arduino.*;
import ddf.minim.*;

Minim minim;
AudioPlayer sound1;
AudioPlayer sound2;

PImage[] stars = new PImage[55];
PImage[] bg = new PImage[13];

Arduino arduino;
int[] ledPins = {6,2,3,4,5};
int vibrator = 7;
int sensor = 0;
int i=0;

int read;
boolean energy = true;
int step = -1;
PImage scenario;

int sT;
boolean sound = false;

void setup()
{
  frameRate(15);
  size(1024,650);
  imageMode(CENTER);
  background(loadImage("background.jpg"));
  scenario = (loadImage("background.jpg"));
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  
  //filling up the arrays with the led pins info as OUTPUT
  for (int i = 0; i < 5; i++)
  {
    arduino.pinMode(ledPins[i], Arduino.OUTPUT);
  }
  
  //sensor will receive accelerometer input
  arduino.pinMode(sensor, Arduino.INPUT);
  
  //vibration motor as Output
  arduino.pinMode(vibrator, Arduino.OUTPUT);
  
  minim = new Minim(this);
  
  
  sound1 = minim.loadFile("161699__xserra__ocean-4.wav");
  sound2 = minim.loadFile("22267__zeuss__the-chime.wav");
  
  //filling up the array stars with the sequential frames 
  for (int c = 0; c < 55; c++ ) 
  {
    stars[c] = loadImage( "stars (" + c + ").png" ); 
  }  
  
  //filling up the arrays with the sequential frames of the story
  for (int c = 0; c < 13; c++ ) 
  {
    bg[c] = loadImage( c + ".png" ); 
  }  
}

void draw()
{
  //if the variable energy is true, all leds are turned on and vibration motor is off
  if (energy == true)
  {
    
    for (int i = 0; i < 5; i++)
    {
      arduino.digitalWrite(ledPins[i], Arduino.HIGH);
    }
    
    arduino.digitalWrite(vibrator, Arduino.LOW);
  }
  
  //variable read stores the accelerometer sensor information
  read = arduino.analogRead(sensor);
  
  println (read);
  //println(energy);
  //println("step: " + step);
  
  
  //if the magic wand is shaken, activates sounds, vibration motor vibrates, turns off the leds and changes variables steps and energy
  if (read>500 && read!=-1 && energy == true)
  {
    i = 0;
    if (sound == false)
    {
      arduino.digitalWrite(vibrator, Arduino.HIGH);
      sound1.loop(4);
      sound = true;
    }
    sound2.loop(0);
    energy = false;
    arduino.digitalWrite(vibrator, Arduino.HIGH);
    sT = millis();
     
    step ++;
    energy();
    for (int i = 0; i < 5; i++)
    {
      arduino.digitalWrite(ledPins[i], Arduino.LOW);
    }
  } 
 
  //println("sT" + sT);
  steps();
  energy();
  //println(millis());
}

//function that displays the sequential images of the story, together with the stars effect
public void steps()
{
  for (int i=0; i<13; i++)
  {
    if (step == i)
    {
      image(bg[i], width/2, height/2);
      stars();
    }
  }
  if (step == 13)
  {
    background(loadImage("background.jpg"));
  }
  
}

//when variable energy is set to false, leds will turn on again one by one, vibration motors stops, and when all leds are turned on again, energy variable is set to true
public void energy()
{
  if (energy == false)
  {
    if( millis() > sT + 1000 && millis() < sT + 2000 )
    {
      arduino.digitalWrite(vibrator, Arduino.LOW); 
    }
    if( millis() > sT + 2000 && millis() < sT + 6000 )
    {
      arduino.digitalWrite(ledPins[0], Arduino.HIGH); 
    }
    else if(millis() > sT +6000 && millis() < sT + 10000 )
    {
      arduino.digitalWrite(ledPins[1], Arduino.HIGH);
    }
    else if(millis() > sT +10000 && millis() < sT + 14000 )
    {
      arduino.digitalWrite(ledPins[2], Arduino.HIGH);
    }
    else if(millis() > sT + 14000 && millis() < sT + 18000 )
    {
      arduino.digitalWrite(ledPins[3], Arduino.HIGH);
    }
    else if( millis() > sT +18000 && millis() < sT + 22000 )
    {
      arduino.digitalWrite(ledPins[4], Arduino.HIGH);
    }
    else if( millis() > sT +22000)
    {
      energy = true;
    } 
  }
}

public void stop()
{
  for (int i = 0; i < 5; i++)
  {
    arduino.digitalWrite(ledPins[i], Arduino.LOW);
  }
  super.stop();
} 

//function that displays the stars effect
void stars(){
    if (i<55)
    {
      image(stars[i], width/2, height/2);
      i++;
    }
}

