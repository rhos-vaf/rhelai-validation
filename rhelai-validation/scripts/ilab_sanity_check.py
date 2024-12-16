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

try:
    is_cuda_available = torch.cuda.is_available()
    num_cuda_devices = torch.cuda.device_count()
    sanity_check()
except Exception:
    sys.exit(1)
finally:
    sys.exit(0)
