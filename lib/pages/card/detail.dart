import 'dart:io';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../common/abmob/admob_banner.dart';
import '../../common/app.dart';
import '../../common/layout/appbar.dart';
import 'package:flutter/services.dart';

import 'form.dart';



class CardDetail extends StatefulWidget {
  CardDetail({Key? key, required this.listMap}) : super(key: key);
  Map? listMap;

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  late SetCards card;
  double padding = 12.0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  FlipCardController flipCardController = FlipCardController();

  @override
  void initState() {
    card = SetCards(frontPath: widget.listMap!['frontPath'], backPath: widget.listMap!['backPath']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BannerBody(
        child: Scaffold(
          body: GestureDetector(
            onTap: () { FocusScope.of(context).requestFocus(FocusNode()); print("tap");},
            child: Visibility(
              visible: App.isVisible,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // アップバー
                      CustomAppBar(
                          title: widget.listMap!['list_title'] ?? '',
                          leftButton: IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: App.btn_color),
                            onPressed: () { Navigator.of(context).pop(); },
                          ),
                      ),
                      Container(
                        padding: EdgeInsets.all(padding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          /*
                           * カード
                           */
                            Expanded(
                              child: FlipCard(
                                controller: flipCardController,
                                key: cardKey,
                                flipOnTouch: false,
                                fill: Fill.fillBack,
                                direction: FlipDirection.HORIZONTAL,
                                front: cardWidget(context, 0, true),
                                back: cardWidget(context, 0, false),
                              ),
                            ),
                            /*
                             * カードボタン
                             */
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: cardButtons(cardKey, 0),
                            ),
                          ],
                        ),
                      ),
                      /*
                         * メモ
                         */
                      Container(
                        padding: EdgeInsets.all(padding),
                        child: Text(widget.listMap!['memo'] ?? '')
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: App.primary_color,
            child: Icon(Icons.edit, color: App.btn_color, size: 40),
            onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CardForm(listMap: widget.listMap);
                    },
                  ),
                );
                setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget cardWidget(context, index, bool isFront) {
    String? path = isFront ? card.frontPath : card.backPath;
    return Card(
      child: path != null
          ?
      //画像あり時

      Container(
        height: 200,
        width: 300,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(child: cardHero(isFront)),
      )
          :
      SizedBox(
        height: 200,
        width: 300,
        child: Center(
          child: Text(
            isFront ? '表面' : '裏面',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> cardButtons(cardKey, index) {
    return <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding:const EdgeInsets.all(10.0),
          backgroundColor: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
        ),
        onPressed: () {
          cardKey.currentState?.toggleCard();
          setState(() {});
        },
        child: Center(child: Icon(Icons.swap_horiz, color: App.btn_color,size: 30)),
      ),
    ];
  }

  Widget cardHero(bool isFront) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SecondScreen(imagePath:isFront ? card.frontPath : card.backPath, isFront: isFront);
        }),);
      },
      child: Center(
        child: Hero(
          tag: isFront ? "imageTagFront" : "imageTagBack",
          child: Image.file(File((isFront ? card.frontPath : card.backPath) ?? ''))
        ),
      ),
    );
  }
}

// 遷移先の画面
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key, required this.imagePath, this.isFront});
  final imagePath;
  final isFront;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late HeroController _heroController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _heroController = HeroController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () { Navigator.of(context).pop();},
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.3),
            duration: Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: pi / 2, // 回転の角度
                child: Transform.scale(
                  scale: value,
                  child: child,
                ),
              );
            },
            child: Hero(
              tag: widget.isFront ? "imageTagFront" : "imageTagBack",
              child: Container(
    // width: double.infinity,
    // height: double.infinity,
                  child: Image.file(File(widget.imagePath))), // 表示する画像,
              // createRectTween: (begin, end) {
              //   return RectTween(
              //     begin: Rect.fromCenter(
              //       center: begin!.center,
              //       width: begin.width,
              //       height: begin.height,
              //     ),
              //     end: Rect.fromCenter(
              //       center: end!.center,
              //       width: end.width,
              //       height: end.height,
              //     ),
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }
}