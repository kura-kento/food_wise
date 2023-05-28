//数量の単位
enum Unit {
  piece, // 1個
  g, // 1g
  ml, // 1ml
}

// 名前を呼び出す
extension UnitExtension on Unit {
  static final names = {
    Unit.piece: '個', // 1個
    Unit.g: 'g', // 1g
    Unit.ml: 'ml', // 1ml
  };

  String? get typeName => names[this];
}

class UnitMap {
  static Volume manualVolume = Volume('入力', null);
  static Map<String, List> volumeMap = {
    'piece' : [
      Volume('入力', null),
      Volume('1', 1),
      Volume('2', 2),
      Volume('5', 5),
      Volume('1/2', 0.50),
      Volume('1/4', 0.250),
      Volume('1/8', 0.125),
      Volume('1/10', 0.10),
    ],
    'g' : [
      Volume('入力', null),
      Volume('50', 50),
      Volume('100', 100),
      Volume('200', 200),
      Volume('500', 500),
    ],
    'ml' : [
      Volume('入力', null),
      Volume('50', 50),
      Volume('100', 100),
      Volume('200', 200),
      Volume('500', 500),

      // Volume('100', 100),
      // Volume('500', 500),
      // Volume('10', 10),
      // Volume('50', 50),
      // Volume('1', 1),
      // Volume('5', 5),
      // Volume('1000', 1000),

    ],
  };

  static Unit toUnit(String name) {
    switch(name) {
      case 'piece':
        return Unit.piece;
      case 'g':
        return Unit.g;
      case 'ml':
        return Unit.ml;
    }
    return Unit.piece;
  }
}

class Volume {
  Volume(
      this.name,
      this.volume,
  );
  String? name;
  double? volume;
}

