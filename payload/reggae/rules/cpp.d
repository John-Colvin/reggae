/**
High-level rules for compiling C++ files
 */

module reggae.rules.cpp;

import reggae.types;
import reggae.build;
import reggae.rules.common;
import std.algorithm;


Target cppCompile(in string srcFileName, in string flags = "",
                  in string[] includePaths = []) @safe pure nothrow {
    immutable includes = includePaths.map!(a => "-I$project/" ~ a).join(",");
    return Target(srcFileName.objFileName, "_cppcompile includes=" ~ includes ~ " flags=" ~ flags,
                  [Target(srcFileName)]);
}


/**
 * Compile-time function to that returns a list of Target objects
 * corresponding to C++ source files from a particular directory
 */
Target[] cppObjects(SrcDirs dirs = SrcDirs(),
                    Flags flags = Flags(),
                    ImportPaths includes = ImportPaths(),
                    SrcFiles srcFiles = SrcFiles(),
                    ExcludeFiles excludeFiles = ExcludeFiles())
    () {

    Target[] cppCompileInner(in string[] files) {
        return files.map!(a => cppCompile(a, flags.value, includes.value)).array;
    }

    return srcObjects!cppCompileInner("cpp", dirs.value, srcFiles.value, excludeFiles.value);
}