# basic_project

Welcome to `basic_project`!

This is a very quick way for you to set up a project using CMake, complete with a tutorial.

The code used is derived from my course "Applied Modern C++ -- Exploring the Standard Library".

## Prerequisites

`basic_project` assumes that you have CMake 3.4.3 or later. Your compiler must support C++14, as
well as a few flags. GCC 4.9 or later should do, and the equivalent version of Clang is probably
also okay (but I am yet to try it out).

The code compiles using GCC 4.9.3.

## Getting started

To build the demo, simply execute the following:

```bash
git clone https://github.com/cjdb/basic_project.git
cd basic_project
git remote rename origin cjdb
git remote add origin <your repository url here>
mkdir -p build/debug
cd build/debug
cmake -DCMAKE_CXX_COMPILER=`which <your compiler here>` -DCMAKE_BUILD_TYPE=Debug ../..
make && make test
```

All going well, you should see some output that resembles the following:

```
cjdb: make && make test
Running tests...
Test project /mnt/c/Users/cjdbn/projects/basic_project/bin
    Start 1: test.demo.hello
1/2 Test #1: test.demo.hello ..................   Passed    0.02 sec
    Start 2: test.demo.employee
2/2 Test #2: test.demo.employee ...............   Passed    0.03 sec

100% tests passed, 0 tests failed out of 2

Total Test time (real) =   0.06 sec
```

This indicates a successful build and test.

## Project structure

The project is very simply structured.

* `include` is where your headers go. If you wish to locally install a header for a library, put it
   in this directory. For example, if you wish to install
   [range-v3](https://github.com/ericniebler/range-v3.git), the directory would be `include/range`.
* `source` is where your source files go. We'll study `source` a bit more below.
* `test` is where you place your tests. We'll also look at `test` separately.

## `source`

This is where you place your source files. If you examine the current makeup of the directory:

```bash
cjdb: ls source
CMakeLists.txt  demo
```

Here, you see a file, `CMakeLists.txt`. This is a file that helps make up the build system that
CMake uses. The primary `CMakeLists.txt` is in the root directory, but you probably won't need to
modify that without learning more about CMake, so we'll start with this sub-`CMakeLists.txt`.

```bash
cjdb: cat source/CMakeLists.txt
add_subdirectory(demo)

add_library(demo STATIC $<TARGET_OBJECTS:demo.employee>)
```

The first line tells CMake to start building the contents of the subdirectory `source/demo`. We'll
look at that next. The second line says to build a static library called `demo` from an object
named `demo.employee`.

### `source/demo`

```bash
cjdb: ls source/demo
CMakeLists.txt  employee.cpp  hello.cpp
```

Here, we see two C++ source files, and another `CMakeLists.txt`.

```bash
cjdb: cat source/demo/CMakeLists.txt
add_executable(demo.hello hello.cpp)
add_test(test.demo.hello demo.hello)

add_library(demo.employee OBJECT employee.cpp)
```

The first line tells CMake that we want to create a program named `demo.hello` from the file
`hello.cpp`. The second line tells CMake that when we run `make test`, we ought to run `demo.hello`
under the alias of `test.demo.hello`. Since CMake tests only fail when `main` returns a nonzero
number, this test will always pass.

The third line says that we should compile `employee.cpp` as an object file, but it shouldn't be an
executable. This is what we add to the static library `demo`. If you're writing library code or an
assignment for a training course, you'll probably use `add_library` in your
`source/foo/CMakeLists.txt`.

## `test`

```bash
cjdb: ls test
australian_scientists.txt  CMakeLists.txt  employee.cpp
```

Another `CMakeLists.txt`, a C++ source file, and an input file.

```bash
cjdb: cat test/CMakeLists.txt
file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/australian_scientists.txt" in)
file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/output" out)

add_executable(test.employee employee.cpp)
target_link_libraries(test.employee demo)
add_test(NAME test.demo.employee
   COMMAND ${BASH} -c "$<TARGET_FILE:test.employee> < ${in} > ${out}")
```

This one has quite a fair amount of juice to it.

`file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/australian_scientists.txt" in)` creates a
variable named `in`, which we'll use to refer to the input we feed our program from standard input.

`file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/output" out)` creates an output variable so that
CMake can write the file `output` to `test/output`.

`target_link_libraries(test.employee demo)` takes the `demo` library we made in `source`, and links
it against our new executable, `test.employee`.

Our `add_test` is a bit more involved this time. Because we're reading from the character input,
and writing to the character output, we need to do something that's a bit more involved. We
explicitly name our test `test.demo.employee`, and then invoke a bash command. When writing tests
for libraries or assignments, you'll be wanting to do these last three lines.

### `test/employee.cpp`

```cpp
// basic_project -- a simple startup project
//
//  Copyright Christopher Di Bella 2017 -- Present
//
//  Use, modification and distribution is subject to the
//  Boost Software License, Version 1.0. (See accompanying
//  file LICENSE_1_0.txt or copy at
//  http://www.boost.org/LICENSE_1_0.txt)
//
// Project home: https://github.com/cjdb/basic_project.git
//
#include <algorithm>
#include "amcpp/employee.hpp"
#include "amcpp/simple_test.hpp"
#include <iostream>
#include <iterator>
#include <vector>

using amcpp::Employee;

int main()
{
   auto v = std::vector<Employee>{std::istream_iterator<Employee>{std::cin},
      std::istream_iterator<Employee>{}};

   CHECK(v.size() == 10u);

   v.emplace_back("Smith", "John", 123'456.00);
   CHECK(v.size() == 11u);

   std::sort(std::begin(v), std::end(v), [](const auto& a, const auto& b) {
         return a.salary() < b.salary(); });

   CHECK(std::lower_bound(std::begin(v), std::end(v), "Zac", [](const auto& a, const auto& b) {
      return a.given_name() < b; }) == std::end(v));

   return ::test_result();
}
```

For the purposes of this discussion, most of the code above is noise. The only relevant lines are
the ones with `CHECK` and `return ::test_result();`.

Both the `CHECK` macro (identified as a macro because its name is in `ALL_CAPS`) and the
`test_result` function are found in `include/amcpp/simple_test.hpp`. I advise against reading that
file if you're new to C++.

`CHECK` will give you a soft assertion: the test fails, but the program doesn't crash on failure.
This gives you the opportunity to know _all_ of the tests that fail on each run, rather than
discovering just one at a time. You can always replace `CHECK` with `assert` if you want a simpler
model.

`test_result` will just return the number of `CHECK`s that have failed. Recall that CMake considers
a nonzero return value from `main` to be a failure, as well as an abnormal exit.

## Debug and release builds

Our initial setup tells CMake to build `basic_project` in debug mode. This means that you can run a debugger
(e.g GDB), and write assertions. However, this isn't the build line that your programs should
be running with in production, and I find it doubtful that a course will test with the debug build.
To build for a release, you'll need to do this from the root directory:

```bash
mkdir -p build/releass
cd build/release
cmake -DCMAKE_CXX_COMPILER=`which compiler` -DCMAKE_BUILD_TYPE=Release ../.. 
make && make test
```

If you wish to dictate your sanitizers, you can add the flag `-DSANITIZER="your sanitizer options here"`.
Add this to either a debug or release CMake line.

## Conclusion

That's it! You're done! :)

If you have any queries, please lodge them as issues in the GitHub Issues page. You're also welcome
to make pull requests, if you think the system can be improved.
