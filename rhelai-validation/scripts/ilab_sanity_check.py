import json
import os
import sys

import torch
import torch.nn as nn

RESULT_PATH = os.path.join(os.getcwd(), "ilab_sanity_result.json")

_DATA = {
    "success": False,
    "extra": {},
}

def sanity_check():
    # Define a simple model
    model = nn.Linear(10, 5)  # Input size 10, output size 5
    # Create dummy input
    dummy_input = torch.randn(1, 10)  # Batch size 1, input size 10
    # Pass dummy input through the model
    output = model(dummy_input)
    # Print input and output shapes
    print(f"Input shape: {dummy_input.shape}, Output shape: {output.shape}")

try:
    _DATA["extra"]["is_cuda_available"] = torch.cuda.is_available()
    _DATA["extra"]["cude_device_count"] = torch.cuda.device_count()
    sanity_check()
    SUCCESS = True
except Exception:
    SUCESS = False

try:
    _DATA["success"] = SUCCESS
    with open(RESULT_PATH, "w") as json_file:
        json.dump(_DATA, json_file, indent=4)
finally:
    rc = 0 if SUCCESS else 1
    sys.exit(rc)
