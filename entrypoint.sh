#!/bin/bash
set -e

MEMORY_GB=$(python3 -c "print(${PUFFIN_MEMORY:-1000}/1000)")

sed \
  -e "s/ip: 127.0.0.1/ip: ${PUFFIN_DATABASE_IP:-127.0.0.1}/" \
  -e "s/  cores: [0-9]*/  cores: ${PUFFIN_THREADS:-1}/" \
  -e "s/  memory: [0-9.]*/  memory: ${MEMORY_GB}/" \
  /scratch/puffin.yaml.template > /puffin.yaml

source /scratch/puffin.sh

export OMP_NUM_THREADS=${PUFFIN_THREADS:-1}

exec python3 -m scine_puffin -c /puffin.yaml container
