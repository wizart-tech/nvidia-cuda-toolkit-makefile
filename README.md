# nvidia-cuda-toolkit-makefile
Install Nvidia CUDA 11.2/11.3 with cuDNN and Nvidia Container Toolkit on Ubuntu 20.04 using `make`


## Requirements

- Ubuntu 20.04/21.04 Instance (Tested on Ubuntu 20.04)
- [GNU Make](https://www.gnu.org/software/make/)
- Downloaded [cuDNN Archive](https://developer.nvidia.com/rdp/cudnn-archive) for Linux
- `sudo` or `root` privileges;

## Usage

Once the cuDNN Archive is downloaded from the [Official Nvidia Page](https://developer.nvidia.com/rdp/cudnn-archive), the installation procedure can be started.

For CUDA 11.2 - `cudnn-11.2-linux-x64-v8.1.1.33.tgz` is used in Makefile. 

For CUDA 11.3 - `cudnn-11.3-linux-x64-v8.2.0.53.tgz` respectively.

Depending on the OS platform or cuDNN release you can download desired version and just specify It in your Makefile.

**Install Nvidia CUDA 11.3 with cuDNN v8.2.0.53:**

```make install-cuda-11-3```

This action will automatically reboot your machine after the installation will be completed.

**Verify the installation:**

```make verify-cuda```

The output should be like:
```
nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2021 NVIDIA Corporation
Built on Sun_Mar_21_19:15:46_PDT_2021
Cuda compilation tools, release 11.3, V11.3.58
Build cuda_11.3.r11.3/compiler.29745058_0
nvidia-smi
Wed Sep  1 13:43:43 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 465.19.01    Driver Version: 465.19.01    CUDA Version: 11.3     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA Tesla T4     On   | 00000000:00:1E.0 Off |                    0 |
| N/A   38C    P0    26W /  70W |   8444MiB / 15109MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A     10837      C   ...n/tensorflow_model_server     8441MiB |
+-----------------------------------------------------------------------------+
```
**(Optional) You can also check that TensorFlow can now detect and use your GPU(s):**

```make verify-cuda-11-3-tf```

**(Optional) Install Docker and Nvidia Container Toolkit:**

```make install-docker```

```make install-nvidia-docker```
