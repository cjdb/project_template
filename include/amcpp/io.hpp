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
#ifndef AMCPP_IO_HPP
#define AMCPP_IO_HPP

#include <algorithm>
#include <fstream>
#include <iterator>
#include <iosfwd>
#include <stdexcept>
#include <string>

namespace amcpp {
   template <typename T>
   inline char* as_bytes(T& t) noexcept
   {
      void* p = &t;
      return static_cast<char*>(p);
   }

   template <typename T>
   inline const char* as_bytes(const T& t) noexcept
   {
      const void* p = &t;
      return static_cast<const char*>(p);
   }

   inline std::ostream& write(std::ostream& o, const std::string& s)
   {
      o.write(as_bytes(s.size()), sizeof(s.size()));
      return o.write(s.data(), static_cast<std::streamsize>(s.size()));
   }

   inline std::istream& discard_ws(std::istream& in)
   {
      while (in && isspace(in.peek()))
         in.get();
      return in;
   }

   inline std::istream& read(std::istream& in, std::string& s)
   {
      {
         auto size = decltype(s.size()){};
         if (in.read(as_bytes(size), sizeof(size))) {
            s = std::string(size, '\0');
            in.read(&s[0], static_cast<std::streamsize>(size));
         }
      }

      return in;
   }

   template <typename T, std::enable_if_t<std::is_constructible<T, std::istream&, std::ios_base::openmode>::value, int>>
   inline T from_file(const std::string& path,
      const std::ios_base::openmode open = std::ios_base::in)
   {
      if (auto in = std::ifstream{path, open})
         return {in, open};
      else
         throw std::ios_base::failure{"Could not open file \"" + path + '"'};
   }

   template <typename Rng,
      std::enable_if_t<std::is_constructible<typename Rng::value_type, std::istream&, std::ios_base::openmode>::value, int>>
   inline void from_file(Rng& rng, const std::string& path,
      const std::ios_base::openmode open = std::ios_base::in)
   {
      if (auto in = std::ifstream{path, open}) {
         auto r = transform(begin(rng), end(rng), begin(rng), [&in, &open](const auto&) {
               return typename Rng::value_type{in, open};
            });

         if (r.in() != r.out())
            throw std::logic_error{"file input did not copy as expected"};
      }
      else {
         throw std::ios_base::failure{"Could not open file \"" + path + '"'};
      }
   }

   template <typename Rng, typename I = std::istream_iterator<typename Rng::value_type>>
   inline Rng from_file(const std::string& path)
   {
      if (auto in = std::ifstream{path}) {
         in >> std::noskipws;
         return {I{in}, I{}};
      }
      throw std::ios_base::failure{"Could not open file \"" + path + '"'};
   }

   template <typename T>
   inline void to_file(const T& t, const std::string& path,
      const std::ios_base::openmode open = std::ios_base::out)
   {
      if (auto o = std::ofstream{path, open})
         open & std::ios_base::binary ? write(o, t) : o << t;
      else
         throw std::ios_base::failure{"Could not open file \"" + path + '"'};
   }
} // namespace amcpp

#endif // AMCPP_IO_HPP
