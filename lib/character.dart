// lib/character.dart
import 'monster.dart';  // 몬스터 클래스를 사용하기 위해

class Character {
  String name;
  int health;
  int attackPower;
  int defense;

  Character(this.name, this.health, this.attackPower, this.defense);

  void takeDamage(int damage) {
    health -= damage;
  }

  void attackMonster(Monster monster) {
    int damage = attackPower - monster.defense;
    if (damage < 0) damage = 0;
    monster.takeDamage(damage);
    print('$name이(가) ${monster.name}에게 $damage 데미지를 입혔습니다!');
  }

  void defend() {
    // 방어 시 자신의 체력을 방어력만큼 회복
    health += defense;
    print('$name이(가) 방어하여 $defense 만큼 체력을 회복했습니다!');
  }

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower, 방어력: $defense');
  }
}
