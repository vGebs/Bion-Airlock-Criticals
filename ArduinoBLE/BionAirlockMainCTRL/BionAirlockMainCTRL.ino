// Bion AirLock Main Controler firmware
// !!!PLEASE SELECT SETTINGS IN LINES 17 & 18 BEFORE UPLOAD!!!

// Author: Samuel Reddekop - Celestial Laboratories, Orion Divison
// Start Date: 08/23/2020
// Finish Date:

// Libraries needed for the various sensors
#include "Adafruit_MAX31855.h" // Airlock and Outside Thermocouples
#include <SparkFun_MS5803_I2C.h> // AirLock Air Pressure sensor
#include <MICS-VZ-89TE.h> // CO2 sensor
#include <SPI.h> // SPI Library
#include <Wire.h> // Wire Library
#include <OneWire.h> // OneWire Libary

// Settings for upload
int ArdNum = 1;  //set to either 1, 2, or 3 depending on which arduino this code is being uploaded to
bool SpkEN = true; // set to false to disable on board alarms or true(recommended) to enable on board alarms

// Pins
int HRO = 2; // Heat Redundancy check output signal
int PRO = 3; // Pressure Redundancy check output signal
int Alarm = 4; // Alarm signal to on board Alarm
int PRI1 = 5; // Pressure Redundancy check input signal 1
int PRI2 = 6; // Pressure Redundancy check input signal 2
int HRI1 = 7; // Heat Redundancy check input signal 1
int HRI2 = 8; // Heat Redundancy check input signal 2
int TCK = 9; // SPI clock for MAX31855s
int TD = 10; // SPI data for MAX31855s
int DPI = 11; // Depressurize input from external buttons
int LK = 12; // Door lock signal from door switch
int TAiS = 13; // SPI Airlock Temperature select signal
int COpin = A0; // Carbon Monoxide signal pin
int DPO = A1; // Depressurize output from App
int NOpin = A2; // Nitric Oxide signal pin
int PressOut = A3; // Pressurize signal to compressor
int HeatOut = A6; // Heater signal to compressor
int TOuS = A7; // SPI Outside Temperature select signal

// Variables
int AutoPressCont = 0; // 0 - Autopressurize, 1 - Maunal Go, 2 - Manual Stop, 3 - Manual Depressurize - Controlled by app 
double TempSet = 22; // Temperature set point. Changeable in app. Units in degrees Celsius.
bool HeatAlarmStat = false; // Heat Alarm Status for app
bool PressAlarmStat = false; // Pressure Alarm Status for app
bool PRI1ERR = false;
bool PRI2ERR = false;
bool HRI1ERR = false;
bool HRI2ERR = false;
double OTEMP = 00.00; // Outside Temperature in degrees Celsius
int OTEMPN = 0000; // Outside Temperature in degrees Celcius for Nextion Display
double ATEMP = 00.00; // Airlock Temperature in degrees Celsius
int ATEMPN = 0000; // Airlock Temperature in degrees Celsius for Nextion Display
bool DepressurizeStat = false; // Depressurize Status for app
bool DoorLkStat = false; // Door Lock status for app
int COcon = 0; // Carbon Monoxide Concentration
float ETEMP = 00.00; // Electronics Temperature in degrees Celsius
int ETEMPN = 0000; // Electronics Temperature in degrees Celsius for Nextion Display  
double PressVal = 00.00; // AirLock Pressure in psi
int PressValN = 0000; // AirLock Pressure in psi for Nextion
int NOcon = 0; // Nitric Oxide concentration
bool PressurizeStat = false; // Pressurize Status for app
bool HeatStat = false; // Heating Status for app
int CO2con = 0; // CO2 concentration
String NextionCom; // String Command for Nextion

// Constants
const double MaxAutoPress = 14.5; // Maximum pressure value, electronics turn off the compressor at this point and above (1 bar)
const double MinAutoPress = 11.7; // Minimum pressure value, electronics turn on the compressor at this point and below (0.8 bar)

// Library Objects
Adafruit_MAX31855 OutsideThermocouple(TCK, TOuS, TD); // Outside Temperature Thermocouple  
Adafruit_MAX31855 InsideThermocouple(TCK, TAiS, TD); // Inside Temperature Thermocouple
MS5803 PressETemp(ADDRESS_HIGH); // Pressure and Electronics Temperature Sensor
MICS_VZ_89TE CO2SENSOR; // CO2 Sensor


// Bluetooth Variables and objects


void setup() {
  // put your setup code here, to run once:

// Declare pinModes
pinMode(HRO, OUTPUT); // Heat Redundancy Output - set as output
pinMode(PRO, OUTPUT); // Pressure Redundancy Output - set as output
pinMode(Alarm, OUTPUT); // Alarm Output - set as output
pinMode(PRI1, INPUT); // Pressure Redundancy Input 1 - set as input
pinMode(PRI2, INPUT); // Pressure Redundancy Input 2 - set as input
pinMode(HRI1, INPUT); // Heat Redundancy Input 1 - set as input
pinMode(HRI2, INPUT); // Heat Redundancy Input 2 - set as input
pinMode(DPI, INPUT); // Depressurize button notification signal - set as input
pinMode(LK, INPUT); // Door Lock input from door switch - set as input  
pinMode(TAiS, OUTPUT); // Airlock Temperature Thermocouple Select - set as output
pinMode(COpin, INPUT); // Carbon Monoxide input - set as input
pinMode(DPO, OUTPUT); // Depressurize output for app - set as output
pinMode(NOpin, INPUT); // Nitric Oxide input - set as input
pinMode(PressOut, OUTPUT); // Pressurize output - set as output
pinMode(HeatOut, OUTPUT); // Heat output - set as output
pinMode(TOuS, OUTPUT); // Outside Temperature Thermocouple Select - set as output

// Activate Serial connection
Serial.begin(9600); // start serial for nextion
Wire.begin(); // start I2C bus
delay(500);

// Set Arduino Number on Nextion Screen
NextionCom = "ArdNum.val=";
NextionCom.concat(ArdNum);
NextionWrite(NextionCom);

// Initialize MAX chips
delay(500);
OutsideThermocouple.begin();
InsideThermocouple.begin();

// Initialize Pressure and Electronics Temperature sensor
PressETemp.reset();
PressETemp.begin();

//Bluetooth Setup

}

void loop() {
  
// Read Outside Thermocouple
digitalWrite(TOuS, LOW); // Activate Outside Thermocouple
digitalWrite(TAiS, HIGH); // Deactivate Inside Thermocouple
OTEMP = OutsideThermocouple.readCelsius();

// Read Inside Thermocouple
digitalWrite(TOuS, HIGH); // Deactivate Outside Thermocouple
digitalWrite(TAiS, LOW); // Activate Inside Thermocouple
ATEMP = InsideThermocouple.readCelsius();
digitalWrite(TAiS, HIGH); // Deactivate Inside Thermocouple

// Read Pressure and Electronics Temperature
ETEMP = PressETemp.getTemperature(CELSIUS, ADC_4096);
PressVal = (PressETemp.getPressure(ADC_4096)) * 0.0145038; // retrieve pressure and convert from mbar to psi

// Read Carbon Monoxide
COcon = map(analogRead(COpin), 1023, 372, 0, 600); // Read CO Analog input, 0ppm = 3.3V, 600pmm = 1.2V, - convert to ppm using map function.

// Read Carbon Dioxide
CO2SENSOR.readSensor(); // Read Sensor
CO2con = CO2SENSOR.getCO2(); // Collect CO2 data

// Read Nitric Oxide
NOcon = map(analogRead(NOpin), 1023, 403, 0, 100); // Read NO Analog input, 0ppm = 3.3V, 100ppm = 1.3V, - convert to ppm using map function

// React to Inside Temperature Reading
if (ATEMP >= (TempSet + 1))
{
  digitalWrite(HeatOut, LOW);
  digitalWrite(HRO, LOW);
  digitalWrite(Alarm, LOW);
  HeatStat = false;
}

if (ATEMP <= (TempSet - 1))
{
  digitalWrite(HRO, HIGH);
  delay(1000);
  if (digitalRead(HRI1) && digitalRead(HRI2))
  {
    digitalWrite(HeatOut, HIGH);
    HRI1ERR = false;
    HRI2ERR = false;
    HeatAlarmStat = false;
    HeatStat = true;
  }
  else
  {
    digitalWrite(HeatOut, HIGH);
    if ((HeatAlarmStat == false) && (SpkEN))
    {
      digitalWrite(Alarm, HIGH);
      delay(1500);
      digitalWrite(Alarm, LOW);
    }
    HeatAlarmStat = true;
    HeatStat = true;
    if (digitalRead(HRI1) == false)
    {
      HRI1ERR = true;
    }
    if (digitalRead(HRI2) == false)
    {
      HRI2ERR = true;
    }
  }
}

// React to Pressure Reading
if ((PressVal >= MaxAutoPress) && (AutoPressCont == 0))
{
  digitalWrite(PressOut, LOW);
  digitalWrite(PRO, LOW);
  digitalWrite(Alarm, LOW);
  PressurizeStat = false;
}

if ((ATEMP <= MinAutoPress) && (AutoPressCont == 0))
{
  digitalWrite(PRO, HIGH);
  delay(1000);
  if (digitalRead(PRI1) && digitalRead(PRI2))
  {
    digitalWrite(PressOut, HIGH);
    PRI1ERR = false;
    PRI2ERR = false;
    PressAlarmStat = false;
    PressurizeStat = true;
  }
  else
  {
    digitalWrite(PressOut, HIGH);
    if ((PressAlarmStat == false) && (SpkEN))
    {
      digitalWrite(Alarm, HIGH);
      delay(1500);
      digitalWrite(Alarm, LOW);  
    }
    PressAlarmStat = true;
    PressurizeStat = true;
    if (digitalRead(HRI1) == false)
    {
      PRI1ERR = true;
    }
    if (digitalRead(HRI2) == false)
    {
      PRI2ERR = true;
    }
  }
}

if (AutoPressCont == 1)
{
  digitalWrite(PressOut, HIGH); 
  PressurizeStat = true; 
}

if (AutoPressCont == 2)
{
  digitalWrite(PressOut, LOW);
  digitalWrite(DPO, LOW);
  PressurizeStat = false;
  DepressurizeStat = false;
}

if (AutoPressCont == 3)
{
  digitalWrite(DPO, HIGH);
  DepressurizeStat = true;  
}

// Check DPI input
if (digitalRead(DPI) == true)
{
  DepressurizeStat = true;
}

// Update Nextion Display
    // 1. Outside Temperature
      OTEMPN = OTEMP * 100; // shift decimal by multiplying by 100 and putting value into integer to transmit over serial to nextion EX: 26.93 will become 2693, 0.9 will become 90.
      NextionCom = "numOutTemp.val="; //Build the part of the string that we know
      NextionCom.concat(OTEMPN); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100);
      
    // 2. Airlock Temperature
      ATEMPN = ATEMP * 100; // shift decimal by multiplying by 100 and putting value into integer to transmit over serial to nextion EX: 26.93 will become 2693, 0.9 will become 90.
      NextionCom = "numLkTemp.val="; //Build the part of the string that we know
      NextionCom.concat(ATEMPN); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100); 
      
    // 3. Electronics Temperature           
      ETEMPN = ETEMP * 100; // shift decimal by multiplying by 100 and putting value into integer to transmit over serial to nextion EX: 26.93 will become 2693, 0.9 will become 90.
      NextionCom = "numEleTemp.val="; //Build the part of the string that we know
      NextionCom.concat(ETEMPN); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100); 
      
    // 4. Airlock Pressure
      PressValN = PressVal * 100; // shift decimal by multiplying by 100 and putting value into integer to transmit over serial to nextion EX: 26.93 will become 2693, 0.9 will become 90.
      NextionCom = "numPressure.val="; //Build the part of the string that we know
      NextionCom.concat(PressValN); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100); 
      
    // 5. Carbon monoxide 
      NextionCom = "numCO.val="; //Build the part of the string that we know
      NextionCom.concat(COcon); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100); 

    // 6. Carbon Dioxide
      NextionCom = "numCO2.val="; //Build the part of the string that we know
      NextionCom.concat(CO2con); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100);

    // 7. Nitric Oxide
      NextionCom = "numNO.val="; //Build the part of the string that we know
      NextionCom.concat(NOcon); //Add the variable we want to send
      NextionWrite(NextionCom);
      delay(100);

    // 8. Status
      if (PressurizeStat == true)
      {
        NextionCom = "statP.pco=65535";
        NextionWrite(NextionCom);
      }
      else 
      {
        NextionCom = "statP.pco=22";
        NextionWrite(NextionCom);  
      }

      if (DepressurizeStat == true)
      {
        NextionCom = "statD.pco=65535";
        NextionWrite(NextionCom); 
      }
      else
      {
        NextionCom = "statD.pco=22";
        NextionWrite(NextionCom);
      }

      if (HeatStat == true)
      {
        NextionCom = "statH.pco=65535";
        NextionWrite(NextionCom);
      }
      else
      {
        NextionCom = "statH.pco=22";
        NextionWrite(NextionCom);
      }

    // 9. Errors
      if (PRI1ERR == true)
      {
        if (ArdNum == 1)
        {
          NextionCom = "error2.pco=65535";
          NextionWrite(NextionCom);
        }

        if (ArdNum == 2)
        {
          NextionCom = "error1.pco=65535";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 3)
        {
          NextionCom = "error1.pco=65535";
          NextionWrite(NextionCom);  
        }
      }

      else
      {
       if (ArdNum == 1)
        {
          NextionCom = "error2.pco=22";
          NextionWrite(NextionCom);
        }

        if (ArdNum == 2)
        {
          NextionCom = "error1.pco=22";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 3)
        {
          NextionCom = "error1.pco=22";
          NextionWrite(NextionCom);  
        } 
      }

      if (PRI2ERR == true)
      {
        if (ArdNum == 1)
        {
          NextionCom = "error3.pco=65535";
          NextionWrite(NextionCom);
        }

        if (ArdNum == 2)
        {
          NextionCom = "error3.pco=65535";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 3)
        {
          NextionCom = "error2.pco=65535";
          NextionWrite(NextionCom);  
        }
      }

      else
      {
       if (ArdNum == 1)
        {
          NextionCom = "error3.pco=22";
          NextionWrite(NextionCom);
        }

        if (ArdNum == 2)
        {
          NextionCom = "error3.pco=22";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 3)
        {
          NextionCom = "error2.pco=22";
          NextionWrite(NextionCom);  
        } 
      }

      if (HRI1ERR == true)
      {
        if (ArdNum == 1)
        {
          NextionCom = "error5.pco=65535";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 2)
        {
          NextionCom = "error4.pco=65535";
          NextionWrite(NextionCom);
        }

        if(ArdNum == 3)
        {
          NextionCom = "error4.pco=65535";
          NextionWrite(NextionCom);
        }
      }

      else
      {
        if (ArdNum == 1)
        {
          NextionCom = "error5.pco=22";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 2)
        {
          NextionCom = "error4.pco=22";
          NextionWrite(NextionCom);
        }

        if(ArdNum == 3)
        {
          NextionCom = "error4.pco=22";
          NextionWrite(NextionCom);
        }
      }

      if (HRI2ERR == true)
      {
        if (ArdNum == 1)
        {
          NextionCom = "error6.pco=65535";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 2)
        {
          NextionCom = "error6.pco=65535";
          NextionWrite(NextionCom);
        }

        if(ArdNum == 3)
        {
          NextionCom = "error5.pco=65535";
          NextionWrite(NextionCom);
        }
      }

      else
      {
        if (ArdNum == 1)
        {
          NextionCom = "error6.pco=22";
          NextionWrite(NextionCom);  
        }

        if (ArdNum == 2)
        {
          NextionCom = "error6.pco=22";
          NextionWrite(NextionCom);
        }

        if(ArdNum == 3)
        {
          NextionCom = "error5.pco=22";
          NextionWrite(NextionCom);
        }
      }
// Update bluetooth


}


// This Function is borrowed from here https://www.instructables.com/id/Writing-From-Arduino-Uno-to-Nextion/
void NextionWrite(String stringData) { // Used to serially push out a String with Serial.write()

  for (int i = 0; i < stringData.length(); i++)
  {
    Serial.write(stringData[i]);   // Push each char 1 by 1 on each loop pass  
  }

  Serial.write(0xff); //We need to write the 3 ending bits to the Nextion as well
  Serial.write(0xff); //it will tell the Nextion that this is the end of what we want to send.
  Serial.write(0xff);

}// end writeString function
