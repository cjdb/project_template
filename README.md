# basic_project

Welcome to `basic_project`!
This is a quick way for you to set up a project using Conan, CMake, clang-tidy, and continuous
integration, complete with a tutorial.

## Prerequisites

`basic_project` expects that you have the following software installed. Note that the versions
supplied are the _minimum_ required versions: if you are running something later, then please keep
doing so!

* Conan 1.12.3
* CMake 3.13
* At least one of:
   * GCC 8
   * Clang 7
   * MSVC 2017
* clang-tidy-7
* clang-format-7

## Getting started

To build the demo, run the following script in either a Unix shell environment or a Microsoft
PowerShell environment.

```bash
git clone git@github.com:cjdb/basic_project.git                                      && \
cd basic_project                                                                     && \
mkdir -p build/debug                                                                 && \
cd build/debug                                                                       && \
conan config install ../../conan/profile                                             && \
export PROFILE=clang                                                                 && \
conan install ../.. --profile=${PROFILE} --settings build_type=Debug --build missing && \
conan build ../.. --configure --build                                                && \
ctest -j $(nproc) --output-on-failure                                                && \
echo "All tests passed!"
```

All going well, you should see the project output `"All tests passed!"`. This means that the project
built and ran successfully.

### Breaking it down

Let's break down the above script.

#### Obtaining the project

```bash
git clone git@github.com:cjdb/basic_project.git
cd basic_project
```

This section of the script clones the repository and gets you into the project directory.

#### Pre-configuration

```bash
mkdir -p build/debug
cd build/debug
conan config install ../../conan/profile
```

This section of the script sets up a directory for building the project in _Debug_ mode, and then
installs the necessary Conan profiles.

#### Project installation

```bash
export PROFILE=clang
conan install ../.. --profile=${PROFILE} --settings build_type=Debug --build missing
```

Here, we inform our tools that we'd like to compile using `clang` in _Debug_ mode. If there are any
dependencies that are missing, then we'll build those.

If you need to build with GCC, then you can change `PROFILE` to `export PROFILE=gcc`.

#### Configuring and building the project

```bash
conan build ../.. --configure --build
```

This generates the necessary build script files and then actually builds the project.

#### Testing the project

```bash
ctest -j $(nproc) --output-on-failure
```

Runs the project's tests in parallel. If any of the tests fail, then the program output is printed.

## Project structure

This project is structured so that you can immediately start using it as the basis for your project,
sans a few changes.

```
basic_project
├── .git
├── .github
|   └── ISSUE_TEMPLATE
├── .vscode
├── cmake
├── conan
|   ├── config
├── config
|   ├── hooks
├── include
├── source
└── test
    ├── integration
    └── unit
```

### .git

This is where Git stores all of the necessary meta-data. It is a distinct directory from `.github`.

### .github

This is where GitHub stores its meta-data. The meta-data stored here is specific to GitHub, so if
you change from GitHub to GitLab for example, you may need to provide meta-data that is compatible
with GitLab.

#### .github/ISSUE_TEMPLATE

TODO

### .vscode

TODO

### cmake

TODO

### conan

TODO

#### conan/config

TODO

### config

TODO

#### config/hooks

TODO

### include

TODO

### source

TODO

### test

TODO

#### test/integration

TODO

#### test/unit

TODO
