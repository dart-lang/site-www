void main() {
  // Get the current date and time.
  var now = new DateTime.now();
  print(now);

  // Create a new DateTime with the local time zone.
  var y2k = new DateTime(2000); // January 1, 2000
  print(y2k);

  // Specify the month and day.
  y2k = new DateTime(2000, 1, 2); // January 2, 2000
  print(y2k);

  // Specify the date as a UTC time.
  y2k = new DateTime.utc(2000); // 1/1/2000, UTC
  print(y2k);

  // Specify a date and time in ms since the Unix epoch.
  y2k = new DateTime.fromMillisecondsSinceEpoch(946684800000, isUtc: true);
  print(y2k);

  // Parse an ISO 8601 date.
  y2k = DateTime.parse('2000-01-01T00:00:00Z');
  print(y2k);

  // 1/1/2000, UTC
  y2k = new DateTime.utc(2000);
  assert(y2k.millisecondsSinceEpoch == 946684800000);

  // 1/1/1970, UTC
  var unixEpoch = new DateTime.utc(1970);
  assert(unixEpoch.millisecondsSinceEpoch == 0);

  // Add one year.
  var y2001 = y2k.add(const Duration(days: 366));
  assert(y2001.year == 2001);

  // Subtract 30 days.
  var december2000 = y2001.subtract(const Duration(days: 30));
  assert(december2000.year == 2000);
  assert(december2000.month == 12);

  // Calculate the difference between two dates.
  // Returns a Duration object.
  var duration = y2001.difference(y2k);
  assert(duration.inDays == 366); // y2k was a leap year.
}
