#!/bin/bash

if [ ! -f "./data/moa.db" ]; then
    python3 -m moa.models
fi

./worker.sh & python3 app.py
