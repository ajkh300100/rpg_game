// lib/monster.dart
import 'character.dart';  // 캐릭터 클래스를 사용하기 위해

class Monster {
  String name;
  int health;
  int attackPower;
  int defense;

  Monster(this.name, this.health, this.attackPower, this.defense);

  void takeDamage(int damage) {
    health -= damage;
  }

  void attackCharacter(Character character) {
    int damage = attackPower - character.defense;
    if (damage < 0) damage = 0;
    character.takeDamage(damage);
    print('$name이(가) ${character.name}에게 $damage 데미지를 입혔습니다!');
  }

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower');
  }
}
