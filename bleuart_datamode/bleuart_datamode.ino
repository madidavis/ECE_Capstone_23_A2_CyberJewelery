/*********************************************************************
 This is an example for our nRF51822 based Bluefruit LE modules

 Pick one up today in the adafruit shop!

 Adafruit invests time and resources providing this open source code,
 please support Adafruit and open-source hardware by purchasing
 products from Adafruit!

 MIT license, check LICENSE for more information
 All text above, and the splash screen below must be included in
 any redistribution
*********************************************************************/

#include <Arduino.h>
#include <SPI.h>
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"
#include "Adafruit_BLEBattery.h"

#include "BluefruitConfig.h"

#if SOFTWARE_SERIAL_AVAILABLE
  #include <SoftwareSerial.h>
#endif

#include <Adafruit_GFX.h>
#include <Adafruit_DotStarMatrix.h>
#include <Adafruit_DotStar.h>

#define CLOCKPIN 5
#define DATAPIN  6

Adafruit_DotStarMatrix matrix = Adafruit_DotStarMatrix(
                                8, 8, DATAPIN, CLOCKPIN,
                                DS_MATRIX_BOTTOM     + DS_MATRIX_RIGHT +
                                DS_MATRIX_COLUMNS + DS_MATRIX_PROGRESSIVE,
                                DOTSTAR_BGR);

/*=========================================================================
    APPLICATION SETTINGS

    FACTORYRESET_ENABLE       Perform a factory reset when running this sketch
   
                              Enabling this will put your Bluefruit LE module
                              in a 'known good' state and clear any config
                              data set in previous sketches or projects, so
                              running this at least once is a good idea.
   
                              When deploying your project, however, you will
                              want to disable factory reset by setting this
                              value to 0.  If you are making changes to your
                              Bluefruit LE device via AT commands, and those
                              changes aren't persisting across resets, this
                              is the reason why.  Factory reset will erase
                              the non-volatile memory where config data is
                              stored, setting it back to factory default
                              values.
       
                              Some sketches that require you to bond to a
                              central device (HID mouse, keyboard, etc.)
                              won't work at all with this feature enabled
                              since the factory reset will clear all of the
                              bonding data stored on the chip, meaning the
                              central device won't be able to reconnect.
    MINIMUM_FIRMWARE_VERSION  Minimum firmware version to have some new features
    MODE_LED_BEHAVIOUR        LED activity, valid options are
                              "DISABLE" or "MODE" or "BLEUART" or
                              "HWUART"  or "SPI"  or "MANUAL"
    -----------------------------------------------------------------------*/
    #define FACTORYRESET_ENABLE         0
    #define MINIMUM_FIRMWARE_VERSION    "0.6.6"
    #define MODE_LED_BEHAVIOUR          "MODE"
/*=========================================================================*/

// Create the bluefruit object, either software serial...uncomment these lines
/*
SoftwareSerial bluefruitSS = SoftwareSerial(BLUEFRUIT_SWUART_TXD_PIN, BLUEFRUIT_SWUART_RXD_PIN);

Adafruit_BluefruitLE_UART ble(bluefruitSS, BLUEFRUIT_UART_MODE_PIN,
                      BLUEFRUIT_UART_CTS_PIN, BLUEFRUIT_UART_RTS_PIN);
*/

/* ...or hardware serial, which does not need the RTS/CTS pins. Uncomment this line */
// Adafruit_BluefruitLE_UART ble(BLUEFRUIT_HWSERIAL_NAME, BLUEFRUIT_UART_MODE_PIN);

/* ...hardware SPI, using SCK/MOSI/MISO hardware SPI pins and then user selected CS/IRQ/RST */
Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

/* ...software SPI, using SCK/MOSI/MISO user-defined SPI pins and then user selected CS/IRQ/RST */
//Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_SCK, BLUEFRUIT_SPI_MISO,
//                             BLUEFRUIT_SPI_MOSI, BLUEFRUIT_SPI_CS,
//                             BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

Adafruit_BLEBattery battery(ble);

enum ledMode {STILL, MOVELEFT, MOVERIGHT, MOVEUP, MOVEDOWN, ROTATE, FLASH};


// A small helper
void error(const __FlashStringHelper*err) {
  Serial.println(err);
  while (1);
}

ledMode M;
char password[] = "123456";
bool passed = false;
uint8_t flashState = 0;
bool flashing = false;

/**************************************************************************/
/*!
    @brief  Sets up the HW an the BLE module (this function is called
            automatically on startup)
*/
/**************************************************************************/
void setup(void)
{
  pinMode(11, OUTPUT);
  randomSeed(analogRead(14));
  M = STILL;

  matrix.begin();
  matrix.setBrightness(4);

  matrix.fillScreen(0);
  matrix.show();
  delay(500);

  // attachInterrupt(digitalPinToInterrupt(8), receive, LOW);

  // while (!Serial);  // required for Flora & Micro
  // delay(500);

  Serial.begin(115200);
  Serial.println(F("Adafruit Bluefruit Command <-> Data Mode Example"));
  Serial.println(F("------------------------------------------------"));

  /* Initialise the module */
  Serial.print(F("Initialising the Bluefruit LE module: "));

  if ( !ble.begin(VERBOSE_MODE) )
  {
    error(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
  }
  Serial.println( F("OK!") );

  if ( FACTORYRESET_ENABLE )
  {
    /* Perform a factory reset to make sure everything is in a known state */
    Serial.println(F("Performing a factory reset: "));
    if ( ! ble.factoryReset() ){
      error(F("Couldn't factory reset"));
    }
  }

  /* Disable command echo from Bluefruit */
  ble.echo(false);

  Serial.println("Requesting Bluefruit info:");
  /* Print Bluefruit information */
  ble.info();
  battery.begin(true);

  Serial.println(F("Please use Adafruit Bluefruit LE app to connect in UART mode"));
  Serial.println(F("Then Enter characters to send to Bluefruit"));
  Serial.println();

  ble.verbose(false);  // debug info is a little annoying after this point!

  if (! ble.sendCommandCheckOK(F("AT+GAPDEVNAME=CYBER JEWELRY")) ) {
    error(F("Could not set device name?"));
  }

  /* Wait for connection */
  while (! ble.isConnected()) {
      delay(500);
  }

  Serial.println(F("******************************"));

  // LED Activity command is only supported from 0.6.6
  if ( ble.isVersionAtLeast(MINIMUM_FIRMWARE_VERSION) )
  {
    // Change Mode LED Activity
    Serial.println(F("Change LED activity to " MODE_LED_BEHAVIOUR));
    ble.sendCommandCheckOK("AT+HWModeLED=" MODE_LED_BEHAVIOUR);
  }

  // Set module to DATA mode
  Serial.println( F("Switching to DATA mode!") );
  ble.setMode(BLUEFRUIT_MODE_DATA);

  Serial.println(F("******************************"));
}

/**************************************************************************/
/*!
    @brief  Constantly poll for new command or response data
*/
/**************************************************************************/
int iRecv = 0; // index for receiving data
int numRecv = 0; // this number is set when the end of transfer ascii character (0xA) is received to store how many bytes is received
char recv_buf[800]; 

void loop(void)
{

  // Echo received data
  while ( ble.available() )
  {
    Serial.printf("iRecv: %d, ble available\n", iRecv);
    char c = (char) ble.read();
   // if (c == )
    
    recv_buf[iRecv] = c;
    iRecv++;
    // if (c == 0xA) {
    //   numRecv = iRecv;
    //   iRecv = 0;
    //   // if (passed) {
    //   //   processRGB();
    //   // } else {
    //   //   checkPassword();
    //   // }
    //   // optProcessRGB();
    // }
  }

  if (iRecv >= 322) {
    numRecv = iRecv;
    iRecv = 0;
    Serial.printf("mode: %d\n", recv_buf[0]);
    for (int i = 0; i < 64; i++) {
      Serial.printf("index: %d, r: %d, g: %d, b: %d, brightness: %d\n", recv_buf[2 + 5*i], recv_buf[2 + 5*i + 1], recv_buf[2 + 5*i + 2], recv_buf[2 + 5*i + 3], recv_buf[2 + 5*i + 4]);
    }
    optProcessRGB();
  }

  if (!ble.available()) {
    processMovingPattern();
  }
}

void checkPassword() {
  if (numRecv != 7) {
    return;
  }
  for (int i = 0; i < 6; i++) {
    if (password[i] != recv_buf[i])
      return;
  }
  passed = true;
}

// parses data and program LED matrix
void processRGB() {
  if (numRecv <= 768) {
    Serial.print("no enough RGB data received\n");
    return;
  }
  uint16_t x, y;
  uint8_t r, g, b;
  char *p;
  char hex_buf[4];

  // digitalWrite(11, HIGH);
  for (int pixel = 0; pixel < 64; pixel++) {
    // current portocol: every pixel is defined by: 0x??0x??0x?? (12 bytes in total)
    hex_buf[0] = recv_buf[pixel*12];
    hex_buf[1] = recv_buf[pixel*12+1];
    hex_buf[2] = recv_buf[pixel*12+2];
    hex_buf[3] = recv_buf[pixel*12+3];
    r = (uint8_t) strtoul(hex_buf, &p, 16);

    hex_buf[0] = recv_buf[pixel*12+4];
    hex_buf[1] = recv_buf[pixel*12+5];
    hex_buf[2] = recv_buf[pixel*12+6];
    hex_buf[3] = recv_buf[pixel*12+7];
    g = (uint8_t) strtoul(hex_buf, &p, 16);

    hex_buf[0] = recv_buf[pixel*12+8];
    hex_buf[1] = recv_buf[pixel*12+9];
    hex_buf[2] = recv_buf[pixel*12+10];
    hex_buf[3] = recv_buf[pixel*12+11];
    b = (uint8_t) strtoul(hex_buf, &p, 16);

    y = pixel / 8;
    x = pixel % 8;

    Serial.printf("pixel: %d, r: %d g: %d b: %d\n", pixel, r, g, b);
    matrix.drawPixel(x, y, matrix.Color(r, g, b));
  }

  matrix.show();
  // digitalWrite(11, LOW);
  delay(500);
}

void optProcessRGB() {
  if (numRecv < 322) {
    Serial.print("no enough RGB data received\n");
    return;
  }

  switch (recv_buf[0]) {
    case 0x00: {
      M = STILL;
      break;
    }

    case 0x01: {
      M = MOVEUP;
      break;
    }

    case 0x02: {
      M = MOVEDOWN;
      break;
    }

    case 0x03: {
      M = MOVELEFT;
      break;
    }

    case 0x04: {
      M = MOVERIGHT;
      break;
    }

    case 0x05: {
      M = ROTATE;
      break;
    }

    default: {
      M = STILL;
      break;
    }
    // case 0x06: {
    //   M = FLASH;
    //   break;
    // }
  }

  if (recv_buf[1]) {
    flashing = true;
  } else {
    flashing = false;
  }

  uint16_t x, y;
  uint8_t r, g, b, brightness;

  for (int pixel = 0; pixel < 64; pixel++) {
    // portocol: every pixel is defined by: 0x???(5 bytes in total)
    r = recv_buf[2 + 5*pixel + 1];

    g = recv_buf[2 + 5*pixel + 2];

    b = recv_buf[2 + 5*pixel + 3];

    brightness = recv_buf[2 + 5*pixel + 4];

    // float scale = 255 / brightness;
    // float scale = 255.0 / ((float) brightness);
    // float scale = ((float) brightness) / 255.0;

    // r = r * scale;
    // g = g * scale;
    // b = b * scale;

    y = pixel / 8;
    x = pixel % 8;

    // scale = 97.0 / 255.0;
    // Serial.printf("scale: %f\n", scale);
    // Serial.printf("pixel: %d, r: %d g: %d b: %d\n", pixel, r, g, b);
    matrix.drawPixel(x, y, matrix.Color(r, g, b));
  }

  matrix.show();
  delay(500);
}

void processMovingPattern() {
  switch (M) {
    case STILL: {
      if (flashing) {
      matrix.setBrightness(0);
      matrix.show();
      delay(200);

      matrix.setBrightness(5);
      matrix.show();
      delay(200);

      matrix.setBrightness(0);
      matrix.show();
      delay(200);

      matrix.setBrightness(5);
      matrix.show();
      delay(200);
      }
      break;
    }

    case MOVEUP: {
      moveUp();
      break;
    }

    case MOVEDOWN: {
      moveDown();
      break;
    }

    case MOVELEFT: {
      moveLeft();
      break;
    }

    case MOVERIGHT: {
      moveRight();
      break;
    }

    case ROTATE: {
      rotate();
      break;
    }

    case FLASH: {
      flash();
      break;
    }
  }
}

void receive() {
  Serial.print("see interrupt\n");
  while ( ble.available() )
  {
    Serial.print("ble available\n");
    char c = (char) ble.read();
   // if (c == )
    
    recv_buf[iRecv] = c;
    iRecv++;
    if (c == 0xA) {
      numRecv = iRecv;
      iRecv = 0;
      if (passed) {
        processRGB();
      } else {
        checkPassword();
      }
    }
  }
}

// moveUp
void moveRight() {
  uint32_t color_read, color_to_write;
  for (int x = 0; x < 8; x++) {
    color_to_write = matrix.getPixelColor(8 * 7 + x);
    for (int y = 7; y >= 0; y--) {
      if (y != 0) {
        color_read = matrix.getPixelColor(8 * (y - 1) + x);
        matrix.setPixelColor(8 * (y - 1) + x, color_to_write);
        color_to_write = color_read;
      } else {
        matrix.setPixelColor(8 * 7 + x, color_to_write);
      }
    }
  }

  matrix.show();
  if (flashing) {
    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);

    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);
  } else {
    delay(500);
  }
}

// moveDown
void moveLeft() {
  uint32_t color_read, color_to_write;
  for (int x = 0; x < 8; x++) {
    color_to_write = matrix.getPixelColor(x);
    for (int y = 0; y <= 7; y++) {
      if (y != 7) {
        color_read = matrix.getPixelColor(8 * (y + 1) + x);
        matrix.setPixelColor(8 * (y + 1) + x, color_to_write);
        color_to_write = color_read;
      } else {
        matrix.setPixelColor(x, color_to_write);
      }
    }
  }

  matrix.show();
  if (flashing) {
    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);

    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);
  } else {
    delay(500);
  }
}

// moveRight
void moveUp() {
  uint32_t color_read, color_to_write;
  for (int y = 0; y < 8; y++) {
    color_to_write = matrix.getPixelColor(8 * y);
    for (int x = 0; x <= 7; x++) {
      if (x != 7) {
        color_read = matrix.getPixelColor(8 * y + x + 1);
        matrix.setPixelColor(8 * y + x + 1, color_to_write);
        color_to_write = color_read;
      } else {
        matrix.setPixelColor(8 * y, color_to_write);
      }
    }
  }

  matrix.show();
  if (flashing) {
    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);

    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);
  } else {
    delay(500);
  }
}

// moveLeft
void moveDown() {
  uint32_t color_read, color_to_write;
  for (int y = 0; y < 8; y++) {
    color_to_write = matrix.getPixelColor(8 * y + 7);
    for (int x = 7; x >= 0; x--) {
      if (x != 0) {
        color_read = matrix.getPixelColor(8 * y + x - 1);
        matrix.setPixelColor(8 * y + x - 1, color_to_write);
        color_to_write = color_read;
      } else {
        matrix.setPixelColor(8 * y + 7, color_to_write);
      }
    }
  }

  matrix.show();
  if (flashing) {
    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);

    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);
  } else {
    delay(500);
  }
}

//rotateRight
void rotate() {
  int xDisp, yDisp, newX, newY, tmp;
  int centerX[4] = {3, 4, 4, 3};
  int centerY[4] = {4, 4, 3, 3};
  for (int y = 0; y < 4; y++) {
    for (int x = y; x < 8 - y - 1; x++) {
      uint32_t color_to_write = matrix.getPixelColor(8 * y + x);
      uint32_t color_read;
      xDisp = x - centerX[3];
      yDisp = y - centerY[3];
      for (int i = 0; i < 4; i++) {
        //swap xDisp, yDisp
        tmp = xDisp;
        xDisp = yDisp;
        yDisp = -tmp;

        newX = centerX[i] + xDisp;
        newY = centerY[i] + yDisp;
        color_read = matrix.getPixelColor(8 * newY + newX);
        matrix.setPixelColor(8 * newY + newX, color_to_write);
        //Serial.printf("(%d, %d)\n", newX, newY);

        color_to_write = color_read;
      }
    }
  }

  matrix.show();
  if (flashing) {
    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);

    matrix.setBrightness(0);
    matrix.show();
    delay(200);

    matrix.setBrightness(5);
    matrix.show();
    delay(200);
  } else {
    delay(500);
  }
}

void flash() {
  if (flashState == 0) {
    matrix.setBrightness(0);
    flashState = 1;
  } else {
    matrix.setBrightness(5);
    flashState = 0;
  }
  matrix.show();
  delay(100);
}
