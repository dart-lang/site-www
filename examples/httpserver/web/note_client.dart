// Copyright (c) 2014, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client to note_server.dart. This client script is used by note_taker.html.

import 'dart:html';

String note;

TextInputElement noteTextInput;
ParagraphElement howManyNotes;
TextInputElement chooseNote;
ParagraphElement displayNote;
HttpRequest request;
String url = 'http://localhost:4042';

void main() {
  noteTextInput = querySelector('#note_entry') as TextInputElement;
  howManyNotes = querySelector('#display_how_many_notes') as ParagraphElement;
  chooseNote = querySelector('#choose_note') as TextInputElement;
  displayNote = querySelector('#display_note') as ParagraphElement;

  querySelector('#save_note').onClick.listen(saveNote);
  querySelector('#get_note').onClick.listen(requestNote);
}

void saveNote(Event e) {
  request = HttpRequest();
  request.onReadyStateChange.listen(onData);

  request.open('POST', url);
  request.send('{"myNote":"${noteTextInput.value}"}');
}

void requestNote(Event e) {
  if (chooseNote.value.isEmpty) return;

  int getNoteNumber = int.tryParse(chooseNote.value) ?? 0;

  request = HttpRequest();
  request.onReadyStateChange.listen(onData);

  request.open('POST', url);
  request.send('{"getNote":"$getNoteNumber"}');
}

void onData(_) {
  if (request.readyState == HttpRequest.DONE && request.status == 200) {
    if (request.responseText.startsWith('You')) {
      howManyNotes.text = request.responseText;
    } else {
      displayNote.text = request.responseText;
    }
  } else if (request.readyState == HttpRequest.DONE && request.status == 0) {
    // Status is 0; most likely the server isn't running.
    howManyNotes.text = 'No server';
  }
}
