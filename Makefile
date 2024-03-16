DEBUG ?= 0

PROGRAM = amalgamate
SRCS := Amalgamate.cpp

JUCE_CORE_DIR := 3rd/JUCE/modules/juce_core
JUCE_CORE_SRCS :=
ifeq ($(shell uname -s),Darwin)
	JUCE_CORE_SRCS += $(JUCE_CORE_DIR)/juce_core.mm
else
	JUCE_CORE_SRCS += $(JUCE_CORE_DIR)/juce_core.cpp
endif

CXXLD ?= $(CXX)
CXXFLAGS ?= -O2
CXXFLAGS += -std=c++14 -pthread
CXXFLAGS += -Wall
CXXFLAGS += -I$(JUCE_CORE_DIR) -I./ -DJUCE_APP_CONFIG_HEADER=\"AppConfig.h\"
ifeq ($(DEBUG), 1)
	CXXFLAGS += -DDEBUG=1 -DJUCE_DEBUG=1
endif
LIBS += -ldl
LDFLAGS += -pthread
ifeq ($(shell uname -s),Darwin)
	LDFLAGS += -framework Foundation -framework AppKit
endif
MV ?= mv


all: preflight $(PROGRAM)

$(PROGRAM): $(PROGRAM).o juce_core.o
	$(CXXLD) -o $@ $(CXXFLAGS) $(LDFLAGS) $^ $(LIBS)

$(PROGRAM).o: $(SRCS)
	$(CXX) -c -o $@ $(CPPFLAGS) $(CXXFLAGS) $<

juce_core.o: $(JUCE_CORE_SRCS)
	$(CXX) -c -o $@ $(CPPFLAGS) $(CXXFLAGS) $<


clean:
	$(RM) -v $(PROGRAM) *.gch *.o $(JUCE_CORE_DIR)/*.o

_preflight-linux:
	cat /etc/os-release
_preflight-macos:
	sw_vers

_preflight_os = _preflight-linux
ifeq ($(shell uname -s),Darwin)
	_preflight_os = _preflight-macos
endif

preflight: $(_preflight_os)
	$(MAKE) -v
	@echo CXX = $(CXX)
	@echo CXXLD = $(CXXLD)
	$(CXX) -v
	$(CXXLD) -v
	@echo CXXFLAGS = $(CXXFLAGS)
	@echo LDFLAGS = $(LDFLAGS)
	@echo LIBS = $(LIBS)

check: $(PROGRAM)
	./$(PROGRAM) -v $(JUCE_CORE_DIR)/juce_core.h juce_core.h
	$(MV) -v juce_core.h $(JUCE_CORE_DIR)/juce_core.h
	$(MAKE) clean
	$(MAKE) $(PROGRAM)
	@# just check if it's able to at least output the usage text
	./$(PROGRAM) -h


.PHONY: all clean check preflight _preflight-linux _preflight-macos
