# Amalgamate
[![GitHub Actions Continuous Integration Status][GH-actions-CI-build-status-img]][GH-actions-CI-build-status]
[![a][GH-release-img]][GH-release]
[![a][GH-release-dl-img]][GH-release]

[GH-actions-CI-build-status-img]: https://img.shields.io/github/actions/workflow/status/rindeal/Amalgamate/CI.yml?branch=master&event=push&style=flat&logo=github&logoColor=white&label=CI&labelColor=%232d2d2d&cacheSeconds=3600
[GH-release-img]: https://img.shields.io/github/v/release/rindeal/Amalgamate?sort=semver&filter=amalgamate%20v*.*.*&display_name=release&style=flat&logo=github&labelColor=2d2d2d&cacheSeconds=3600
[GH-release-dl-img]: https://img.shields.io/github/downloads/rindeal/Amalgamate/total?style=flat&logo=github&labelColor=2d2d2d&cacheSeconds=3600

A cross platform CLI tool for producing an amalgamation of C/C++ sources.

## What is an amalgamation?

An amalgamation is an alternate way to distribute a library's source code using
only a few files (as low as one or two). This tool produces an amalgamation by
inlining included files to create one or more large source or header files.

## How is this useful?

For libraries which are mature (i.e. do not change often) the amalgamated
distribution format is often both easier to integrate, and update. The
amalgmation is added as an additional source file to an existing project
rather than needing to be built separately by build tools. Here are some
examples of source code libraries that have been amalgamated:

Best known real-world example is the [SQLite project][SQLite], which uses amalgamation
to concatenate over 130 source files into a single `sqlite3.c` file, making it
trivial for their downstream users to incorporate the library into their projects.

## How to build

Prebuilt binaries are available in [:arrow_down: the release page :arrow_down:][GH-release].
Currently for following platforms:
- Linux x86_64
- MacOS x86_64 / ARM64
- Windows x86_64

If you want to build it from the source code, see below :point_down::

<details>
  <summary><b>Click here</b> to show/hide section</summary>
  <br>

Download and unpack one of `*-source-code.{zip,tar.gz}` archives from [the latest release][GH-release].
<br> You can use the following snippet to do that automatically:

```bash
#!/bin/bash
(
  repo="rindeal/Amalgamate"
  asset_filter='[^"]*-source-code.tar.gz'
  tag=$(basename "$(curl -Lso /dev/null -w "%{url_effective}" https://github.com/${repo}/releases/latest)")
  hrefrel=$(curl -Ls "https://github.com/${repo}/releases/expanded_assets/${tag}" | grep -oEm1 '[^"]*/releases/download/'"${asset_filter}")
  curl -Lo - "https://github.com${hrefrel}" | tar -xzf -
)
cd amalgamate-*-source-code
```

Or clone this repository including submodules.

```sh
git clone --depth=1 --recurse-submodules --shallow-submodules https://github.com/rindeal/Amalgamate.git
cd Amalgamate
```

> NOTE: Snapshot archives or simple clones are not enough.

#### Linux or MacOS

Requirements:
- `c++`
- `make`

Build commands:
```sh
make
```

#### Windows

Requirements:
- `cl.exe` courtesy of [MSVC]

Build commands:
```sh
./build.bat
```

</details>

## Usage

```sh
./amalgamate INPUT.h OUTPUT.h
./amalgamate -w "include/*.h" OUTPUT.h
```

<details>
  <summary><b>Click here</b> to show/hide section</summary>
  <br >
  
```plain
  NAME

   amalgamate - produce an amalgamation of C/C++ source files.

  SYNOPSIS

   amalgamate [-s]
     [-w {wildcards}]
     [-f {file|macro}]...
     [-p {file|macro}]...
     [-d {name}={file}]...
     [-i {dir}]...
     {inputFile} {outputFile}

  DESCRIPTION

   Produces an amalgamation of {inputFile} by replacing #include statements with
   the contents of the file they refer to. This replacement will only occur if
   the file was located in the same directory, or one of the additional include
   paths added with the -i option.

   Files included in angle brackets (system includes) are only inlined if the
   -s option is specified.

   If an #include line contains a macro instead of a string literal, the list
   of definitions provided through the -d option is consulted to convert the
   macro into a string.

   A file will only be inlined once, with subsequent #include lines for the same
   file silently ignored, unless the -f option is specified for the file.

  OPTIONS

    -s                Process #include lines containing angle brackets (i.e.
                      system includes). Normally these are not inlined.

    -w {wildcards}    Specify a comma separated list of file name patterns to
                      match when deciding to inline (assuming the file can be
                      located). The default setting is "*.cpp;*.c;*.h;*.mm;*.m".

    -f {file|macro}   Force reinclusion of the specified file or macro on
                      all appearances in #include lines.

    -p {file|macro}   Prevent reinclusion of the specified file or macro on
                      subsequent appearances in #include lines.

    -d {name}={file}  Use {file} for macro {name} if it appears in an #include
                      line.

    -i {dir}          Additionally look in the specified directory for files when
                      processing #include lines.

    -v                Verbose output mode
```

</details>

## License

Copyright (C)  2012       _[Vinnie Falco]_<br>
Copyright (C)  2016-2024  _Jan Chren_<br>
Amalgamate is provided under the terms of the [MIT] license.<br>
Amalgamate embeds `juce_core` module of [JUCE], licensed separately under [ISC] license.

[SQLite]: https://sqlite.org/amalgamation.html "The SQLite Amalgamation"
[MSVC]: https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170 "How to use the Microsoft C++ toolset from the command line"
[JUCE]: https://rawmaterialsoftware.com/juce.php "JUCE"
[Vinnie Falco]: https://vinniefalco.com "Vinnie Falco's Home Page"
[MIT]: https://spdx.org/licenses/MIT.html "MIT License"
[ISC]: https://spdx.org/licenses/ISC.html "ISC License"
[GH-release]: https://github.com/rindeal/Amalgamate/releases/latest "GitHub Releases"
[GH-actions-CI-build-status]: https://github.com/rindeal/Amalgamate/actions/workflows/CI.yml "GitHub Actions Continuous Integration Status"

[![GitHub Actions Continuous Integration Status](https://github.com/rindeal/Amalgamate/actions/workflows/CI.yml/badge.svg?branch=master&event=push)][GH-actions-CI-build-status]
