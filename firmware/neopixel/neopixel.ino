#include <string.h>
#include <Arduino.h>
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_DotStarMatrix.h>
#include <Adafruit_DotStar.h>
// #include <Adafruit_NeoPixel.h>
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"
#if SOFTWARE_SERIAL_AVAILABLE
  #include <SoftwareSerial.h>
#endif

#include "BluefruitConfig.h"

#define FACTORYRESET_ENABLE     1
#define NEOPIXEL_VERSION_STRING "Neopixel v2.0"
#define PIN                     6   /* Pin used to drive the NeoPixels */

#define MAXCOMPONENTS  4

/* ...hardware SPI, using SCK/MOSI/MISO hardware SPI pins and then user selected CS/IRQ/RST */
Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

#define CLOCKPIN 5
#define DATAPIN  6

enum ledMode {STILL, MOVELEFT, MOVERIGHT, MOVEUP, MOVEDOWN,
              ROTATELEFT, ROTATERIGHT, EXPAND, SHRINK};
  
ledMode M;

Adafruit_DotStarMatrix matrix = Adafruit_DotStarMatrix(
                                  8, 8, DATAPIN, CLOCKPIN,
                                  DS_MATRIX_BOTTOM     + DS_MATRIX_RIGHT +
                                  DS_MATRIX_COLUMNS + DS_MATRIX_PROGRESSIVE,
                                  DOTSTAR_BGR);

// A small helper
void error(const __FlashStringHelper*err) {
  // Serial.println(err);
  while (1);
}

void serial_printf(const char * format, ...) {
  char buffer [48];
  va_list args;
  va_start(args, format);
  vsnprintf(buffer, sizeof(buffer), format, args);
  va_end(args);
  // Serial.print(buffer);
}


/**************************************************************************/
/*!
    @brief  Sets up the HW an the BLE module (this function is called
            automatically on startup)
*/
/**************************************************************************/
void setup(void)
{
  Serial.begin(115200);
  // Serial.println("Adafruit Bluefruit Neopixel Test");
  // Serial.println("--------------------------------");

  // Serial.println();
  // Serial.println("Please connect using the Bluefruit Connect LE application");
  M = STILL;

  matrix.begin();
  matrix.setBrightness(2);

  /* Initialise the module */
  // Serial.print(F("Initialising the Bluefruit LE module: "));

  if ( !ble.begin(VERBOSE_MODE) )
  {
    error(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
  }
  // Serial.println( F("OK!") );

  if ( FACTORYRESET_ENABLE )
  {
    /* Perform a factory reset to make sure everything is in a known state */
    // Serial.println(F("Performing a factory reset: "));
    if ( ! ble.factoryReset() ){
      error(F("Couldn't factory reset"));
    }
  }

  /* Disable command echo from Bluefruit */
  ble.echo(false);

  ble.verbose(false);  // debug info is a little annoying after this point!

    /* Wait for connection */
  while (! ble.isConnected()) {
      delay(500);
  }

  // Serial.println(F("***********************"));

  // // Set Bluefruit to DATA mode
  // Serial.println( F("Switching to DATA mode!") );
  ble.setMode(BLUEFRUIT_MODE_DATA);

  // Serial.println(F("***********************"));

}

// int i = 0;
// uint8_t buffer[10];

void loop()
{
  // uint8_t buffer[10];
  // int i = 0;
  // Echo received data
  if ( ble.isConnected() /*&& ble.available()*/ )
  {
    int command = ble.read();
    // if (command != -1)
    //   Serial.println(command);

    switch (command) {
      case 'V': {   // Get Version
          commandVersion();
          break;
        }
  
      case 'S': {   // Setup dimensions, components, stride...
          commandSetup();
          break;
       }

      case 'C': {   // Clear with color
          commandClearColor();
          break;
      }

      case 'B': {   // Set Brightness
          commandSetBrightness();
          break;
      }
            
      case 'P': {   // Set Pixel
          commandSetPixel();
          break;
      }
  
      case 'I': {   // Receive new image
          commandImage();
          break;
      }

      case '<': {
        M = MOVELEFT;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case '>': {
        M = MOVERIGHT;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case '^': {
        M = MOVEUP;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case '_': {
        M = MOVEDOWN;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case 'l': {
        M = ROTATELEFT;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case 'r': {
        M = ROTATERIGHT;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case 'e': {
        M = EXPAND;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case 's': {
        M = SHRINK;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      case '.': {
        M = STILL;
        Serial.println((char) command);
        sendResponse("OK");
        break;
      }

      default: {
        // move the matrix
        movePattern();
      }
    }
  }
}

void movePattern() {
  switch (M) {
    case STILL: {
      break;
    }

    case MOVELEFT: {
      break;
    }

    case MOVERIGHT: {
      break;
    }

    case MOVEUP: {
      break;
    }

    case MOVEDOWN: {
      break;
    }

    case ROTATELEFT: {
      // Serial.println("rotate left");
      rotateLeft();
      break;
    }

    case ROTATERIGHT: {
      rotateRight();
      break;
    }

    case EXPAND: {
      break;
    }

    case SHRINK: {
      break;
    }
  }
}

void commandVersion() {
  // Serial.println(F("Command: Version check"));
  sendResponse(NEOPIXEL_VERSION_STRING);
}

void commandSetup() {
  // Serial.println(F("Command: Setup"));
  sendResponse("OK");
}

void commandSetBrightness() {
  // Serial.println(F("Command: SetBrightness"));

  // // Done
  sendResponse("OK");
}

void commandClearColor() {
  // Serial.println(F("Command: ClearColor"));
  int components = 3;
  // Read color
  uint8_t color[MAXCOMPONENTS];
  for (int j = 0; j < components;) {
    if (ble.available()) {
      color[j] = ble.read();
      j++;
    }
  }
  
  matrix.fillScreen(matrix.Color(color[0], color[1], color[2]));
  matrix.show();

  // Done
  sendResponse("OK");
}

void commandSetPixel() {
  // Serial.println(F("Command: SetPixel"));

  // Read position
  uint8_t x = ble.read();
  uint8_t y = ble.read();

  int components = 3;

  // // Read colors
  // uint32_t pixelOffset = y*width+x;
  // uint32_t pixelDataOffset = pixelOffset*components;
  // uint8_t *base_addr = pixelBuffer+pixelDataOffset;
  uint8_t color[MAXCOMPONENTS];
  for (int j = 0; j < components;) {
    if (ble.available()) {
      color[j] = ble.read();
      j++;
    }
  }

  matrix.drawPixel(x, y, matrix.Color(color[0], color[1], color[2]));
  matrix.show();

  // // Done
  sendResponse("OK");
}

void commandImage() {
  // serial_printf("Command: Image %dx%d, %d, %d\n", width, height, components, stride);
  // Done
  sendResponse("OK");
}

void sendResponse(char const *response) {
    // serial_printf("Send Response: %s\n", response);
    ble.write(response, strlen(response)*sizeof(char));
}

void rotateLeft() {
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
        Serial.printf("(%d, %d)\n", newX, newY);

        color_to_write = color_read;
      }
    }
  }

  matrix.show();
  delay(500);
}

void rotateRight() {
  int xDisp, yDisp, newX, newY, tmp;
  int centerX[4] = {4, 4, 3, 3};
  int centerY[4] = {3, 4, 4, 3};
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
        Serial.printf("(%d, %d)\n", newX, newY);

        color_to_write = color_read;
      }
    }
  }

  matrix.show();
  delay(500);
}
