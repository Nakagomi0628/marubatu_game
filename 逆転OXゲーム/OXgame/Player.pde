class Player {
  String name;
  float x;
  int max = 4;
  int sp = 0, num = 0, sum = 0;
  int[] cnts = new int[max];
  Skill[] skills = new Skill[max];

  Player(String _name, float _x) {
    name = _name;
    x = _x;
  }

  void output() {
    for (int i = 0; i < num; i++) {
      skills[i].output(x, height / 3 + height * i / 10, sp, cnts[i]);
    }
    if (name == "PlayerA") {
      fill(250, 150, 150);
    } else {
      fill(150, 200, 250);
    }
    textSize(height / 10);
    text(name, x - textWidth(name) / 2, height / 6);
    textSize(height / 20);
    text(sum + "/" + max, x - textWidth(sum + "/" + max) / 2, 3 * height / 4);
    for (int i = 0; i < sp; i++) {
      if (name == "PlayerA") {
        fill(250, i + 50, i + 50);
      } else {
        fill(i + 50, i + 100, 250);
      }
      text("|", x + 2.5 * (i - 50), height / 4);
    }
  }

  void press() {
    for (int i = 0; i < num; i++) {
      cnts[i] += skills[i].press(x, height / 3 + height * i / 10);
    }
  }

  void obtain(Skill s) {
    if (sum + s.size <= max) { //サイズの合計がn以下のとき
      sum += s.size; //スキルの合計を更新する
      skills[num] = s; //スキルを追加する
      num++; //スキルの数を更新する
    }
  }

  void reset() {
    num = 0; //スキルの数を更新する
    sum = 0; //スキルの合計を更新する
    skills = new Skill[max]; //スキルを消す
  }
}
