# serial_audio_encoder

Serial audio (I2S or Left justified) encoder.

## Module description

![serial_audio_encoder](https://user-images.githubusercontent.com/14823909/113436176-35a78480-941f-11eb-936f-84346c20c97f.png)

|Name|Direction|Description|
|--|--|--|
|data_width|parameter|Width of channel audio data|
|reset|input|reset signal (active high)|
|clk|input|Input sclk (Eg. Fs:44100Hz/16bit = 44100 * 16 * 2 = 1.4112MHz)|
|is_i2s|input|Serial format (0: Left justified / 1: I2S)|
|lrclk_polarity|input|Left-right clock polarity (0: low = left / 1: low = right)|
|i_valid|input|Input data (i_xxxx) valid|
|i_is_left|input|i_audio channel (0: right / 1: left)|
|i_audio|input|Channel audio data|
|i_ready|output|Data incoming ready|
|sclk|output|Output SCLK signal|
|lrclk|output|Output LRCLK signal|
|sdo|output|Output DATA signal|

## Timming diagram

![is_i2s=0 lrclk_polarity=0](https://user-images.githubusercontent.com/14823909/113442011-385ba700-942a-11eb-85fb-e7f5cdc02cf2.png)
![is_i2s=1 lrclk_polarity=1](https://user-images.githubusercontent.com/14823909/113442014-38f43d80-942a-11eb-89be-81a6671dd340.png)
