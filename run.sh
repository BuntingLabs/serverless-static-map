#!/bin/sh

Xvfb ${DISPLAY} -screen 0 "1024x768x24" -ac +render -noreset -nolisten tcp  &

/opt/.aws-lambda-rie/aws-lambda-rie python3 -m awslambdaric app.handler