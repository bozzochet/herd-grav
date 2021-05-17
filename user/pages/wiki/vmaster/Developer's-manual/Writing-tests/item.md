---
title: 'HERD Wiki - Version master'
body_classes: 'header-dark header-transparent'
hero_classes: 'text-light title-h1h1 overlay-dark-gradient hero-tiny'
hero_image: mountain_short.jpg
header_image_height: 10
item_type: 'wiki'
show_sidebar: true
sidebar_root: wiki/vmaster
hero_noarrow: true
process:
    markdown: true
    twig: false
twig_first: false
---

[[_TOC_]]

**Guideline**: write tests for your software.  
* Write unit tests for your class at least for the most common use cases
* Try to keep coverage high

---

Tests are an essential components of HerdSoftware, to ensure quality and correctness. A "test" can be grossly defined as an executable program that runs a piece of code using well defined input parameters which, if the code is correctly implemented, will produce a known "correct" output; it then checks the actual output against the known correct one and if they differ it warns the user. A systematic approach to writing and executing tests is mandatory, since both can be tedious and thus perceived as roadblocks during code development. The best way to avoid this is to convince the developers that in reality tests can _boost_ code development and also make them _feel better_ about the code they produce.

* Actually, tests can be of great help even in speeding up code development:
  * a set of tests might provide a quick benchmark to try the code as it's being developed; without dedicated tests, an alternative is to run the final program where the new component is being integrated. But this program can potentially be very slow (since it could perform also many tasks not directly related to the new code)
  * tests can help in spotting bugs early in the development cycle, reducing the time needed for bug finding and fixing after the code release

* Moreover, all the developers test their code to some extent, for example by manually checking that the output of an executable making use of their new code is correct. At first sight this might appear to be faster than writing additional test code; however the output check procedure can become lengthy when the output is complex, thus requiring much more time than writing a dedicated test code that does this check automatically. This is true especially when the tests have to be repeated many times (which, in fact, always happens). 

* Finally, anyone gets tired of repeatedly checking a complicate output in search of bugs. Without a dedicated test program that automates the checks and makes testing easy and quick, the developer will inevitably stop to check the code at some time during the development, or will start to do it sloppily. And will inevitably be less confident about his half-tested modifications, and bugs probably will start to flow in undetected. A good test program that continuously reassures him/her that he/she didn't break anything while modifying some code portion, or that promptly signals a breakage, will instead help also from a "psychological" point of view. And the larger the extension of the tests, the better.

All in all, writing tests typically does not require a sizeable amount of additional time, and surely improves the code quality (and to some extent also the mood of developers).

HerdSoftware developers are encouraged to write tests together with (or even [before](https://en.wikipedia.org/wiki/Test-driven_development)) the new code. The "I'll write the tests later" approach inevitably leads to the "No tests, sorry" state, which especially for crucial components is not acceptable.

# Unit tests
A [unit test](https://en.wikipedia.org/wiki/Unit_testing) is a test involving a minimal portion of code: its meaning is to test that code in isolation from other components and check for bugs related to its internal behevior. In object oriented programming the typical portion of code that is unit-tested is a class.
Roughly speaking, a unit test of a class is conducted more or less as follows:
* an instance of the class being tested is created using a given set of initialization parameters
* the methods of the public interface are called using argument values that, if the implementation is correct, will produce known results
* actual results (i.e. return values or exceptions being thrown or not) are checked against the expected ones
* the procedure is repeated with different values for initialization parameters and function arguments
The set of parameters and arguments that can reasonably be tested is inevitably limited; this is an unavoidable limitation of unit tests.

## Mocks
It is not unfrequent that a class A depends on another class B, either because A has a memeber of class B or because one of its methods requires an argument of class B. In this case it is not possible to unit test A in isolation from B. Typicially these tests make use of a _mock_: an object of type B built with parameters that will determine a known behavior of A. When testing polymorphic interfaces, a mock can also be a class derived from B and implementing a behavior that is suitable for testing A. 

## Unit tests and class design
When designing a new class it is a good practice to think about how it could be unit tested. Design choices that will make it hard or impossible to unit test the class (e.g. references to global ojbects, impossibility to properly initialize the instances to test a given aspect of their behavior etc.) are almost always bad choices, and will likely create issues in future. Focusing on tests early during the design phase will help to avoid these issues. 

# Integration tests
Unit tests do not cover the interaction of units between them. For this reason, [integration tests](https://en.wikipedia.org/wiki/Integration_testing) are useful to verify that each unit correctly interacts with others to produce correct results.

# System tests
More comprehensive tests are called [system tests](https://en.wikipedia.org/wiki/System_testing): the full, integrated software system is tested. For data analysis software, this might correspond to running a full analysis jobs with real or mock data.

# Tests in HerdSoftware
HerdSoftware tests are mostly unit tests. Algorithms and data providers have well-defined interfaces inherited from the base classes of EventAnalysis, and are tested typically with mock data objects. The common classes and data object classes have custom interfaces and are unit-tested for basic functionalities, since typically their implementations are quite simple.

The simulation code is not tested at the moment. Testing geometries is probably not feasible. Particle generators could instead be tested for positions, angles, energies etc.; some work on this topic is needed.

All the test code is inside the `testsuite` subfolder. 

# Testing framework
The testing in HerdSoftware is based on the [Catch2](https://github.com/catchorg/Catch2) framework. It is a very simple yet powerful testing framework which provides macros for defining test cases and checking test results. It features detailed output, also in standard machine-readable formats, and the possibility to run only select tests. It is quite simple to use: please refer to the tutorial on the GitHub page linked above or to one of the test files in HerdSoftware.

## The Catch2 workflow
Catch2 provides a single `catch.hpp` header (in HerdSoftware it is placed in 
`teststuite/include/`) with the main executable and the macros used for writing
the tests. Test code is placed in different source files, which are then compiled
in shared libraries and linked to the main test executable. All the tests in
linked libraries will be executed, so the developer writing a test does not have
to worry about calling it.

The majority of the tests in HerdSoftware are written using a BDD approach (see
[here](https://en.wikipedia.org/wiki/Behavior-driven_development) for a general
introduction ande [here](https://github.com/catchorg/Catch2/blob/devel/docs/tutorial.md#bdd-style)
for its implementation in Catch2). The intended code behavior is tested in scenarios,
each scenario grouping the tests related to a use case of a given class or component.
Inside a scenario, the tests are organized in given-when-then code blocks. To better
understand the code flow, let's suppose to have a class `MyClass` with two
constructors (the default one and another taking an unsinged int argument) and a
method `M()` which throws an exception when called for a default-initialized
object, or returns a random value between 0 and the value passed to the
non-default constructor. The unit tests for this class would look like:  

```c++
#include "catch.hpp" // Needed for using the Catch2 macros
#include "MyClass.h" // Class to be unit-tested

SCENARIO("Testing MyClass behavior", "[TestMyClass][MyTests]"){

  GIVEN("A MyClass object initialized with an integer"){
    MyClass myObject(5);
     
    WHEN("Method M is called"){
      int result;
      REQUIRE_NOTHROW(result = myObject.M());
      THEN("The returned value is greater than 0"){
        REQUIRE(result > 0);
      } 
      THEN("The returned value is less than the initialization value"){
        REQUIRE(result < 5);
      }
    }
  }
  
  GIVEN("A default-initialized MyClass object"){
    MyClass myObject;
    THEN("An exception is thrown when M is called"){
      REQUIRE_THROWS(myObject.M())
    }
  }


}

```

The `SCENARIO` block is defined with a title (first argument, must be different
for every scenario) and up to two labels (second argument, each label inside 
square brackets; in HerdSoftware unit tests, the first argument is usually the
name of the tested class, while the second is the category like `Algorithms`,
`DataObjects` etc.). The `GIVEN` block usually contains all the tests related
to a given configuration of the class to be tested and of the eventual mock
objects. In the above code, the first `GIVEN` block tests an object built with
the non-default constructor. The `WHEN` blocks (can be more than one) define
an action occuring on the object and/or mocks, like calling a method. In this
case, the execution of the `M()` method is tested by the `REQUIRE_NOTHROW` macro
which fails if during the evaluation of its argument an exception is thrown (and
the class specifications prescribe that this should not happen for a 
non-default-initialized object). Finally, the `THEN` blocks checks for the
result of the action using `REQUIRE` macros. The `REQUIRE` macro is the heart of
the test: its argument is an expresion that can be evaluated to a boolean, and
the test is passed if the result of the evaluation is `true`. In the example,
the test in the first `THEN` block is passes if the result of the invocation of
`M()` is greater than 0 (as required by the class specification).

Two considerations are worth being made at this point:

1. the above described flow is quite an ideal one; in a real case the `REQUIRE`
macros can be present also in the `GIVEN` and `WHEN` blocks when it makes
sense, and objects can be created also in `WHEN` and `THEN` blocks. The
`GIVEN`, `WHEN` and `THEN` blocks are best understood as a useful way to factor
out the common parts of a set of tests rather than strict prescriptions about
their content (indeed, `GIVEN` blocks can be nested, and so on);   
2. each single `GIVEN-WHEN-THEN` sequence is executed in isolation. This means
that as the control flow reaches the end of a `THEN` block the execution does
not proceed to the next `THEN` block inside the same `WHEN` block, but is
resumed from the beginning of the `GIVEN` block, re-doing the same `GIVEN` and
`WHEN` but skipping the already executed `THEN` and proceeding with the
subsequent `THEN`. This ensures that each possible combination of 
`GIVEN-WHEN-THEN` blocks is executed independently, thus avoiding that changes
in the internal status of the tested object triggered by one `GIVEN-WHEN-THEN`
sequence could impact on the execution of another `GIVEN-WHEN-THEN` sequence.
For the first `GIVEN` block in the example, this results in this execution flow:
    - Build `myObject` using 5 as initialization value;  
    - call `myObject.M()`  
    - check `result > 0`;  
    - destroy `myObject` (since the flow exits from the `GIVEN` block before
      re-entering in it);  
    - Build `myObject` using 5 as initialization value;  
    - call `myObject.M()`  
    - check `result < 5`;  
  In the example no side-effects are present so this execution flow is not
  particularly useful; however, in some cases it allows for avoiding cross-talk
  between different test cases.

The second `GIVEN` block tests the behavior of a default-initialized object.
With respect to the first, there's no `WHEN` block and the throw of exception
prescribed by the class specifications is tested with the `REQUIRE_THROWS` macro
inside the `THEN` block. With this macro, the test is passed if an exception
is thrown during the evaluation of the argument. 


# Running tests
Test program is built together with the other components of HerdSoftware; the test executable is named `run_tests`. It can be found in the `testsuite` subfolder of the build folder (it is not installed). A successful run of the test program looks like:

```bash
$ testsuite/run_tests 
  ****************************************************
  *             HerdSoftware v0.0                    *
  * commit: bdeaf9f35152c53d5d85f8763e5bc46a87b4f5c8 *
  * code status: dirty                               *
  ****************************************************
===============================================================================
All tests passed (9888 assertions in 21 test cases)
```

A restricted number of tests can be run by providing an appropriate tag. The list of available tags cane be obtained with the `-l` option:

```bash
$ testsuite/run_tests -l
  ****************************************************
  *             HerdSoftware v0.0                    *
  * commit: daa443fce3ee61cd512252fac34fc3882c864c97 *
  * code status: clean                               *
  ****************************************************
All available test cases:
  Scenario: Basic tests of the GGSDataProvider
      [DataProviders][GGSDataProvider]
  Scenario: Testing the GGSDataProvider against the GGS reader
      [DataProviders][GGSDataProvider]
  Scenario: HoughFinder voting space index are calculated correctly
      [Algorithms][HoughFinder]
  Scenario: Simple tracks are reconstructed correctly
  Scenario: Testing computation of geometric parameters in STK geometric
    digitizer
      [Algorithms][StkGeometricDigitizerAlgo]
  Scenario: Testing STK geometric digitizer algorithm on top STK hits
      [Algorithms][StkGeometricDigitizerAlgo]
  Scenario: Testing STK geometric digitizer algorithm on side STK hits
      [Algorithms][StkGeometricDigitizerAlgo]
  Scenario: Testing STK clustering algorithm on top STK: regular clusters
      [Algorithms][StkClusteringAlgo]
  Scenario: Testing STK clustering algorithm on top STK: irregular clusters
      [Algorithms][StkClusteringAlgo]
  Scenario: Testing STK clustering algorithm on lateral STK on side Xneg
      [Algorithms][StkClusteringAlgo]
  Scenario: Testing STK clustering algorithm on lateral STK on side Yneg
      [Algorithms][StkClusteringAlgo]
  Scenario: Testing STK clustering algorithm errors
      [Algorithms][StkClusteringAlgo]
  Scenario: Testing digitization of hits on top PSD
      [Algorithms][PsdGeometricDigitizerAlgo]
  Scenario: Testing digitization of hits on lateral PSD
      [Algorithms][PsdGeometricDigitizerAlgo]
  Scenario: Configuring and building an external analysis project using
    HerdSoftware from build folder
      [External]
  Scenario: Configuring and building an external analysis project using
    HerdSoftware from install folder
      [External]
  Scenario: Testing AxisArray
      [AxisArray][Common]
  Scenario: Testing SidesArray
      [Common][SidesArray]
  Scenario: Points operations are valid
      [DataObjects][Point]
  Scenario: Cluster: default construction
      [Cluster][DataObjects]
  Scenario: Cluster: construction with parameters
      [Cluster][DataObjects]
21 test cases
```
Test tags are indicated within square brackets. For example, to run only the test scenarios relative to algorithms:

```bash
$ testsuite/run_tests [Algorithms]
  ****************************************************
  *             HerdSoftware v0.0                    *
  * commit: daa443fce3ee61cd512252fac34fc3882c864c97 *
  * code status: clean                               *
  ****************************************************
===============================================================================
All tests passed (1652 assertions in 11 test cases)
```

Running tests is simple and quick, so it should be done at least before committing some changes to the repository.  

### Test data files
Some tests relies on the availability of data files. These files are automatically generated by running a Monte Carlo simulation when launching the test program. To optimize the run time they are generated only if they are missing. To force the re-generation of the data files launch the test program with the `--makedatafiles` option.

Note that since data files are generated by running a Monte Carlo simulation the tests relying on them will not be executed if HerdSoftware has been compiled [without support for Monte Carlo simulation](User's-manual/Download,-configure,-build-and-install.md#modular-build).

## Continuous integration
The HerdSoftware test program is run automatically by GitLab on every code push by the continuous integration (CI) GitLab subsystem. Results are displayed on the CI/CD GitLab page acessible from the menu on the right side of the main page.

# Coverage
Tests are inevitably limited in covering all the possible usage scenarios: some corner cases will always lie outside the test perimeter, either because some relevant combination of input parameters are not considered by the tests, or because some code portions are not tested at all. Both these cases will reduce the effectiveness of the tests, but while it's very difficult to assess the entity of the former there is a handy way to get a measurement of the second: code coverage reports. Code coverage is the percentage of the code lines actually being run at least once during the execution of the test program. It gives a quick feeling about how much code is actually tested, although it provides no information about the quality of the tests (e.g. a code line executed just once or 100 times will contribute the same to the code coverage). Code coverage for the master branch is reported on the GitLab main page; detailed coverage reports are available from the Jobs page in the CI/CD section (see right menu), for jobs belonging to the test stage. From this reports it is possible to get the code coverage and also a list of code lines that were not tested.

While code coverage _per se_ is not a fully trustworthy measurement of test quality, it indeed better to have a high coverage than not. The goal for HerdSoftware is to keep code coverage for the master branch above 90%. 
