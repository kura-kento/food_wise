import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTags extends StatefulWidget {
  CustomTags({Key? key, required this.title, required this.tags, required this.selected,
    // required this.onTap
  }) : super(key: key);
  String title;
  List tags;
  var selected;
  // GestureTapCallback? onTap;

  @override
  State<CustomTags> createState() => _CustomTagsState();
}

class _CustomTagsState extends State<CustomTags> {
  EdgeInsets formPadding = const EdgeInsets.only(top:10.0, left:10.0, right:10.0);
  var selectTag;
  late var tags;
  @override
  void initState() {
    selectTag = widget.selected;
    tags = widget.tags;
    print(widget.tags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: formPadding,
      child: Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('${widget.title}：'),
          ),
          ...(selectTag != null ? [widget.selected] : tags).map((food) {
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              onTap: () {
                if(selectTag == food) {
                  selectTag = null;
                } else {
                  selectTag = food;
                }
                setState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  border: Border.all(
                    width: 2,
                    color: Colors.pink,
                  ),
                  color: selectTag?.id == food?.id ? Colors.pink : null,
                ),
                child: Text(
                  food?.foodName ?? '',
                  style: TextStyle(
                    color: selectTag?.id == food?.id ? Colors.white : Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
