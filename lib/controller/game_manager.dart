import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:infinity_alive/config/global.dart';
import 'package:infinity_alive/menu_overlay.dart';
import 'package:infinity_alive/model/bad_thing.dart';
import 'package:infinity_alive/model/player.dart';

import '../model/clam.dart';

class GameManager extends FlameGame
    with HasCollisionDetection, MouseMovementDetector {
  late Player player;
  late MenuOverlay menu;
  final List<BadThing> badThings = [];
  final List<Clam> clams = [];
  @override
  Color backgroundColor() => Colors.grey;

  int createBadCount = 10;
  int createGoodCount = 5;

  @override
  Future<void>? onLoad() async {
    Global.deviceWidth = size[0];
    Global.deviceHeight = size[1];

    player = Player();
    add(player);

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (Global.isPause()) return;
    if (Global.isOver()) {
      menu.refreshScreen();
      return;
    }

    if (createBadCount > 0) {
      var badThing = BadThing();
      add(badThing);
      badThings.add(badThing);
      createBadCount--;
    }

    if (createGoodCount > 0) {
      var clam = Clam();
      add(clam);
      clams.add(clam);
      createGoodCount--;
    }

    Global.timer += dt;

    if (Global.score >= Global.level * 10 && Global.level <= 20) {
      Global.level++;
      Global.gameSpeed += 10;
      createBadCount += 10;
      createGoodCount += 5;
    }
    menu.refreshScreen();
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    if (Global.isPause() || Global.isOver()) return;

    player.move(info.eventPosition.game);
  }

  void restart() {
    for (var badThing in badThings) {
      badThing.resetComponent();
    }
    for (var clam in clams) {
      clam.resetComponent();
    }
    badThings.clear();
    clams.clear();
    createBadCount = 10;
    createGoodCount = 5;
    player.restart();
    Global.level = 1;
    Global.gameSpeed = 100;
    Global.score = 0;
    Global.status = GameStatus.run;
  }
}
