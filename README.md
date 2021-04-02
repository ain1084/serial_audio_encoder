# serial_audio_encoder

Serial audio (I2S or Left justified) encoder.

![serial_audio_encoder](https://user-images.githubusercontent.com/14823909/113435242-5ff84280-941d-11eb-9f99-e2086f402560.png)

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
