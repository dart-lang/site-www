---
title: Class modifiers reference
description: >-
  The allowed and disallowed combinations of class modifiers.
prevpage:
  url: /language/class-modifiers
  title: Class modifiers
nextpage:
  url: /language/async
  title: Asynchronous support
---

This page contains reference information for
[class modifiers](/language/class-modifiers).

## Valid combinations

The valid combinations of class modifiers and their resulting capabilities are:

<div class="table-wrapper" markdown="1">
| Declaration | [Construct][]? | [Extend][]? | [Implement][]? | [Mix in][]? | [Exhaustive][]? |
|--|--|--|--|--|--|
|`class`                    |**Yes**|**Yes**|**Yes**|No     |No     | |
|`base class`               |**Yes**|**Yes**|No     |No     |No     |
|`interface class`          |**Yes**|No     |**Yes**|No     |No     |
|`final class`              |**Yes**|No     |No     |No     |No     |
|`sealed class`             |No     |No     |No     |No     |**Yes**|
|`abstract class`           |No     |**Yes**|**Yes**|No     |No     |
|`abstract base class`      |No     |**Yes**|No     |No     |No     |
|`abstract interface class` |No     |No     |**Yes**|No     |No     |
|`abstract final class`     |No     |No     |No     |No     |No     |
|`mixin class`              |**Yes**|**Yes**|**Yes**|**Yes**|No     |
|`base mixin class`         |**Yes**|**Yes**|No     |**Yes**|No     |
|`abstract mixin class`     |No     |**Yes**|**Yes**|**Yes**|No     |
|`abstract base mixin class`|No     |**Yes**|No     |**Yes**|No     |
|`mixin`                    |No     |No     |**Yes**|**Yes**|No     |
|`base mixin`               |No     |No     |No     |**Yes**|No     |
{:.table .table-striped .nowrap}
</div>

[Construct]: /language/classes#using-constructors
[Extend]: /language/extend
[Implement]: /language/classes#implicit-interfaces
[Mix in]: /language/mixins
[Exhaustive]: /language/branches#exhaustiveness-checking

## Invalid combinations

Certain [combinations](/language/class-modifiers#combining-modifiers)
of modifiers are not allowed:

<div class="table-wrapper" markdown="1">
| Combination | Reasoning |
|--|--|
|`base`, `interface`, and `final`  |All control the same two capabilities (`extend` and `implement`), so are mutually exclusive. |
|`sealed` and `abstract` |Neither can be constructed, so are redundant together. |
|`sealed` with `base`, `interface`, or `final` | `sealed` types already cannot be mixed in, extended or implemented from another library, so are redundant to combine with the listed modifiers. |
|`mixin` and `abstract` |Neither can be constructed, so are redundant together. |
|`mixin` and `interface`, `final`, or `sealed` |A `mixin` or `mixin class` declaration is intended to be mixed in, which the listed modifiers prevent. |
|`enum` and any modifiers |`enum` declarations cannot be extended, implemented, mixed in, and can always be instantiated, so no modifiers apply to `enum` declarations. |
{:.table .table-striped .nowrap}
</div>
