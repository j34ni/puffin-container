# puffin-container

Container image for [SCINE Puffin](https://github.com/qcscine/puffin), the calculation handler for [SCINE Chemoton](https://github.com/qcscine/chemoton).

## Differences from the official Dockerfile

The [official SCINE Puffin Dockerfile](https://github.com/qcscine/puffin/blob/master/container/docker/Dockerfile) uses Intel MKL (Math Kernel Library). While MKL is free to use, it deliberately underperforms on non-Intel CPUs, and the target machines here have AMD CPUs. This image uses OpenBLAS instead, which is fully open source and performs consistently across all x86_64 hardware.

Other changes:
- `-march=native` removed to ensure the image runs on any CPU, not just the build machine
- `OMP_NUM_THREADS` made dynamic via environment variable (the official image hardcodes it to 1)
- `entrypoint.sh` patches `ip`, `cores`, and `memory` in `puffin.yaml` at container startup from environment variables

## Image

The image is built automatically by GitHub Actions and published to GHCR:

```bash
docker pull ghcr.io/j34ni/puffin-container:latest
```

## Usage

```bash
docker run -d \
  --name puffin-1 \
  --restart unless-stopped \
  -e PUFFIN_DATABASE_IP=<mongodb_ip> \
  -e PUFFIN_THREADS=2 \
  -e PUFFIN_MEMORY=4000 \
  ghcr.io/j34ni/puffin-container:latest
```

### Environment variables

| Variable | Default | Description |
|---|---|---|
| `PUFFIN_DATABASE_IP` | `127.0.0.1` | IP address of the MongoDB instance |
| `PUFFIN_THREADS` | `1` | Number of CPU threads per Puffin instance |
| `PUFFIN_MEMORY` | `1000` | Memory in MB per Puffin instance |

`PUFFIN_THREADS` × number of containers should equal the number of available CPUs. `PUFFIN_MEMORY` × number of containers should stay within available RAM.
