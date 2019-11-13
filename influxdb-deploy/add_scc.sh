#!/bin/bash
oc adm policy add-scc-to-user anyuid system:serviceaccount:influxdb:influxdb
