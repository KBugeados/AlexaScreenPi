# AlexaScreenPi
Crea un Amazon Echo Show usando una raspberry pi

![alt text](https://github.com/KBugeados/AlexaScreenPi/blob/main/Github_miniatura.PNG?raw=true)

<h2>Pasos a seguir</h2>

1. Instalar Raspberry Pi OS en una tarjeta SD
2. Seguir los pasos descritos en la guia de Amazon para instalar el "Alexa Smart Screen SDK" y crear una aplicación: https://developer.amazon.com/en-US/docs/alexa/alexa-smart-screen-sdk/raspberry-pi.html
3. Para poder despertar a Alexa mediante la voz, usaremos <link href='https://github.com/Picovoice/porcupine/tree/master/demo/python'>Picovoice</link>, para ello ejecuta los siguientes comandos en tu Raspberry Pi:

   3.1 Instalar la demo en python de Picovoice porcupine mediante el siguiente comando
        <code>sudo pip3 install pvporcupinedemo</code>
        </br>
   3.2 Crear una cuenta nueva en la Picovoice console y crear una nueva key de acceso, tal como se describe aquí: https://github.com/Picovoice/porcupine/tree/master/demo/python#accesskey
        </br>
   3.3 Sustituir el fichero <code>porcupine_demo_mic.py</code> por el fichero del mismo nombre de este repositorio. El cual simula la pulsación de la tecla "A" durante 3 segundos, para que despierte a Alexa:
   <pre>
   $ cd /usr/local/lib/python3.7/dist-packages/pvporcupinedemo/
   $ sudo rm -rf porcupine_demo_mic.py
   $ sudo wget https://github.com/KBugeados/AlexaScreenPi/blob/main/porcupine_demo_mic.py
   </pre>
        </br>
   3.4 Ejecuta picovoice para que empiece a detectar la palabra <code>Alexa</code> (modifica ${ACCESS_KEY} por el access key que creaste en el paso 3.2):
   <pre>
    DISPLAY=":0" porcupine_demo_mic --access_key ${ACCESS_KEY} --keywords alexa
   </pre>

4. [OPCIONAL] Modifica el aspecto de la Home:

   Para ello, sustituye los siguiente ficheros, por los que puedes encontrar en este repositorio:
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/main.tsx
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/main.css
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/components/SampleHome.tsx
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/components/sampleHome.css

   Nota: Estos cambios se han probado en una pantalla de 7 pulgadas, para pantallas de diferente tamaño es posible que no se ajuste correctamente. En cualquier modo, modificando estos 4 ficheros, puedes crear tu propio home personalizado.
 

5. En otra consola diferente, ejecuta la aplicación "Alexa Smart Screen SDK sample":
   <pre>
   $ cd $HOME/sdk_folder/ss-build
   $ PA_ALSA_PLUGHW=1 ./modules/Alexa/SampleApp/src/SampleApp -C \
$HOME/sdk_folder/sdk-build/Integration/AlexaClientSDKConfig.json -C \
$HOME/sdk_folder/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json -L INFO
   </pre>

6. En la Raspberry Pi, ejecuta un navegador web, y abre el fichero <code>file://$HOME/sdk_folder/ss-build/modules/GUI/index.html</code>
