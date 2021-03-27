import 'dart:developer';

import 'package:flutter/scheduler.dart';

class AnimationTicker {
  Duration _durationAnimation;
  Duration get durationAnimation => _durationAnimation;
  final Function(double) onChange;
  final Function()? onStart;
  final Function()? onEnd;

  late Ticker _ticker;
  late int _lateTicks;
  late int _millisecondsFrame;

  AnimationTicker({
    required Duration durationAnimation,
    required this.onChange,
    this.onStart,
    this.onEnd,
    int frameFrequency = 60,
  }) : _durationAnimation = durationAnimation {
    _ticker = Ticker(_onTick);
    _lateTicks = 0;
    _millisecondsFrame = (1000 / frameFrequency).ceil();
  }

  void startAnimation() {
    _ticker.start();
    onStart?.call();
  }

  void stopAnimation() {
    _ticker.stop();
    _lateTicks = 0;
    onEnd?.call();
  }

  void changeDuration(Duration duration) {
    if (_ticker.isActive) {
      log('Can not change Duration when play animation!');
    } else {
      _durationAnimation = duration;
    }
  }

  void _onTick(Duration duration) {
    if (duration.inMilliseconds - _lateTicks > _millisecondsFrame) {
      onChange.call(duration.inMilliseconds / durationAnimation.inMilliseconds);
      _lateTicks = duration.inMilliseconds;
    }
    if (duration.inMilliseconds > durationAnimation.inMilliseconds) {
      stopAnimation();
    }
  }
}
