#include <LiquidCrystal.h>

// RS, E, D4, D5, D6, D7
LiquidCrystal lcd(8, 7, 6, 5, 4, 3);

// Sensores
int tempPin = A0;   // TMP36/LM35
int pressPin = A1;  // FSR

void setup()
{
  Serial.begin(9600);
  lcd.begin(16, 2);

  pinMode(pressPin, INPUT);
}

void loop()
{
  // ===== TEMPERATURA =====
  int leituraTemp = analogRead(tempPin);
  float tensao = leituraTemp * (5.0 / 1023.0);
  float temperaturaC = (tensao - 0.5) * 100; // TMP36

  // ===== PRESSÃO (FSR) =====
  int leituraPressao = analogRead(pressPin);

  // ===== LCD =====
  lcd.setCursor(0, 0);
  lcd.print("Temp: ");
  lcd.print(temperaturaC);
  lcd.print(" C   "); // espaços limpam sobra

  lcd.setCursor(0, 1);
  lcd.print("Pressao: ");
  lcd.print(leituraPressao);
  lcd.print("   ");

  // ===== Serial =====
  Serial.print("Temp: ");
  Serial.print(temperaturaC);
  Serial.print(" C | Pressao: ");
  Serial.println(leituraPressao);

  delay(1000);
}