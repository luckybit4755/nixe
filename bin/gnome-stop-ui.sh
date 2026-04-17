#!/bin/bash

# to set: sudo systemctl set-default multi-user.target

sudo systemctl stop systemd-logind
sudo systemctl isolate multi-user.target
