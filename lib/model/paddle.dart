import 'dart:async';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../forge2d_game_world.dart';

class Paddle extends BodyComponent<Forge2dGameWorld> with DragCallbacks, HasGameRef<Forge2dGameWorld> {
  final Size size;
  final BodyComponent ground;
  final Vector2 position;
  late final StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  late final MouseJoint? _mouseJoint;
  Vector2 dragStartPosition = Vector2.zero();
  Vector2 dragAccumulativePosition = Vector2.zero();

  Paddle({
    required this.size,
    required this.ground,
    required this.position,
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position
      ..fixedRotation = true
      ..angularDamping = 1.0
      ..linearDamping = 10.0;

    final paddleBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        size.width / 2.0,
        size.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    paddleBody.createFixture(FixtureDef(shape)
      ..density = 100.0
      ..friction = 0.0
      ..restitution = 1.0);

    return paddleBody;
  }

  void reset() {
    body.setTransform(position, angle);
    body.angularVelocity = 0.0;
    body.linearVelocity = Vector2.zero();
  }

  @override
  void onMount() {
    super.onMount();

    final worldAxis = Vector2(1.0, 0.0);

    final travelExtent = (gameRef.size.x / 2) - (size.width / 2.0);

    final jointDef = PrismaticJointDef()
      ..enableLimit = true
      ..lowerTranslation = -travelExtent
      ..upperTranslation = travelExtent
      ..collideConnected = true;

    jointDef.initialize(body, ground.body, body.worldCenter, worldAxis);
    final joint = PrismaticJoint(jointDef);
    world.createJoint(joint);

    // Subscribe to the gyroscope events.
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      _handleGyroscopeEvent(event);
    });
  }

  @override
  void onRemove() {
    super.onRemove();
    // Cancel the gyroscope subscription.
    _gyroscopeSubscription.cancel();
  }

  void _handleGyroscopeEvent(GyroscopeEvent event) {
    // Use the gyroscope event to update the paddle's position.
    // You might need to adjust the sensitivity factor.
    const sensitivity = 10.0;
    final deltaX = event.y * sensitivity;

    // Apply the delta to the paddle's position.
    body.applyLinearImpulse(Vector2(deltaX, 0));
  }

  @override
  void onDragStart(DragStartEvent info) {
    super.onDragStart(info);
    if (_mouseJoint != null) {
      return;
    }
    dragStartPosition = info.localPosition; // todo check
    _setupDragControls();

    // Don't continue passing the event.
    return;
  }

  @override
  void onDragUpdate(DragUpdateEvent info) {
    dragAccumulativePosition += info.localDelta;
    if ((dragAccumulativePosition - dragStartPosition).length > 0.1) {
      _mouseJoint?.setTarget(dragAccumulativePosition);
      dragStartPosition = dragAccumulativePosition;
    }

    // Don't continue passing the event.
    return;
  }

  @override
  void onDragEnd(DragEndEvent info) {
    _resetDragControls();

    // Don't continue passing the event.
    super.onDragEnd(info);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _resetDragControls();

    // Don't continue passing the event.
    super.onDragCancel(event);
    
  }

  void _setupDragControls() {
    final mouseJointDef = MouseJointDef()
      ..bodyA = ground.body
      ..bodyB = body
      ..frequencyHz = 5.0
      ..dampingRatio = 0.9
      ..collideConnected = false
      ..maxForce = 2000.0 * body.mass;

    _mouseJoint = MouseJoint(mouseJointDef);
    world.createJoint(_mouseJoint!);
  }

  // Clear the drag position accumulator and remove the mouse joint.
  void _resetDragControls() {
    dragAccumulativePosition = Vector2.zero();
    if (_mouseJoint != null) {
      world.destroyJoint(_mouseJoint);
      _mouseJoint = null;
    }
  }

  @override
  void render(Canvas canvas) {
    final shape = body.fixtures.first.shape as PolygonShape;

    final paint = Paint()
      ..color = const Color.fromARGB(255, 80, 80, 228)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTRB(
          shape.vertices[0].x,
          shape.vertices[0].y,
          shape.vertices[2].x,
          shape.vertices[2].y,
        ),
        paint);
  }
}
