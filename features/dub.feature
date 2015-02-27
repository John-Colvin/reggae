Feature: Dub integration
  As a user of both dub and reggae
  I want to import the dub targets into the reggae description
  So that I can build my dub projects with reggae

  Background:
    Given a file named "dub_proj/dub.json" with:
      """
      {
        "name": "atest",
        "targetType": "executable",
        "dflags": ["-g", "-debug"],
        "importPaths": ["imps"],
        "stringImportPaths": ["stringies"],
        "dependencies": {"cerealed": ">=0.5.2"}
      }

      """

    And a file named "dub_proj/source/main.d" with:
      """
      import strings;
      import cerealed;
      import std.stdio;
      void main(string[] args) {
          writeln(import(`banner.txt`));
          auto enc = Cerealiser();
          enc ~= 4;
          writeln(enc.bytes);
          writeln(string1);
      }
      """

    And a file named "dub_proj/stringies/banner.txt" with:
      """
      Why hello!
      """

    And a file named "dub_proj/imps/strings.d" with:
      """
      enum string1 = `I'm immortal!`;
      """

    Scenario: Dub/Reggae build with Ninja
      When I successfully run `reggae -b ninja dub_proj`
      Then the file "dub_proj/reggaefile.d" should not exist
      And a file named "reggaefile.d" should exist
      Given I successfully run `ninja`
      When I successfully run `./atest`
      Then the output should contain:
        """
        Why hello!
        [0, 0, 0, 4]
        I'm immortal!
        """

    Scenario: Dub/Reggae build with Make
      When I successfully run `reggae -b make dub_proj`
      Then the file "dub_proj/reggaefile.d" should not exist
      And a file named "reggaefile.d" should exist
      Given I successfully run `make`
      When I successfully run `./atest`
      Then the output should contain:
        """
        Why hello!
        [0, 0, 0, 4]
        I'm immortal!
        """