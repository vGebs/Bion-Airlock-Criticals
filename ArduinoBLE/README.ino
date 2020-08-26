/*
 This script allows the microcontroller to connect with 
    other devices, send data (ie, pressure,
    temp, door status, etc) and retrieve data (ie, pressurize,
    set temp, etc).

    Service: Airlock Criticals
      Characteristics
      1: Pressure
        Central Capabilities: 
          1. Read Pressure
          2. Write: 
            a) Increase pressure
            b) Pause pressurization
            c) Decrease pressure
          3. Indicate and Notify: 
            ask the peripheral to continuously send 
            updated values of the characteristic, without 
            the central having to constantly ask for it.
            
      2: Door locks
        Central Capabilities:
          1. Read door status
          2. Write: no writing capabilites
          3. Indicate and Notify: 
            ask the peripheral to continuously send 
            updated values of the characteristic, without 
            the central having to constantly ask for it.
            
      3: Temp
        Central Capabilities
          1. Read interior temp
          2. Write:
            a) Set temp
          3. Indicate and Notify: 
            ask the peripheral to continuously send 
            updated values of the characteristic, without 
            the central having to constantly ask for it.
            
      4: Gas Sensor
      5: Gas Sensor
      6: Gas Sensor
*/
