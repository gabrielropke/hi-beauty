import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class TimerWidget extends StatefulWidget {
  final TimerController controller;
  final void Function()? function;
  const TimerWidget({super.key, required this.controller, this.function});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _timer?.cancel();
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final time = widget.controller.remainingTime;
      if (time <= 0) {
        t.cancel();
        _timer = null;
      } else {
        widget.controller.setRemainingTime(time - 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) {
        return Column(
          children: [
            if (widget.controller.remainingTime == 0)
              GestureDetector(
                onTap: widget.function,
                child: Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          AppLocalizations.of(context)!.resendCode,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.controller.remainingTime != 0)
              Container(
                height: 50,
                color: Colors.transparent,
                child: Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        '${AppLocalizations.of(context)!.resendCodeTimer(widget.controller.remainingTime)}${widget.controller.remainingTime == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class TimerController extends ChangeNotifier {
  int _remainingTime;
  int get remainingTime => _remainingTime;

  TimerController({required int initialTime}) : _remainingTime = initialTime;

  void setRemainingTime(int value) {
    if (value == _remainingTime) return;
    _remainingTime = value;
    notifyListeners();
  }
}
