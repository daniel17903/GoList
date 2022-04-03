class BackendUrl {
  static String httpUrl() => const String.fromEnvironment("ENV") == "dev"
      ? "http://127.0.0.1:8000"
      : "https://${const String.fromEnvironment("BACKEND")}";

  static String websocketUrl() => const String.fromEnvironment("ENV") == "dev"
      ? "ws://127.0.0.1:8000"
      : "wss://${const String.fromEnvironment("BACKEND")}";
}
