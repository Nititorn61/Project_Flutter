class COStringHelper {
  static int minuteStringToInt(String string) {
    return int.parse(string.split(" ").first);
  }
}
