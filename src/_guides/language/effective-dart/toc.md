    {% comment %}
    NOTE: The generator is broken.
    See https://github.com/dart-lang/site-www/issues/1325.

    This file is generated from the other files in this directory.
    To re-generate it, please run the following command from root of
    the project:

      $ dart deploy/effective-dart-rules/bin/main.dart

    {% endcomment %}
    
<div class='effective_dart--summary_column' markdown='1'>

### Style


**Identifiers**

* <a href='/guides/language/effective-dart/style#do-name-types-using-uppercamelcase'>DO name types using <code>UpperCamelCase</code>.</a>
* <a href='/guides/language/effective-dart/style#do-name-libraries-and-source-files-using-lowercase_with_underscores'>DO name libraries, packages, directories, and source files using <code>lowercase_with_underscores</code>.</a>
* <a href='/guides/language/effective-dart/style#do-name-import-prefixes-using-lowercase_with_underscores'>DO name import prefixes using <code>lowercase_with_underscores</code>.</a>
* <a href='/guides/language/effective-dart/style#do-name-other-identifiers-using-lowercamelcase'>DO name other identifiers using <code>lowerCamelCase</code>.</a>
* <a href='/guides/language/effective-dart/style#prefer-using-lowercamelcase-for-constant-names'>PREFER using <code>lowerCamelCase</code> for constant names.</a>
* <a href='/guides/language/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words'>DO capitalize acronyms and abbreviations longer than two letters like words.</a>
* <a href='/guides/language/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private'>DON'T use a leading underscore for identifiers that aren't private.</a>
* <a href='/guides/language/effective-dart/style#dont-use-prefix-letters'>DON'T use prefix letters.</a>

**Ordering**

* <a href='/guides/language/effective-dart/style#do-place-dart-imports-before-other-imports'>DO place "dart:" imports before other imports.</a>
* <a href='/guides/language/effective-dart/style#do-place-package-imports-before-relative-imports'>DO place "package:" imports before relative imports.</a>
* <a href='/guides/language/effective-dart/style#prefer-placing-third-party-package-imports-before-other-imports'>PREFER placing external "package:" imports before other imports.</a>
* <a href='/guides/language/effective-dart/style#do-specify-exports-in-a-separate-section-after-all-imports'>DO specify exports in a separate section after all imports.</a>
* <a href='/guides/language/effective-dart/style#do-sort-sections-alphabetically'>DO sort sections alphabetically.</a>

**Formatting**

* <a href='/guides/language/effective-dart/style#do-format-your-code-using-dartfmt'>DO format your code using <code>dartfmt</code>.</a>
* <a href='/guides/language/effective-dart/style#consider-changing-your-code-to-make-it-more-formatter-friendly'>CONSIDER changing your code to make it more formatter-friendly.</a>
* <a href='/guides/language/effective-dart/style#avoid-lines-longer-than-80-characters'>AVOID lines longer than 80 characters.</a>
* <a href='/guides/language/effective-dart/style#do-use-curly-braces-for-all-flow-control-structures'>DO use curly braces for all flow control statements.</a>

</div>
<div class='effective_dart--summary_column' markdown='1'>


### Documentation


**Comments**

* <a href='/guides/language/effective-dart/documentation#do-format-comments-like-sentences'>DO format comments like sentences.</a>
* <a href='/guides/language/effective-dart/documentation#dont-use-block-comments-for-documentation'>DON'T use block comments for documentation.</a>

**Doc comments**

* <a href='/guides/language/effective-dart/documentation#do-use--doc-comments-to-document-members-and-types'>DO use <code>///</code> doc comments to document members and types.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-writing-doc-comments-for-public-apis'>PREFER writing doc comments for public APIs.</a>
* <a href='/guides/language/effective-dart/documentation#consider-writing-a-library-level-doc-comment'>CONSIDER writing a library-level doc comment.</a>
* <a href='/guides/language/effective-dart/documentation#consider-writing-doc-comments-for-private-apis'>CONSIDER writing doc comments for private APIs.</a>
* <a href='/guides/language/effective-dart/documentation#do-start-doc-comments-with-a-single-sentence-summary'>DO start doc comments with a single-sentence summary.</a>
* <a href='/guides/language/effective-dart/documentation#do-separate-the-first-sentence-of-a-doc-comment-into-its-own-paragraph'>DO separate the first sentence of a doc comment into its own paragraph.</a>
* <a href='/guides/language/effective-dart/documentation#avoid-redundancy-with-the-surrounding-context'>AVOID redundancy with the surrounding context.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-starting-function-or-method-comments-with-third-person-verbs'>PREFER starting function or method comments with third-person verbs.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-starting-variable-getter-or-setter-comments-with-noun-phrases'>PREFER starting variable, getter, or setter comments with noun phrases.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-starting-library-or-type-comments-with-noun-phrases'>PREFER starting library or type comments with noun phrases.</a>
* <a href='/guides/language/effective-dart/documentation#consider-including-code-samples-in-doc-comments'>CONSIDER including code samples in doc comments.</a>
* <a href='/guides/language/effective-dart/documentation#do-use-square-brackets-in-doc-comments-to-refer-to-in-scope-identifiers'>DO use square brackets in doc comments to refer to in-scope identifiers.</a>
* <a href='/guides/language/effective-dart/documentation#do-use-prose-to-explain-parameters-return-values-and-exceptions'>DO use prose to explain parameters, return values, and exceptions.</a>
* <a href='/guides/language/effective-dart/documentation#do-put-doc-comments-before-metadata-annotations'>DO put doc comments before metadata annotations.</a>

**Markdown**

* <a href='/guides/language/effective-dart/documentation#avoid-using-markdown-excessively'>AVOID using markdown excessively.</a>
* <a href='/guides/language/effective-dart/documentation#avoid-using-html-for-formatting'>AVOID using HTML for formatting.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-backtick-fences-for-code-blocks'>PREFER backtick fences for code blocks.</a>

**Writing**

* <a href='/guides/language/effective-dart/documentation#prefer-brevity'>PREFER brevity.</a>
* <a href='/guides/language/effective-dart/documentation#avoid-abbreviations-and-acronyms-unless-they-are-obvious'>AVOID abbreviations and acronyms unless they are obvious.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-using-this-instead-of-the-to-refer-to-a-members-instance'>PREFER using "this" instead of "the" to refer to a member's instance.</a>

</div>
<div style='clear:both'></div>
<div class='effective_dart--summary_column' markdown='1'>


### Usage


**Libraries**

* <a href='/guides/language/effective-dart/usage#do-use-strings-in-part-of-directives'>DO use strings in <code>part of</code> directives.</a>
* <a href='/guides/language/effective-dart/usage#dont-import-libraries-that-are-inside-the-src-directory-of-another-package'>DON'T import libraries that are inside the <code>src</code> directory of another package.</a>
* <a href='/guides/language/effective-dart/usage#prefer-relative-paths-when-importing-libraries-within-your-own-packages-lib-directory'>PREFER relative paths when importing libraries within your own package's <code>lib</code> directory.</a>

**Booleans**

* <a href='/guides/language/effective-dart/usage#do-use--to-convert-null-to-a-boolean-value'>DO use <code>??</code> to convert <code>null</code> to a boolean value.</a>

**Strings**

* <a href='/guides/language/effective-dart/usage#do-use-adjacent-strings-to-concatenate-string-literals'>DO use adjacent strings to concatenate string literals.</a>
* <a href='/guides/language/effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values'>PREFER using interpolation to compose strings and values.</a>
* <a href='/guides/language/effective-dart/usage#avoid-using-curly-braces-in-interpolation-when-not-needed'>AVOID using curly braces in interpolation when not needed.</a>

**Collections**

* <a href='/guides/language/effective-dart/usage#do-use-collection-literals-when-possible'>DO use collection literals when possible.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-length-to-see-if-a-collection-is-empty'>DON'T use <code>.length</code> to see if a collection is empty.</a>
* <a href='/guides/language/effective-dart/usage#consider-using-higher-order-methods-to-transform-a-sequence'>CONSIDER using higher-order methods to transform a sequence.</a>
* <a href='/guides/language/effective-dart/usage#avoid-using-iterableforeach-with-a-function-literal'>AVOID using <code>Iterable.forEach()</code> with a function literal.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-listfrom-unless-you-intend-to-change-the-type-of-the-result'>DON'T use <code>List.from()</code> unless you intend to change the type of the result.</a>
* <a href='/guides/language/effective-dart/usage#do-use-wheretype-to-filter-a-collection-by-type'>DO use <code>whereType()</code> to filter a collection by type.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-cast-when-a-nearby-operation-will-do'>DON'T use <code>cast()</code> when a nearby operation will do.</a>
* <a href='/guides/language/effective-dart/usage#avoid-using-cast'>AVOID using <code>cast()</code>.</a>

**Functions**

* <a href='/guides/language/effective-dart/usage#do-use-a-function-declaration-to-bind-a-function-to-a-name'>DO use a function declaration to bind a function to a name.</a>
* <a href='/guides/language/effective-dart/usage#dont-create-a-lambda-when-a-tear-off-will-do'>DON'T create a lambda when a tear-off will do.</a>

**Parameters**

* <a href='/guides/language/effective-dart/usage#do-use--to-separate-a-named-parameter-from-its-default-value'>DO use <code>=</code> to separate a named parameter from its default value.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-an-explicit-default-value-of-null'>DON'T use an explicit default value of <code>null</code>.</a>

**Variables**

* <a href='/guides/language/effective-dart/usage#dont-explicitly-initialize-variables-to-null'>DON'T explicitly initialize variables to <code>null</code>.</a>
* <a href='/guides/language/effective-dart/usage#avoid-storing-what-you-can-calculate'>AVOID storing what you can calculate.</a>

**Members**

* <a href='/guides/language/effective-dart/usage#dont-wrap-a-field-in-a-getter-and-setter-unnecessarily'>DON'T wrap a field in a getter and setter unnecessarily.</a>
* <a href='/guides/language/effective-dart/usage#prefer-using-a-final-field-to-make-a-read-only-property'>PREFER using a <code>final</code> field to make a read-only property.</a>
* <a href='/guides/language/effective-dart/usage#consider-using--for-simple-members'>CONSIDER using <code>=&gt;</code> for simple members.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-this-when-not-needed-to-avoid-shadowing'>DON'T use <code>this.</code> except to redirect to a named constructor or to avoid shadowing.</a>
* <a href='/guides/language/effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible'>DO initialize fields at their declaration when possible.</a>

**Constructors**

* <a href='/guides/language/effective-dart/usage#do-use-initializing-formals-when-possible'>DO use initializing formals when possible.</a>
* <a href='/guides/language/effective-dart/usage#dont-type-annotate-initializing-formals'>DON'T type annotate initializing formals.</a>
* <a href='/guides/language/effective-dart/usage#do-use--instead-of--for-empty-constructor-bodies'>DO use <code>;</code> instead of <code>{}</code> for empty constructor bodies.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-new'>DON'T use <code>new</code>.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-const-redundantly'>DON'T use <code>const</code> redundantly.</a>

**Error handling**

* <a href='/guides/language/effective-dart/usage#avoid-catches-without-on-clauses'>AVOID catches without <code>on</code> clauses.</a>
* <a href='/guides/language/effective-dart/usage#dont-discard-errors-from-catches-without-on-clauses'>DON'T discard errors from catches without <code>on</code> clauses.</a>
* <a href='/guides/language/effective-dart/usage#do-throw-objects-that-implement-error-only-for-programmatic-errors'>DO throw objects that implement <code>Error</code> only for programmatic errors.</a>
* <a href='/guides/language/effective-dart/usage#dont-explicitly-catch-error-or-types-that-implement-it'>DON'T explicitly catch <code>Error</code> or types that implement it.</a>
* <a href='/guides/language/effective-dart/usage#do-use-rethrow-to-rethrow-a-caught-exception'>DO use <code>rethrow</code> to rethrow a caught exception.</a>

**Asynchrony**

* <a href='/guides/language/effective-dart/usage#prefer-asyncawait-over-using-raw-futures'>PREFER async/await over using raw futures.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-async-when-it-has-no-useful-effect'>DON'T use <code>async</code> when it has no useful effect.</a>
* <a href='/guides/language/effective-dart/usage#consider-using-higher-order-methods-to-transform-a-stream'>CONSIDER using higher-order methods to transform a stream.</a>
* <a href='/guides/language/effective-dart/usage#avoid-using-completer-directly'>AVOID using Completer directly.</a>
* <a href='/guides/language/effective-dart/usage#do-test-for-futuret-when-disambiguating-a-futureort-whose-type-argument-could-be-object'>DO test for <code>Future&lt;T&gt;</code> when disambiguating a <code>FutureOr&lt;T&gt;</code> whose type argument could be <code>Object</code>.</a>

</div>
<div class='effective_dart--summary_column' markdown='1'>


### Design


**Names**

* <a href='/guides/language/effective-dart/design#do-use-terms-consistently'>DO use terms consistently.</a>
* <a href='/guides/language/effective-dart/design#avoid-abbreviations'>AVOID abbreviations.</a>
* <a href='/guides/language/effective-dart/design#prefer-putting-the-most-descriptive-noun-last'>PREFER putting the most descriptive noun last.</a>
* <a href='/guides/language/effective-dart/design#consider-making-the-code-read-like-a-sentence'>CONSIDER making the code read like a sentence.</a>
* <a href='/guides/language/effective-dart/design#prefer-a-noun-phrase-for-a-non-boolean-property-or-variable'>PREFER a noun phrase for a non-boolean property or variable.</a>
* <a href='/guides/language/effective-dart/design#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable'>PREFER a non-imperative verb phrase for a boolean property or variable.</a>
* <a href='/guides/language/effective-dart/design#consider-omitting-the-verb-for-a-named-boolean-parameter'>CONSIDER omitting the verb for a named boolean <em>parameter</em>.</a>
* <a href='/guides/language/effective-dart/design#prefer-the-positive-name-for-a-boolean-property-or-variable'>PREFER the "positive" name for a boolean property or variable.</a>
* <a href='/guides/language/effective-dart/design#prefer-an-imperative-verb-phrase-for-a-function-or-method-whose-main-purpose-is-a-side-effect'>PREFER an imperative verb phrase for a function or method whose main purpose is a side effect.</a>
* <a href='/guides/language/effective-dart/design#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose'>PREFER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose.</a>
* <a href='/guides/language/effective-dart/design#consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs'>CONSIDER an imperative verb phrase for a function or method if you want to draw attention to the work it performs.</a>
* <a href='/guides/language/effective-dart/design#avoid-starting-a-method-name-with-get'>AVOID starting a method name with <code>get</code>.</a>
* <a href='/guides/language/effective-dart/design#prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object'>PREFER naming a method <code>to___()</code> if it copies the object's state to a new object.</a>
* <a href='/guides/language/effective-dart/design#prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object'>PREFER naming a method <code>as___()</code> if it returns a different representation backed by the original object.</a>
* <a href='/guides/language/effective-dart/design#avoid-describing-the-parameters-in-the-functions-or-methods-name'>AVOID describing the parameters in the function's or method's name.</a>
* <a href='/guides/language/effective-dart/design#do-follow-existing-mnemonic-conventions-when-naming-type-parameters'>DO follow existing mnemonic conventions when naming type parameters.</a>

**Libraries**

* <a href='/guides/language/effective-dart/design#prefer-making-declarations-private'>PREFER making declarations private.</a>
* <a href='/guides/language/effective-dart/design#consider-declaring-multiple-classes-in-the-same-library'>CONSIDER declaring multiple classes in the same library.</a>

**Classes and mixins**

* <a href='/guides/language/effective-dart/design#avoid-defining-a-one-member-abstract-class-when-a-simple-function-will-do'>AVOID defining a one-member abstract class when a simple function will do.</a>
* <a href='/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members'>AVOID defining a class that contains only static members.</a>
* <a href='/guides/language/effective-dart/design#avoid-extending-a-class-that-isnt-intended-to-be-subclassed'>AVOID extending a class that isn't intended to be subclassed.</a>
* <a href='/guides/language/effective-dart/design#do-document-if-your-class-supports-being-extended'>DO document if your class supports being extended.</a>
* <a href='/guides/language/effective-dart/design#avoid-implementing-a-class-that-isnt-intended-to-be-an-interface'>AVOID implementing a class that isn't intended to be an interface.</a>
* <a href='/guides/language/effective-dart/design#do-document-if-your-class-supports-being-used-as-an-interface'>DO document if your class supports being used as an interface.</a>
* <a href='/guides/language/effective-dart/design#do-use-mixin-to-define-a-mixin-type'>DO use <code>mixin</code> to define a mixin type.</a>
* <a href='/guides/language/effective-dart/design#avoid-mixing-in-a-class-that-isnt-intended-to-be-a-mixin'>AVOID mixing in a type that isn't intended to be a mixin.</a>

**Constructors**

* <a href='/guides/language/effective-dart/design#consider-making-your-constructor-const-if-the-class-supports-it'>CONSIDER making your constructor <code>const</code> if the class supports it.</a>

**Members**

* <a href='/guides/language/effective-dart/design#prefer-making-fields-and-top-level-variables-final'>PREFER making fields and top-level variables <code>final</code>.</a>
* <a href='/guides/language/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties'>DO use getters for operations that conceptually access properties.</a>
* <a href='/guides/language/effective-dart/design#do-use-setters-for-operations-that-conceptually-change-properties'>DO use setters for operations that conceptually change properties.</a>
* <a href='/guides/language/effective-dart/design#dont-define-a-setter-without-a-corresponding-getter'>DON'T define a setter without a corresponding getter.</a>
* <a href='/guides/language/effective-dart/design#avoid-returning-null-from-members-whose-return-type-is-bool-double-int-or-num'>AVOID returning <code>null</code> from members whose return type is <code>bool</code>, <code>double</code>, <code>int</code>, or <code>num</code>.</a>
* <a href='/guides/language/effective-dart/design#avoid-returning-this-from-methods-just-to-enable-a-fluent-interface'>AVOID returning <code>this</code> from methods just to enable a fluent interface.</a>

**Types**

* <a href='/guides/language/effective-dart/design#prefer-type-annotating-public-fields-and-top-level-variables-if-the-type-isnt-obvious'>PREFER type annotating public fields and top-level variables if the type isn't obvious.</a>
* <a href='/guides/language/effective-dart/design#consider-type-annotating-private-fields-and-top-level-variables-if-the-type-isnt-obvious'>CONSIDER type annotating private fields and top-level variables if the type isn't obvious.</a>
* <a href='/guides/language/effective-dart/design#avoid-type-annotating-initialized-local-variables'>AVOID type annotating initialized local variables.</a>
* <a href='/guides/language/effective-dart/design#avoid-annotating-inferred-parameter-types-on-function-expressions'>AVOID annotating inferred parameter types on function expressions.</a>
* <a href='/guides/language/effective-dart/design#avoid-redundant-type-arguments-on-generic-invocations'>AVOID redundant type arguments on generic invocations.</a>
* <a href='/guides/language/effective-dart/design#do-annotate-when-dart-infers-the-wrong-type'>DO annotate when Dart infers the wrong type.</a>
* <a href='/guides/language/effective-dart/design#prefer-annotating-with-dynamic-instead-of-letting-inference-fail'>PREFER annotating with <code>dynamic</code> instead of letting inference fail.</a>
* <a href='/guides/language/effective-dart/design#prefer-signatures-in-function-type-annotations'>PREFER signatures in function type annotations.</a>
* <a href='/guides/language/effective-dart/design#dont-specify-a-return-type-for-a-setter'>DON'T specify a return type for a setter.</a>
* <a href='/guides/language/effective-dart/design#dont-use-the-legacy-typedef-syntax'>DON'T use the legacy typedef syntax.</a>
* <a href='/guides/language/effective-dart/design#prefer-inline-function-types-over-typedefs'>PREFER inline function types over typedefs.</a>
* <a href='/guides/language/effective-dart/design#consider-using-function-type-syntax-for-parameters'>CONSIDER using function type syntax for parameters.</a>
* <a href='/guides/language/effective-dart/design#do-annotate-with-object-instead-of-dynamic-to-indicate-any-object-is-allowed'>DO annotate with <code>Object</code> instead of <code>dynamic</code> to indicate any object is allowed.</a>
* <a href='/guides/language/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values'>DO use <code>Future&lt;void&gt;</code> as the return type of asynchronous members that do not produce values.</a>
* <a href='/guides/language/effective-dart/design#avoid-using-futureort-as-a-return-type'>AVOID using <code>FutureOr&lt;T&gt;</code> as a return type.</a>

**Parameters**

* <a href='/guides/language/effective-dart/design#avoid-positional-boolean-parameters'>AVOID positional boolean parameters.</a>
* <a href='/guides/language/effective-dart/design#avoid-optional-positional-parameters-if-the-user-may-want-to-omit-earlier-parameters'>AVOID optional positional parameters if the user may want to omit earlier parameters.</a>
* <a href='/guides/language/effective-dart/design#avoid-mandatory-parameters-that-accept-a-special-no-argument-value'>AVOID mandatory parameters that accept a special "no argument" value.</a>
* <a href='/guides/language/effective-dart/design#do-use-inclusive-start-and-exclusive-end-parameters-to-accept-a-range'>DO use inclusive start and exclusive end parameters to accept a range.</a>

**Equality**

* <a href='/guides/language/effective-dart/design#do-override-hashcode-if-you-override-'>DO override <code>hashCode</code> if you override <code>==</code>.</a>
* <a href='/guides/language/effective-dart/design#do-make-your--operator-obey-the-mathematical-rules-of-equality'>DO make your <code>==</code> operator obey the mathematical rules of equality.</a>
* <a href='/guides/language/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes'>AVOID defining custom equality for mutable classes.</a>
* <a href='/guides/language/effective-dart/design#dont-check-for-null-in-custom--operators'>DON'T check for <code>null</code> in custom <code>==</code> operators.</a>

</div>
<div style='clear:both'></div>
