import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/geometry.dart';
import 'package:infinity_alive/config/global.dart';
import 'package:flame/components.dart';
import 'package:infinity_alive/model/player.dart';

class Clam extends SpriteComponent with HasGameRef, CollisionCallbacks {
  Clam() : super(size: Vector2.all(16));

  late Sprite clam;

  bool isLoadedFirst = false;
  Vector2 startPosition = Vector2(0, 0);
  Vector2 endPosition = Vector2(0, 0);

  final random = Random();

  @override
  Future<void>? onLoad() async {
    clam = await Sprite.load('clam.png');

    reloadSprite();

    final hitbox = RectangleHitbox();
    add(hitbox);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (!isLoadedFirst) {
      isLoadedFirst = true;

      reloadPosition();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (Global.isPause() || Global.isOver()) return;

    if (isScreenOut(position.x, position.y)) {
      reloadSprite();
      reloadPosition();
    }

    var diff = endPosition - startPosition;
    double speed = dt * Global.gameSpeed;
    var next = diff.normalized() * speed;
    position += next;

  }

  bool isScreenOut(double x, double y) {
    return x < 0 || x > Global.deviceWidth || y < 0 || y > Global.deviceHeight;
  }

  void reloadSprite() {
    sprite = clam;
    anchor = Anchor.center;
  }

  void reloadPosition() {
    int ran = random.nextInt(4);
    double startX, startY, endX, endY;

    // 좌
    if (ran == 0) {
      startX = 0.0;
      startY = random.nextInt(Global.deviceHeight.toInt()).toDouble();
      endX = Global.deviceWidth;
      endY = random.nextInt(Global.deviceHeight.toInt()).toDouble();

      // 상
    } else if (ran == 1) {
      startX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      startY = 0.0;
      endX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      endY = Global.deviceHeight;

      // 우
    } else if (ran == 2) {
      startX = Global.deviceWidth;
      startY = random.nextInt(Global.deviceHeight.toInt()).toDouble();
      endX = 0.0;
      endY = random.nextInt(Global.deviceHeight.toInt()).toDouble();

      // 하
    } else {
      startX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      startY = Global.deviceHeight;
      endX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      endY = 0.0;
    }

    startPosition = Vector2(startX, startY);
    endPosition = Vector2(endX, endY);
    position = Vector2(startX, startY);
  }

  void takeHit() {
    reloadPosition();
    Global.score += 1;
  }

  void resetComponent() {
    removeFromParent();
  }
}
