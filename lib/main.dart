import 'dart:math';
import 'dart:ui' as ui;

import 'package:SketchWars/models/messageModel.dart';
import 'package:SketchWars/utils/constants.dart';
import 'package:finger_painter/finger_painter.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      /*  theme: ThemeData.dark(
      ).copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          background: Colors.black
        )
      ),*/
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PainterController painterController;
  bool isYourTurn = true;
  int score = 0;
  @override
  void initState() {
    super.initState();
    wordsList.shuffle();
    painterController = PainterController()
      ..setStrokeColor(Colors.black)
      ..setMinStrokeWidth(3)
      ..setMaxStrokeWidth(15)
      ..setBlurSigma(0.0)
      ..setPenType(PenType.paintbrush2)
      ..setBlendMode(ui.BlendMode.srcOver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text(
          "Sketch wars",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isYourTurn
                    ? "Draw given word and let your friends Guess"
                    : "Guess what your friend is drawing",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Score $score",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Time Left: ",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                TweenAnimationBuilder<Duration>(
                    duration: const Duration(minutes: 3),
                    tween: Tween(
                        begin: const Duration(minutes: 3), end: Duration.zero),
                    onEnd: () {},
                    builder:
                        (BuildContext context, Duration value, Widget? child) {
                      final minutes = value.inMinutes;
                      final seconds = value.inSeconds % 60;
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('$minutes:$seconds',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)));
                    }),
              ],
            ),
            if (isYourTurn)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("The word is '${wordsList.first}'",
                    style: const TextStyle(color: Colors.green, fontSize: 18)),
              ),
            const SizedBox(height: 10),
            Painter(
              controller: painterController,
              backgroundColor: const Color(0xFFF0F0F0),
              onDrawingEnded: (bytes) {
                print('${painterController.getPoints()?.length} drawn points');
                setState(() {});
              },
              size: const Size(double.infinity, 250),
            ),
            const SizedBox(height: 30),
            if (isYourTurn)
              Controls(
                pc: painterController,
              ),
            Expanded(
              child: Container(
                height: 400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (c, i) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                            child: ListTile(
                                          title: Text(
                                            messages[i].user.name,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          horizontalTitleGap: 0,
                                          leading: const Icon(
                                            Icons.send,
                                            size: 20,
                                          ),
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      messages[i].message,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!isYourTurn)
                      TextFormField(
                        onFieldSubmitted: (value) {
                          if (value.toLowerCase() ==
                              wordsList.first.toLowerCase()) {
                            showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: Text("You Guessed it !!"),
                                content: Text("You got +10 score"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        score += 10;
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Text("Go Back"))
                                ],
                              ),
                            );
                          }
                          messages.add(MessageModel(
                              message: value.toString(),
                              user: UserModel(name: 'Smkwinner', id: "1"),
                              id: (Random().nextInt(41235) + 1).toString(),
                              time: DateTime.now().toIso8601String()));
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            hintText: "Guess your answer here",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade900)),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.send),
                              color: Colors.grey.shade900,
                            )),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Controls extends StatefulWidget {
  final PainterController? pc;

  const Controls({
    Key? key,
    this.pc,
  }) : super(key: key);

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /**/
        GestureDetector(
            onTap: () {
              widget.pc?.clearContent(clearColor: const Color(0xfff0f0ff));
            },
            child: roundedButton(title: 'Clear')),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            showBottomSheet(
                backgroundColor: Colors.grey.shade300,
                context: context,
                builder: (builder) {
                  return StatefulBuilder(builder: (context, setState) {
                    return SizedBox(
                      height: 300,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Pen types
                              Row(
                                children: [
                                  for (int i = 0;
                                      i < PenType.values.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                              backgroundColor: widget.pc
                                                          ?.getState()
                                                          ?.penType
                                                          .index ==
                                                      i
                                                  ? MaterialStateProperty.all(
                                                      Colors.green.shade700)
                                                  : MaterialStateProperty.all(
                                                      Colors.black)),
                                          onPressed: () {
                                            if (widget.pc != null) {
                                              widget.pc!.setPenType(
                                                  PenType.values[i]);
                                              setState(() {});
                                            }
                                          },
                                          child: Text(
                                            PenType.values[i].name,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                    ),
                                ],
                              ),
                              //Close icon
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ))
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Colors, background & delete
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                  backgroundColor: Colors.red,
                                  onPressed: () =>
                                      widget.pc?.setStrokeColor(Colors.red)),
                              FloatingActionButton(
                                  backgroundColor: Colors.yellowAccent,
                                  onPressed: () => widget.pc
                                      ?.setStrokeColor(Colors.yellowAccent)),
                              FloatingActionButton(
                                  backgroundColor: Colors.black,
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color:
                                              Colors.white.withOpacity(0.3))),
                                  onPressed: () =>
                                      widget.pc?.setStrokeColor(Colors.black)),
                              FloatingActionButton(
                                  backgroundColor: Colors.green,
                                  onPressed: () =>
                                      widget.pc?.setStrokeColor(Colors.green)),
                            ],
                          ),

                          const SizedBox(height: 30),

                          Row(
                            children: [
                              Text('  min stroke '
                                  '${widget.pc?.getState()!.strokeMinWidth.toStringAsFixed(1)}'),
                              Expanded(
                                child: Slider.adaptive(
                                    value:
                                        widget.pc?.getState()?.strokeMinWidth ??
                                            0,
                                    min: 1,
                                    max: 20,
                                    onChanged: (value) {
                                      if (widget.pc != null) {
                                        widget.pc?.setMinStrokeWidth(value);
                                        if (widget.pc!
                                                .getState()!
                                                .strokeMinWidth >
                                            widget.pc!
                                                .getState()!
                                                .strokeMaxWidth) {
                                          widget.pc?.setMinStrokeWidth(widget
                                              .pc!
                                              .getState()!
                                              .strokeMaxWidth);
                                        }
                                        setState(() {});
                                      }
                                    }),
                              ),
                            ],
                          ),

                          /// max stroke width
                          Row(
                            children: [
                              Text('  max stroke '
                                  '${widget.pc?.getState()!.strokeMaxWidth.toStringAsFixed(1)}'),
                              Expanded(
                                child: Slider.adaptive(
                                    value:
                                        widget.pc?.getState()?.strokeMaxWidth ??
                                            0,
                                    min: 1,
                                    max: 40,
                                    onChanged: (value) {
                                      if (widget.pc != null) {
                                        widget.pc!.setMaxStrokeWidth(value);
                                        if (widget.pc!
                                                .getState()!
                                                .strokeMaxWidth <
                                            widget.pc!
                                                .getState()!
                                                .strokeMinWidth) {
                                          widget.pc!.setMaxStrokeWidth(widget
                                              .pc!
                                              .getState()!
                                              .strokeMinWidth);
                                        }
                                        setState(() {});
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                });
          },
          child: roundedButton(
            title: 'Options',
          ),
        ),
      ],
    );
  }

  roundedButton({required String title}) {
    return Container(
        width: 120,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ));
  }
}
