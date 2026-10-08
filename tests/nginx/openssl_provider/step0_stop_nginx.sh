#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

# Use with Caution
# check if the oldest nginx process is really the nginx we want to kill for start our own
NGINX_PID=$(pgrep -o nginx || true)
if [ -n "$NGINX_PID" ]
then
    echo "Stop current running nginx"
    echo
    echo "=================================================="
    sudo kill -9 $NGINX_PID
fi
