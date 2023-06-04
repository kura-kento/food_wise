import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app.dart';

class CustomAppBar extends StatefulWidget {
   CustomAppBar({
     Key? key,
     this.title,
     this.leftButton,
     this.rightButton,
     this.onTap,
     this.color,
     this.fontColor,
   }) : super(key: key);

  String? title;
  Widget? leftButton;
  Widget? rightButton;
  Color? color;
  Color? fontColor;

  void Function()? onTap;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: App.appbar_height,
      color:  widget.color ?? App.primary_color,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: widget.leftButton
                ??
            Container()
          ),
          Expanded(
            flex: 5,
            child: InkWell(
                onTap: widget.onTap ?? () => {},
                child: Center(child: App.title(widget.title ?? '', widget.fontColor),),
            ),
          ),
          Expanded(
            flex: 1,
            child: widget.rightButton
                ??
            Container()
          ),
        ],
      ),
    );
  }
}
