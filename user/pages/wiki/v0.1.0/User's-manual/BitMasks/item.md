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

# Bitmasks

A collection of boolean flags can be easily stored treating each single bit in an integer variable as a single flag. Such an object is ofter referred to as a "bitmask" and can be potentially very useful. However bitmasks are often difficult to use, requiring good knowledge of bitwise operations, and difficult to read/understand (especially in the presence of strange magic numbers like `0x10013D` or similar). 

Given their close connection to integer types, `enum`s can be used to partially solve the readibility problem but, since they can be implicitly converted to their underlying integral type, they are completely interchangeable, representing a big issue in type-safety.
As an example this snippet would be valid C++ code:
```cpp
enum CaloPDFlag {Saturated = 1<<0, HighGain = 1<<1, Dead = 1<<2};
enum SiliconStripFlag {Noisy = 1<<0, Saturated = 1<<1, Dead = 1<<2};

// ...

auto caloPDChannelFlags = caloPDEventChannelInfo->GetStatusFlags(caloChannel);
if(caloPDChannelFlags & SiliconStripFlags::Saturated){ // !!! do you see what's wrong here?
  // some code
}
```
but the user made a big mistake! Checking the presence of the saturation flag using the `SiliconStripFlags` enum instead of the `CaloPDFlags` one in this case results in a bug.

To prevent such problems the C++11 standard introduces `enum class` types which behave as classic `enum`s but cannot be implicitly converted to their underlying integral type, meaning that different `enum class` objects cannot be mixed as in the previous example, or it would lead to a compilation error. However bitwise operations are not allowed on `enum class` objects (again, because they cannot be implicitly converted to `int`) out of the box, but require some extra work. 
In HerdSoftware this extra work is done in the `common/BitMask.h` header, and allows developers to declare a `enum class` as a bitmask with a single macro
```cpp
#include "common/BitMask.h"

namespace Herd{
enum class CaloPDFlag {Saturated = 1<<0, HighGain = 1<<1, Dead = 1<<2};

// other stuff...
}

ENABLE_BITMASK_OPERATORS(Herd::CaloPDFlag)
```
now the common bitmask operations are allowed for the `CaloPDFlag` `enum class`
```cpp
CaloPDFlag mask = CaloPDFlag::Dead | CaloPDFlag::Saturated;
```
but still, the result of these operations cannot be converted to POD types, especially `bool`. This means that
```cpp
CaloPDFlag mask = CaloPDFlag::Dead | CaloPDFlag::Saturated;

auto caloPDChannelFlags = caloPDEventChannelInfo->GetStatusFlags(caloChannel);
if(caloPDChannelFlags & mask){ // error: cannot convert CaloPDFlag to bool
  // channel is either dead or saturated...
}
```
This problem is solved introducing two helper functions designed to compare a bitmask with a given mask value and return a `bool`:
 - `MatchAllBits(flags, ones, zeroes)`: returns true if all of the bits set in `ones` are set in `flags` and if all of the bits set in `zeroes` are unset in `flags`.
 - `MatchAnyBit(flags, ones, zeroes)`: returns true if at least one of the bits set in `ones` is also set in `flags`, or if at least one of the bits set in `zeroes` is unset in `flags.

Example:
```cpp
CaloPDFlag badMask = CaloPDFlag::Dead | CaloPDFlag::Saturated;
CaloPDFlag lowGainMask = CaloPDFlag::HighGain | CaloPDFlag::Saturated;

auto caloPDChannelFlags = caloPDEventChannelInfo->GetStatusFlags(caloChannel);
if(MatchAnyBit(caloPDChannelFlags, badMask)){
  // channel is either dead or saturated...
}

if(MatchAllBits(caloPDChannelFlags, lowGainMask)){
  // high-gain channel is saturated, switch to low-gain
}

if(MatchAllBits(caloPDChannelFlags, CaloPDFlag::HighGain, badMask)){
  // channel is in high-gain and it's neither dead nor saturated
}

if(MatchAllBits(caloPDChannelFlags, SiliconStripFlag::Saturated)){ 
  // error: no match for 'operator&' (operand types are 'Herd::CaloPDFlag' and 'Herd::SiliconStripFlag'
  // This doesn't compile, different enum class types can't be mixed!
}
```

Of course these can be used to check for the presence of a single flag, allowing more complex patterns where the match is difficult to express in terms of simple bitwise operations
```cpp
if(
  MatchAllBits(channelFlags, Flags::Flag1) &&
  !MatchAllBits(channelFlags, Flags::Flag2) && 
  (
    MatchAllBits(channelFlags, Flags::Flag3) ||
    !MatchAllBits(channelFlags, Flags::Flag4) 
  )
){
  // ...
}
```
