#!/bin/bash
curl -s -f http://localhost:8080/actuator/health >/dev/null 2>&1
exit $?
