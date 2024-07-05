import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/rendering.dart';
import 'package:flame/extensions.dart';
import '../forge2d_game_world.dart';

class Ball extends BodyComponent<Forge2dGameWorld> {
  final Vector2 position;
  final double radius;
  final Vector2 initialVelocity;

  Ball({
    required this.position,
    required this.radius,
    required this.initialVelocity,
  });

  final _gradient = RadialGradient(
    center: Alignment.topLeft,
    colors: [
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 1.0).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.9).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.4).toColor(),
    ],
    stops: const [0.0, 0.5, 1.0],
    radius: 0.95,
  );

  static const double exponentialSpeedFactor = 1.05; // Factor for exponential speed increase

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.dynamic
      ..position = position;

    final ball = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..density = 1.0;

    ball.createFixture(fixtureDef);

    // Apply initial velocity to the body directly
    ball.setTransform(position, 0); // Set initial position and angle
    ball.linearVelocity = initialVelocity; // Set initial velocity directly

    return ball;
  }

  void reset(Vector2 newPosition) {
    body.setTransform(newPosition, 0); // Reset position and angle
    body.linearVelocity = initialVelocity; // Reset velocity to initial
    body.angularVelocity = 0.0; // Reset angular velocity
  }

  void increaseSpeedExponentially() {
    final currentVelocity = body.linearVelocity;
    final newVelocity = currentVelocity * exponentialSpeedFactor;
    body.linearVelocity = newVelocity;
  }

  @override
  void render(Canvas canvas) {
    final circle = body.fixtures.first.shape as CircleShape;

    final paint = Paint()
      ..shader = _gradient.createShader(Rect.fromCircle(
        center: circle.position.toOffset(),
        radius: radius,
      ))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(circle.position.toOffset(), radius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Optionally increase speed over time
    increaseSpeedExponentially();
  }
}
