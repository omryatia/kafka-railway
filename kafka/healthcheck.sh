#!/bin/bash
kafka-topics --bootstrap-server localhost:29092 --list >/dev/null 2>&1
exit $?
