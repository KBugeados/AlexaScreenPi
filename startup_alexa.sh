#!/bin/bash
export DISPLAY=:0.0
porcupine_demo_mic --access_key <TU CLAVE> --keywords alexa &

PA_ALSA_PLUGHW=1 /home/pi/sdk_folder/ss-build/modules/Alexa/SampleApp/src/SampleApp -C /home/pi/sdk_folder/sdk-build/Integration/AlexaClientSDKConfig.json -C /home/pi/sdk_folder/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json -L INFO &
