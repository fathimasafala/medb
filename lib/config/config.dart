enum Build { testing, production, local, staging }

enum UserMode { normal, admin }

class Config {
  static const Build server = Build.testing;
  static UserMode userMode = UserMode.normal;

  static String get baseUrl {
    switch (server) {
      case Build.testing:
        return "https://testapi.medb.co.in/api/";

      case Build.production:
        return "https://testapi.medb.co.in/api/";

      case Build.local:
        return "http://00.00.0.00:0000/";
      case Build.staging:
        return "https://example.com/";
    }
  }
}
