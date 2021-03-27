@echo off
iverilog ../serial_audio_encoder.v serial_audio_encoder_tb.v
if not errorlevel 1 (
    vvp a.out
    del a.out
)
