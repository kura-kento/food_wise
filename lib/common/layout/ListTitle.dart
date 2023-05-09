import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTitle extends StatelessWidget {
  CustomListTitle({Key? key, required this.title, this.subtitle, this.color, required this.onTap}) : super(key: key);

  // this.leading;
  String title;
  String? subtitle;
  Color? color;
  GestureTapCallback onTap;
  // this.trailing;
  @override
  Widget build(BuildContext context) {
    double padding = 8.0;
    
    return Container(
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerLeft, //任意のプロパティ
              // width: double.infinity,
              padding: EdgeInsets.all(padding),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.centerLeft, //任意のプロパティ
                // width: double.infinity,
                padding: EdgeInsets.only(top: 0,bottom: padding,left: padding, right: padding),
                child: Text(
                  subtitle ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TextOverflow.clip : はみ出した文字は隠す
// TextOverflow.ellipsis : はみ出した文字を「・・・」で隠す
// TextOverflow.fade : はみ出した文字をフェードで隠す
