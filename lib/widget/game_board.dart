import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/widget/applifting_fire.dart';
import 'package:fingertap/widget/finger_touch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
    required this.gameProvider,
  }) : super(key: key);

  final GameProvider gameProvider;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with SingleTickerProviderStateMixin {
  int _counter = 0;
  late final TouchCallbacks touchCallbacks;
  late final RenderBox renderBox;

  late final AnimationController _controller;

  @override
  void initState() {
    touchCallbacks = TouchCallbacks(
      gameProvider: widget.gameProvider,
      animate: () {
        _controller.reset();
        _controller.animateTo(1, curve: Curves.easeInCubic);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => renderBox = context.findRenderObject()! as RenderBox);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            return AppliftingFire(count: gameProvider.previousCount, location: 400 * _controller.value);
          },
        ),
        AppliftingFire(count: gameProvider.currentCount),
        ...touchCallbacks.taps.map((tap) => FingerTouch(dx: tap.offset.dx, dy: tap.offset.dy)).toList(),

        // LISTENER
        // Listener(
        //   onPointerDown: (details) {
        //     setState(() {
        //       touchCallbacks.touchBegan(TouchData(details.pointer, renderBox.globalToLocal(details.position)));
        //     });
        //   },
        //   onPointerMove: (details) {
        //     setState(
        //       () => touchCallbacks.touchMoved(
        //         TouchData(details.pointer, renderBox.globalToLocal(details.position)),
        //       ),
        //     );
        //   },
        //   onPointerUp: (details) {
        //     setState(() => touchCallbacks.touchEnded(TouchData(details.pointer)));
        //   },
        //   onPointerCancel: (details) {
        //     setState(() => touchCallbacks.touchCanceled(TouchData(details.pointer)));
        //   },
        //   child: Container(color: Colors.transparent),
        // ),

        // RAW GESTURE RECOGNIZER
        RawGestureDetector(
          gestures: <Type, GestureRecognizerFactory>{
            ImmediateMultiDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<ImmediateMultiDragGestureRecognizer>(
              ImmediateMultiDragGestureRecognizer.new,
              (ImmediateMultiDragGestureRecognizer instance) {
                instance.onStart = (Offset offset) {
                  setState(() {
                    _counter++;
                    touchCallbacks.touchBegan(TouchData(_counter, offset));
                  });
                  return ItemDrag(
                    onUpdate: (DragUpdateDetails details, tId) {
                      setState(
                        () => touchCallbacks.touchMoved(
                          TouchData(tId, renderBox.globalToLocal(details.globalPosition)),
                        ),
                      );
                    },
                    onEnd: (details, tId) => setState(() => touchCallbacks.touchEnded(TouchData(tId))),
                    onCancel: (tId) => setState(() => touchCallbacks.touchCanceled(TouchData(tId))),
                    touchId: _counter,
                  );
                };
              },
            ),
          },
        ),
      ],
    );
  }
}

class TouchCallbacks {
  TouchCallbacks({
    required this.gameProvider,
    required this.animate,
  });

  final GameProvider gameProvider;
  final VoidCallback animate;

  List<TouchData> taps = [];

  int get tapCount => taps.length;

  void touchBegan(TouchData touch) {
    taps.add(touch);
    if (gameProvider.touchState == TouchState.incrementing) {
      if (gameProvider.currentCount == tapCount) {
        gameProvider.touchState = TouchState.decrementing;
      }
    } else if (gameProvider.touchState == TouchState.decrementing) {
      gameProvider.failGame();
    }
  }

  void touchMoved(TouchData touch) {
    for (int i = 0; i < taps.length; i++) {
      if (taps[i].touchId == touch.touchId) {
        taps[i] = touch;
        break;
      }
    }
  }

  void touchCanceled(TouchData touch) {
    taps.removeWhere((element) => element.touchId == touch.touchId);
    if (gameProvider.touchState == TouchState.incrementing) {
      gameProvider.failGame();
      if (gameProvider.touchState == TouchState.still && tapCount == 0) {
        gameProvider.touchState = TouchState.incrementing;
      }
    } else if (gameProvider.touchState == TouchState.decrementing) {
      if (tapCount == 0) {
        gameProvider.winRound();
        animate();
      }
    } else if (gameProvider.touchState == TouchState.still && tapCount == 0) {
      gameProvider.touchState = TouchState.incrementing;
    }
  }

  void touchEnded(TouchData touch) {
    taps.removeWhere((element) => element.touchId == touch.touchId);
    if (gameProvider.touchState == TouchState.incrementing) {
      gameProvider.failGame();
      if (gameProvider.touchState == TouchState.still && tapCount == 0) {
        gameProvider.touchState = TouchState.incrementing;
      }
    } else if (gameProvider.touchState == TouchState.decrementing) {
      if (tapCount == 0) {
        gameProvider.winRound();
        animate();
      }
    } else if (gameProvider.touchState == TouchState.still && tapCount == 0) {
      gameProvider.touchState = TouchState.incrementing;
    }
  }
}

class TouchData {
  final int touchId;
  final Offset offset;

  TouchData(this.touchId, [this.offset = Offset.zero]);
}

class ItemDrag extends Drag {
  final Function? onUpdate;
  final Function? onEnd;
  final Function? onCancel;
  final int touchId;

  ItemDrag({
    this.onUpdate,
    this.onEnd,
    this.onCancel,
    required this.touchId,
  });

  @override
  void update(DragUpdateDetails details) {
    super.update(details);
    onUpdate?.call(details, touchId);
  }

  @override
  void end(DragEndDetails details) {
    super.end(details);
    onEnd?.call(details, touchId);
  }

  @override
  void cancel() {
    super.cancel();
    onCancel?.call(touchId);
  }
}
