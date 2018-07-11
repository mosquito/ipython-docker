#!/bin/bash


if [ ! -e .jupyter/jupyter_notebook_config.py ]; then
  ipython notebook --generate-config
fi

exec ipython3 notebook \
  --ip=0.0.0.0 \
  --port=8000 \
  --notebook-dir=/data \
  --no-browser \
  --config .jupyter/jupyter_notebook_config.py
