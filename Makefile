PROGRAM = amalgamate

LIBS = -ldl -lrt
CXXFLAGS += -std=c++11 -pthread $(LIBS)

.PHONY: all
all: $(PROGRAM)

$(PROGRAM): $(wildcard *.cpp) $(wildcard *.h)
	$(CXX) -o $@ $^ $(CXXFLAGS)

.PHONY: clean
clean:
	$(RM) -v $(PROGRAM)
