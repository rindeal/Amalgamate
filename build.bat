@echo off

cl ^
  /EHsc /nologo ^
  /I3rd\JUCE\modules\juce_core /I.\ ^
  /D"JUCE_APP_CONFIG_HEADER=""AppConfig.h""" ^
  Amalgamate.cpp 3rd\JUCE\modules\juce_core\juce_core.cpp ^
  /Fe:amalgamate ^
  /link ole32.lib Shell32.lib

del *.obj
