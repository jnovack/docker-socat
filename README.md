# TCP Socat

[![](https://images.microbadger.com/badges/image/jnovack/socat.svg)](https://microbadger.com/images/jnovack/socat "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/jnovack/socat.svg)](https://microbadger.com/images/jnovack/socat "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/jnovack/socat.svg)](https://microbadger.com/images/jnovack/socat "Get your own commit badge on microbadger.com")

Provides the possibility of cat a TCP connection to a defined PORT.

## Use cases

If you want to export something from the Docker API in a service this can be useful.

For example it comes with default values to expose the `docker_gwbridge`.

Imagine you are exposing the "metrics" endpoint that comes with docker over tcp/9393.

```bash
$ docker run -d --name socat-test -p 39393:9393 localhost:5000/jnovack/socat:v0.1.0
$ curl localhost:39393/metrics
# HELP engine_daemon_container_actions_seconds The number of seconds it takes to process each container action
# TYPE engine_daemon_container_actions_seconds histogram
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.005"} 1
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.01"} 1
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.025"} 1
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.05"} 1
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.1"} 1
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.25"} 1
engine_daemon_container_actions_seconds_bucket{action="changes",le="0.5"} 1
...
```
