---
title: Remove DOM elements
description: Learn how to remove children elements from the DOM.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]

prevpage:
  url: /tutorials/web/low-level-html/add-elements
  title: Add elements to the DOM
---

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * Use `element.remove()` to remove an element from the DOM.
  * Remove all children from an element with `element.children.clear()`.
  * Function expressions are a convenient way to define single-use functions.
  * `=>` is a shorthand syntax for defining functions that contain just one expression.
</div>


{{site.alert.note}}
    This page uses embedded DartPads to display runnable examples.
    {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

This tutorial shows you how to delete elements from the DOM.
A new and improved version of the todo app from
[the previous tutorial](add-elements)
now allows the user to delete items from the list
either one at a time, or all at once.

## Try the app

Below is a revised version
of the todo app from the previous tutorial
that allows you to delete items.

**Try it!**
Click **Run** to start the web app.
Then type in the app's input field, and press the return key;
a new item appears in the list.
Enter a few more items.
Point the mouse cursor at one of the items in the list;
the item turns red and gets slightly larger.
Click it and it disappears from the list.
Use the **Delete All** button
to remove all the items in the list at once.

```dart:run-dartpad:mode-html:ga_id-try_the_app
{$ begin main.dart $}
import 'dart:html';

final InputElement toDoInput = querySelector('#to-do-input') as InputElement;
final UListElement toDoList = querySelector('#to-do-list') as UListElement;
final ButtonElement deleteAll = querySelector('#delete-all') as ButtonElement;

void main() {
  toDoInput.onChange.listen(addToDoItem);
  deleteAll.onClick.listen((_) => toDoList.children.clear());
}

void addToDoItem(Event e) {
  final newToDo = LIElement()..text = toDoInput.value;
  newToDo.onClick.listen((_) => newToDo.remove());
  toDoInput.value = '';
  toDoList.children.add(newToDo);
}
{$ end main.dart $}
{$ begin index.html $}
<h2>Todo</h2>
        
<div>
  <input id="to-do-input" type="text" placeholder="What needs to be done?">
</div>
   
<div>
  <ul id="to-do-list">
  </ul>
</div>

<button id="delete-all" type="button" style="float:right">Delete All</button>
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

#to-do-list li:hover {
  color: blue;
  cursor: pointer;
}

#delete-all {
  margin-top: 8px;
  background-color: #F8F8F8;
  border: 1px dotted #ccc;
  border-radius: 1em;
  float: right;
}

#delete-all:hover {
  background-color: #ddd;
}
{$ end styles.css $}
```

The remaining sections describe
key aspects of the code
added to the todo app for this tutorial.
Specifically, they look at
the Dart code that removes one or more elements from the DOM
and the CSS code that makes the text blue and larger.

## Changing the appearance when cursor is over an element

As you saw, an item in the list turns blue and gets bigger
when the user points at it.
The mouse cursor also changes shape.
These visual clues are an important part of the user interface
in this example because they are the only indication to the user
that something will happen when the item is clicked.

This behavior is coded in the app's CSS file with this rule:

```css
#to-do-list li:hover {
  color: blue;
  cursor: pointer;
}
```

We've used this CSS trick
instead of providing a familiar user interface,
such as a button with an 'X' on it,
to keep the code simpler.

## Removing an element from the DOM tree

An element is removed from
the DOM when it is removed from its parent's list of children.
The
[`List`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html){:target="_blank" rel="noopener"}class provides functions for finding an item in the list
and removing it.
But, in this case,
using the element's `remove()` function
is shorter and more concise than
using functions from the `List` class.

<img class="scale-img-max" src="/assets/img/tutorials/web/remove-element.png"
     alt="Use element.remove() to remove an element from the DOM">

In the app,
the user clicks an item to delete it.
This is achieved with one line of Dart code.
When a new to do item is created,
the code registers a mouse click handler on the new element.
When the user clicks that new element,
its event handler causes the element to remove itself from the DOM
with `remove()`.

<img class="scale-img-max" src="/assets/img/tutorials/web/remove-element-code.png"
     alt="Registering an event handler to delete an item">

When the element removes itself from the DOM,
the browser re-renders the page,
and the item disappears from the to do list.

## Removing all child elements from an element

When the user clicks the **Delete All** button,
all elements are removed from the list.

<img class="scale-img-max" src="/assets/img/tutorials/web/remove-all-elements.png"
     alt="Use element.children.clear() to remove all of an element's children">

In this case, using the `List` class's `clear()` function
yields the most concise code.
Here's the code from the app
that implements the **Delete All** button.

1. The HTML code creates a button with the ID `delete-all`.
   (The CSS styles it.)

    ```html
    <button id="delete-all" type="button" style="float:right">Delete All</button>
    ```

2. The Dart code gets the button element from the DOM
   using `querySelector()` and the button's ID, `delete-all`.
   The code registers a mouse click handler on the button;
   the handler removes all of the child elements from the to do list.
   Here is all the Dart code related to the **Delete All** button.

   <img class="scale-img-max" src="/assets/img/tutorials/web/remove-all-code.png"
   alt="Remove all child elements from an Element">

## About function expressions and =>

The app uses
some interesting Dart syntax
when adding an event listener to the **Delete All** button.
The argument passed into the `listen()` function
is an example of a _function expression_,
which is a shorthand way of defining functions
and it uses the `=>` syntax to define the function concisely.
For more details,
see the language tour's coverage of
[functions](/language/functions).

<img class="scale-img-max" src="/assets/img/tutorials/web/event-listener-exp.png"
     alt="A one-line function definition">

It is equivalent to writing this:

```dart
deleteAll.onClick.listen((_) {
  toDoList.children.clear();
});
```

or even this:

```dart
...
void main() {
  ...
  deleteAll.onClick.listen(deleteAllElements);
}
void deleteAllElements(Event e) {
  toDoList.children.clear();
}
...
```

Function expressions are often used
when registering event handlers on an element
and can extend over multiple lines.
When registering event handlers,
the function must be an `EventListener`.
That is,
it returns no value and takes an `Event` object as a parameter.


## What next?

Rather than implement your web app using low-level APIs, you can leverage
existing web programming frameworks.
For more information, see the [web libraries overview](/web/libraries).

