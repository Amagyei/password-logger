enum Flavor {
  development,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'in_house';
      case Flavor.production:
        return 'In House';
      default:
        return 'title';
    }
  }

}
