import 'package:breakout/model/ball.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:breakout/model/arena.dart';

class Forge2dGameWorld extends Forge2DGame {
  Forge2dGameWorld() : super(gravity: Vector2.zero(), zoom: 20);

  // 1
  late final Ball _ball;

  @override
  Future<void> onLoad() async {
    await _initializeGame();

    // 2
    _ball.body.applyLinearImpulse(Vector2(-10, -10));
  }

  Future<void> _initializeGame() async {
    final arena = Arena();
    await add(arena);
    // 3
    _ball = Ball(
      
      radius: 0.5,
      position: size / 2,
    );
    await add(_ball);
  }
}

