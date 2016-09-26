#!/bin/bash

python feature_dist.py "" norm.fix 1
python feature_dist.py lora_ norm.fix.valid 1
python feature_dist.py light_ norm.fix.valid 1
