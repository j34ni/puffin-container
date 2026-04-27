# puffin-container

Container image for [SCINE Puffin](https://github.com/qcscine/puffin), the calculation handler for [SCINE Chemoton](https://github.com/qcscine/chemoton).

This is a **modified version** of the official Puffin Dockerfile, optimized for AMD CPUs.

## Key Differences from the Official Dockerfile

- Replaced Intel MKL with **OpenBLAS** (better and consistent performance on AMD CPUs)
- Removed `-march=native` for better portability across different machines
- Made `OMP_NUM_THREADS` configurable via environment variable (official version hardcodes it to 1)
- Added `entrypoint.sh` that dynamically patches `ip`, `cores`, and `memory` in `puffin.yaml` at container startup

## License

This repository contains a modified version of files from the [qcscine/puffin](https://github.com/qcscine/puffin) project.

The original work is Copyright (c) ETH Zurich, Department of Chemistry and Applied Biosciences, Reiher Group and licensed under the **BSD-3-Clause** license.  
This derivative work is released under the **same BSD-3-Clause license**.

See the [LICENSE](LICENSE) file for the full license text.

## Image

The image is automatically built by GitHub Actions and published to GitHub Container Registry (GHCR):

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
