# Use this Makefile to install CUDA 11.2/11.3 and NVIDIA Container Toolkit https://www.wizart.tech/ on Ubuntu (Tested on Ubuntu 20.4)

# The MIT License (MIT)

# Copyright (C) 2021 Wizart https://www.wizart.ai/. Written by Artur Kuchynski.

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

SHELL := /bin/bash
OS_TYPE := $(shell uname -s)
OS_ARCH := $(shell uname -m)
ID := $(shell grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
VERSION := $(shell grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')


install-cuda-11-3:
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
	wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
	sudo apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
	sudo apt-get update
	sudo apt-get -y install cuda
	tar -xzvf cudnn-11.3-linux-x64-v8.2.0.53.tgz
	sudo cp cuda/include/cudnn.h /usr/local/cuda/include
	sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
	sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.3/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/lib/cuda/include:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export PATH=/usr/local/cuda-11.3/bin:$PATH' >> ~/.bashrc
	echo 'export PATH=/usr/bin:$PATH' >> ~/.bashrc
	echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc
	source ~/.bashrc
	sudo modprobe nvidia
	sudo update-initramfs -u
	sudo reboot


install-cuda-11-2:
	sudo add-apt-repository ppa:graphics-drivers/ppa -y
	sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
	sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
	wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb
	sudo apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub
	sudo apt-get update
	sudo apt-get -y install cuda
	tar -xzvf cudnn-11.2-linux-x64-v8.1.1.33.tgz
	sudo cp cuda/include/cudnn.h /usr/local/cuda/include
	sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
	sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/lib/cuda/include:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
	echo 'export PATH=/usr/local/cuda-11.2/bin:$PATH' >> ~/.bashrc
	echo 'export PATH=/usr/bin:$PATH' >> ~/.bashrc
	source ~/.bashrc
	sudo modprobe nvidia
	sudo update-initramfs -u
	sudo reboot

verify-cuda:
	nvcc --version
	nvidia-smi

verify-cuda-11-3-tf:
	sudo apt-get install -y python3-venv
	python3 -m venv venv
	source venv/bin/activate && pip3 install tensorflow==2.5.1 && python3 -c 'import tensorflow as tf; tf.config.list_physical_devices("GPU")'
	rm -rf venv/
	
verify-cuda-11-2-tf:
	sudo apt-get install -y python3-venv
	python3 -m venv venv
	source venv/bin/activate && pip3 install tensorflow==2.4.2 && python3 -c 'import tensorflow as tf; tf.config.list_physical_devices("GPU")'
	rm -rf venv/
	
purge-nvidia-cuda:
	sudo apt purge *nvidia*
	sudo apt --purge -y remove 'cuda*'
	sudo apt autoremove
	sudo apt autoclean
	sudo rm -rf /usr/local/cuda*
	sudo reboot	

install-docker:
	sudo apt-get update
	sudo apt install curl
	sudo apt-get remove docker docker.io
	sudo apt install docker.io
	sudo systemctl start docker
	sudo systemctl enable docker
	docker --version
	sudo usermod -a -G docker ${USER}
	newgrp docker
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(OS_TYPE)-$(OS_ARCH)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version

install-nvidia-docker:
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
	sudo bash -c "curl -s -L https://nvidia.github.io/nvidia-docker/$(ID)$(VERSION)/nvidia-docker.list >> /etc/apt/sources.list.d/nvidia-docker.list"
	sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
	sudo systemctl restart docker

