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

GH_ASSETS := "$(PROGRAM)" "$(PROGRAM).1" "README.md" "LICENSE"

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
CP    ?= cp
ZIP   ?= zip
GH    ?= gh
MKDIR ?= mkdir


all: _preflight $(PROGRAM)

$(PROGRAM): $(PROGRAM).o juce_core.o
	$(CXXLD) -o $@ $(CXXFLAGS) $(LDFLAGS) $^ $(LIBS)

$(PROGRAM).o: $(SRCS)
	$(CXX) -c -o $@ $(CPPFLAGS) $(CXXFLAGS) $<

juce_core.o: $(JUCE_CORE_SRCS)
	$(CXX) -c -o $@ $(CPPFLAGS) $(CXXFLAGS) $<


clean:
	$(RM) -v $(PROGRAM) *.gch *.o $(JUCE_CORE_DIR)/*.o

_preflight:
	-@test `uname -s` = "Darwin" && sw_vers || cat /etc/os-release
	-$(MAKE) -v
	-@echo CXX = $(CXX)
	-@echo CXXLD = $(CXXLD)
	-$(CXX) -v
	-$(CXXLD) -v
	-@echo CXXFLAGS = $(CXXFLAGS)
	-@echo LDFLAGS = $(LDFLAGS)
	-@echo LIBS = $(LIBS)

check: $(PROGRAM)
	./$(PROGRAM) -v $(JUCE_CORE_DIR)/juce_core.h juce_core.h
	$(MV) -v juce_core.h $(JUCE_CORE_DIR)/juce_core.h
	$(MAKE) clean
	$(MAKE) $(PROGRAM)
	@# just check if it's able to at least output the usage text
	./$(PROGRAM) -h


gh-upload: $(PROGRAM)
	@test -n "$(GH_TAG)" || (echo "Error: Variable 'GH_TAG' not set" >&2; exit 1)
	@test -n "$(REL_TAG)" || (echo "Error: Variable 'REL_TAG' not set" >&2; exit 1)
	set -ex ;\
	platform="$$(uname -s | tr '[:upper:]' '[:lower:]')" ;\
	    arch="$$(uname -m | tr '[:upper:]' '[:lower:]' | sed 's|x86_64|amd64|')" ;\
	archive_basename="$(ASSET_BASENAME)-$${platform}-$${arch}" ;\
	$(MKDIR) -v                                                            "$${archive_basename}" ;\
	$(CP)    -v -a $(GH_ASSETS)                                            "$${archive_basename}" ;\
	$(ZIP) -r                                  "$${archive_basename}.zip"  "$${archive_basename}" ;\
	$(GH) release upload --clobber "$(GH_TAG)" "$${archive_basename}.zip" ;\
	set +ex


.PHONY: all clean check
.PHONY: _preflight
.PHONY: gh-upload
