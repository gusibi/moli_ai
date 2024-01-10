int timestampNow() {
  DateTime now = DateTime.now();
  int timestamp = now.second;
  return timestamp;
}
