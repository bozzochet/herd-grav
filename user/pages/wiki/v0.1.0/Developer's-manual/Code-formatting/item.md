---
title: 'HERD Wiki - Version 0.1.0'
body_classes: 'header-dark header-transparent'
hero_classes: 'text-light title-h1h1 overlay-dark-gradient hero-tiny'
hero_image: mountain_short.jpg
header_image_height: 10
item_type: 'wiki'
show_sidebar: true
sidebar_root: wiki/v0.1.0
hero_noarrow: true
process:
    markdown: true
    twig: false
twig_first: false
---

**Guideline**: it is required to format all the C++ files with `clang-format` before committing them to the HerdSoftware repository:

```bash
clang-format -i file.cpp
```

---

Code style is not a mere question of personal taste. Indenting with two or four spaces, breaking a long line in two lines or three, and other similar "aesthetic" issues can turn into real issues when different conventions coming from different developers are mixed. This is best understood by means of an example; then, after convincing ourselves that a common code style is indeed desirable, a tool for enforcing it, called `clang-format`, is introduced.


# Inspecting code modifications with git
Git provides a very nice tool to inspect the modifications introduced in a source file: `git diff`. With this command a developer can e.g. compare the modifications introduced in a given file by a commit with respect to a previous commit. For example, let's assume that we have committed this C++ file:

```c++
#include <iostream>
class MyClass {
  MyClass(int a) : _a(a) { std::cout << "This is MyCLass constructor. Hope you're having a great day!" << std::endl; }

  int AValue() { return _a; }

private:
  int _a;
};
```

Now, another developer makes some modifications to it:

```c++
#include <iostream>
class MyClass {
  MyClass(int a) : _a(a) { std::cout << "This is MyCLass constructor. Hope you're having a great day!" << std::endl; }

  int AValue() { return _a; }
  int TwiceA() { return 2 * _a; }

private:
  int _a;
  float _unused;
};

```

Using `git diff` it is possible to have a nice resume of the modifications:

```diff
diff --git a/test/file.cpp b/test/file.cpp
index 7cf8de6..a0a7740 100644
--- a/test/file.cpp
+++ b/test/file.cpp
@@ -3,7 +3,9 @@ class MyClass {
   MyClass(int a) : _a(a) { std::cout << "This is MyCLass constructor. Hope you're having a great day!" << std::endl; }
 
   int AValue() { return _a; }
+  int TwiceA() { return 2 * _a; }
 
 private:
   int _a;
+  float _unused;
 };

```

Two lines (those beginning with `+`) have been introduced. Clear and simple.

# Introduce code style variations

Suppose now that the second developer decided to also adapt the code to its personal style, other than introducing the relevant modifications he wanted to introduce. He could end up with committing this version of the modified file:

```c++
#include <iostream>

class MyClass {
  
  MyClass(int a) : 
    _a(a)
  {
    std::cout << "This is MyCLass constructor. Hope you're having a great day!" << std::endl;
  }

  int AValue() 
  { 
    return _a; 
  }
  int TwiceA() 
  { 
    return 2 * _a; 
  }

private:
  int _a; float _unused;
};

```

which is equivalent to the modified code presented in the previous section from the point of view of code functionality. But now the developer that wants to inspect the chanegs with the help of `git diff` obtains:

```diff
diff --git a/test/file.cpp b/test/file.cpp
index 7cf8de6..39b41fc 100644
--- a/test/file.cpp
+++ b/test/file.cpp
@@ -1,9 +1,22 @@
 #include <iostream>
+
 class MyClass {
-  MyClass(int a) : _a(a) { std::cout << "This is MyCLass constructor. Hope you're having a great day!" << std::endl; }
 
-  int AValue() { return _a; }
+  MyClass(int a) :
+    _a(a)
+  {
+    std::cout << "This is MyCLass constructor. Hope you're having a great day!" << std::endl;
+  }
+
+  int AValue()
+  {
+    return _a;
+  }
+  int TwiceA()
+  {
+    return 2 * _a;
+  }
 
 private:
-  int _a;
+  int _a; float _unused;
 };
```

According to git we have now a massive amount of new lines and also some removed lines (the ones beginning with `-`). This is correct since the developer actually introduced new code lines by refactoring the existing code according to its style, and this makes it very hard to identify the real changes that truly introduce new code or remove old code. This can clearly be avoided by adopting a common code style.

# Formatting the code with clang-format

Writing code that respects a given style is very hard since one may not be aware of all the conventions, or simply forget to comply to some. Fortunately, there are tools that modify source code files in order to make them compliant to a given style. The chosen code formatting tool for HerdSoftware is `clang-format`: it is a very popular command-line tool that can be easily installed on Linux distributions and OSX, which can also be integrated in IDEs (like Eclipse) and code editors.

To format a code file (call it `file.cpp` in this example) with `clang-format`, simply launch the command:

```bash
clang-format -i file.cpp
```

By default, `clang-format` looks for the definition of the code style in a file called `.clang-format`, searching for it in the current folder; if `clang-format` doesn't find the file then it searches in the parent folder, and so on up to the root of the file system. The `.clang-format` style file for HerdSoftware is located in the top folder so that any C++ file in any subfolder can be formatted according to it using the command above.

# Automatic reminder for code formatting

To help in remembering to format the code, HerdSoftware automatically prints a warning whenever the developer is about to commit badly formatted code:

<img src="../uploads/28ff92c82eb0eb248bd9f3ed55c45cbd/AutoFormat.png" width="720"> 

The developer can either choose to automatically format the code, ignore and commit anyway or cancel the commit. The second option should be avoided except in special cases; the safest option is to cancel the commit, format manually with `clang-format`, compile and then try again to commit (because clang-format might change the order of included headers and this might introduce errors in compilation, so better check before committing).

The automatic reminder is an optional feature that  requires `clang-format` to be present in the system. On most Linux systems it can be installed with the package manager; on CentOS 7 it is available with the `llvm-toolset-7.0` package, that can be installed with:  
```bash
yum install llvm-toolset-7.0
```
and enabled by adding the line:  
```bash
source scl_source enable llvm-toolset-7.0
```
to your `.bashrc` file.

To disable the automatic code indentation reminder (not recommended), run cmake with the `-DDISABLE_AUTOFORMAT=1`
command line option.
