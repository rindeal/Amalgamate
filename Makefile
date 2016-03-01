PROGRAM = amalgamate

LIBS = -ldl
CXXFLAGS += -std=c++11 -pthread $(LIBS)

.PHONY: all
all: $(PROGRAM)

$(PROGRAM): $(wildcard *.cpp) $(wildcard *.h)
	$(CXX) $(CXXFLAGS) -o $@ $^

.PHONY: clean
clean:
	$(RM) -v $(PROGRAM)
