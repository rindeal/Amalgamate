project(
    'amalgamate',
    'cpp',
    default_options : [
        'cpp_std=c++17',
        'warning_level=2',
        'optimization=2',
        'buildtype=release',
        'default_library=static',
    ],
)
if host_machine.system() == 'darwin'
    add_languages('objcpp', required: true)
endif

executable_name = meson.project_name()
manpage_name = executable_name + '.1'

cpp_compiler = meson.get_compiler('cpp')

doc_files = [
    'README.md',
    'LICENSE',
]

juce_core_dir_str = '3rd/JUCE/modules/juce_core'
juce_core_inc = include_directories(juce_core_dir_str)

juce_core_sources = []
if host_machine.system() == 'darwin'
    juce_core_sources += files(juce_core_dir_str / 'juce_core.mm')
else
    juce_core_sources += files(juce_core_dir_str / 'juce_core.cpp')
endif

juce_core_cpp_args = [
  '-DJUCE_APP_CONFIG_HEADER="AppConfig.h"',
]
if get_option('buildtype') == 'debug'
    juce_core_cpp_args += [ '-DJUCE_DEBUG=1', '-DDEBUG=1', ]
else
    juce_core_cpp_args += [ '-DNDEBUG=1', ]
endif

executable_sources = files('Amalgamate.cpp')

executable_cpp_args = [
    '-pthread',
]

executable_link_args = [
  '-pthread',
]
if host_machine.system() == 'darwin'
    executable_link_args += [
        '-framework', 'Foundation',
        '-framework', 'AppKit',
        '-framework', 'CoreServices',
        '-framework', 'IOKit',
        '-framework', 'Security',
    ]
endif

executable_dependencies = []
if host_machine.system() == 'linux' or host_machine.system() == 'darwin'
    executable_dependencies += [
      cpp_compiler.find_library('dl'),
    ]
elif host_machine.system() == 'windows'
    executable_dependencies += [
      cpp_compiler.find_library('Shlwapi'),
      cpp_compiler.find_library('Version'),
      cpp_compiler.find_library('Winmm'),
      cpp_compiler.find_library('Ws2_32'),
      cpp_compiler.find_library('Wininet'),
    ]
endif

#########################

executable(
    executable_name,
    executable_sources + juce_core_sources,
    include_directories : [
        juce_core_inc,
        '.',
    ],
    cpp_args : juce_core_cpp_args + executable_cpp_args,
    objcpp_args : juce_core_cpp_args + executable_cpp_args,
    link_args : executable_link_args,
    dependencies : executable_dependencies,
    install: true,
)

# Install man page
install_man(
    manpage_name,
    install_dir : get_option('mandir'),
)

# Install documentation
install_data(
    doc_files,
    install_dir : get_option('datadir') / 'doc' / meson.project_name(),
)

# Create a GitHub release asset
if get_option('create-github-release')
    current_os = host_machine.system()
    current_arch = host_machine.cpu_family()
    asset_basename = f'{executable_name}-{current_os}-{current_arch}'

    custom_target(
        'github_release_asset',
        command : [
            'zip', '-r', '@OUTPUT@', '@DEPFILE@',
        ],
        output : f'{asset_basename}.zip',
        input : [
            executable_name,
            manpage_name,
        ] + doc_files,
        install : true,
        install_dir : get_option('prefix'),
    )
endif