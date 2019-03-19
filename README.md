# basic_project

Welcome to `basic_project`!
This is a quick way for you to set up a project using Conan, CMake, clang-tidy, and continuous
integration, complete with a tutorial.

Please see the [project wiki][basic-project-wiki] for documentation.

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
├── config
|   ├── hooks
|   ├── conan
|   |   ├── profiles
├── include
├── source
└── test
    ├── integration
    └── unit
```

[basic-project-wiki]: https://github.com/cjdb/basic_project/wiki
