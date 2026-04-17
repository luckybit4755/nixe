#!/bin/bash	

_mic_record_main() {
pw-jack $(which deepin-voice-recorder )
}

_mic_record_main ${*}
