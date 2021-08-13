CC = g++
LDFLAGS = -shared
CXXFLAGS += -fPIC
CXXFLAGS += -Wall
CXXFLAGS += -g
CXXFLAGS += -I../spindrv/include/

RM = rm -f
#TARGET_LIB = libspin.so
TARGET_LIB = libspin.a

SRCS = spin.cpp
OBJS = $(SRCS:.cpp=.o)

.PHONY: all
all: ${TARGET_LIB}

$(TARGET_LIB): $(OBJS)
	#$(CC) -g ${LDFLAGS} -o $@ $^ -ldl
	ar rc $@ $^
	ranlib $@

.PHONY: clean
clean:
	-${RM} ${TARGET_LIB} ${OBJS} $(SRCS:.cpp=.d)

