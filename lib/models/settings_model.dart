class SettingsModel {

  static final String tableSettings = "Settings";
  static final String colKey = "key";
  static final String colValue = "value";

  String key;
  String value;

  SettingsModel({required this.key, required this.value});

  Map<String, dynamic> toMap() {
    return {
      colKey: key,
      colValue: value,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {

    return SettingsModel(
      key: map[colKey],
      value: map[colValue],
    );
  }

}