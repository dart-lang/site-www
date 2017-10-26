void main() {
  // BEGIN(specify_default_values)
  /// Sets the [bold] and [hidden] flags to the values you
  /// specify, defaulting to false.
  void enableFlags({bool bold = false, bool hidden = false}) {
    // ...
  }

  // bold will be true; hidden will be false.
  enableFlags(bold: true);
  // END(specify_default_values)
}
