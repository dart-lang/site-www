void main() {
  // BEGIN(map_missing_key)
  var gifts = {'first': 'partridge'};
  assert(gifts['fifth'] == null);
  // END(map_missing_key)
}
