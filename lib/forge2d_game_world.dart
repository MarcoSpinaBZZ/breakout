import 'package:breakout/model/arena.dart';
import 'package:breakout/model/ball.dart';
import 'package:breakout/model/brick_wall.dart';
import 'package:breakout/model/dead_zone.dart';
import 'package:breakout/model/paddle.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

enum GameState {
  initializing,
  ready,
  running,
  paused,
  won,
  lost,
}

class Forge2dGameWorld extends Forge2DGame {
  Forge2dGameWorld() : super(gravity: Vector2.zero(), zoom: 20);

  late final Arena _arena;
  late final Ball _ball;
  late final Paddle _paddle;
  late final DeadZone _deadZone;
  late final BrickWall _brickWall;

  GameState gameState = GameState.initializing;

  @override
  Future<void> onLoad() async {
    await _initializeGame();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState == GameState.lost || gameState == GameState.won) {
      pauseEngine();
      overlays.add('PostGame');
    }
  }

  Future<void> resetGame() async {
    gameState = GameState.initializing;

    _ball.reset();
    _paddle.reset();
    await _brickWall.reset();

    gameState = GameState.ready;

    overlays.remove(overlays.activeOverlays.first);
    overlays.add('PreGame');

    resumeEngine();
  }

  void startGame() {
    _ball.body.applyLinearImpulse(Vector2(-10.0, -10.0));
    gameState = GameState.running;
  }

  Future<void> _initializeGame() async {
    _arena = Arena();
    await add(_arena);

    final brickWallPosition = Vector2(0.0, size.y * 0.075);

    _brickWall = BrickWall(
      position: brickWallPosition,
      rows: 8,
      columns: 6,
    );
    await add(_brickWall);

    final deadZoneSize = Size(size.x, size.y * 0.1);
    final deadZonePosition = Vector2(
      size.x / 2.0,
      size.y - (size.y * 0.1) / 2.0,
    );

    _deadZone = DeadZone(
      size: deadZoneSize,
      position: deadZonePosition,
    );
    await add(_deadZone);

    const paddleSize = Size(4.0, 0.8);
    final paddlePosition = Vector2(
      size.x / 2.0,
      size.y - deadZoneSize.height - paddleSize.height / 2.0,
    );

    _paddle = Paddle(
      size: paddleSize,
      ground: _arena,
      position: paddlePosition,
    );
    await add(_paddle);

    final ballPosition = Vector2(size.x / 2.0, size.y / 2.0 + 10.0);

    _ball = Ball(
      radius: 0.5,
      position: ballPosition,
    );
    await add(_ball);

    gameState = GameState.ready;
    overlays.add('PreGame');
  }
}
