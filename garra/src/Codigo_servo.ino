#include <Servo.h>

Servo servoBase;
Servo servoGarra;

int anguloBase = 0;
int anguloGarra = 0;

int ledPin = 7;

void setup() {
  Serial.begin(9600);

  servoBase.attach(9);
  servoGarra.attach(10);

  pinMode(ledPin, OUTPUT);

  servoBase.write(anguloBase);
  servoGarra.write(anguloGarra);

  Serial.println("Sistema pronto.");
  Serial.println("Comandos:");
  Serial.println("U - subir");
  Serial.println("D - descer");
  Serial.println("O - abrir garra");
  Serial.println("C - fechar garra");
}

void loop() {
  if (Serial.available()) {
    char comando = Serial.read();

    digitalWrite(ledPin, HIGH); // LED acende ao receber comando

    switch (comando) {
      case 'U':
        anguloBase += 50;
        anguloBase = constrain(anguloBase, 0, 180);
        servoBase.write(anguloBase);
        Serial.println("Subindo braço");
        break;

      case 'D':
        anguloBase -= 50;
        anguloBase = constrain(anguloBase, 0, 180);
        servoBase.write(anguloBase);
        Serial.println("Descendo braço");
        break;

      case 'O':
        anguloGarra += 50;
        anguloGarra = constrain(anguloGarra, 0, 180);
        servoGarra.write(anguloGarra);
        Serial.println("Abrindo garra");
        break;

      case 'C':
        anguloGarra -= 50;
        anguloGarra = constrain(anguloGarra, 0, 180);
        servoGarra.write(anguloGarra);
        Serial.println("Fechando garra");
        break;
      
    }

    delay(300);
    digitalWrite(ledPin, LOW);
  }
}