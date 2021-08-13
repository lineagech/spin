#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <linux/unistd.h>
//#include <spin/spindrv.h>
#include <spindrv.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdarg.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <dlfcn.h>
#include <string>
#include <stdexcept>
#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;
using error = std::runtime_error;

extern void myinit(void);
extern void myend(void);

void transfer_to_address(void *address, size_t size)
{
    CUDA_POINTER_ATTRIBUTE_P2P_TOKENS tokens;
    CUresult status = cuPointerGetAttribute(&tokens,
            CU_POINTER_ATTRIBUTE_P2P_TOKENS, (CUdeviceptr)address);
    if (CUDA_SUCCESS == status) {
        // GPU path
        //pass_to_kernel_driver(tokens, address, size);
        fprintf(stderr, "%p is GPU path\n", address);
    }
}

static void getDeviceMemory(void*& bufferPtr, void*& devicePtr, size_t size)
{
    bufferPtr = nullptr;
    devicePtr = nullptr;

    //cudaError_t err = cudaSetDevice(device);
    cudaError_t err = cudaSuccess;
    if (err != cudaSuccess)
    {
        throw error(string("Failed to set CUDA device: ") + cudaGetErrorString(err));
    }

    err = cudaMalloc(&bufferPtr, size);
    if (err != cudaSuccess)
    {
        throw error(string("Failed to allocate device memory: ") + cudaGetErrorString(err));
    }

    err = cudaMemset(bufferPtr, 0, size);
    if (err != cudaSuccess)
    {
        cudaFree(bufferPtr);
        throw error(string("Failed to clear device memory: ") + cudaGetErrorString(err));
    }

    cudaPointerAttributes attrs;
    err = cudaPointerGetAttributes(&attrs, bufferPtr);
    if (err != cudaSuccess)
    {
        cudaFree(bufferPtr);
        throw error(string("Failed to get pointer attributes: ") + cudaGetErrorString(err));
    }

    devicePtr = attrs.devicePointer;

    fprintf(stderr, "buff %p, dev %p\n", bufferPtr, devicePtr);
}
int main()
{
    //myinit();
    int fd = open("/dev/spindrv", O_RDONLY);
    spindrv_ioctl_inc_t ioctl_args;
    spindrv_ioctl_param_union send_ioctl;
    memset(&ioctl_args, 0, sizeof(spindrv_ioctl_inc_t));
    
    size_t size = 208*1024*1024;
    void* d_buffer = NULL, *h_buffer = NULL;
    getDeviceMemory(h_buffer, d_buffer, size);
    //cudaMalloc(&d_buffer, 1024*1024);
    transfer_to_address(d_buffer, size);



    //cudaMallocHost(&buffer, 1024*1024);
    //h_buffer = malloc(1024*1024);

    //cudaMemcpy(d_buffer, h_buffer, 1024*1024, cudaMemcpyHostToDevice);
    if (d_buffer == NULL) {
        fprintf(stderr, "cuda d_buffer allocation failed");
        return -1;
    }
    else {
        fprintf(stderr, "d_buffer %p\n", d_buffer);
    }
    ioctl_args.addr = d_buffer;
    ioctl_args.size = size;

    if (fd < 0) {
        fprintf(stderr, "cannot open spindrv\n");
        return -1;
    }
    send_ioctl.set = ioctl_args;

    if (ioctl(fd, SPIN_IOCTL_ADDR_TEST, &send_ioctl) != 0) {
        fprintf(stderr, "Spin Drv IOCTL addr test failed\n");
    }
    cudaFree(d_buffer);
    //free(h_buffer);
    //myend();
    close(fd);
    return 0;
}
