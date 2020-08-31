#include <ArduinoBLE.h>
//16.06 == 0x00848041
BLEService airlockCriticalService("1000");
BLEFloatCharacteristic pressureLevelChar("1001", BLERead | BLENotify);
BLEIntCharacteristic doorStatusChar("1002", BLERead | BLENotify);
BLEFloatCharacteristic tempLevelChar("1003", BLERead | BLENotify);

const int tempSensorPin = A0;
const float baselineTemp = 20.0;

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");

    while (1);
  }

  BLE.setLocalName("Bion Airlock");
  BLE.setAdvertisedService(airlockCriticalService);
  
  airlockCriticalService.addCharacteristic(pressureLevelChar);
  airlockCriticalService.addCharacteristic(doorStatusChar);
  airlockCriticalService.addCharacteristic(tempLevelChar);

  BLE.addService(airlockCriticalService);

  BLE.advertise();
  BLE.setConnectable(true);  
}

void loop() {
  BLEDevice central = BLE.central();

  if (central) 
  {
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    digitalWrite(LED_BUILTIN, HIGH);

    while (central.connected()) {
      tempLevelChar.writeValue(GetTemp());
      Serial.print("temp level from tempLevelChar: ");
      Serial.print(tempLevelChar.value());
      Serial.print(" ");
      delay(2000); //delays 2 seconds
    }
  }

  digitalWrite(LED_BUILTIN, LOW);
  //Serial.print("Disconnected from central: ");
  //Serial.println(central.address());

//Serial.print(GetTemp());
//delay(15000);
}

float GetTemp(){
  int sensVal = analogRead(tempSensorPin);
  
//  Serial.print("Sensor Value: ");
//  Serial.print(sensVal);

  //Convert the ADC reading to voltage
  float voltage = (sensVal / 1024.0) * 3.3;

//  Serial.print(" Voltage is: ");
//  Serial.print(voltage);

  //Convert to Celsius
  float temp = (voltage - .5) * 100;

//  Serial.print(" Temp is: ");
//  Serial.print(temp);

  return temp;
}
