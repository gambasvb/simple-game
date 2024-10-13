import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: SimplePlatformerGame()));
}

class SimplePlatformerGame extends FlameGame with HasKeyboardHandlerComponents {
  SimplePlatformerGame() {
    debugMode = true; // Mengaktifkan mode debugging Flame
  }
  late Player player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Add the player to the game world
    player = Player()..position = Vector2(100, 100);
    add(player);

    // Add a platform
    add(Platform(Vector2(0, 300), Vector2(800, 50)));
  }

  @override
  Color backgroundColor() => const Color(0xFF111111);
}

class Player extends SpriteComponent with KeyboardHandler {
  final double gravity = 1000;
  final double jumpSpeed = 300;
  final double moveSpeed = 200;

  Vector2 velocity = Vector2.zero();
  bool isOnGround = true;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Test rendering a simple rectangle
    // add(RectangleComponent(
    //   position: Vector2(100, 100),
    //   size: Vector2(50, 50),
    //   paint: Paint()..color = const Color(0xFF00FF00),
    // ));

    sprite = await Sprite.load('player.png');
    size = Vector2(32, 32); // Adjust size based on your sprite
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    if (!isOnGround) {
      velocity.y += gravity * dt;
    }

    // Move the player
    position += velocity * dt;

    // Handle ground collision
    if (position.y > 250) {
      // Simple collision with the platform
      position.y = 250;
      isOnGround = true;
      velocity.y = 0;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        velocity.x = moveSpeed;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        velocity.x = -moveSpeed;
      } else if (keysPressed.contains(LogicalKeyboardKey.space) && isOnGround) {
        velocity.y = -jumpSpeed; // Jump
        isOnGround = false;
      }
    }

    if (event is KeyUpEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        velocity.x = 0;
      }
    }

    return false;
  }
}

class Platform extends PositionComponent {
  Platform(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      position: Vector2.zero(),
      size: size,
      paint: Paint()..color = const Color(0xFF00FF00),
    ));
  }
}
