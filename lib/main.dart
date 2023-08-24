import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:infinity_alive/controller/game_manager.dart';
import 'package:infinity_alive/menu_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final manager = GameManager();
  final menuOverlay = MenuOverlay(game: manager);
  manager.menu = menuOverlay;
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: SizedBox(
              width: 800,
              height: 600,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GameWidget(game: manager),
                  menuOverlay,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
