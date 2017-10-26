void executeClosed() {}
void executePending() {}
void executeApproved() {}
void executeDenied() {}
void executeOpen() {}
void executeUnknown() {}
void executeNowClosed() {}

void main() {
  switcher();
  switcheroo();
  switcherooni();
  switchItUp();
}

void switcher() {
  var command = 'OPEN';
  switch (command) {
    case 'CLOSED':
      executeClosed();
      break;
    case 'PENDING':
      executePending();
      break;
    case 'APPROVED':
      executeApproved();
      break;
    case 'DENIED':
      executeDenied();
      break;
    case 'OPEN':
      executeOpen();
      break;
    default:
      executeUnknown();
  }
}

void switcheroo() {
  var command = 'OPEN';
  switch (command) {
    case 'OPEN':
      executeOpen();
      // ERROR: Missing break causes an exception!!
      // NOTE: Added break so sample passes dart_analyzer
      break;

    case 'CLOSED':
      executeClosed();
      break;
  }
}

void switcherooni() {
  var command = 'CLOSED';
  switch (command) {
    case 'CLOSED': // Empty case falls through.
    case 'NOW_CLOSED':
      // Runs for both CLOSED and NOW_CLOSED.
      executeNowClosed();
      break;
  }
}

void switchItUp() {
  var command = 'CLOSED';
  switch (command) {
    case 'CLOSED':
      executeClosed();
      continue nowClosed;
    // Continues executing at the nowClosed label.

    nowClosed: case 'NOW_CLOSED':
      // Runs for both CLOSED and NOW_CLOSED.
      executeNowClosed();
      break;
  }
}
