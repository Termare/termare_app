import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class SettingInfo {
  SettingInfo({
    this.bufferLine,
    this.enableUtf8,
    this.bellWhenEscapeA,
    this.vibrationWhenEscapeA,
    this.repository,
    this.cmdLine,
    this.initCmd,
    this.termType,
    this.fontSize,
    this.fontFamily,
    this.termStyle,
  });

  factory SettingInfo.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : SettingInfo(
          bufferLine: asT<int>(jsonRes['bufferLine']),
          enableUtf8: asT<bool>(jsonRes['enableUtf8']),
          bellWhenEscapeA: asT<bool>(jsonRes['bellWhenEscapeA']),
          vibrationWhenEscapeA: asT<bool>(jsonRes['vibrationWhenEscapeA']),
          repository: asT<String>(jsonRes['repository']),
          cmdLine: asT<String>(jsonRes['cmdLine']),
          initCmd: asT<String>(jsonRes['initCmd']),
          termType: asT<String>(jsonRes['termType']),
          fontSize: asT<int>(jsonRes['fontSize']),
          fontFamily: asT<String>(jsonRes['fontFamily']),
          termStyle: asT<String>(jsonRes['termStyle']),
        );

  int bufferLine;
  bool enableUtf8;
  bool bellWhenEscapeA;
  bool vibrationWhenEscapeA;
  String repository;
  String cmdLine;
  String initCmd;
  String termType;
  int fontSize;
  String fontFamily;
  String termStyle;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bufferLine': bufferLine,
        'enableUtf8': enableUtf8,
        'bellWhenEscapeA': bellWhenEscapeA,
        'vibrationWhenEscapeA': vibrationWhenEscapeA,
        'repository': repository,
        'cmdLine': cmdLine,
        'initCmd': initCmd,
        'termType': termType,
        'fontSize': fontSize,
        'fontFamily': fontFamily,
        'termStyle': termStyle,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
