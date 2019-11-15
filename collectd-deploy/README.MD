# Collectd

## Overview

Collectd uses the *network* plugin to push metrics into *influxdb*.  Influxdb exposes a UDP port for this purpose.  Influxdb is run within an external cluster and uses nodePort to expose a port.  The *influxdb* directory will explain it's usage.  

## General steps

1. Create the collectd namespace: **oc apply -f 02_namespace.yml**
2. Create a service account: **oc apply -f 02_serviceaccount.yml**
3. Create a binding: **oc apply -f 04_rbac.yml**
4. Enable permissions for the collectd container (host network/privileged): **./add_scc.sh** which executes..
   1. oc adm policy add-scc-to-user hostnetwork system:serviceaccount:collectd:collectd
   2. oc adm policy add-scc-to-user privileged system:serviceaccount:collectd:collectd
5. Prepare the collectd.conf file as below.

### Collectd config file

Change the following section

    <Plugin network>
        Server "<destination_host_goes_here>" "30000" #InfluxDB
    </Plugin>

to match the influxdb deployment.  By default, influxdb will expose it's collectd interface on **nodePort** 30000.  However, since nodePorts are dynamically allocated, the actual port may be different if there is a conflict.  You can obtain the <destination_host_goes_here> value using
a command similar to:

    kubectl get pod/collectd-influxdb-cb86f69c8-j86p5 -n influxdb -oyaml

Where the pod name matches the deployed pod.  The output of the above command contains the **hostIP**.  Replace <destination_host_goes_here> with the hostIP.  

Finally, deploy the daemonset with:

    oc apply -f 06_daemonset.yml"

## Intel PMU

Additional work is required on each node where collectd is running for intel_pmu to work.  The *intel_pmu* configuration requires an events config file (.json).
The intel_pmu plugin configuration is:

       <Plugin intel_pmu>
         ReportHardwareCacheEvents true
         ReportKernelPMUEvents true
         ReportSoftwareEvents true
         EventList "/var/cache/pmu/GenuineIntel-6-2D-core.json"
         HardwareEvents "L2_RQSTS.CODE_RD_HIT,L2_RQSTS.CODE_RD_MISS" "L2_RQSTS.ALL_CODE_RD"
         Cores "[0-4]"
       </Plugin>

To generate the events file:

1. Enter the pod through the OpenShift GUI (or through the oc exec -it command)
2. Inside, cd /src/barometer/src/pmu-tools/pmu-tools
3. Run: ./events_download.py
4. The file: /root/.cache/pmu-events/GenuineIntel-6-55-4-core.json will be created.
5. Copy /root/.cache/pmu-events/GenuineIntel-6-55-4-core.json to /var/cache/pmu
6. The /var/cache/pmu directory is a hostPath mount described in the daemonset.

After completing the above steps, delete the associated pod so that collectd will restart with the event file in place.
