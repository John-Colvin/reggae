Feature: C++ compilation rule
  As a reggae user
  I want to have reggae determine the implicit dependencies when compiling a single C++ file
  So that I don't have to specify the dependencies myself

  Scenario: Mixing C++ and D files
    Given a file named "mixproj/src/d/main.d" with:
      """
      extern(C++) int calc(int i);
      import std.stdio;
      import std.conv;
      void main(string[] args) {
          immutable number = args[1].to!int;
          immutable result = calc(number);
          writeln(`The result of calc(`, number, `) is `, result);
      }
      """

    And a file named "mixproj/src/cpp/maths.cpp" with:
      """
      #include "maths.hpp"
      int calc(int i) {
          return i * factor;
      }
      """
    And a file named "mixproj/headers/maths.hpp" with:
      """
      const int factor = 3;
      """
    And a file named "mixproj/reggaefile.d" with:
      """
      import reggae;
      Build bb;
      shared static this() {
        const mainObj  = dcompile(`src/d/main.d`);
        const mathsObj = cppcompile(`src/cpp/maths.cpp`, [`headers`]);
        bb = Build(Target(`calc`, `dmd -of$out $in`, [mainObj, mathsObj]));
      }
      """
    When I successfully run `reggae -b ninja mixproj`
    And I successfully run `ninja`
    And I successfully run `./calc 5`
    Then the output should contain:
      """
      The result of calc(5) is 15
      """
    Given a file named "mixproj/headers/maths.hpp" with:
      """
      const int factor = 10;
      """
    And I successfully run `touch mixproj/headers/maths.hpp`
    And I successfully run `touch mixproj/headers/maths.hpp`
    And I successfully run `touch mixproj/headers/maths.hpp`
    And I successfully run `touch mixproj/headers/maths.hpp`
    And I successfully run `ninja`
    And I successfully run `./calc 3`
    Then the output should contain:
      """
      The result of calc(3) is 30
      """