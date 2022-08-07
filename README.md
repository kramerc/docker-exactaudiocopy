# docker-exactaudiocopy

Runs Exact Audio Copy using Wine inside a Docker container.

Example usage:
```
docker run --name=exactaudiocopy -p 3000:3000 --device /dev/cdrom:/dev/cdrom -v $(pwd)/config:/config -v $(pwd)/data:/data ghcr.io/kramerc/docker-exactaudiocopy
```
