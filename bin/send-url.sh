#!/bin/sh
echo $* | nc localhost 6663 || echo "send-url failed"
