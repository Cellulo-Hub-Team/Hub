class Game {
  String name = "";
  String unityName = "";
  String companyName = "";
  String unityCompanyName = "";
  String description = "";
  String instructions = "";
  bool isInstalled = false;
  bool isInLibrary = false;
  bool isExpanded = false;
  String? androidBuild;
  String? linuxBuild;
  String? windowsBuild;
  String? webUrl;
  String? iOSBuild;
  String? macOSBuild;
  String backgroundImage = "";
  int physicalPercentage = 0;
  int cognitivePercentage = 0;
  int socialPercentage = 0;
  int celluloCount = 0;
  int downloads = 0;
  String apkName = "";

  Game(
      this.name,
      this.unityName,
      this.companyName,
      this.unityCompanyName,
      this.description,
      this.instructions,
      this.backgroundImage,
      this.androidBuild,
      this.linuxBuild,
      this.windowsBuild,
      this.webUrl,
      this.physicalPercentage,
      this.cognitivePercentage,
      this.socialPercentage,
      this.celluloCount,
      this.downloads,
      this.apkName);

  @override
  String toString() {
    return "Game name: $name";
  }
}
