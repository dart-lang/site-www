---
title: Add elements to the DOM
description: Learn how to add created elements to the DOM.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]

nextpage:
  url: /tutorials/web/low-level-html/remove-elements
  title: Remove DOM elements
prevpage:
  url: /tutorials/web/low-level-html/connect-dart-html
  title: Connect Dart and HTML
---

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * In Dart, page elements are of type `Element`.
  * An `Element` knows its parent.
  * An `Element` keeps its children in a `List<Element>`.
  * Change the DOM by adding or removing children of elements.
  * Respond to user input with an `EventListener`.
</div>

{{site.alert.note}}
  This page uses embedded DartPads to display runnable examples.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

As you learned in the previous tutorial,
the DOM represents the structure
of a web page document using a simple tree structure.
Each node in the tree represents an item on the page.
Each node in the tree keeps track of both
its parent and its children.
In Dart, the
[`Node`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Node-class.html){:target="_blank" rel="noopener"}
class contains the methods and properties
that implement a node's tree functionality.

HTML page elements are one kind of node that can be in the DOM tree.
They have a rectangular area on the page and can receive events.
Examples of elements include
heading elements, paragraph elements, table elements,
button elements, and so on.

In Dart,
elements are implemented by the
[`Element`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Element-class.html){:target="_blank" rel="noopener"}
class, which is a subclass of `Node`.
Because the nodes you care about most are usually elements,
this tutorial focuses on `Element`,
rather than on `Node`.

## Running the Todo app {#try-app}

In this tutorial, you will be working with a sample web app
that is a partial implementation of a todo list.
This program dynamically changes the DOM,
and therefore the web page,
by adding elements to the DOM tree.

**Try it!**
Click **Run** to start the web app.
Then type in the app's text field, and press return.
The app adds an item to the list.
Enter a few items into the input field.

```dart:run-dartpad:mode-html:ga_id-running_the_todo_app:null_safety-true
{$ begin main.dart $}
import 'dart:html';

final InputElement toDoInput = querySelector('#to-do-input') as InputElement;
final UListElement toDoList = querySelector('#to-do-list') as UListElement;

void main() {
  toDoInput.onChange.listen(addToDoItem);
}

void addToDoItem(Event e) {
  final newToDo = LIElement()..text = toDoInput.value;
  toDoInput.value = '';
  toDoList.children.add(newToDo);
}
{$ end main.dart $}
{$ begin index.html $}
<h2>Procrastinator's Todo</h2>
        
<div>
  <input id="to-do-input" type="text" placeholder="What needs to be done?">
</div>
   
<div>
  <ul id="to-do-list">
  </ul>
</div>
{$ end index.html $}
{$ begin styles.css $}
body {
  font-family: 'Roboto', sans-serif;
  background-color: WhiteSmoke;
  margin: 15px;
  color: black;
}

h2 {
  color: black;
}

#to-do-input {
  font-family: 'Roboto', sans-serif;
  font-size: 14px;
  font-weight: normal;
  padding: 5px 0px 5px 5px;
  width: 100%;
  border: 1px solid Silver;
  background-color: White;
}

#to-do-list {
  padding: 0;
  margin: 0;
  list-style-position: inside;
}

#to-do-list li {
  padding: 5px 0px 5px 5px;
  border-bottom: 1px dotted Silver;
}
{$ end styles.css $}
```

This is the beginning of an app to manage a list of things to do.
Right now, this app is for procrastinators only
because the program can only add items to your to do list
but not remove them.

## About parent and child Elements in Dart {#tree-structure}

The `Node` class implements the basic treeing behavior
for nodes in the Dart DOM.
The `Element` class is a subclass of `Node` that implements
the behavior specific to page element nodes.
For example,
an element knows the width and height of
its enclosing rectangle on the page
and it can receive events.

You can manipulate the DOM tree by adding and deleting nodes.
However, many Dart apps are concerned only with page elements.
So for convenience and code simplicity,
the `Element` class implements API
for interacting with
a subset of the DOM that includes
only the nodes that are elements.
You can work with a virtual tree of elements
rather than the more complex tree of `Node` objects.
This tutorial shows you how to manipulate the
DOM through the `Element` class.

An `Element` object has a parent `Element`
and maintains references to its children elements in a list.

<img class="scale-img-max" src="/assets/img/tutorials/web/relationships.png"
     alt="An element with multiple child elements and a parent element">

An `Element` object has at most one parent `Element`.
An `Element` object's parent is final and cannot be changed.
So you cannot move an `Element` by changing its parent.
Get an `Element`'s parent with the getter `parent`.
For example, if you have an `Element` with the name `anElement`
you would refer to its parent element with `anElement.parent`.

<img class="scale-img-max" src="/assets/img/tutorials/web/parent-reference.png"
     alt="Dart code reference to anElement's parent">

An `Element` object maintains references to its child elements in a list.
[`List`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html){:target="_blank" rel="noopener"}is a class in the dart:core library
that implements an indexable collection with a length.
A list can be of fixed size or extendable.

`List` is an example of a _generic_ (or _parameterized_) type—a type
that can declare formal type parameters.
This means that a list can be declared
to contain only objects of a particular type.
For example:

| List declaration | List description |
|------------------|------------------|
| `List<String>`   | List of strings  |
| `List<int>`      | List of integers |
| `List<Element>`  | List of elements |
{: .table}

An `Element` maintains references to its child element in a `List<Element>`,
which your Dart code can refer to with the getter `children`.
The `List` class has various methods and operators
whereby you can refer to each child element individually,
iterate over the list, and add and remove elements.

<img class="scale-img-max" src="/assets/img/tutorials/web/child-references.png"
     alt="Dart code references to anElement's list of children and individual child Elements">

You can change the tree structure by adding children to
and removing children from an element's list of children.

<img class="scale-img-max" src="/assets/img/tutorials/web/add-element.png"
     alt="Add a child element">

When you change an `Element` or its child elements in your Dart program,
you change the DOM and therefore the web page.
The browser re-renders the page automatically.

## Setting up the page in HTML {#html-code}

Let's take a look at the todo app
to see how it dynamically
adds an element to the DOM
and displays a new item in the list of things to do.

The HTML code for the todo app sets up the initial HTML page,
and thereby the initial DOM tree.
You could get the same results using Dart code,
but it's usually better to define the primary page elements
in HTML code (easier to read, quicker to load).

<img class="scale-img-max" src="/assets/img/tutorials/web/todo-html.png"
     alt="todo app and its corresponding HTML code">

The following diagram shows a partial DOM tree for the todo app.

<img class="scale-img-max" src="/assets/img/tutorials/web/todo-dom.png"
     alt="The todo app and part of its DOM tree">

Of interest are the two-page elements that have IDs:
`to-do-input` and `to-do-list`.
The first identifies the `<input>` element into which the user types.
The second identifies the `<ul>` (unordered list) element
containing the task items.
Dart code adds elements to this list
whenever the user enters text into the input element.

## Getting an element from the DOM {#dart-code}

The following diagram shows
the Dart code for the todo app.

<img class="scale-img-max" src="/assets/img/tutorials/web/todo-dart.png"
     alt="todo app and its corresponding Dart code">

The top-level variables are initialized using
the `dart:html` library's top-level `querySelector()` function
to get the interesting elements from the DOM.
Because calling `querySelector()` isn't free,
if a program refers to an element more than once
it should stash a reference to the element if possible.

This program stashes a reference
to the input element
in a top-level variable called `toDoInput`.
The unordered list
is in the top-level variable `toDoList`.

Note the types of these variables: `InputElement` and `UListElement`.
These are both subclasses of `Element`.
The `dart:html` library has dozens of `Element` subclasses,
many of which correspond to certain HTML tags.
This program uses three:

| HTML tag  | Dart class                                                                                                                                |
|-----------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `<input>` | [`InputElement`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/InputElement-class.html){:target="_blank" rel="noopener"} |
| `<ul>`    | [`UListElement`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/UListElement-class.html){:target="_blank" rel="noopener"} |
| `<li>`    | [`LIElement`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/LIElement-class.html){:target="_blank" rel="noopener"}       |
{: .table}

## Registering an event handler {#event-handler}

When a user enters text into the input field,
a _change_ event fires,
indicating that the value in the input field has just changed.
The todo app defines a function, `addToDoItem()`,
that can handle these change events.
The following code connects `addToDoItem()` to the input field:

<img class="scale-img-max" src="/assets/img/tutorials/web/event-handler-todo.png"
     alt="Add an event handler to the toDoInput element">

Rather than dissect this busy line of code,
think of it as a Dart idiom
for adding an event handler to an `Element` object.

<img class="scale-img-max" src="/assets/img/tutorials/web/event-handler-idiom.png"
     alt="Dart idiom: Add an event handler to an Element">

A change event is just one of many types of events
that an input element can generate.
For example, you can use `click` to handle mouse clicks,
or `keyDown` for when the user presses a key on the keyboard.

## About EventListener functions {#about-event-listeners}

The argument passed to the `listen()` method is a _callback function_
of type
[`EventListener`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/EventListener.html){:target="_blank" rel="noopener"}.
`EventListener` is a typedef defined in the `dart:html` library as follows:

```dart
typedef void EventListener(Event event)
```

As you can see, an EventListener returns no value (`void`) and takes an
[`Event`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Event-class.html){:target="_blank" rel="noopener"}object as an argument.
Any function with this signature is an `EventListener`.
Based on its signature, the `addToDoItem()` function is an `EventListener`.

```dart
void addToDoItem(Event e) { ... }
```

The `Event` object passed into an `EventListener` function
carries information about the `Event` that occurred.
For example, the `Event` object knows which `Element` fired the event,
and when.
For location-specific events such as mouse clicks,
the `Event` object also knows where the event occurred.

The `addToDoItem()` function ignores the Event object passed to it.

## Adding an element to the DOM tree {#add-elem}

The change event handler has the following code:

<img class="scale-img-max" src="/assets/img/tutorials/web/add-element-code.png"
     alt="The addToDoItem() function explained">

The final line of code is where the DOM gets changed.

An `Element` object keeps references to all of its children
in a list called `children`.
By adding and removing elements to and from this list,
the code changes the DOM.
When the DOM changes, the browser re-renders the browser page.
The effect, in our todo app, is that a new bullet item appears
in the to do list.

## Styling the page elements {#about-css}

Let's take a look at the CSS file for this app.

<img class="scale-img-max" src="/assets/img/tutorials/web/css-code.png"
     alt="The effect of CSS styles">

This code uses three different kinds of CSS selectors.
The first is an HTML element selector that matches the `<body>` element
and sets some basic style attributes,
such as the background color,
for the entire page.
Next in the file are two ID selectors:
`#to-do-input` controls the appearance of the input field
and `#to-do-list` sets the appearance of the unordered list element
in general.
The elements in the list are controlled by the final rule,
which uses both an ID selector and an HTML selector.
This rule matches all `<li>` elements in the
element with the ID `to-do-list`, thus styling
each item in the to do list.

## Moving elements within the DOM tree {#moving-elements}

The Anagram app shows how to move an element within the DOM.

**Try it!**
Click **Run** to start the web app.
Then form a word by clicking the app's letter tiles.

```dart:run-dartpad:mode-html:ga_id-moving_elements_within_the_dom_tree
{$ begin main.dart $}
import 'dart:html';
import 'dart:math';

// Should remove tiles from here when they are selected
// otherwise the ratio is off.
const String scrabbleLetters =
    'aaaaaaaaabbccddddeeeeeeeeeeeeffggghhiiiiiiiiijkllllmmnnnnnnooooooooppqrrrrrrssssttttttuuuuvvwwxyyz**';
const Map<String, int> scrabbleValues = {
  'a': 1, 'e': 1, 'i': 1, 'l': 1, 'n': 1,
  'o': 1, 'r': 1, 's': 1, 't': 1, 'u': 1,
  'd': 2, 'g': 2, 'b': 3, 'c': 3, 'm': 3,
  'p': 3, 'f': 4, 'h': 4, 'v': 4, 'w': 4,
  'y': 4, 'k': 5, 'j': 8, 'x': 8, 'q': 10,
  'z': 10, '*': 0
};

final List<ButtonElement> buttons = [];
final Element letterpile = querySelector('#letterpile') as Element;
final Element result = querySelector('#result') as Element;
final Element value = querySelector('#value') as Element;
final ButtonElement clearButton =
    querySelector('#clear-button') as ButtonElement;
int wordValue = 0;

void main() {
  clearButton.onClick.listen(newLetters);
  generateNewLetters();
}

void moveLetter(MouseEvent e) {
  final letter = e.target;
  if (letter is! Element) {
    return;
  }
  if (letter.parent == letterpile) {
    result.children.add(letter);
    wordValue += scrabbleValues[letter.text] ?? 0;
    value.text = '$wordValue';
  } else {
    letterpile.children.add(letter);
    wordValue -= scrabbleValues[letter.text] ?? 0;
    value.text = '$wordValue';
  }
}

void newLetters(Event e) {
  letterpile.children.clear();
  result.children.clear();
  generateNewLetters();
}

void generateNewLetters() {
  final indexGenerator = Random();
  wordValue = 0;
  value.text = '0';
  buttons.clear();
  for (var i = 0; i < 7; i++) {
    final letterIndex = indexGenerator.nextInt(scrabbleLetters.length);
    // Should remove the letter from scrabbleLetters to keep the
    // ratio correct.
    final button = ButtonElement();
    button.classes.add('letter');
    button.onClick.listen(moveLetter);
    button.text = scrabbleLetters[letterIndex];
    buttons.add(button);
    letterpile.children.add(button);
  }
}
{$ end main.dart $}
{$ begin index.html $}
<h1>Anagram</h1>
    
<h3>Pile:</h3>
<div id="letterpile">
</div>
<h3>Word:</h3>
<div id="result">
</div>

<h3>Scrabble Value:</h3>
<p id="value"></p>

<button id="clear-button">New Letters</button>
{$ end index.html $}
{$ begin styles.css $}
body {
  background-color: #F8F8F8;
  font-family: 'Roboto', sans-serif;
  font-size: 14px;
  font-weight: normal;
  line-height: 1.2em;
  margin: 15px;
}

h1, h3, p {
  color: black;
}

.letter {
  width: 48px;
  height: 48px;
  font-size: 32px;
  background-color: Lavender;
  color: purple;
  border: 1px solid black;
  margin: 2px 2px 2px 2px;
}
{$ end styles.css $}
```

When the program starts,
it creates one button element for each of seven
randomly selected letters.
The program adds each button to a DOM element—a simple
`<div>` element identified by the CSS selector `letterpile`—with
a call to `letterpile.children.add()`.

<img class="scale-img-max" src="/assets/img/tutorials/web/anagram-newletters.png"
     alt="Dart code populates the letter pile with buttons">

Each button element in the letter pile
has a mouse click handler called `moveLetter()`.
If the button is in the letter pile,
the mouse click handler moves the button to the end of the word.
If the button is in the word,
the mouse click handler moves the button back to the letter pile.

To move the button from the letter pile to the word or back,
the code simply adds the button to a DOM element
that is different from the button's current parent.
Because an element can have only one parent,
adding the button to a different parent
automatically removes it from its previous parent.

<img class="scale-img-max" src="/assets/img/tutorials/web/anagram-move.png"
     alt="The mouse click handler adds the button to the word, thus moving it">

The `+=` operator is a compound assignment operator,
which combines an operation (`+`) with an assignment.

The `scrabbleValues` variable is a
[`Map`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html){:target="_blank" rel="noopener"}—a
data structure that contains key/value pairs.
Use the square bracket syntax to retrieve a value by its key
and the `length` property to get the number of pairs it contains.

## What next?

The next tutorial, [Remove DOM Elements](remove-elements),
describes how to remove elements from the DOM and items off your todo list.
