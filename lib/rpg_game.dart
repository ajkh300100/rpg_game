// lib/rpg_game.dart
import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

class Game {
  List<Character> characters = [];
  List<Monster> monsters = [];
  int monstersToDefeat = 3;  // 승리 조건: 3마리 물리치기
  int defeatedMonsterCount = 0;

  void addCharacter(Character character) {
    characters.add(character);
  }

  void addMonster(Monster monster) {
    monsters.add(monster);
  }

  // data/characters.txt 파일에서 캐릭터 데이터를 불러오고, 사용자로부터 이름 입력 받기
  void loadCharacter() {
    try {
      final file = File('data/characters.txt');
      final contents = file.readAsStringSync();
      // 파일 내용 예: "100,25,10"
      final data = contents.split(',');
      if (data.length != 3) throw FormatException('캐릭터 데이터 형식이 올바르지 않습니다.');
      int health = int.parse(data[0].trim());
      int attackPower = int.parse(data[1].trim());
      int defense = int.parse(data[2].trim());

      // 사용자로부터 캐릭터 이름 입력 (한글, 영문 대소문자만 허용)
      stdout.write('캐릭터의 이름을 입력하세요 (한글, 영문 대소문자만 허용): ');
      String? inputName = stdin.readLineSync();
      while (inputName == null || inputName.isEmpty || !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(inputName)) {
        stdout.write('유효한 이름을 입력하세요 (한글, 영문 대소문자만 허용): ');
        inputName = stdin.readLineSync();
      }
      
      addCharacter(Character(inputName, health, attackPower, defense));
      print('캐릭터 로드 완료: $inputName, 체력: $health, 공격력: $attackPower, 방어력: $defense');
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // data/monsters.txt 파일에서 몬스터 데이터를 불러오기
  void loadMonsters() {
    try {
      final file = File('data/monsters.txt');
      final contents = file.readAsStringSync();
      final lines = contents.split('\n');
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        // 각 줄 예: "Batman,30,20,0"
        final data = line.split(',');
        if (data.length != 4) continue;
        String name = data[0].trim();
        int health = int.parse(data[1].trim());
        int attackPower = int.parse(data[2].trim());
        int defense = int.parse(data[3].trim());
        addMonster(Monster(name, health, attackPower, defense));
        print('몬스터 로드 완료: $name, 체력: $health, 공격력: $attackPower, 방어력: $defense');
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 전투 진행: 캐릭터와 몬스터 간의 전투, 전투 후 사용자에게 다음 대결 여부를 물어봄
  void startGame() {
    if (characters.isEmpty) {
      print('로드된 캐릭터가 없습니다.');
      return;
    }
    Character hero = characters[0];
    print('게임을 시작합니다!');
    
    while (hero.health > 0 && defeatedMonsterCount < monstersToDefeat && monsters.isNotEmpty) {
      // 몬스터 리스트에서 랜덤으로 몬스터 선택
      Monster currentMonster = monsters[Random().nextInt(monsters.length)];
      print('\n${hero.name}과(와) ${currentMonster.name}의 전투 시작!');
      
      // 전투 루프: 한 몬스터와의 전투
      while (hero.health > 0 && currentMonster.health > 0) {
        print('\n행동을 선택하세요: 1. 공격하기, 2. 방어하기');
        stdout.write('입력: ');
        String? action = stdin.readLineSync();
        if (action == '1') {
          hero.attackMonster(currentMonster);
        } else if (action == '2') {
          hero.defend();
        } else {
          print('잘못된 입력입니다. 다시 시도하세요.');
          continue;
        }
        
        if (currentMonster.health <= 0) {
          print('${currentMonster.name}을(를) 물리쳤습니다!');
          defeatedMonsterCount++;
          // 처치한 몬스터는 리스트에서 삭제
          monsters.remove(currentMonster);
          break;
        }
        
        currentMonster.attackCharacter(hero);
        if (hero.health <= 0) {
          print('${hero.name}이(가) 쓰러졌습니다! 게임 오버.');
          exit(0);
        }
        
        hero.showStatus();
        currentMonster.showStatus();
      }
      
      // 전투가 끝난 후, 승리 조건 확인 및 다음 대결 여부 선택
      if (defeatedMonsterCount >= monstersToDefeat) {
        print('축하합니다! ${hero.name}이(가) 모든 몬스터를 물리쳐 게임에서 승리했습니다!');
        return;
      }
      if (monsters.isNotEmpty) {
        stdout.write('다음 몬스터와 대결하시겠습니까? (y/n): ');
        String? choice = stdin.readLineSync();
        if (choice == null || choice.toLowerCase() != 'y') {
          print('게임을 종료합니다.');
          return;
        }
      }
    }
    
    if (hero.health <= 0) {
      print('게임 오버!');
    } else {
      print('게임을 종료합니다.');
    }
  }
}
