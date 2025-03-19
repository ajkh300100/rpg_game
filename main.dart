// main.dart
import 'package:rpg_game/rpg_game.dart';

void main() {
  Game game = Game();
  game.loadCharacter();
  game.loadMonsters();
  game.startGame();
}
