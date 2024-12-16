import sys

import torch
import torch.nn as nn


def sanity_check():
    # Define a simple model
    model = nn.Linear(10, 5)  # Input size 10, output size 5
    # Create dummy input
    dummy_input = torch.randn(1, 10)  # Batch size 1, input size 10
    # Pass dummy input through the model
    output = model(dummy_input)
    # Print input and output shapes
    print(f"Input shape: {dummy_input.shape}, Output shape: {output.shape}")

SUCCESS = False
try:
    sanity_check()
    SUCCESS = True
finally:
    rc = 0 if SUCCESS else 1
    sys.exit(rc)
