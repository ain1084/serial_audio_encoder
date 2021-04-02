# serial_audio_encoder

Serial audio (I2S or Left justified) encoder.

![serial_audio_encoder](https://user-images.githubusercontent.com/14823909/113178140-3c03f800-9289-11eb-89fb-b5b3fdb758af.png)

|Name|Direction|Description|
|--|--|--|
|data_width|parameter|Width of channel audio data|
|reset|input|reset signal (active high)|
|sclk|input|Bit clock (Eg. Fs:44100Hz/16bit = 44100 * 16 * 2 = 1.4112MHz)|
|is_i2s|input|Serial format (0: Left justified / 1: I2S)|
|lrclk_polarity|input|Left-right clock polarity (0: low = left / 1: low = right)|
|i_valid|input|Input data (i_xxxx) valid|
|i_is_left|input|i_data channel (0: right / 1: left)|
|i_data|input|Channel audio data|
|i_ready|output|Data incoming ready|
|osclk|output|Output SCLK signal|
|olrclk|output|Output LRCLK signal|
|osdat|output|Output DATA signal|
