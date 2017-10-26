void main() {
  // BEGIN(map_length)
  var gifts = {'first': 'partridge'};
  gifts['fourth'] = 'calling birds';
  assert(gifts.length == 2);
  // END(map_length)
}
