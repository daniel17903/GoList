class BackendUrl {
  static String httpUrl() => const String.fromEnvironment("ENV") == "dev"
      ? "http://127.0.0.1:8000"
      : "https://golist.ge1ger.de";

  static String websocketUrl() => const String.fromEnvironment("ENV") == "dev"
      ? "ws://127.0.0.1:8000"
      : "wss://golist.ge1ger.de";
}
