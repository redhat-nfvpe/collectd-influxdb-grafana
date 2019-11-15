# collectd-influxdb-grafana

Setup collectd+influxdb+grafana to show infrastructure metrics of a kubernetes cloud.

## Overview

This repo contains instructions and manifests to deploy:

* Collectd -- Metrics gathering agent
* Influxdb -- Timeseries database
* Grafana -- Tool to graphically present metrics

This particular deploy targeted by this repo consists of two separate kubernetes clouds.  The first cloud, where collectd is running as a daemonset, is an OpenShift cloud running RAN software.  The second cloud is a generic Kubernetes cloud that is running general applications in addition to Influxdb and Grafana.  

    
         OpenShift                                Kubernetes
           RAN
    +-----------------+              +---------------------------------+
    |                 |              |                                 |
    |  +----------+   |              |                                 |
    |  |          |   |              |                                 |
    |  | Collectd +--------------+   |                                 |
    |  |          |   |          |   |                                 |
    |  +----------+   |          |   |                                 |
    |                 |          |   |                                 |          +-------------+
    |  +----------+   |          |   | +----------+        +---------+ |          |             |
    |  |          |   |          |   | |          |        |         | |          |        ++   |
    |  | Collectd +--------------------> InfluxDB +<-------+ Grafana +------------+     +--+    |
    |  |          |   |          |   | |          |        |         | |          |  +--+       |
    |  +----+-----+   |          |   | +----------+        +---------+ |          |  +          |
    |       |         |          |   |                                 |          |             |
    |       |         |          |   |                                 |          +-------------+
    |       |         |          |   |                                 |
    |       |         |          |   |                                 |
    |       |         |          |   |                                 |
    |  +----+-----+   |          |   |                                 |
    |  |          |   |          |   |                                 |
    |  | Collectd +--------------+   |                                 |
    |  |          |   |              |                                 |
    |  +----------+   |              |                                 |
    |                 |              |                                 |
    +-----------------+              +---------------------------------+
