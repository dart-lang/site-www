void enableFlags({bool bold, bool hidden}) {}

void main() {
  // BEGIN(use_named_parameters)
  enableFlags(bold: true, hidden: false);
  // END(use_named_parameters)
}
