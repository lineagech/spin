CC = g++
LDFLAGS = -shared
CXXFLAGS += -fPIC
CXXFLAGS += -Wall
CXXFLAGS += -g 
CXXFLAGS += -I../spindrv/include/

RM = rm -f
TARGET =

SRCS = $(wildcard *.cu)
CPP_SRCS = $(wildcard *.cpp)
TARGET = $(patsubst %.cu,%,$(SRCS))
TARGET += $(patsubst %.cpp,%,$(CPP_SRCS))

EXEC ?= 
NVCC := /usr/local/cuda/bin/nvcc -ccbin g++
NVCCFLAGS := -m64 -g -G -L../libspin -std=c++11
INCLUDES := -I../spindrv/include
LIBRARIES := -lcudart -lcuda -lspin
GENCODE_FLAGS = -gencode arch=compute_75,code=compute_75

.PHONY: all
all: $(TARGET)

%:%.cu
	$(EXEC) $(NVCC) $(NVCCFLAGS) $(INCLUDES) $(GENCODE_FLAGS) $^ -o $@ $(LIBRARIES)

.PHONY: clean
clean:
	rm -f $(TARGET)
