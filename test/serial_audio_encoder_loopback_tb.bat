@echo off
iverilog ../serial_audio_encoder.v serial_audio_encoder_loopback_tb.v serial_audio_decoder/serial_audio_decoder.v
if not errorlevel 1 (
    vvp a.out
    del a.out
)
