PROGRAM = amalgamate

SRCS := Amalgamate.cpp juce_core_amalgam.cpp
INCS := AppConfig.h juce_core_amalgam.h

CXXFLAGS ?= -O2
CXXFLAGS += -std=c++11 -pthread
CXXFLAGS += -Wall
LIBS += -ldl -lrt
LDFLAGS += -pthread $(LIBS)

.PHONY: all
all: $(PROGRAM)

$(PROGRAM): $(SRCS) $(INCS)
	$(CXX) -o $@ $(CPPFLAGS) $(CXXFLAGS) $(SRCS) $(LDFLAGS)

.PHONY: clean
clean:
	$(RM) -v $(PROGRAM) *.gch *.o
