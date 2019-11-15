#!/bin/bash
oc adm policy add-scc-to-user hostnetwork system:serviceaccount:sa-grafana:sa-grafana
oc adm policy add-scc-to-user privileged system:serviceaccount:sa-grafana:sa-grafana
