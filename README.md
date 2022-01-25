# AlexaScreenPi
Crea un Amazon Echo Show usando una Raspberry Pi. Esta guia incluye los pasos para:

- Añade la opción de despertar a Alexa mediante el uso de una "wake up word" (palabra para despertar), en lugar de tener que pulsar una tecla en el teclado.
- Home modificado para mostrar la hora, temperatura y una imagen de fondo.
- Soporte parcialmente de Spotify (usando raspotify)

![alt text](https://github.com/KBugeados/AlexaScreenPi/blob/main/Github_miniatura.PNG?raw=true)

<h1>Instalación básica</h1>

1. Instalar Raspberry Pi OS en una tarjeta SD
2. Seguir los pasos descritos en la guia de Amazon para instalar el "Alexa Smart Screen SDK" y crear una aplicación: https://developer.amazon.com/en-US/docs/alexa/alexa-smart-screen-sdk/raspberry-pi.html 
3. Ejecuta la aplicación "Alexa Smart Screen SDK sample":
   <pre>
   $ cd $HOME/sdk_folder/ss-build
   $ PA_ALSA_PLUGHW=1 ./modules/Alexa/SampleApp/src/SampleApp -C \
     $HOME/sdk_folder/sdk-build/Integration/AlexaClientSDKConfig.json -C \
     $HOME/sdk_folder/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json -L INFO
   </pre>

4. En la Raspberry Pi, ejecuta un navegador web, y abre el fichero <code>file://$HOME/sdk_folder/ss-build/modules/GUI/index.html</code>

<h1>Mejoras</h1>

En esta sección os muestro una serie de mejoras opcionales para hacer el dispositivo más atractivo y cómodo de usar, ya que por defecto, viene bastante limitado.

1. Por defecto, no podremos usar comandos de voz para despetar a Alexa, teniendo que pulsar la tecla "A" en nuestro teclado. Por ello, he hecho un pequeño script que nos permite despertar a Alexa mediante la voz. Para ello usaremos <link href='https://github.com/Picovoice/porcupine/tree/master/demo/python'>Picovoice</link>. 
Los pasos a seguir son los siguientes:

   1.1 Instalar la demo en python de Picovoice porcupine mediante el siguiente comando
        <code>sudo pip3 install pvporcupinedemo</code>
        </br>
   1.2 Crear una cuenta nueva en la Picovoice console y crear una nueva key de acceso, tal como se describe aquí: https://github.com/Picovoice/porcupine/tree/master/demo/python#accesskey
        </br>
   1.3 Sustituir el fichero <code>porcupine_demo_mic.py</code> por el fichero del mismo nombre de este repositorio. El cual simula la pulsación de la tecla "A" durante 3 segundos, para que despierte a Alexa:
   <pre>
   $ cd /usr/local/lib/python3.7/dist-packages/pvporcupinedemo/
   $ sudo rm -rf porcupine_demo_mic.py
   $ sudo wget https://raw.githubusercontent.com/KBugeados/AlexaScreenPi/main/porcupine_demo_mic.py
   </pre>
   1.4 Ejecuta picovoice para que empiece a detectar la palabra <code>Alexa</code> (modifica ${ACCESS_KEY} por el access key que creaste en el paso 3.2):
   <pre>
    DISPLAY=":0" porcupine_demo_mic --access_key ${ACCESS_KEY} --keywords alexa
   </pre>

2. Modifica el aspecto de la Home:

   Para ello, sustituye los siguiente ficheros, por los que puedes encontrar en este repositorio:
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/main.tsx
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/main.css
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/components/SampleHome.tsx
   - /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/js/src/components/sampleHome.css

   Nota: Estos cambios se han probado en una pantalla de 7 pulgadas, para pantallas de diferente tamaño es posible que no se ajuste correctamente. En cualquier modo, modificando estos 4 ficheros, puedes crear tu propio home personalizado.

3. Añadir la posibilidad de escuchar Spotify en nuestra Raspberry Pi. 
Amazon Alexa para la Raspberry Pi está bastante limitado y capado por parte de Amazon. Muchas aplicaciones de música y vídeo no son permitidas. Sin embargo, podemos hacer un pequeño arreglo para poder escuchar Spotify en nuestro dispositivo. Para ello, usaremos <link href='https://github.com/dtcooper/raspotify'>Raspotify</link>.
Tal y como indica la guía de Raspotify, simplemente deberemos ejecutar el siguiente comando en la Raspberry Pi:

<code>curl -sL https://dtcooper.github.io/raspotify/install.sh | sh</code>

Con esto, ya podremos mandar música a nuestra Raspberry Pi desde nuestro teléfono móvil o PC, ya que aparecerá como un dispositivo disponible en nuestra red, haciendo uso de la función <link href='https://support.spotify.com/es/article/spotify-connect/'>Spotify Connect</link>.

4. Ver vídeos de Youtube, Netflix, etc en nuestra Raspberry Pi.
Tal como comento en el punto anterior, las aplicaciones de vídeo más populares también están capadas por Amazon. Sin embargo, al estar usando un navegador web desde nuestra Raspberry Pi, podremos simplemente abrir una nueva pestaña en el navegador y usar la versión web de estas aplicaciones. Creando accesos directos a favoritos, tendremos a un solo click estas aplicaciones.

5. Teclado en pantalla para no usar teclado. Para hacer el dispositivo totalmente táctil, podremos instalar un teclado virtual en pantalla, para aquellas ocaciones en las que necesitemos escribir.  Para instalarlo podemos usar los siguientes comandos:

<pre>
sudo apt update
sudo apt install matchbox-keyboard
</pre>

6. Inicio automático de la aplicación al arrancar el sistema.
Usando el script que podeis encontrar en mi repositorio (startup_alexa.sh), podréis hacer que la aplicación se inicie automáticamente al arrancar el sistema.
Para ello:


6.1 Colocar el fichero startup_alexa.sh en el directorio /home/pi/Desktop/
6.2 Editar el fichero /etc/rc.local y añadir la siguiente línea, justo antes de <code>exit 0</code>:

<pre>
su pi - c 'bash /home/pi/Desktop/startup_alexa.sh
</pre>
6.3 Modificar el fichero startup_alexa.sh para añadir tu access_key de Picovoice.

7. Para hacer el dispositivo totalmente portátil, se puede añadir una batería externa (powerbank). Es recomentable usar una powerbank que permita cargarse a la vez que cargue la Raspberry Pi. De este modo, cuando no queramos gastar batería, podremos tener enchufada la batería a la corriente, a la misma vez que mantenga la Raspberry Pi funcionando.
Este tipo de Powerbanks se llaman "pass-through power bank".


<h1>Usar pines GPIO para sacar el audio y usar un amplificador de audio</h1>

Para el audio del dispositivo, se puede usar simplemente el mini jack que incluye la Raspberry Pi y conectar unos altavoces de forma sencilla y sin complicaciones.
Sin embargo, si como yo, quieres reutilizar unos viejos altavoces y conectar un amplificador de audio a estos, existe la posibilidad de replicar la salida del mini jack por los pines GPIO de la Raspberry, y de este modo prescindir del mini jack.

A continuación os explico los pasos que seguí yo para conseguirlo:

1. En primer lugar, necesitaremos un amplificador de audio (stereo a ser posible). En mi caso utilicé el modelo <b>CJMCU-98306 MAX98306, amplificador estéreo clase D, Audio Clase AB, 3,7 W</b> el cual se puede encontrar muy barato en muchas tiendas, con un coste de menos de 5 euros. Además necesitaremos unos altavoces, como es lógico.
2. El diagrama de conexiones que utlicé es el siguiente:

![alt text](https://github.com/KBugeados/AlexaScreenPi/blob/main/gpio.png?raw=true)

Las conexiones son las siguientes:

<pre>
Raspberry Pi 5V <--------------> VDD
Raspberry Pi GND <-------------> GND
Raspberry Pi GPIO18 <-----------> L+
Raspberry Pi GND <---------------> L-
Raspberry Pi GPIO13 <------------> R+
Raspberry Pi GND <---------------> R-
</pre>

3. Añadir la siguiente línea al final del fichero <code>/boot/config.txt</code>:

<pre>
dtoverlay=pwm-2chan,pin=18,func=2,pin2=13,func2=4
</pre>

4. Reiniciar Raspberry Pi.

<h1>Limitaciones y posibles mejoras extra</h1>

Al tratarse de una version de código abierto que Amazon pone a disposición de todo el mundo, esta versión presenta ciertas limitaciones a la hora de usar algunas aplicaciones.
Por ejemplo, las aplicaciones de música y vídeo más populares en su mayoría están capadas (Spotify, Youtube, Netflix, etc), por lo que no podremos ejecutarlas pidiéndoselo a Alexa por voz. Esto es una limitación importante respecto al Amazon Echo Show original.

La limitación de Spotify queda relativamente bien cubierta, haciendo uso de Raspotify, y las aplicaciones de vídeo, mediante el uso de las versiones web de las mismas.

Por otro lado, puesto que estamos usando una Raspberry Pi, se podrían implementar mejoras futuras mediante el uso de scripts por ejemplo en Python, en los cuales usando las API públicas de estas aplicaciones, podríamos crear aplicaciones propias que fuesen ejecutadas por Alexa mediante comandos de voz. Esto lo añado como posibles mejoras futuras para el proyecto. Aún así, en este primer prototipo del proyecto, pienso que es bastante usable, ya que podemos usar funciones como:

- Control domótico (controlar luces, persianas, aspiradores robot, controlar televisión, calefacción y muchas más cosas).
- Escuchar la radio.
- Juegos.
- Aplicaciones de recetas con vídeos incluidos.
- Preguntar cualquier cosa a Alexa.
- Traducción por voz con texto escrito en pantalla.
- Ejecución de scripts propios usando aplicaciones como IFTTT.
- Noticias.
- Escuchar música mediante Spotify en combinación con Raspotify.
- Ver vídeos y series usando las versiones web de Youtube, Netflix, etc.
- Etc.

<h1>Troubleshooting</h1>
A la hora de instalar el Alexa Smart Screen SDK de Amazon, me encontré con varios problemas que puede que tú también tengas. En este apartado, encontrarás un recopilatorio con posibles problemas que puedes encontrar al instarlo en tu Raspberry Pi, y cómo solventarlos.

<b>1. Al tratar de instalar paquetes usando <i>apt-get</i> no es capaz de localizar ningún paquete y no instala nada, mostrando un mensaje similar a <code>E: Unable to locate package</code></b>.
Para solucionar este paquete, probar a hacer un upgrade primero:

<pre>sudo apt full-upgrade</pre>

Y a continuación:

<code>sudo apt-get update</code>

<b>2. Al ejecutar el comando del paso 3.3 de la guía la raspberry pi se queda congelada y no avanza.</b>

Esto es debido a que la memoria RAM de la raspberry Pi no da más de sí. Para solventar este problema y que se pueda ejecutar el comando, podemos crear más memoria swap (referencia: https://amazon.developer.forums.answerhub.com/questions/207360/raspberry-pi-freezes-on-avs-install.html)

Para ello ejecutar los siguientes comandos (si con 512 MB no es suficiente, podeis poner 1024 en su lugar):

<pre>
sudo -s
swapoff -a
dd if=/dev/zero of=/swapfile bs=1M count=512
mkswap /swapfile
swapon /swapfile
swapon -s
</pre>


<b>3. Al ejecutar el comando del paso 11.3, me aparece el siguiente mensaje de error o similar:</b>
(referencia: https://issueexplorer.com/issue/alexa/alexa-smart-screen-sdk/116)

<pre>
/usr/bin/ld: /home/pi/sdk_folder/apl-client-library/preinstall/lib/libAPLClient.so: undefined reference to `apl::ResourceHoldingAction::ResourceHoldingAction(std::shared_ptr<apl::Timers> const&, std::shared_ptr<apl::Context> const&)'
/usr/bin/ld: /home/pi/sdk_folder/apl-client-library/preinstall/lib/libAPLClient.so: undefined reference to `apl::PlayMediaAction::make(std::shared_ptr<apl::Timers> const&, std::shared_ptr<apl::CoreCommand> const&)'
/usr/bin/ld: /home/pi/sdk_folder/apl-client-library/preinstall/lib/libAPLClient.so: undefined reference to `typeinfo for apl::ResourceHoldingAction'
/usr/bin/ld: /home/pi/sdk_folder/apl-client-library/preinstall/lib/libAPLClient.so: undefined reference to `apl::ResourceHoldingAction::onFinish()'
/usr/bin/ld: /home/pi/sdk_folder/apl-client-library/preinstall/lib/libAPLClient.so: undefined reference to `vtable for apl::ResourceHoldingAction'
collect2: error: ld returned 1 exit status
make[2]: *** [modules/Alexa/SampleApp/test/CMakeFiles/SmartScreenCaptionStateManagerTest.dir/build.make:96: modules/Alexa/SampleApp/test/SmartScreenCaptionStateManagerTest] Error 1
make[1]: *** [CMakeFiles/Makefile2:2126: modules/Alexa/SampleApp/test/CMakeFiles/SmartScreenCaptionStateManagerTest.dir/all] Error 2
make: *** [Makefile:130: all] Error 2
</pre>


Para solventarlo debemos volver a ejecutar el comando del pasos 11.2, pero en este caso, añadiremos la siguiente opción:

<code>-DRAPIDJSON_MEM_OPTIMIZATION=OFF</code>

De modo que ejecutaremos lo siguiente:

<pre>
cmake -DCMAKE_PREFIX_PATH=$HOME/sdk_folder/sdk-install \
-DWEBSOCKETPP_INCLUDE_DIR=$HOME/sdk_folder/third-party/websocketpp-0.8.2 \
-DDISABLE_WEBSOCKET_SSL=ON \
-DGSTREAMER_MEDIA_PLAYER=ON \
-DCMAKE_BUILD_TYPE=DEBUG \
-DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=$HOME/sdk_folder/third-party/portaudio/lib/.libs/libportaudio.a \
-DPORTAUDIO_INCLUDE_DIR=$HOME/sdk_folder/third-party/portaudio/include/ \
-DAPL_CLIENT_INSTALL_PATH=$HOME/sdk_folder/apl-client-library/preinstall \
-DAPL_CLIENT_JS_PATH=$HOME/sdk_folder/apl-client-library/apl-client-js \
-DPKCS11=OFF \
-DRAPIDJSON_MEM_OPTIMIZATION=OFF  \
../alexa-smart-screen-sdk
</pre>

Una vez hecho, ya podremos ejecutar el comando 11.3 y debería funcionar sin problemas.


<b>4. Al intentar ejecutar el porcupine para detectar la <i>wake up word</i> (alexa), me aparece el siguiente error:</b>

<pre>
pi@raspberrypi:~ $ porcupine_demo_mic
Traceback (most recent call last):
  File "/usr/local/bin/porcupine_demo_mic", line 6, in <module>
    from pvporcupinedemo.porcupine_demo_mic import main
  File "<fstring>", line 1
    (self._access_key=)
                     ^
SyntaxError: invalid syntax
</pre>


Para solucionarlo, podemos simplemente comentar las siguiente líneas dentro del fichero <i>/usr/local/lib/python3.7/dist-packages/pvporcupinedemo/porcupine_demo_mic.py</i> (para comentar una línea pondremos el caracter # delante de cada línea a comentar)

<pre>
        #    print("One or more arguments provided to Porcupine is invalid: {\n" +
        #          f"\t{self._access_key=}\n" +
        #          f"\t{self._library_path=}\n" +
        #          f"\t{self._model_path=}\n" +
        #          f"\t{self._keyword_paths=}\n" +
        #          f"\t{self._sensitivities=}\n" +
        #          "}")
        #    print(f"If all other arguments seem valid, ensure that '{self._access_key}' is a valid AccessKey")
</pre>

