import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_wise/common/shared_prefs.dart';

import '../main.dart';

class SelectDialog extends StatefulWidget {
  const SelectDialog({Key? key}) : super(key: key);

  @override
  _SelectDialogState createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.all(15.0),
        child: const Center(
          child: Text(
            '広告の位置',
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
          ),
        ),
      ) ,
      onTap: (){
        AddPositionDialog(context);
      },
    );
  }

  void AddPositionDialog(context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('選択してください'),
        // message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('上に変更'),
            onPressed: () {
              SharedPrefs.setAdPositionTop(true);
              Navigator.pop(context);
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('下に変更'),
            onPressed: () {
              SharedPrefs.setAdPositionTop(false);
              Navigator.pop(context);
              RestartWidget.restartApp(context);
            },
          )
        ],
      ),
    );
  }
}
