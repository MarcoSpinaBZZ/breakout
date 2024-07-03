import 'package:flame_forge2d/flame_forge2d.dart';

import '../forge2d_game_world.dart';

// 1
class Ball extends BodyComponent<Forge2dGameWorld> {
  // 2
  final Vector2 position;
  final double radius;

  Ball({required this.position, required this.radius});

  // 3
  @override
  Body createBody() {
    // 4
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;

    // 5
    final ball = world.createBody(bodyDef);

    // 6
    final shape = CircleShape()..radius = radius;

    // 7
    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..density = 1.0;

    // 8
    ball.createFixture(fixtureDef);
    return ball;
  }
}
