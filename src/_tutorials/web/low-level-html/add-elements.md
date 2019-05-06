---
title: "Add elements to the DOM"
description: "You have an Element object, now what?"

nextpage:
  url: /tutorials/web/low-level-html/remove-elements
  title: "Remove DOM elements"
prevpage:
  url: /tutorials/web/low-level-html/connect-dart-html
  title: "Connect Dart & HTML"
---

{% comment %}
NOTE: No sample_links section goes here because all the samples are in embedded
DartPads.
{% endcomment %}

<div class="panel" markdown="1">

#### <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?

* In Dart, page elements are of type Element.
* An Element knows its parent.
* An Element keeps its children in a List &lt;Element&gt;.
* Change the DOM by adding or removing children of elements.
* Respond to user input with an EventListener.

</div>

As you learned in the previous tutorial,
the DOM represents the structure
of a web page document using a simple tree structure.
Each node in the tree represents an item on the page.
Each node in the tree keeps track of both
its parent and its children.
In Dart, the
<a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Node-class.html" target="_blank" rel="noopener">Node</a>
class contains the methods and properties
that implement a node's tree functionality.

HTML page elements are one kind of node that can be in the DOM tree.
They have a rectangular area on the page and can receive events.
Examples of elements include
heading elements, paragraph elements, table elements,
button elements, and so on.

In Dart,
elements are implemented by the
<a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Element-class.html" target="_blank" rel="noopener">Element</a>
class, which is a subclass of Node.
Because the nodes you care about most are usually elements,
this tutorial focuses on Element,
rather than on Node.

## Running the Todo app {#try-app}

In this tutorial, you will be working with a sample web app
that is a partial implementation of a todo list.
This program dynamically changes the DOM,
and therefore the web page,
by adding elements to the DOM tree.

**Try it!**
Click run ( {% asset red-run.png %} ) to start the web app.
Then type in the app's text field, and press return.
The app adds an item to the list.
Enter a few items into the input field.

Example goes here...

<!-- need to fix this section, not working properly -->
<!-- https://gist.github.com/Sfshaza/65c90ff6b078c332d4b6

main.dart:
// Copyright (c) 2012, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';

InputElement toDoInput;
UListElement toDoList;

void main() {
  toDoInput = querySelector('#to-do-input');
  toDoList = querySelector('#to-do-list');
  toDoInput.onChange.listen(addToDoItem);
}

void addToDoItem(Event e) {
  var newToDo = new LIElement();
  newToDo.text = toDoInput.value;
  toDoInput.value = '';
  toDoList.children.add(newToDo);
} -->

<!-- <iframe
src="{{site.custom.dartpad.embed-html-prefix}}?id=65c90ff6b078c332d4b6&horizontalRatio=60&verticalRatio=80"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>-->

This is the beginning of an app to manage a list of things to do.
Right now, this app is for procrastinators only
because the program can only add items to your to do list
but not remove them.

## About parent and child Elements in Dart {#tree-structure}

The Node class in Dart implements the basic treeing behavior
for nodes in the Dart DOM.
The Element class is a subclass of Node that implements
the behavior specific to page element nodes.
For example,
an element knows the width and height of
its enclosing rectangle on the page
and it can receive events.

You can manipulate the DOM tree by adding and deleting nodes.
However, many Dart apps are concerned only with page elements.
So for convenience and code simplicity,
the Element class implements API
for interacting with
a subset of the DOM that includes
only the nodes that are Elements.
You can work with a virtual tree of Elements
rather than the more complex tree of Nodes.
This tutorial shows you how to manipulate the
DOM through the Element class.

An Element has a parent Element
and maintains references to its child Elements in a list.

<img class="scale-img-max" src="/tutorials/web/images/relationships.png"
     alt="An element with multiple child elements and a parent element">

An Element has at most one parent Element.
An Element's parent is final and cannot be changed.
So you cannot move an Element by changing its parent.
Get an Element's parent with the getter `parent`.
For example, if you have an Element with the name `anElement`
you would refer to its parent element with `anElement.parent`.

<img class="scale-img-max" src="/tutorials/web/images/parent-reference.png"
     alt="Dart code reference to anElement's parent">

An Element maintains references to its child elements in a list.
<a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html" target="_blank" rel="noopener">List</a>
is a class in the dart:core library
that implements an indexable collection with a length.
A list can be of fixed size or extendable.

List is an example of a _generic_ (or _parameterized_) type&mdash;a type
that can declare formal type parameters.
This means that a list can be declared
to contain only objects of a particular type.
For example:

| List declaration | List description|
|---|---|
| List\<String> | list of strings |
| List\<int> | list of integers |
| List\<Element> | list of elements|
{: .table}

An Element maintains references to its child element in a List\<Element>,
which your Dart code can refer to with the getter `children`.
The List class has various methods and operators
whereby you can refer to each child Element individually,
iterate over the list, and add and remove elements.

<img class="scale-img-max" src="/tutorials/web/images/child-references.png"
     alt="Dart code references to anElement's list of children and individual child Elements">

You can change the tree structure by adding children to
and removing children from an Element's list of children.

<img class="scale-img-max" src="/tutorials/web/images/add-element.png"
     alt="Add a child element">

When you change an Element or its child Elements in your Dart program,
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

<img class="scale-img-max" src="/tutorials/web/images/todo-html.png"
     alt="todo app and its corresponding HTML code">

The following diagram shows a partial DOM tree for the todo app.

<img class="scale-img-max" src="/tutorials/web/images/todo-dom.png"
     alt="The todo app and part of its DOM tree">

Of interest are the two page elements that have IDs:
`to-do-input` and `to-do-list`.
The first identifies the &lt;input&gt; element into which the user types.
The second identifies the &lt;ul&gt; (unordered list) element
containing the task items.
Dart code adds elements to this list
whenever the user enters text into the input element.

## Getting an element from the DOM {#dart-code}

The following diagram shows
the Dart code for the todo app.

<img class="scale-img-max" src="/tutorials/web/images/todo-dart.png"
     alt="todo app and its corresponding Dart code">

The main() function uses dart:html's top-level querySelector()
function to get the interesting elements from the DOM.
Because calling querySelector() isn't free,
if a program refers to an element more than once
it should stash a reference to the element.

This program stashes a reference
to the input element
in a top-level variable called `toDoInput`.
The unordered list
is in the top-level variable `toDoList`.

Note the types of these variables: InputElement and UListElement.
These are both subclasses of Element.
The dart:html library has dozens of Element subclasses,
many of which correspond to certain HTML tags.
This program uses three:

| HTML tag | Dart class |
|---|---|
| \<input> | <a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/InputElement-class.html" target="_blank" rel="noopener">InputElement</a> |
| \<ul> | <a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/UListElement-class.html" target="_blank" rel="noopener">UListElement</a> |
| \<li> | <a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/LIElement-class.html" target="_blank" rel="noopener">LIElement</a> |
{: .table}

## Registering an event handler {#event-handler}

When a user enters text into the input field,
a _change_ event fires,
indicating that the value in the input field has just changed.
The todo app defines a function, addToDoItem(),
that can handle these change events.
The following code connects addToDoItem() to the input field:

<img class="scale-img-max" src="/tutorials/web/images/event-handler-todo.png"
     alt="Add an event handler to the toDoInput element">

Rather than dissect this busy line of code,
think of it as a Dart idiom
for adding an event handler to an Element.

<img class="scale-img-max" src="/tutorials/web/images/event-handler-idiom.png"
     alt="Dart idiom: Add an event handler to an Element">

A change event is just one of many different types of events
that an input element can generate.
For example, you can use `click` to handle mouse clicks,
or `keyDown` for when the user presses a key on the keyboard.

## About EventListener functions {#about-event-listeners}

The argument passed to the listen() method is a _callback function_
of type
<a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/EventListener.html" target="_blank" rel="noopener">EventListener</a>.
EventListener is a typedef defined in the dart:html library as follows:

{% prettify dart %}
typedef void EventListener(Event event)
{% endprettify %}

As you can see, an EventListener returns no value (void) and takes an
<a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Event-class.html" target="_blank" rel="noopener">Event</a>
object as an argument.
Any function with this signature is an EventListener.
Based on its signature, the addToDoItem() function is an EventListener.

{% prettify dart %}
void addToDoItem(Event e) { ... }
{% endprettify %}

The Event object passed into an EventListener function
carries information about the Event that occurred.
For example, the Event object knows which Element fired the event,
and when.
For location-specific events such as mouse clicks,
the Event object also knows where the event occurred.

The addToDoItem() function ignores the Event object passed to it.

## Adding an element to the DOM tree {#add-elem}

The change event handler has the following code:

<img class="scale-img-max" src="/tutorials/web/images/add-element-code.png"
     alt="The addToDoItem() function explained">

The final line of code is where the DOM gets changed.

An Element keeps references to all of its children in a list called `children`.
By adding and removing elements to and from this list,
the code changes the DOM.
When the DOM changes, the browser re-renders the browser page.
The effect, in our todo app, is that a new bullet item appears
in the to do list.

## Styling the page elements {#about-css}

Let's take a look at the CSS file for this app.

<img class="scale-img-max" src="/tutorials/web/images/css-code.png"
     alt="The effect of CSS styles">

This code uses three different kinds of CSS selectors.
The first is an HTML element selector that matches the \<body> element
and sets some basic style attributes,
such as the background color,
for the entire page.
Next in the file are two ID selectors:
#to-do-input controls the appearance of the input field
and #to-do-list sets the appearance of the unordered list element
in general.
The elements in the list are controlled by the final rule,
which uses both an ID selector and an HTML selector.
This rule matches all \<li> elements in the
element with the ID to-do-list, thus styling
each item in the to do list.

## Moving elements within the DOM tree {#moving-elements}

The Anagram app shows how to move an element within the DOM.

**Try it!**
Click run ( {% asset red-run.png %} ) to start the web app.
Then form a word by clicking the app's letter tiles.
You might prefer to
<a href="{{site.custom.dartpad.direct-link}}/0532bfcb70bf5e4a900c" target="_blank" rel="noopener">open
the app in DartPad</a>
to have more space for the app's code and UI.

{% comment %}
https://gist.github.com/Sfshaza/0532bfcb70bf5e4a900c

main.dart:
// Copyright (c) 2012, the Dart project authors.  Please see the
// AUTHORS file for details. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';
import 'dart:math';

// Should remove tiles from here when they are selected otherwise
// the ratio is off.

String scrabbleLetters = 'aaaaaaaaabbccddddeeeeeeeeeeeeffggghhiiiiiiiiijkllllmmnnnnnnooooooooppqrrrrrrssssttttttuuuuvvwwxyyz**';

List<ButtonElement> buttons = new List();
Element letterpile;
Element result;
ButtonElement clearButton;
Element value;
int wordvalue = 0;

Map scrabbleValues = { 'a':1, 'e':1, 'i':1, 'l':1, 'n':1,
                       'o':1, 'r':1, 's':1, 't':1, 'u':1,
                       'd':2, 'g':2, 'b':3, 'c':3, 'm':3,
                       'p':3, 'f':4, 'h':4, 'v':4, 'w':4,
                       'y':4, 'k':5, 'j':8, 'x':8, 'q':10,
                       'z':10, '*':0 };

void main() {
  letterpile = querySelector("#letterpile");
  result = querySelector("#result");
  value = querySelector("#value");

  clearButton = querySelector("#clearButton");
  clearButton.onClick.listen(newletters);

  generateNewLetters();
}

void moveLetter(Event e) {
  Element letter = e.target;
  if (letter.parent == letterpile) {
    result.children.add(letter);
    wordvalue += scrabbleValues[letter.text];
    value.text = "$wordvalue";
  } else {
    letterpile.children.add(letter);
    wordvalue -= scrabbleValues[letter.text];
    value.text = "$wordvalue";
  }
}

void newletters(Event e) {
  letterpile.children.clear();
  result.children.clear();
  generateNewLetters();
}

generateNewLetters() {
  Random indexGenerator = new Random();
  wordvalue = 0;
  value.text = '';
  buttons.clear();
  for (var i = 0; i < 7; i++) {
    int letterIndex =
        indexGenerator.nextInt(scrabbleLetters.length);
    // Should remove the letter from scrabbleLetters to keep the
    // ratio correct.
    buttons.add(new ButtonElement());
    buttons[i].classes.add("letter");
    buttons[i].onClick.listen(moveLetter);
    buttons[i].text = scrabbleLetters[letterIndex];
    letterpile.children.add(buttons[i]);
  }
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-html-prefix}}?id=0532bfcb70bf5e4a900c&horizontalRatio=70&verticalRatio=80"
    width="100%"
    height="600px"
    style="border: 1px solid #ccc;">
</iframe>

When the program starts,
it creates one button element for each of seven
randomly selected letters.
The program adds each button to a DOM element&mdash;a simple
&lt;div&gt; element identified by the CSS selector `letterpile`&mdash;with
a call to letterpile.children.add().

<img class="scale-img-max" src="/tutorials/web/images/anagram-newletters.png"
     alt="Dart code populates the letter pile with buttons">

Each button element in the letter pile
has a mouse click handler called moveLetter().
If the button is in the letterpile,
the mouse click handler moves the button to the end of the word.
If the button is in the word,
the mouse click handler moves the button back to the letter pile.

To move the button from the letter pile to the word or back,
the code simply adds the button to a DOM element
that is different from the button's current parent.
Because an element can have only one parent,
adding the button to a different parent
automatically removes it from its previous parent.

<img class="scale-img-max" src="/tutorials/web/images/anagram-move.png"
     alt="The mouse click handler adds the button to the word, thus moving it">

The `+=` operator is a compound assignment operator,
which combines an operation (`+`) with an assignment.

The `scrabbleValues` variable is a
<a href="{{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html" target="_blank" rel="noopener">Map</a>&mdash;a
data structure that contains key/value pairs.
Use the square bracket syntax to retrieve a value by its key
and the `length` property to get the number of pairs it contains.

## Other resources

<ul>
  <li>
    You can find more information about the DOM and CSS in the
    <a href="/guides/language/language-tour">language tour</a>,
    which also provides thorough coverage of the Dart language.
  </li>
</ul>

## What next?

The next tutorial, [Remove DOM Elements](remove-elements),
describes how to remove elements from the DOM and items off your todo list.
