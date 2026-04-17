#!/bin/bash

# to set: sudo systemctl set-default graphical.target

export __GL_MaxFramesAllowed=1
sudo nvidia-smi -pm 1
sudo nvidia-smi -i 0 -pl 200 

sudo systemctl isolate graphical
sudo systemctl start systemd-logind
