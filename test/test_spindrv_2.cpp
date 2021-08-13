
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
#include <iostream>

#define filename "/export/home2/cuc1057/test/rand_data"

using namespace std;
using error = std::runtime_error;

extern void myinit(void);
extern void myend(void);


int main()
{   
    int fd;
    char* buf;
    size_t size = 64*1024;
    off_t offset = 0;
    myinit();
    
    fd = open(filename, O_RDWR);
    buf = (char*)malloc(128*1024);
    memset(buf, 0, size*2);
    if (fd < 0) {
        fprintf(stderr, "open failed\n");
        exit(-1);
    }
    if (!buf) {
        fprintf(stderr, "buf alloc failed\n");
        exit(-1);
    }
    pread64(fd, buf, size, offset);
    //fprintf(stderr, "%s\n", (const char*)buf);
    for (auto i = 0; i < 64; i++) { fprintf(stderr, "%x\n", ((char*)buf)[i]&0xff); }
    //cout << buf[0] << endl;

    myend();
    free(buf);
    return 0;
}
