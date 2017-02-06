PROGRAM = amalgamate

SRCS := Amalgamate.cpp juce_core_amalgam.cpp
INCS := AppConfig.h juce_core_amalgam.h

CXXFLAGS ?= -O2
CXXFLAGS += -std=c++11 -pthread -Wall
LIBS += -ldl -lrt
LDFLAGS += -pthread


all: $(PROGRAM)

$(PROGRAM): $(SRCS) $(INCS)
	$(CXX) -o $@ $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $(SRCS) $(LIBS)

clean:
	$(RM) -v $(PROGRAM) *.gch *.o


.PHONY: all clean
