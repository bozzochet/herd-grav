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

**Guideline**: use modern C++ features as much as possible:
* do not use C arrays: go for std::array or std::vector
* do not use raw pointers: go for EA::observer_ptr, std::unique_ptr, std::shared_ptr
* prefer STL algorithms over self-written ones
* define copy/move constructor and copy/move assignment operator for new classes
* do not ignore error codes or exceptions

---

HerdSoftware is written in C++14, leveraging some of the language features that ease writing fast and well-behaved code. These include:
* [smart pointers](https://en.wikipedia.org/wiki/Smart_pointer)
* [move semantics](https://www.cprogramming.com/c++11/rvalue-references-and-move-semantics-in-c++11.html)
  * [rvalues, rvalues references and move constructor](https://en.wikipedia.org/wiki/C%2B%2B11#Rvalue_references_and_move_constructors)
  * [move assignment](https://en.wikipedia.org/wiki/Move_assignment_operator)
* [lambdas](https://www.cprogramming.com/c++11/c++11-lambda-closures.html)
* [STL algorithms](https://cal-linux.com/tutorials/STL_algorithms)

The developers are encouraged to make use of these features. Some of them are enforced by the framework (e.g. EventAnalysis data objects are almost entirely handled with smart pointers).

In the following there's a very brief description of selected topics; the interested reader should refer to links and online resources for more detailed descriptions.

# Arrays
C arrays are equivalent to raw pointers, and they don't carry information about their size. The `std::array` class provides a replacement for fixed-size C-style arrays with no overhead and compile-time size information. Use it for fixed-size arrays, and opt for `std::vector` for variable-size arrays.

# Pointers
Raw pointers (i.e. `MyClass *p`) have to be entirely managed by he user, which has to create and destroy the pointed objects with `new` and `delete`. This often leads to well-known runtime problems like memory leaks and double delete errors. Moreover, using raw pointers as return values always generates confusion about the ownership of the pointed objects: who should delete (i.e. who "owns") the object pointed by the return value of 
```c++
MyClass *Function()
```
? The user who calls the function? Is it automatically deleted by some underlying manager class? This problem can be partly circumvented by documenting `Function()`, but the user might not read the documentation or forget to comply with the ownership rule.

Smart pointers are classes that wrap a raw pointer and owns the pointed object: the latter is destroyed when the smart pointer object goes out of scope. There are rules for "passing" the pointed objects from one pointer to another, which also defines the destruction rules. There are two standard C++ smart pointers:
* [std:unique_ptr](https://en.wikipedia.org/wiki/Smart_pointer#unique_ptr)
* [std::shared_ptr](https://en.wikipedia.org/wiki/Smart_pointer#shared_ptr_and_weak_ptr)

Defining now:
```c++
std::unique_ptr<MyClass> Function()
```
it is now clear that the returned smart pointer will be the only owner of the pointed `MyClass` object, and that the object will be destroyed automatically when the `std::unique_ptr` will go out of scope (unless it is passed to another smart pointer) without the user having to call `delete` explicitly (and thus with no chance of forgetting to do it).

For the sake of uniformity in notation, EventAnalysis defines a smart pointer which do not hold the pointed object:
* [EA::observer_ptr](https://wizard.fi.infn.it/eventanalysis/doxygen/master/classEA_1_1observer__ptr.html)

It behaves exactly as a raw pointer, with the advantage of making it clear that the pointed object is not owned by the pointer and that it will not be deleted when the pointer goes out of scope.

By using smart pointers consistently and avoiding raw pointers the resulting code is more safe (no memory leaks, no double deletes) and clear to understand (object ownership is explicitly coded in the type of the smart pointer).

# Algorithms and lambdas
The C++ Standard Template Library (STL) provides generic implementations of [many common algorithms](http://www.cplusplus.com/reference/algorithm) that work on objects contained in standard containers like `std::array` and `std::vector`. These include: sort, search, merge, partition, modify etc. These algorithms are implemented for efficiency and optimized versions for a given container type are sometimes available. It is then advisable to use a STL algorithm when available, instead of writing it again from scratch, reducing the room for bugs and sometimes making the code easier to read, e.g.:
```c++
std::sort(vect.begin(), vect.end());
```
clearly sorts all the elements of `vect`.

The use of STL algorithms becomes really convenient when pairing it with lambdas. Consider the sorting example above: if one wants to sort in the reverse order then a comparison function can be passed as the final argument:
```c++
std::sort(vect.begin(), vect.end(), ReverseSort);
```
The `ReverseSort` function takes as arguments two elements of `vect` and returns false if the first is smaller than the second: this will produce a reverse-sorted container. The `ReverseSort` function has however to be defined somewhere, possibly in a different file, just for being used once in the call to `std::sort`. A user inspecting the code then has to search for it to see if it's properly implemented, while some other user might wonder what is its purpose if he doesn't know that it is used for `std::sort`.

These potential confusion can be eliminated with lambdas. A [lambda](https://www.cprogramming.com/c++11/c++11-lambda-closures.html) is a small inline function without a name, defined in the place where it is used. For example:
```c++
std::sort(vect.begin(),vect.end(),[](float a, float b){return b < a;});
```
(we supposed that `vect` contains `float`s). All the code is now where it ought to be and there are no named functions around with obscure functionality.

# Copy/move

The usual object copy that was common in language versions previous to C++11 has always been a cause of performance loss. Allocating memory for a new object and setting its values requires resources in terms of memory and computation time; copying large objects could slow down the code considerably.

While copying an object is the intended behavior in many cases, and then in these cases the overhead is unavoidable, it is not necessary in many others. Suppose that a function returns a large `std::vector`:
```c++
std::vector<float> CreateHugeVector(){
  return std::vector<float>(10000000);
}

std::vector<float> vf = CreateHugeVector();
```
Before C++11, the above code would create a `std::vector` with 10000000 elements inside `CreateHugeVector`, then creates `vf`, resize it to 10000000 elements, copy all the values and then destroy the original vector. This is completely unnecessary: inside `std::vector` there is a pointer pointing to the memory area where the 10000000 are stored, and since the vector on the right hand side (RHS) of the assignment operation (i.e. the one created inside `CreateHugeVector`) is going to be destroyed at the end of the assignment it is much more efficient to just copy the value of this pointer in `vf` and set the pointer value in the RHS vector to `nullptr`. In this way, the memory originally owed by the RHS vector is "given" or "moved" to `vf`, without any need for allocating memory and copying values; moreover, no deallocation is done when the RHS vector is destroyed, since its internal pointer is `nullptr`. The whole operation requires just copying a pointer and setting another pointer to `nullptr`.

In order to feature this move behavior, a class must implement a move constructor and a move assignment operator; for example, every STL container (including `std:vector`) implements a move assignment operator that behaves more or less as described above.

Every class which includes container members (e.g. a vector) or which holds a pointer to large memory zones should implement the move constructor/assignment for automatically optimizing certain operations for speed and memory usage. In HerdSoftware this is particularly important for data objects, so all the data objects should implement the move semantics.  

# Errors

Errors during code execution should never be ignored. If the program crashes unconditionally then it could be difficult to identify the reason of the crash. On the other hand, if the error is not critical and the execution goes on then incorrect results might be silently produced. It is then important e.g. to check the function return values which are interpretable as error flags (e.g. null pointers) and take appropriate actions. The meaning of "appropriate" is somewhat blurry, but generally speaking it should comply to these guidelines:

* a program error must not cause a crash or program termination without any indication of the error reason
* a program must not silently go on when an error occurs

The minimum that has to be done when an error occurs is to print an error message (see the `COUT` macro in the EventAnalysis [SmartLog](https://wizard.fi.infn.it/eventanalysis/doxygen/master/namespaceEA_1_1SmartLog.html) facility for printing various kind of messages). But this can often be not enough since an error message in the logs might go unnoticed. The error should then also be handled in some way and when recovery is not possible then an error signal should be raised, e.g. by returning an error code from the function where the error happened. But sometimes this could be not feasible since the function return type migh be `void` or another type that cannot encode an error code, or not enough since there's no way to enforce the caller to handle the error.

The best option in case of unrecoverable errors is to throw an [exception](http://www.cplusplus.com/doc/tutorial/exceptions). An exception thrown from a function  will cause the termination of the program if the function caller doesn't deal with it (i.e. if the caller doesn't catch it); moreover, exception objects deriving from `std::exception` carry an error description string that is automatically printed when the program is terminated because the exception has not been caught. Error management with exceptions guarantees that:
* the error cannot be ignored, because this will cause program termination  
* the error cannot produce wrong results, because either the caller recovers from it (by catching the exception) or the rogram is terminated  
* information about the error will be printed when the program is terminated  

In HerdSoftware, all the errors should be checked and handled for the sake of correctness. Exceptions provide a handy tool for raising an error, so it's recommended to use them. Some member functions of EventAnalysis classes returns a `bool` which is `false` when an error occurs, while some others rise an exception: check the [EventAnalysis doxygen documentation](https://wizard.fi.infn.it/eventanalysis/doxygen) for details and handle errors in the analysis code.
