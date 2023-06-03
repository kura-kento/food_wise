import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:food_wise/common/shared_prefs.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:ncmb/ncmb.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class App {
  // 【共通】お問合せ
  static NCMB ncmb = NCMB('2a0564276557a6a58a342a8a2c9c5d4764eb4da3a70680f929e3ac7c96f40559', 'bc483c9060efab8b713dddc3de8c33ad692dffded369c18a3cd1e24d4dc573a9');
  static String table_name = 'Card_Manage';
  // static int graphLength = 10;
  // 【共通】リワード
  static Color NoAdsButtonColor = Color(0xffFFD865);
  static Color NoAdsButtonColorDark = Color(0xffd59e11);
  static int addHours = 40;
  static double BTNfontsize = 10;
  static double drawer_width = 300.0;

  static int infinityPage = 1000;
  //
  static Color btn_color = Colors.white;
  static Color text_color = Colors.black54;
  static Color primary_color = Color(int.parse(SharedPrefs.getCustomColor()));
  static double appbar_height = 60.0;

  static int minLines = 50;
  static double goldenRatio = 1.618;

  static bool isCamera = false;
  static bool isVisible = true; // falseで非表示
  // static int addHours = 40;
  //
  // static double BTNfontsize = 10;

  static final List<String> week = ['日', '月', '火', '水', '木', '金', '土'];
  static final weekColor = [Colors.red[200],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.blue[200]];

  static Color? plusColor = Colors.lightBlueAccent[200];
  static Color? minusColor = Colors.redAccent[200];



  //画像をパスにローカル保存
  //<key>LSSupportsOpeningDocumentsInPlace</key>
  // <true/>
  // <key>UIFileSharingEnabled</key>
  // <true/>
  static Future<void> saveImagePath(pickedFile) async{
    final directory = await getExternalStorageDirectory();
    print('ディレクトリ:${directory}');
    if (directory != null) {
      String path = join(directory.path, '${directory.path}.png');
      pickedFile.saveTo(path);
      print('ファイル保存先:${directory.path}.png');
    }
  }
  /// ローカルパスの取得
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///ダークモードかどうか
  ///true:dark, false:light
  static bool isDarkMode(BuildContext context) {
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark;
  }

  static Widget title(String title, {double fontSize = 20.0}) {
    return  Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  static Map<String, MarkdownElementBuilder> titleBuilders = {
    'a': CustomTitleBuilder(),
    'p': CustomTitleBuilder(),
    'li': CustomTitleBuilder(),
    'code': CustomTitleBuilder(),
    'pre': CustomTitleBuilder(),
    'h1': CustomTitleBuilder(),
    'h2': CustomTitleBuilder(),
    'h3': CustomTitleBuilder(),
    'h4': CustomTitleBuilder(),
    'h5': CustomTitleBuilder(),
    'h6': CustomTitleBuilder(),
    'em': CustomTitleBuilder(),
    'strong': CustomTitleBuilder(),
    'del': CustomTitleBuilder(),
    'blockquote': CustomTitleBuilder(),
    'img': CustomTitleBuilder(),
    'table': CustomTitleBuilder(),
    'th': CustomTitleBuilder(),
    'tr': CustomTitleBuilder(),
    'td': CustomTitleBuilder(),
  };

  static Map<String, MarkdownElementBuilder> subBuilders = {
    'a': CustomSubBuilder(),
    'p': CustomSubBuilder(),
    'li': CustomSubBuilder(),
    'code': CustomSubBuilder(),
    'pre': CustomSubBuilder(),
    'h1': CustomSubBuilder(),
    'h2': CustomSubBuilder(),
    'h3': CustomSubBuilder(),
    'h4': CustomSubBuilder(),
    'h5': CustomSubBuilder(),
    'h6': CustomSubBuilder(),
    'em': CustomSubBuilder(),
    'strong': CustomSubBuilder(),
    'del': CustomSubBuilder(),
    'blockquote': CustomSubBuilder(),
    'img': CustomSubBuilder(),
    'table': CustomSubBuilder(),
    'th': CustomSubBuilder(),
    'tr': CustomSubBuilder(),
    'td': CustomSubBuilder(),
  };
}

class H1 extends StatelessWidget {
  final String text;
  const H1({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
/// H1
class CustomTitleBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return H1(text: text.text);
  }
}

class Sub extends StatelessWidget {
  final String text;
  const Sub({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: const TextStyle(
        fontSize: 20 * 0.8,
        // fontWeight: FontWeight.bold,
      ),
      onSelectionChanged: (selection, cause) {
        print(cause);
      },
    );
  }
}

class CustomSubBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Sub(text: text.text);
  }
}

// コピー機能追加
class Header extends StatelessWidget {
  final String text;
  final String content;
  final int level;
  final int occurrence;
  final Function(String headerId) onCopyRequested;
  const Header({
    Key? key,
    required this.text,
    required this.level,
    required this.occurrence,//押したコピーアイコンの数値
    required this.content,
    required this.onCopyRequested
  }) : super(key: key);

  String? _extractCopyText() {
    final start = (() { //コピーボタンの押した時の初めの文字
      // 改行コードが０以上　あと　#が1~6個 +　半角スペース
      // Iterable<Match> matches = RegExp("\n{0,}#{1,6} ").allMatches(content);
      //　二行目からの文字列のインデックス
      Iterable<Match> matches = RegExp(r'(?<=\n{0,}#{1,6} .*\n).*').allMatches(content);
      if (matches.isEmpty) {
        return -1;
      }
      return matches.toList()[occurrence].start;
    })();
    if (start < 0) {
      return null;
    }
    final end = content.indexOf(RegExp("(\n{1,})#{1,$level} "), start + level);
    print('level:'+level.toString());//＃の数
    print('end:'+ end.toString());// コピーする最後の文字のインデックス
    final text = content.substring(start, end >= 0 ? end : null);
    print(text);
    // 改行コードを空白に
    return text.replaceAll(RegExp("^\n{0,}"), "");
  }

  @override
  Widget build(BuildContext context) {
    final headerId = idGenerator.generate();
    final fontSize = (() {
      switch(level) {
        case 1: return 20.0;
        case 2: return 18.0;
        case 3: return 16.0;
        case 4: return 14.0;
        case 5: return 13.0;
        case 6: return 12.0;
        default: return 12.0;
      }
    })();
    const copyButtonPaddingInset = EdgeInsets.all(16);
    return Row(
      key: Key(headerId),
      children: [
        Flexible(child:
        Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold
          ),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
        )
        ),
        const Padding(padding: copyButtonPaddingInset),
        IconButton(
            onPressed: () {
              final copyText = _extractCopyText();
              if (copyText != null) {
                onCopyRequested(copyText);
              }
            },
            icon: const Icon(Icons.copy)
        )
      ],
    );
  }
}

class CustomHeaderBuilder extends MarkdownElementBuilder {
  final int Function(String tag, String text) onHeaderFound;
  final Function(String) onCopyRequested;
  final String content;
  int occurrence = 0;
  int level = 1;

  CustomHeaderBuilder({
    required this.content,
    required this.onHeaderFound,
    required this.onCopyRequested
  });

  @override
  void visitElementBefore(md.Element element) {
    super.visitElementBefore(element);

    occurrence = onHeaderFound(element.tag, element.textContent);
  }

  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Header(
        text: text.text,
        content: content,
        occurrence: occurrence,
        level: level,
        onCopyRequested: onCopyRequested
    );
  }
}

class CustomHeader1Builder extends CustomHeaderBuilder {
  CustomHeader1Builder({onCopyRequested, onHeaderFound, content}): super(
    content: content,
    onHeaderFound: onHeaderFound,
    onCopyRequested: onCopyRequested,
  ) {
    level = 1;
  }
}

class CustomHeader2Builder extends CustomHeaderBuilder {
  CustomHeader2Builder({onCopyRequested, onHeaderFound, content}): super(
    content: content,
    onHeaderFound: onHeaderFound,
    onCopyRequested: onCopyRequested,
  ) {
    level = 2;
  }
}

class CustomHeader3Builder extends CustomHeaderBuilder {
  CustomHeader3Builder({onCopyRequested, onHeaderFound, content}): super(
    content: content,
    onHeaderFound: onHeaderFound,
    onCopyRequested: onCopyRequested,
  ) {
    level = 3;
  }
}
class CustomHeader4Builder extends CustomHeaderBuilder {
  CustomHeader4Builder({onCopyRequested, onHeaderFound, content}): super(
    content: content,
    onHeaderFound: onHeaderFound,
    onCopyRequested: onCopyRequested,
  ) {
    level = 4;
  }
}
class CustomHeader5Builder extends CustomHeaderBuilder {
  CustomHeader5Builder({onCopyRequested, onHeaderFound, content}): super(
    content: content,
    onHeaderFound: onHeaderFound,
    onCopyRequested: onCopyRequested,
  )  {
    level = 5;
  }
}
class CustomHeader6Builder extends CustomHeaderBuilder {
  CustomHeader6Builder({onCopyRequested, onHeaderFound, content}): super(
    content: content,
    onHeaderFound: onHeaderFound,
    onCopyRequested: onCopyRequested,
  ) {
    level = 6;
  }
}

final idGenerator = IdGenerator();

class IdGenerator {
  late final Uuid _uuid;

  IdGenerator() {
    _uuid = const Uuid();
  }

  String generate() => _uuid.v4();
}

// class Header extends StatefulWidget {
//   final String text;
//   final String content;
//   final int level;
//   final int occurrence;
//   final Function(String headerId) onCopyRequested;
//   const Header({
//     Key? key,
//     required this.text,
//     required this.level,
//     required this.occurrence,
//     required this.content,
//     required this.onCopyRequested
//   }) : super(key: key);
//
//   @override
//   State<Header> createState() => _HeaderState();
// }
//
// class _HeaderState extends State<Header> {
//   String? _extractCopyText() {
//     final start = (() {
//       Iterable<Match> matches = RegExp("\n{0,}#{1,6} ").allMatches(widget.content);
//       if (matches.isEmpty) {
//         return -1;
//       }
//       return matches.toList()[widget.occurrence].start;
//     })();
//     if (start < 0) {
//       return null;
//     }
//     final end = widget.content.indexOf(RegExp("(\n{1,})#{1,$widget.level} "), start + widget.level);
//     final text = widget.content.substring(start, end >= 0 ? end : null);
//     return text.replaceAll(RegExp("^\n{0,}"), "");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final headerId = idGenerator.generate();
//     final fontSize = (() {
//       switch(widget.level) {
//         case 1: return 20.0;
//         case 2: return 18.0;
//         case 3: return 16.0;
//         case 4: return 14.0;
//         case 5: return 13.0;
//         case 6: return 12.0;
//         default: return 12.0;
//       }
//     })();
//     const copyButtonPaddingInset = EdgeInsets.all(16);
//     return Row(
//       key: Key(headerId),
//       children: [
//         Flexible(child:
//         Text(
//           widget.text,
//           style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold
//           ),
//           maxLines: 1,
//           softWrap: false,
//           overflow: TextOverflow.clip,
//         )
//         ),
//         const Padding(padding: copyButtonPaddingInset),
//         IconButton(
//             onPressed: () {
//               final copyText = _extractCopyText();
//               if (copyText != null) {
//                 widget.onCopyRequested(copyText);
//               }
//             },
//             icon: const Icon(Icons.copy)
//         )
//       ],
//     );
//   }
// }
