CC=gcc
CXX=g++

# Work around hacks in the Source engine
CFLAGS=-m32 -std=gnu++11 -fpermissive -fPIC \
	-DPOSIX -DLINUX -D_LINUX \
	-DSOURCE_ENGINE=6 -D_LINUX -DLINUX -DPOSIX \
	-DGNUC -DCOMPILER_GCC -DCOMPILER_GCC32

OPTFLAGS=-O2

# ******************************
# Change these to the proper
# locations for your system.
# ******************************
HL2SDK=/path/to/hl2sdk-css
MMSDK=/path/to/metamod-source

# Include Source SDK directories
INCLUDES=-I$(HL2SDK)/public -I$(HL2SDK)/public/tier0 -I$(HL2SDK)/public/tier1 -I$(MMSDK)/core

# Include the folder with the Source SDK libraries
LINKFLAGS=-shared -m32 -L$(HL2SDK)/lib/public/linux

all: check serverplugin_empty.o Tickrate_Enabler.so

serverplugin_empty.o: serverplugin_empty.cpp
	$(CXX) $(CFLAGS) $(OPTFLAGS) $(INCLUDES) -c $^

Tickrate_Enabler.so:
	$(CC) -o Tickrate_Enabler.so $(LINKFLAGS) serverplugin_empty.o $(MMSDK)/build/core/metamod.2.$(ENGINE)/linux-x86/sourcehook_sourcehook*.o \
	-ltier0_srv -l:tier1_i486.a -static-libstdc++ -lm -ldl

clean:
	-rm -f serverplugin_empty.o
	-rm -f Tickrate_Enabler.so

check:
	if [ "$(ENGINE)" = "false" ]; then \
	echo "You must supply one of the following values for ENGINE:"; \
	echo "l4d2, l4d, obv, ob, css, sdk2013, ep2, or (possibly, with changes) ep1"; \
	fi
