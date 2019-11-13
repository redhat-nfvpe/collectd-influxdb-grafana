#!/bin/bash
oc adm policy add-scc-to-user hostnetwork system:serviceaccount:collectd:collectd
oc adm policy add-scc-to-user privileged system:serviceaccount:collectd:collectd
