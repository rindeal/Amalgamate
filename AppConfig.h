// Configures the Juce library.

#ifndef   JUCE_DONT_AUTOLINK_TO_WIN32_LIBRARIES
//#define JUCE_DONT_AUTOLINK_TO_WIN32_LIBRARIES
#endif

#define JUCE_USE_CURL 0
#define JUCE_STANDALONE_APPLICATION 1

#ifdef JUCE_DEBUG
#
#  ifndef   JUCE_FORCE_DEBUG
#    define JUCE_FORCE_DEBUG 1
#  endif
#
#  ifndef   JUCE_LOG_ASSERTIONS
#    define JUCE_LOG_ASSERTIONS 1
#  endif
#
#  ifndef   JUCE_CHECK_MEMORY_LEAKS
#    define JUCE_CHECK_MEMORY_LEAKS 1
#  endif
#
#endif