# Deprecated

This container has been deprecated in favor of the official container from [alpine](https://hub.docker.com/r/alpine/socat).

## Use Cases

I use the `alpine/socat` container as a proxy for [traefik](https://containo.us/traefik/) for any non-Docker swarm websites I may be hosting already in my environment.

I already have DNS wildcarding working in my environment for the `*.jnovack.local` domain to point to my [traefik](https://hub.docker.com/_/traefik/) container, so all I'm doing is adding a proxy container to a website that is not hosted within Swarm.

### Working Examples

The following is a `.yml` file compatible for Docker Swarm (it is not compatible with Docker-Compose).  In my example, a fleet of NUCs are running Swarm, but transmission and my NAS management page are on different hosts.

In the first example, `transmission` is already be integrated with my NAS device, but rather than remembering the IP and port, I just run an `alpine/socat` container to proxy `transmission.jnovack.local` to both the IP and port of the NAS device running the service.

In the second example, my NAS device runs management on a non-standard port and uses TLS.  In that instance, you'll need a TCP router (rather than an HTTP router) and set `passthrough=true` so SSL is terminated at the destination, not at the **traefik** container.  Then, I can manage my NAS at `https://nas.jnovack.local` without needing to remember the IP or port.

```
version: '3.7'

services:
  transmission:
    image: alpine/socat
    command: ["tcp-listen:80,fork,reuseaddr", "tcp:192.168.15.123:9999"]
    networks:
      - traefik_backend
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == worker
      restart_policy:
        condition: any
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.transmission.entrypoints=http"
        - "traefik.http.routers.transmission.rule=Host(`transmission.jnovack.local`)"
        - "traefik.http.services.transmission.loadbalancer.server.port=80"
        - "traefik.docker.network=traefik_backend"

  nas:
    image: alpine/socat
    command: ["tcp-listen:443,fork,reuseaddr", "tcp:192.168.15.123:8443"]
    networks:
      - traefik_backend
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == worker
      restart_policy:
        condition: any
      labels:
        - "traefik.enable=true"
        - "traefik.tcp.routers.nasmgmt.rule=HostSNI(`nas.jnovack.local`)"
        - "traefik.tcp.routers.nasmgmt.tls.passthrough=true"
        - "traefik.tcp.services.nasmgmt.loadbalancer.server.port=443"
        - "traefik.docker.network=traefik_backend"

networks:
  traefik_backend:
    external: true
```
