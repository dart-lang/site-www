    {% comment %}
    This file is generated from the other files in this directory.
    To re-generate it, please run the following command from root of
    the project:

      $ dart deploy/effective-dart-rules/bin/main.dart

    {% endcomment %}
    
<div class='effective_dart--summary_column' markdown='1'>

### Style


**Identifiers**

* <a href='/guides/language/effective-dart/style#do-name-types-using-uppercamelcase'>DO name types using <code>UpperCamelCase</code>.</a>
* <a href='/guides/language/effective-dart/style#do-name-libraries-and-source-files-using-lowercase_with_underscores'>DO name libraries and source files using <code>lowercase_with_underscores</code>.</a>
* <a href='/guides/language/effective-dart/style#do-name-import-prefixes-using-lowercase_with_underscores'>DO name import prefixes using <code>lowercase_with_underscores</code>.</a>
* <a href='/guides/language/effective-dart/style#do-name-other-identifiers-using-lowercamelcase'>DO name other identifiers using <code>lowerCamelCase</code>.</a>
* <a href='/guides/language/effective-dart/style#prefer-using-lowercamelcase-for-constant-names'>PREFER using <code>lowerCamelCase</code> for constant names.</a>
* <a href='/guides/language/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words'>DO capitalize acronyms and abbreviations longer than two letters like words.</a>

**Ordering**

* <a href='/guides/language/effective-dart/style#do-place-dart-imports-before-other-imports'>DO place "dart:" imports before other imports.</a>
* <a href='/guides/language/effective-dart/style#do-place-package-imports-before-relative-imports'>DO place "package:" imports before relative imports.</a>
* <a href='/guides/language/effective-dart/style#prefer-placing-third-party-package-imports-before-other-imports'>PREFER placing "third-party" "package:" imports before other imports.</a>
* <a href='/guides/language/effective-dart/style#do-specify-exports-in-a-separate-section-after-all-imports'>DO specify exports in a separate section after all imports.</a>
* <a href='/guides/language/effective-dart/style#do-sort-sections-alphabetically'>DO sort sections alphabetically.</a>

**Formatting**

* <a href='/guides/language/effective-dart/style#do-format-your-code-using-dartfmt'>DO format your code using <code>dartfmt</code>.</a>
* <a href='/guides/language/effective-dart/style#consider-changing-your-code-to-make-it-more-formatter-friendly'>CONSIDER changing your code to make it more formatter-friendly.</a>
* <a href='/guides/language/effective-dart/style#avoid-lines-longer-than-80-characters'>AVOID lines longer than 80 characters.</a>
* <a href='/guides/language/effective-dart/style#do-use-curly-braces-for-all-flow-control-structures'>DO use curly braces for all flow control structures.</a>

</div>
<div class='effective_dart--summary_column' markdown='1'>


### Documentation


**Comments**

* <a href='/guides/language/effective-dart/documentation#do-format-comments-like-sentences'>DO format comments like sentences.</a>
* <a href='/guides/language/effective-dart/documentation#dont-use-block-comments-for-documentation'>DON'T use block comments for documentation.</a>

**Doc comments**

* <a href='/guides/language/effective-dart/documentation#do-use--doc-comments-to-document-members-and-types'>DO use <code>///</code> doc comments to document members and types.</a>
* <a href='/guides/language/effective-dart/documentation#prefer-writing-doc-comments-for-public-apis'>PREFER writing doc comments for public APIs.</a>
* <a href='/guides/language/effective-dart/documentation#consider-writing-doc-comments-for-public-libraries'>CONSIDER writing doc comments for public libraries.</a>
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
* <a href='/guides/language/effective-dart/documentation#avoid-redundantly-mentioning-types-in-doc-comments'>AVOID redundantly mentioning types in doc comments.</a>
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
* <a href='/guides/language/effective-dart/usage#dont-import-libraries-inside-the-src-directory-of-another-package'>DON'T import libraries inside the <code>src</code> directory of another package.</a>
* <a href='/guides/language/effective-dart/usage#prefer-relative-paths-when-importing-libraries-within-your-own-packages-lib-directory'>PREFER relative paths when importing libraries within your own package's <code>lib</code> directory.</a>

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
* <a href='/guides/language/effective-dart/usage#consider-using--for-short-members-whose-body-is-a-single-return-statement'>CONSIDER using <code>=&gt;</code> for short members whose body is a single return statement.</a>
* <a href='/guides/language/effective-dart/usage#dont-use-this-when-not-needed-to-avoid-shadowing'>DON'T use <code>this.</code> when not needed to avoid shadowing.</a>
* <a href='/guides/language/effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible'>DO initialize fields at their declaration when possible.</a>

**Constructors**

* <a href='/guides/language/effective-dart/usage#do-use-initializing-formals-when-possible'>DO use initializing formals when possible.</a>
* <a href='/guides/language/effective-dart/usage#dont-type-annotate-initializing-formals'>DON'T type annotate initializing formals.</a>
* <a href='/guides/language/effective-dart/usage#do-use--instead-of--for-empty-constructor-bodies'>DO use <code>;</code> instead of <code>{}</code> for empty constructor bodies.</a>
* <a href='/guides/language/effective-dart/usage#do-place-the-super-call-last-in-a-constructor-initialization-list'>DO place the <code>super()</code> call last in a constructor initialization list.</a>

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

**Classes**

* <a href='/guides/language/effective-dart/design#avoid-defining-a-one-member-abstract-class-when-a-simple-function-will-do'>AVOID defining a one-member abstract class when a simple function will do.</a>
* <a href='/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members'>AVOID defining a class that contains only static members.</a>
* <a href='/guides/language/effective-dart/design#avoid-extending-a-class-that-isnt-intended-to-be-subclassed'>AVOID extending a class that isn't intended to be subclassed.</a>
* <a href='/guides/language/effective-dart/design#do-document-if-your-class-supports-being-extended'>DO document if your class supports being extended.</a>
* <a href='/guides/language/effective-dart/design#avoid-implementing-a-class-that-isnt-intended-to-be-an-interface'>AVOID implementing a class that isn't intended to be an interface.</a>
* <a href='/guides/language/effective-dart/design#do-document-if-your-class-supports-being-used-as-an-interface'>DO document if your class supports being used as an interface.</a>
* <a href='/guides/language/effective-dart/design#avoid-mixing-in-a-class-that-isnt-intended-to-be-a-mixin'>AVOID mixing in a class that isn't intended to be a mixin.</a>
* <a href='/guides/language/effective-dart/design#do-document-if-your-class-supports-being-used-as-a-mixin'>DO document if your class supports being used as a mixin.</a>

**Constructors**

* <a href='/guides/language/effective-dart/design#prefer-defining-constructors-instead-of-static-methods-to-create-instances'>PREFER defining constructors instead of static methods to create instances.</a>
* <a href='/guides/language/effective-dart/design#consider-making-your-constructor-const-if-the-class-supports-it'>CONSIDER making your constructor <code>const</code> if the class supports it.</a>

**Members**

* <a href='/guides/language/effective-dart/design#prefer-making-fields-and-top-level-variables-final'>PREFER making fields and top-level variables <code>final</code>.</a>
* <a href='/guides/language/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties'>DO use getters for operations that conceptually access properties.</a>
* <a href='/guides/language/effective-dart/design#do-use-setters-for-operations-that-conceptually-change-properties'>DO use setters for operations that conceptually change properties.</a>
* <a href='/guides/language/effective-dart/design#dont-define-a-setter-without-a-corresponding-getter'>DON'T define a setter without a corresponding getter.</a>
* <a href='/guides/language/effective-dart/design#avoid-returning-null-from-members-whose-return-type-is-bool-double-int-or-num'>AVOID returning <code>null</code> from members whose return type is <code>bool</code>, <code>double</code>, <code>int</code>, or <code>num</code>.</a>
* <a href='/guides/language/effective-dart/design#avoid-returning-this-from-methods-just-to-enable-a-fluent-interface'>AVOID returning <code>this</code> from methods just to enable a fluent interface.</a>

**Type annotations**

* <a href='/guides/language/effective-dart/design#do-type-annotate-public-declarations-whose-type-isnt-inferred'>DO type annotate public declarations whose type isn't inferred.</a>
* <a href='/guides/language/effective-dart/design#prefer-type-annotating-private-declarations-whose-type-isnt-inferred'>PREFER type annotating private declarations whose type isn't inferred.</a>
* <a href='/guides/language/effective-dart/design#avoid-annotating-types-for-initialized-local-variables'>AVOID annotating types for initialized local variables.</a>
* <a href='/guides/language/effective-dart/design#avoid-annotating-inferrable-parameter-types-on-function-expressions'>AVOID annotating inferrable parameter types on function expressions.</a>
* <a href='/guides/language/effective-dart/design#prefer-annotating-with-dynamic-even-when-not-required'>PREFER annotating with <code>dynamic</code> even when not required.</a>
* <a href='/guides/language/effective-dart/design#avoid-annotating-with-only-function'>AVOID annotating with only <code>Function</code>.</a>
* <a href='/guides/language/effective-dart/design#dont-specify-a-return-type-for-a-setter'>DON'T specify a return type for a setter.</a>
* <a href='/guides/language/effective-dart/design#dont-use-the-legacy-typedef-syntax'>DON'T use the legacy typedef syntax.</a>
* <a href='/guides/language/effective-dart/design#prefer-inline-function-types-over-typedefs'>PREFER inline function types over typedefs.</a>
* <a href='/guides/language/effective-dart/design#consider-using-the-generalized-function-type-syntax-for-parameters'>CONSIDER using the generalized function type syntax for parameters.</a>
* <a href='/guides/language/effective-dart/design#do-annotate-with-object-instead-of-dynamic-to-indicate-any-object-is-accepted'>DO annotate with <code>Object</code> instead of <code>dynamic</code> to indicate any object is accepted.</a>

**Parameters**

* <a href='/guides/language/effective-dart/design#avoid-positional-boolean-parameters'>AVOID positional boolean parameters.</a>
* <a href='/guides/language/effective-dart/design#avoid-optional-positional-parameters-if-the-user-may-want-to-omit-earlier-parameters'>AVOID optional positional parameters if the user may want to omit earlier parameters.</a>
* <a href='/guides/language/effective-dart/design#avoid-mandatory-parameters-that-permit-nonce-values'>AVOID mandatory parameters that permit nonce values.</a>
* <a href='/guides/language/effective-dart/design#do-use-inclusive-start-and-exclusive-end-parameters-to-accept-a-range'>DO use inclusive start and exclusive end parameters to accept a range.</a>

**Equality**

* <a href='/guides/language/effective-dart/design#do-override-hashcode-if-you-override-'>DO override <code>hashCode</code> if you override <code>==</code>.</a>
* <a href='/guides/language/effective-dart/design#do-make-your--operator-obey-the-mathematical-rules-of-equality'>DO make your <code>==</code> operator obey the mathematical rules of equality.</a>
* <a href='/guides/language/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes'>AVOID defining custom equality for mutable classes.</a>
* <a href='/guides/language/effective-dart/design#dont-check-for-null-in-custom--operators'>DON'T check for <code>null</code> in custom <code>==</code> operators.</a>

</div>
<div style='clear:both'></div>
