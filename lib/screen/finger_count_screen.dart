import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/widget/back_button_aligned.dart';
import 'package:fingertap/widget/finger_touch.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class FingerCountScreen extends StatefulWidget {
  const FingerCountScreen({super.key});

  @override
  State<FingerCountScreen> createState() => _FingerCountScreenState();
}

class _FingerCountScreenState extends State<FingerCountScreen> {
  int? fingerCount;

  int _counter = 0;
  late final TouchCallbacks touchCallbacks;
  late final RenderBox renderBox;

  @override
  void initState() {
    touchCallbacks = TouchCallbacks();
    WidgetsBinding.instance.addPostFrameCallback((_) => renderBox = context.findRenderObject()! as RenderBox);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/applifting_logo.svg',
              width: 400,
              colorFilter: ColorFilter.mode(
                Colors.grey[700]!,
                BlendMode.color,
              ),
            ),
            const BackButtonAligned(),
            Text('${fingerCount ?? '-'}', style: const TextStyle(color: Colors.white, fontSize: 64)),
            Positioned(
              bottom: 64,
              child: MenuButton(
                onPressed: () {
                  if ((fingerCount ?? 0) > 0) {
                    Hive.box(HiveConstants.tapGameBox).put(HiveConstants.fingerCount, fingerCount);
                    Navigator.pop(context);
                  }
                },
                text: 'set',
                fontSize: 28,
              ),
            ),
            ...touchCallbacks.taps.map((tap) => FingerTouch(dx: tap.offset.dx, dy: tap.offset.dy)),
            RawGestureDetector(
              gestures: <Type, GestureRecognizerFactory>{
                ImmediateMultiDragGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<ImmediateMultiDragGestureRecognizer>(
                  ImmediateMultiDragGestureRecognizer.new,
                  (ImmediateMultiDragGestureRecognizer instance) {
                    instance.onStart = (Offset offset) {
                      setState(() {
                        _counter++;
                        touchCallbacks.touchBegan(TouchData(_counter, offset));
                        fingerCount = touchCallbacks.tapCount;
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
        ),
      ),
    );
  }
}

class TouchCallbacks {
  List<TouchData> taps = [];

  int get tapCount => taps.length;

  void touchBegan(TouchData touch) {
    taps.add(touch);
    //touch began code here
  }

  void touchMoved(TouchData touch) {
    for (int i = 0; i < taps.length; i++) {
      if (taps[i].touchId == touch.touchId) {
        taps[i] = touch;
        break;
      }
    }
    //touch moved code here
  }

  void touchCanceled(TouchData touch) {
    //touch canceled code here
  }

  void touchEnded(TouchData touch) {
    //touch ended code here
    taps.removeWhere((element) => element.touchId == touch.touchId);
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
