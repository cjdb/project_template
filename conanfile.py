#
#  Copyright 2019 Christopher Di Bella
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
from conans import ConanFile, CMake, RunEnvironment, tools
import os


class Project_name(ConanFile):
    name = "basic_project"
    description = "A project starter for C++ projects."
    license = "Apache License, Version 2.0"
    version = "1.0"
    settings = "os", "compiler", "arch", "build_type"
    generators = "cmake", "cmake_paths", "virtualrunenv"
    requires = "range-v3/v1.0-beta@cjdb/beta", "doctest/2.2.0@bincrafters/stable", "boost/1.69.0@conan/stable"
    exports_sources = ".clang*", "cmake/*", "CMakeLists.txt", "include/*", "source/*", "test/*", "LICENSE.md"
    build_policy = "missing"
    no_copy_source = True

    def build(self):
        cmake = CMake(self)

        cmake.configure()
        cmake.build()

        env_build = RunEnvironment(self)
        with tools.environment_append(env_build.vars):
            if self.should_test:
                self.run("ctest -j %s --output-on-failure" % tools.cpu_count())

    def package(self):
        cmake = CMake(self)

        cmake.definitions["BUILD_TESTING"] = "OFF"
        cmake.configure()
        cmake.install()
        self.copy("LICENSE.md", dst="licenses", ignore_case=True, keep_path=False)

    def package_info(self):
        self.env_info.PATH.append(os.path.join(self.package_folder, "bin"))