We use `Pytorch` to train models and `Miniconda` to manage python environments.

## Miniconda

### Install
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh;
bash Miniconda3-latest-Linux-x86_64.sh
```
### Setup
Follow steps below to setup python environment:
1. create virtual environment: `conda create -n torch python=3.7`;
2. activate virtual environment: `conda activate torch`;
3. install required packages: `pip install -r requirment.txt -i https://pypi.tuna.tsinghua.edu.cn/simple`

And now, you can activate corresponding virtual environment to train model.
Visit [Conda.io](https://docs.conda.io/projects/conda/en/latest/index.html) for more details.

## Pytorch
`Pytorch` can work in either `CPU` mode or `GPU` mode.

### CPU Environment

#### Install Pytorch
```bash
conda install pytorch torchvision cudatoolkit=10.2 -c pytorch
```

### GPU Environment

#### Install GPU Driver
Before start, make sure that the `secure boot` in your `BIOS` is set to `disable`.

##### Disable nouveau
`nouveau` is an open-source GPU driver, it may get errors while running.
1. Create file:
```
sudo vim /etc/modprobe.d/blacklist-nouveau.conf
```

2. Paste text: 
```
blacklist nouveau
options nouveau modeset=0
```

3. Update your change:
```
sudo update-initramfs -u
```

4. Reboot
```
reboot
```

5. If everything is ok, you will get nothing with following commands:
```
lsmod | grep nouveau
```

##### Install Nvidia Driver
1. Add ppa:
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
```

2. In `Software & Updates` -> `Additional Drivers`, the `NVIDIA Driver` will appear. Choose `nvidia-driver-440` and `Apply Changes`.

3. Reboot.

4. If everything works fine, you can use the following command to show the driver information:
```
nvidia-smi
```

#### CUDA toolkit

##### Download
```
wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda_10.2.89_440.33.01_linux.run
```

##### Install
```
sudo sh cuda_10.2.89_440.33.01_linux.run
```
**Attention:** Do not choose GPU driver.
```
CUDA Installer
- [ ] Driver
     [ ] 440.33.01
+ [X] CUDA Toolkit 10.2
  [X] CUDA Samples 10.2
  [X] CUDA Demo Suite 10.2
  [X] CUDA Documentation 10.2
  Options
  Install
```
**when installization is over, content below will be output**
```
===========
= Summary =
===========

Driver:   Not Selected
Toolkit:  Installed in /usr/local/cuda-10.2/
Samples:  Installed in /home/lyu/

Please make sure that
 -   PATH includes /usr/local/cuda-10.2/bin
 -   LD_LIBRARY_PATH includes /usr/local/cuda-10.2/lib64, or, add /usr/local/cuda-10.2/lib64 to /etc/ld.so.conf and run ldconfig as root

To uninstall the CUDA Toolkit, run cuda-uninstaller in /usr/local/cuda-10.2/bin

Please see CUDA_Installation_Guide_Linux.pdf in /usr/local/cuda-10.2/doc/pdf for detailed information on setting up CUDA.
***WARNING: Incomplete installation! This installation did not install the CUDA Driver. A driver of version at least 440.00 is required for CUDA 10.2 functionality to work.
To install the driver using this installer, run the following command, replacing <CudaInstaller> with the name of this run file:
    sudo <CudaInstaller>.run --silent --driver

Logfile is /var/log/cuda-installer.log
```

#### Cudnn

##### Download
Download CUDNN from [Official website](https://developer.nvidia.com/cudnn).

##### Decompress
```
tar xvf cudnn-10.2-linux-x64-v7.6.5.32.tgz
```

##### Copy to System Dir
```
sudo cp cuda/include/cudnn.h /usr/local/cuda/include;
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64;
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```

##### Check
Reboot your computer and use:
```
nvcc -V
```
to check cuda information.

#### Pytorch
Install `Pytorch` as the `CPU Environment` step.

#### Check GPU is Available
In python environment:
```
import torch
torch.cuda.is_available()
```
