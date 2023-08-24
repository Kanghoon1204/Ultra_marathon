import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:infinity_alive/config/global.dart';
import 'package:infinity_alive/model/bad_thing.dart';

import 'clam.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  Player() : super(size: Vector2.all(32)) {
    add(CircleHitbox());
  }

  bool isLoadedFirst = false;
  bool isTouched = false;
  final List<SpriteAnimation> _runAnimation = [];
  final List<SpriteAnimation> _standingAnimation = [];
  final double _animationSpeed = 0.15;

  @override
  Future<void>? onLoad() async {
    //sprite = await Sprite.load('ship.png');
    anchor = Anchor.center;

    final hitbox = RectangleHitbox();
    add(hitbox);
    await _loadAnimations();
    animation = _standingAnimation[0];

    return super.onLoad();
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player.png'),
      srcSize: Vector2.all(20),
    );

    _runAnimation.addAll([
      spriteSheet.createAnimation(
          row: 0, stepTime: _animationSpeed, from: 1, to: 3),
      spriteSheet.createAnimation(
          row: 1, stepTime: _animationSpeed, from: 1, to: 3),
      spriteSheet.createAnimation(
          row: 2, stepTime: _animationSpeed, from: 1, to: 3),
      spriteSheet.createAnimation(
          row: 3, stepTime: _animationSpeed, from: 1, to: 3)
    ]);
    _standingAnimation.addAll([
      spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1),
      spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 1),
      spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 1),
      spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 1)
    ]);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (!isLoadedFirst) {
      isLoadedFirst = true;

      position = gameSize / 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (Global.isPause() || Global.isOver()) return;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is BadThing) {
      Global.status = GameStatus.gameover;
    }

  }
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Clam){
      other.takeHit();
    }
  }


  void move(Vector2 movePosition) {
    if (!isTouched) {
      isTouched = toRect().contains(movePosition.toOffset());
      if(movePosition.x -position.x > 0)
      {
        animation = _runAnimation[2];
      }
      else
      {
        animation = _runAnimation[3];
      }
      return;
    }
    if(movePosition.y- position.y > 0)
    {
      animation = _runAnimation[0];
    }
    else
    {
      animation = _runAnimation[1];
    }

    position = movePosition;
  }

  void restart() {
    isTouched = false;
    position.x = Global.deviceWidth / 2;
    position.y = Global.deviceHeight / 2;
  }
}
