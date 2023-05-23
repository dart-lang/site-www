{% comment %}
This file is generated from the other files in this directory.
To re-generate it, please run the following command from root of
the project:

```
$ dart run tool/effective_dart_rules/bin/main.dart
```
{% endcomment %}
    
<div class='effective_dart--summary_column' markdown='1'>

### Style


**Identifiers**

* <a href='/effective-dart/style#do-name-types-using-uppercamelcase'>DO name types using <code>UpperCamelCase</code>.</a>
* <a href='/effective-dart/style#do-name-extensions-using-uppercamelcase'>DO name extensions using <code>UpperCamelCase</code>.</a>
* <a href='/effective-dart/style#do-name-packages-and-file-system-entities-using-lowercase-with-underscores'>DO name packages, directories, and source files using <code>lowercase_with_underscores</code>.</a>
* <a href='/effective-dart/style#do-name-import-prefixes-using-lowercase_with_underscores'>DO name import prefixes using <code>lowercase_with_underscores</code>.</a>
* <a href='/effective-dart/style#do-name-other-identifiers-using-lowercamelcase'>DO name other identifiers using <code>lowerCamelCase</code>.</a>
* <a href='/effective-dart/style#prefer-using-lowercamelcase-for-constant-names'>PREFER using <code>lowerCamelCase</code> for constant names.</a>
* <a href='/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words'>DO capitalize acronyms and abbreviations longer than two letters like words.</a>
* <a href='/effective-dart/style#prefer-using-_-__-etc-for-unused-callback-parameters'>PREFER using <code>_</code>, <code>__</code>, etc. for unused callback parameters.</a>
* <a href='/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private'>DON'T use a leading underscore for identifiers that aren't private.</a>
* <a href='/effective-dart/style#dont-use-prefix-letters'>DON'T use prefix letters.</a>
* <a href='/effective-dart/style#dont-explicitly-name-libraries'>DON'T explicitly name libraries.</a>

**Ordering**

* <a href='/effective-dart/style#do-place-dart-imports-before-other-imports'>DO place <code>dart:</code> imports before other imports.</a>
* <a href='/effective-dart/style#do-place-package-imports-before-relative-imports'>DO place <code>package:</code> imports before relative imports.</a>
* <a href='/effective-dart/style#do-specify-exports-in-a-separate-section-after-all-imports'>DO specify exports in a separate section after all imports.</a>
* <a href='/effective-dart/style#do-sort-sections-alphabetically'>DO sort sections alphabetically.</a>

**Formatting**

* <a href='/effective-dart/style#do-format-your-code-using-dart-format'>DO format your code using <code>dart format</code>.</a>
* <a href='/effective-dart/style#consider-changing-your-code-to-make-it-more-formatter-friendly'>CONSIDER changing your code to make it more formatter-friendly.</a>
* <a href='/effective-dart/style#avoid-lines-longer-than-80-characters'>AVOID lines longer than 80 characters.</a>
* <a href='/effective-dart/style#do-use-curly-braces-for-all-flow-control-structures'>DO use curly braces for all flow control statements.</a>

</div>
<div class='effective_dart--summary_column' markdown='1'>


### Documentation


**Comments**

* <a href='/effective-dart/documentation#do-format-comments-like-sentences'>DO format comments like sentences.</a>
* <a href='/effective-dart/documentation#dont-use-block-comments-for-documentation'>DON'T use block comments for documentation.</a>

**Doc comments**

* <a href='/effective-dart/documentation#do-use--doc-comments-to-document-members-and-types'>DO use <code>///</code> doc comments to document members and types.</a>
* <a href='/effective-dart/documentation#prefer-writing-doc-comments-for-public-apis'>PREFER writing doc comments for public APIs.</a>
* <a href='/effective-dart/documentation#consider-writing-a-library-level-doc-comment'>CONSIDER writing a library-level doc comment.</a>
* <a href='/effective-dart/documentation#consider-writing-doc-comments-for-private-apis'>CONSIDER writing doc comments for private APIs.</a>
* <a href='/effective-dart/documentation#do-start-doc-comments-with-a-single-sentence-summary'>DO start doc comments with a single-sentence summary.</a>
* <a href='/effective-dart/documentation#do-separate-the-first-sentence-of-a-doc-comment-into-its-own-paragraph'>DO separate the first sentence of a doc comment into its own paragraph.</a>
* <a href='/effective-dart/documentation#avoid-redundancy-with-the-surrounding-context'>AVOID redundancy with the surrounding context.</a>
* <a href='/effective-dart/documentation#prefer-starting-function-or-method-comments-with-third-person-verbs'>PREFER starting function or method comments with third-person verbs.</a>
* <a href='/effective-dart/documentation#prefer-starting-a-non-boolean-variable-or-property-comment-with-a-noun-phrase'>PREFER starting a non-boolean variable or property comment with a noun phrase.</a>
* <a href='/effective-dart/documentation#prefer-starting-a-boolean-variable-or-property-comment-with-whether-followed-by-a-noun-or-gerund-phrase'>PREFER starting a boolean variable or property comment with &quot;Whether&quot; followed by a noun or gerund phrase.</a>
* <a href='/effective-dart/documentation#dont-write-documentation-for-both-the-getter-and-setter-of-a-property'>DON'T write documentation for both the getter and setter of a property.</a>
* <a href='/effective-dart/documentation#prefer-starting-library-or-type-comments-with-noun-phrases'>PREFER starting library or type comments with noun phrases.</a>
* <a href='/effective-dart/documentation#consider-including-code-samples-in-doc-comments'>CONSIDER including code samples in doc comments.</a>
* <a href='/effective-dart/documentation#do-use-square-brackets-in-doc-comments-to-refer-to-in-scope-identifiers'>DO use square brackets in doc comments to refer to in-scope identifiers.</a>
* <a href='/effective-dart/documentation#do-use-prose-to-explain-parameters-return-values-and-exceptions'>DO use prose to explain parameters, return values, and exceptions.</a>
* <a href='/effective-dart/documentation#do-put-doc-comments-before-metadata-annotations'>DO put doc comments before metadata annotations.</a>

**Markdown**

* <a href='/effective-dart/documentation#avoid-using-markdown-excessively'>AVOID using markdown excessively.</a>
* <a href='/effective-dart/documentation#avoid-using-html-for-formatting'>AVOID using HTML for formatting.</a>
* <a href='/effective-dart/documentation#prefer-backtick-fences-for-code-blocks'>PREFER backtick fences for code blocks.</a>

**Writing**

* <a href='/effective-dart/documentation#prefer-brevity'>PREFER brevity.</a>
* <a href='/effective-dart/documentation#avoid-abbreviations-and-acronyms-unless-they-are-obvious'>AVOID abbreviations and acronyms unless they are obvious.</a>
* <a href='/effective-dart/documentation#prefer-using-this-instead-of-the-to-refer-to-a-members-instance'>PREFER using &quot;this&quot; instead of &quot;the&quot; to refer to a member's instance.</a>

</div>
<div style='clear:both'></div>
<div class='effective_dart--summary_column' markdown='1'>


### Usage


**Libraries**

* <a href='/effective-dart/usage#do-use-strings-in-part-of-directives'>DO use strings in <code>part of</code> directives.</a>
* <a href='/effective-dart/usage#dont-import-libraries-that-are-inside-the-src-directory-of-another-package'>DON'T import libraries that are inside the <code>src</code> directory of another package.</a>
* <a href='/effective-dart/usage#dont-allow-an-import-path-to-reach-into-or-out-of-lib'>DON'T allow an import path to reach into or out of <code>lib</code>.</a>
* <a href='/effective-dart/usage#prefer-relative-import-paths'>PREFER relative import paths.</a>

**Null**

* <a href='/effective-dart/usage#dont-explicitly-initialize-variables-to-null'>DON'T explicitly initialize variables to <code>null</code>.</a>
* <a href='/effective-dart/usage#dont-use-an-explicit-default-value-of-null'>DON'T use an explicit default value of <code>null</code>.</a>
* <a href='/effective-dart/usage#dont-use-true-or-false-in-equality-operations'>DON'T use <code>true</code> or <code>false</code> in equality operations.</a>
* <a href='/effective-dart/usage#avoid-late-variables-if-you-need-to-check-whether-they-are-initialized'>AVOID <code>late</code> variables if you need to check whether they are initialized.</a>
* <a href='/effective-dart/usage#consider-assigning-a-nullable-field-to-a-local-variable-to-enable-type-promotion'>CONSIDER assigning a nullable field to a local variable to enable type promotion.</a>

**Strings**

* <a href='/effective-dart/usage#do-use-adjacent-strings-to-concatenate-string-literals'>DO use adjacent strings to concatenate string literals.</a>
* <a href='/effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values'>PREFER using interpolation to compose strings and values.</a>
* <a href='/effective-dart/usage#avoid-using-curly-braces-in-interpolation-when-not-needed'>AVOID using curly braces in interpolation when not needed.</a>

**Collections**

* <a href='/effective-dart/usage#do-use-collection-literals-when-possible'>DO use collection literals when possible.</a>
* <a href='/effective-dart/usage#dont-use-length-to-see-if-a-collection-is-empty'>DON'T use <code>.length</code> to see if a collection is empty.</a>
* <a href='/effective-dart/usage#avoid-using-iterableforeach-with-a-function-literal'>AVOID using <code>Iterable.forEach()</code> with a function literal.</a>
* <a href='/effective-dart/usage#dont-use-listfrom-unless-you-intend-to-change-the-type-of-the-result'>DON'T use <code>List.from()</code> unless you intend to change the type of the result.</a>
* <a href='/effective-dart/usage#do-use-wheretype-to-filter-a-collection-by-type'>DO use <code>whereType()</code> to filter a collection by type.</a>
* <a href='/effective-dart/usage#dont-use-cast-when-a-nearby-operation-will-do'>DON'T use <code>cast()</code> when a nearby operation will do.</a>
* <a href='/effective-dart/usage#avoid-using-cast'>AVOID using <code>cast()</code>.</a>

**Functions**

* <a href='/effective-dart/usage#do-use-a-function-declaration-to-bind-a-function-to-a-name'>DO use a function declaration to bind a function to a name.</a>
* <a href='/effective-dart/usage#dont-create-a-lambda-when-a-tear-off-will-do'>DON'T create a lambda when a tear-off will do.</a>
* <a href='/effective-dart/usage#do-use--to-separate-a-named-parameter-from-its-default-value'>DO use <code>=</code> to separate a named parameter from its default value.</a>

**Variables**

* <a href='/effective-dart/usage#do-follow-a-consistent-rule-for-var-and-final-on-local-variables'>DO follow a consistent rule for <code>var</code> and <code>final</code> on local variables.</a>
* <a href='/effective-dart/usage#avoid-storing-what-you-can-calculate'>AVOID storing what you can calculate.</a>

**Members**

* <a href='/effective-dart/usage#dont-wrap-a-field-in-a-getter-and-setter-unnecessarily'>DON'T wrap a field in a getter and setter unnecessarily.</a>
* <a href='/effective-dart/usage#prefer-using-a-final-field-to-make-a-read-only-property'>PREFER using a <code>final</code> field to make a read-only property.</a>
* <a href='/effective-dart/usage#consider-using--for-simple-members'>CONSIDER using <code>=&gt;</code> for simple members.</a>
* <a href='/effective-dart/usage#dont-use-this-when-not-needed-to-avoid-shadowing'>DON'T use <code>this.</code> except to redirect to a named constructor or to avoid shadowing.</a>
* <a href='/effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible'>DO initialize fields at their declaration when possible.</a>

**Constructors**

* <a href='/effective-dart/usage#do-use-initializing-formals-when-possible'>DO use initializing formals when possible.</a>
* <a href='/effective-dart/usage#dont-use-late-when-a-constructor-initializer-list-will-do'>DON'T use <code>late</code> when a constructor initializer list will do.</a>
* <a href='/effective-dart/usage#do-use--instead-of--for-empty-constructor-bodies'>DO use <code>;</code> instead of <code>{}</code> for empty constructor bodies.</a>
* <a href='/effective-dart/usage#dont-use-new'>DON'T use <code>new</code>.</a>
* <a href='/effective-dart/usage#dont-use-const-redundantly'>DON'T use <code>const</code> redundantly.</a>

**Error handling**

* <a href='/effective-dart/usage#avoid-catches-without-on-clauses'>AVOID catches without <code>on</code> clauses.</a>
* <a href='/effective-dart/usage#dont-discard-errors-from-catches-without-on-clauses'>DON'T discard errors from catches without <code>on</code> clauses.</a>
* <a href='/effective-dart/usage#do-throw-objects-that-implement-error-only-for-programmatic-errors'>DO throw objects that implement <code>Error</code> only for programmatic errors.</a>
* <a href='/effective-dart/usage#dont-explicitly-catch-error-or-types-that-implement-it'>DON'T explicitly catch <code>Error</code> or types that implement it.</a>
* <a href='/effective-dart/usage#do-use-rethrow-to-rethrow-a-caught-exception'>DO use <code>rethrow</code> to rethrow a caught exception.</a>

**Asynchrony**

* <a href='/effective-dart/usage#prefer-asyncawait-over-using-raw-futures'>PREFER async/await over using raw futures.</a>
* <a href='/effective-dart/usage#dont-use-async-when-it-has-no-useful-effect'>DON'T use <code>async</code> when it has no useful effect.</a>
* <a href='/effective-dart/usage#consider-using-higher-order-methods-to-transform-a-stream'>CONSIDER using higher-order methods to transform a stream.</a>
* <a href='/effective-dart/usage#avoid-using-completer-directly'>AVOID using Completer directly.</a>
* <a href='/effective-dart/usage#do-test-for-futuret-when-disambiguating-a-futureort-whose-type-argument-could-be-object'>DO test for <code>Future&lt;T&gt;</code> when disambiguating a <code>FutureOr&lt;T&gt;</code> whose type argument could be <code>Object</code>.</a>

</div>
<div class='effective_dart--summary_column' markdown='1'>


### Design


**Names**

* <a href='/effective-dart/design#do-use-terms-consistently'>DO use terms consistently.</a>
* <a href='/effective-dart/design#avoid-abbreviations'>AVOID abbreviations.</a>
* <a href='/effective-dart/design#prefer-putting-the-most-descriptive-noun-last'>PREFER putting the most descriptive noun last.</a>
* <a href='/effective-dart/design#consider-making-the-code-read-like-a-sentence'>CONSIDER making the code read like a sentence.</a>
* <a href='/effective-dart/design#prefer-a-noun-phrase-for-a-non-boolean-property-or-variable'>PREFER a noun phrase for a non-boolean property or variable.</a>
* <a href='/effective-dart/design#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable'>PREFER a non-imperative verb phrase for a boolean property or variable.</a>
* <a href='/effective-dart/design#consider-omitting-the-verb-for-a-named-boolean-parameter'>CONSIDER omitting the verb for a named boolean <em>parameter</em>.</a>
* <a href='/effective-dart/design#prefer-the-positive-name-for-a-boolean-property-or-variable'>PREFER the &quot;positive&quot; name for a boolean property or variable.</a>
* <a href='/effective-dart/design#prefer-an-imperative-verb-phrase-for-a-function-or-method-whose-main-purpose-is-a-side-effect'>PREFER an imperative verb phrase for a function or method whose main purpose is a side effect.</a>
* <a href='/effective-dart/design#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose'>PREFER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose.</a>
* <a href='/effective-dart/design#consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs'>CONSIDER an imperative verb phrase for a function or method if you want to draw attention to the work it performs.</a>
* <a href='/effective-dart/design#avoid-starting-a-method-name-with-get'>AVOID starting a method name with <code>get</code>.</a>
* <a href='/effective-dart/design#prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object'>PREFER naming a method <code>to___()</code> if it copies the object's state to a new object.</a>
* <a href='/effective-dart/design#prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object'>PREFER naming a method <code>as___()</code> if it returns a different representation backed by the original object.</a>
* <a href='/effective-dart/design#avoid-describing-the-parameters-in-the-functions-or-methods-name'>AVOID describing the parameters in the function's or method's name.</a>
* <a href='/effective-dart/design#do-follow-existing-mnemonic-conventions-when-naming-type-parameters'>DO follow existing mnemonic conventions when naming type parameters.</a>

**Libraries**

* <a href='/effective-dart/design#prefer-making-declarations-private'>PREFER making declarations private.</a>
* <a href='/effective-dart/design#consider-declaring-multiple-classes-in-the-same-library'>CONSIDER declaring multiple classes in the same library.</a>

**Classes and mixins**

* <a href='/effective-dart/design#avoid-defining-a-one-member-abstract-class-when-a-simple-function-will-do'>AVOID defining a one-member abstract class when a simple function will do.</a>
* <a href='/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members'>AVOID defining a class that contains only static members.</a>
* <a href='/effective-dart/design#avoid-extending-a-class-that-isnt-intended-to-be-subclassed'>AVOID extending a class that isn't intended to be subclassed.</a>
* <a href='/effective-dart/design#do-document-if-your-class-supports-being-extended'>DO document if your class supports being extended.</a>
* <a href='/effective-dart/design#avoid-implementing-a-class-that-isnt-intended-to-be-an-interface'>AVOID implementing a class that isn't intended to be an interface.</a>
* <a href='/effective-dart/design#do-document-if-your-class-supports-being-used-as-an-interface'>DO document if your class supports being used as an interface.</a>
* <a href='/effective-dart/design#do-use-mixin-to-define-a-mixin-type'>DO use <code>mixin</code> to define a mixin type.</a>
* <a href='/effective-dart/design#avoid-mixing-in-a-class-that-isnt-intended-to-be-a-mixin'>AVOID mixing in a type that isn't intended to be a mixin.</a>

**Constructors**

* <a href='/effective-dart/design#consider-making-your-constructor-const-if-the-class-supports-it'>CONSIDER making your constructor <code>const</code> if the class supports it.</a>

**Members**

* <a href='/effective-dart/design#prefer-making-fields-and-top-level-variables-final'>PREFER making fields and top-level variables <code>final</code>.</a>
* <a href='/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties'>DO use getters for operations that conceptually access properties.</a>
* <a href='/effective-dart/design#do-use-setters-for-operations-that-conceptually-change-properties'>DO use setters for operations that conceptually change properties.</a>
* <a href='/effective-dart/design#dont-define-a-setter-without-a-corresponding-getter'>DON'T define a setter without a corresponding getter.</a>
* <a href='/effective-dart/design#avoid-using-runtime-type-tests-to-fake-overloading'>AVOID using runtime type tests to fake overloading.</a>
* <a href='/effective-dart/design#avoid-public-late-final-fields-without-initializers'>AVOID public <code>late final</code> fields without initializers.</a>
* <a href='/effective-dart/design#avoid-returning-nullable-future-stream-and-collection-types'>AVOID returning nullable <code>Future</code>, <code>Stream</code>, and collection types.</a>
* <a href='/effective-dart/design#avoid-returning-this-from-methods-just-to-enable-a-fluent-interface'>AVOID returning <code>this</code> from methods just to enable a fluent interface.</a>

**Types**

* <a href='/effective-dart/design#do-type-annotate-variables-without-initializers'>DO type annotate variables without initializers.</a>
* <a href='/effective-dart/design#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious'>DO type annotate fields and top-level variables if the type isn't obvious.</a>
* <a href='/effective-dart/design#dont-redundantly-type-annotate-initialized-local-variables'>DON'T redundantly type annotate initialized local variables.</a>
* <a href='/effective-dart/design#do-annotate-return-types-on-function-declarations'>DO annotate return types on function declarations.</a>
* <a href='/effective-dart/design#do-annotate-parameter-types-on-function-declarations'>DO annotate parameter types on function declarations.</a>
* <a href='/effective-dart/design#dont-annotate-inferred-parameter-types-on-function-expressions'>DON'T annotate inferred parameter types on function expressions.</a>
* <a href='/effective-dart/design#dont-type-annotate-initializing-formals'>DON'T type annotate initializing formals.</a>
* <a href='/effective-dart/design#do-write-type-arguments-on-generic-invocations-that-arent-inferred'>DO write type arguments on generic invocations that aren't inferred.</a>
* <a href='/effective-dart/design#dont-write-type-arguments-on-generic-invocations-that-are-inferred'>DON'T write type arguments on generic invocations that are inferred.</a>
* <a href='/effective-dart/design#avoid-writing-incomplete-generic-types'>AVOID writing incomplete generic types.</a>
* <a href='/effective-dart/design#do-annotate-with-dynamic-instead-of-letting-inference-fail'>DO annotate with <code>dynamic</code> instead of letting inference fail.</a>
* <a href='/effective-dart/design#prefer-signatures-in-function-type-annotations'>PREFER signatures in function type annotations.</a>
* <a href='/effective-dart/design#dont-specify-a-return-type-for-a-setter'>DON'T specify a return type for a setter.</a>
* <a href='/effective-dart/design#dont-use-the-legacy-typedef-syntax'>DON'T use the legacy typedef syntax.</a>
* <a href='/effective-dart/design#prefer-inline-function-types-over-typedefs'>PREFER inline function types over typedefs.</a>
* <a href='/effective-dart/design#prefer-using-function-type-syntax-for-parameters'>PREFER using function type syntax for parameters.</a>
* <a href='/effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking'>AVOID using <code>dynamic</code> unless you want to disable static checking.</a>
* <a href='/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values'>DO use <code>Future&lt;void&gt;</code> as the return type of asynchronous members that do not produce values.</a>
* <a href='/effective-dart/design#avoid-using-futureort-as-a-return-type'>AVOID using <code>FutureOr&lt;T&gt;</code> as a return type.</a>

**Parameters**

* <a href='/effective-dart/design#avoid-positional-boolean-parameters'>AVOID positional boolean parameters.</a>
* <a href='/effective-dart/design#avoid-optional-positional-parameters-if-the-user-may-want-to-omit-earlier-parameters'>AVOID optional positional parameters if the user may want to omit earlier parameters.</a>
* <a href='/effective-dart/design#avoid-mandatory-parameters-that-accept-a-special-no-argument-value'>AVOID mandatory parameters that accept a special &quot;no argument&quot; value.</a>
* <a href='/effective-dart/design#do-use-inclusive-start-and-exclusive-end-parameters-to-accept-a-range'>DO use inclusive start and exclusive end parameters to accept a range.</a>

**Equality**

* <a href='/effective-dart/design#do-override-hashcode-if-you-override-'>DO override <code>hashCode</code> if you override <code>==</code>.</a>
* <a href='/effective-dart/design#do-make-your--operator-obey-the-mathematical-rules-of-equality'>DO make your <code>==</code> operator obey the mathematical rules of equality.</a>
* <a href='/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes'>AVOID defining custom equality for mutable classes.</a>
* <a href='/effective-dart/design#dont-make-the-parameter-to--nullable'>DON'T make the parameter to <code>==</code> nullable.</a>

</div>
<div style='clear:both'></div>
