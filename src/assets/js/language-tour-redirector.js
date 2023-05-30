const oldToNew = {
    'a-basic-dart-program': '/language',
    'important-concepts': '/language#important-concepts',
    'keywords': '/language/keywords',
    'variables': '/language/variables',
    'default-value': '/language/variables#default-value',
    'late-variables': '/language/variables#late-variables',
    'final-and-const': '/language/variables#final-and-const',
    'built-in-types': '/language/built-in-types',
    'numbers': '/language/built-in-types#numbers',
    'strings': '/language/built-in-types#strings',
    'booleans': '/language/built-in-types#booleans',
    'lists': '/language/collections#lists',
    'trailing-comma': '/language/collections#trailing-comma',
    'trailing-commas': '/language/collections#trailing-comma',
    'spread-operator': '/language/collections#spread-operators',
    'spread-operators': '/language/collections#spread-operators',
    'collection-operators': '/language/collections#control-flow-operators',
    'sets': '/language/collections#sets',
    'maps': '/language/collections#maps',
    'characters': '/language/built-in-types#runes-and-grapheme-clusters',
    'runes-and-grapheme-clusters': '/language/built-in-types#runes-and-grapheme-clusters',
    'symbols': '/language/built-in-types#symbols',
    'functions': '/language/functions',
    'parameters': '/language/functions#parameters',
    'named-parameters': '/language/functions#named-parameters',
    'default-parameters': '/language/functions#default-parameters',
    'optional-positional-parameters': '/language/functions#optional-positional-parameters',
    'main': '/language/functions#the-main-function',
    'the-main-function': '/language/functions#the-main-function',
    'functions-as-first-class-objects': '/language/functions#functions-as-first-class-objects',
    'anonymous-functions': '/language/functions#anonymous-functions',
    'lexical-scope': '/language/functions#lexical-scope',
    'lexical-closures': '/language/functions#lexical-closures',
    'testing-functions-for-equality': '/language/functions#testing-functions-for-equality',
    'return-values': '/language/functions#return-values',
    'operators': '/language/operators',
    'arithmetic-operators': '/language/operators#arithmetic-operators',
    'equality-and-relational-operators': '/language/operators#equality-and-relational-operators',
    'type-test-operators': '/language/operators#type-test-operators',
    'assignment-operators': '/language/operators#assignment-operators',
    'logical-operators': '/language/operators#logical-operators',
    'bitwise-and-shift-operators': '/language/operators#bitwise-and-shift-operators',
    'conditional-expressions': '/language/operators#conditional-expressions',
    'conditional-operators': '/language/operators#conditional-expressions',
    'cascade': '/language/operators#cascade-notation',
    'cascade-notation': '/language/operators#cascade-notation',
    'other-operators': '/language/operators#other-operators',
    'control-flow': '/language/branches',
    'control-flow-statements': '/language/branches',
    'if-and-else': '/language/branches#if',
    'for-loops': '/language/loopsw#for-loops',
    'while-and-do-while': '/language/loops#while-and-do-while',
    'break-and-continue': '/language/loops#break-and-continue',
    'switch-and-case': '/language/branches#switch',
    'assert': '/language/error-handling#assert',
    'exceptions': '/language/error-handling#exceptions',
    'throw': '/language/error-handling#throw',
    'catch': '/language/error-handling#catch',
    'finally': '/language/error-handling#finally',
    'classes': '/language/classes',
    'using-class-members': '/language/classes#using-class-members',
    'using-constructors': '/language/classes#using-constructors',
    'getting-an-objects-type': '/language/classes#getting-an-objects-type',
    'instance-variables': '/language/classes#instance-variables',
    'constructors': '/language/constructors',
    'initializing-formal-parameters': '/language/constructors#initializing-formal-parameters',
    'default-constructors': '/language/constructors#default-constructors',
    'constructors-arent-inherited': '/language/constructors#constructors-arent-inherited',
    'named-constructors': '/language/constructors#named-constructors',
    'invoking-a-non-default-superclass-constructor': '/language/constructors#invoking-a-non-default-superclass-constructor',
    'super-parameters': '/language/constructors#super-parameters',
    'initializer-list': '/language/constructors#initializer-list',
    'redirecting-constructors': '/language/constructors#redirecting-constructors',
    'constant-constructors': '/language/constructors#constant-constructors',
    'factory-constructors': '/language/constructors#factory-constructors',
    'methods': '/language/methods',
    'instance-methods': '/language/methods#instance-methods',
    '_operators': '/language/methods#operators',
    'getters-and-setters': '/language/methods#getters-and-setters',
    'abstract-methods': '/language/methods#abstract-methods',
    'abstract-classes': '/language/class-modifiers#abstract',
    'interfaces': '/language/classes#implicit-interfaces',
    'implicit-interfaces': '/language/classes#implicit-interfaces',
    'extend': '/language/extend',
    'extending-a-class': '/language/extend',
    'overridable-operators': '/language/extend#overriding-members',
    'overridable-members': '/language/extend#overriding-members',
    'nosuchmethod': '/language/extend#nosuchmethod',
    'extension-methods': '/language/extension-methods',
    'enums': '/language/enums',
    'enumerated-types': '/language/enums',
    'declaring-simple-enums': '/language/enums#declaring-simple-enums',
    'declaring-enhanced-enums': '/language/enums#declaring-enhanced-enums',
    'using-enums': '/language/enums#using-enums',
    'mixin': '/language/mixins',
    'mixins': '/language/mixins',
    'adding-features-to-a-class-mixins': '/language/mixins',
    'class-variables-and-methods': '/language/classes#class-variables-and-methods',
    'static-variables': '/language/classes#static-variables',
    'static-methods': '/language/classes#static-methods',
    'generics': '/language/generics',
    'why-use-generics': '/language/generics#why-use-generics',
    'using-collection-literals': '/language/generics#using-collection-literals',
    'using-parameterized-types-with-constructors': '/language/generics#using-parameterized-types-with-constructors',
    'generic-collections-and-the-types-they-contain': '/language/generics#generic-collections-and-the-types-they-contain',
    'restricting-the-parameterized-type': '/language/generics#restricting-the-parameterized-type',
    'using-generic-methods': '/language/generics#using-generic-methods',
    'libraries': '/language/libraries',
    'libraries-and-visibility': '/language/libraries',
    'specifying-a-library-prefix': '/language/libraries#specifying-a-library-prefix',
    'importing-only-part-of-a-library': '/language/libraries#importing-only-part-of-a-library',
    'deferred-loading': '/language/libraries#lazily-loading-a-library',
    'lazily-loading-a-library': '/language/libraries#lazily-loading-a-library',
    'library-directive': '/language/libraries#library-directive',
    'the-library-directive': '/language/libraries#library-directive',
    'implementing-libraries': '/language/libraries#implementing-libraries',
    'async': '/language/async',
    'asynchrony': '/language/async',
    'asynchrony-support': '/language/async',
    'await': '/language/async#handling-futures',
    'handling-futures': '/language/async#handling-futures',
    'declaring-async-functions': '/language/async#declaring-async-functions',
    'await-for': '/language/async#handling-streams',
    'handling-streams': '/language/async#handling-streams',
    'generator': '/language/functions#generators',
    'generators': '/language/functions#generators',
    'callable-classes': '/language/callable-objects',
    'isolates': '/language/concurrency',
    'typedefs': '/language/typedefs',
    'metadata': '/language/metadata',
    'comments': '/language/comments',
    'single-line-comments': '/language/comments#single-line-comments',
    'multi-line-comments': '/language/comments#multi-line-comments',
    'documentation-comments': '/language/comments#documentation-comments',
};

function toDefault() {
    window.location.replace('/language');
}

function handleRedirect() {
    const rawOldFragment = window.location.hash;

    // If no fragment was specified, go to 'Dart introduction' page.
    if (!rawOldFragment) {
        toDefault();
        return;
    }

    const oldFragmentWithHash = rawOldFragment.trim().toLowerCase();

    // If the fragment is empty, go to 'Dart introduction' page.
    if (oldFragmentWithHash.length === 0) {
        toDefault();
        return;
    }

    const oldFragment = oldFragmentWithHash.substring(1);

    // If the fragment did not exist, go to 'Dart introduction' page.
    if (!(oldFragment in oldToNew)) {
        toDefault();
        return;
    }

    const newDestination = oldToNew[oldFragment];

    // If the desired destination exists, go there.
    // Otherwise, go to 'Dart introduction' page.
    fetch(newDestination)
        .then((response) => {
            if (response.status === 200) {
                window.location.replace(newDestination);
            } else {
                toDefault();
            }
        }).catch((_) => toDefault());
}

const currentLocation = window.location.href;

if (currentLocation.includes('language-tour')) {
    handleRedirect();
}
