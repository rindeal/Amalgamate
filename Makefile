PROGRAM = amalgamate

JUCE_CORE_DIR := 3rd/JUCE/modules/juce_core

SRCS := Amalgamate.cpp $(JUCE_CORE_DIR)/juce_core.cpp

CXXLD ?= $(CXX)
CXXFLAGS ?= -O2 -flto
CXXFLAGS += -std=c++14 -pthread -fno-strict-aliasing
CXXFLAGS += -Wall
CXXFLAGS += -I$(JUCE_CORE_DIR) -I./ -DJUCE_APP_CONFIG_HEADER=\"AppConfig.h\"
LIBS += -ldl -lrt
LDFLAGS ?= -flto
LDFLAGS += -pthread


all: $(PROGRAM)

$(PROGRAM): $(SRCS:.cpp=.o)
	$(CXXLD) -o $@ $(LDFLAGS) $^ $(LIBS)

%.o: %.cpp
	$(CXX) -c -o $@ $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $<

clean:
	$(RM) -v $(PROGRAM) *.gch *.o $(JUCE_CORE_DIR)/*.o

check: $(PROGRAM)
	@# just check if it's able to at least output the usage text
	./$(PROGRAM) -h


.PHONY: all clean check
