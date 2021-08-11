class Skill {
  String name;
  int size, cost;
  float w, h;
  color col;
  boolean press = false;

  Skill(String _name, int _size, int _cost) {
    name = _name;
    size = _size;
    cost = _cost;
    w = width / 6;
    h = height / 16;
    col = color(250, 40 * size + 100, 250);
  }

  void output(float x, float y, int sp, int cnt) {
    noStroke();
    fill(col);
    rect(x - w / 2, y - h / 2, w, h);
    if (press && 0 < cnt) { //スキルを発動しているとき
      fill(random(250), random(250), random(250));
    } else {
      fill(0);
    }
    textSize(h / 2);
    if (cost <= sp) { //スキルを発動できるとき
      text(" ! ", x - w / 2, y + h / 6); //"!"を表示する
    }
    if (0 < cnt) { //スキルを発動したことがあるとき
      text("   " + name, x - w / 2, y + h / 6); //名前を表示する
    }
    if (press) { //スキルを発動しているとき
      mouse(); //マウスを拡張する
    }
  }

  int press(float x, float y) {
    switch (scn) {
    case 3: //スキルセレクト
      if (isIn(x - w / 2, y - h / 2, w, h)) {
        player[0].obtain(this); //PlayerAにスキルを追加する
        break;
      }
    case 5: //スキルセレクト
      if (isIn(x - w / 2, y - h / 2, w, h)) {
        player[1].obtain(this); //PlayerBにスキルを追加する
        break;
      }
    case 6: //メインモード
      if (isIn(x - w / 2, y - h / 2, w, h) && cost <= player[turn%2].sp) {
        scn = 7; //スキルモードにする
        player[turn%2].sp -= cost; //spを消費する
        press = true; //スキルを発動する
        return 1;
      }
      break;
    case 7:
      if (press) {
        effect(); //スキルを反映する
      }
      break;
    }
    return 0;
  }

  void mouse() {
    //override
  }

  void effect() {
    //override
  }
}

class Swap extends Skill {
  Swap(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    int x, y;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (stage.ox[x][y] != 1);
    stage.ox[x][y] = -1;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (stage.ox[x][y] != -1);
    stage.ox[x][y] = 1;
    scn = 6;
    press = false;
  }
}

class Turn1 extends Skill {
  Turn1(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    int x, y;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (stage.ox[x][y] == 0);
    stage.ox[x][y] *= -1;
    scn = 6;
    press = false;
  }
}

class MoveM extends Skill {
  MoveM(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void mouse() {
    fill(250, 100);
    rect(mouseX - len / 2, mouseY - len / 2, len, len);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        println(isIn((width - height) / 2 + len * j, len * i, len, len) && stage.ox[j][i] == (turn % 2 == 0 ? 1 : -1));
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && stage.ox[j][i] == (turn % 2 == 0 ? 1 : -1)) {
          int x, y;
          do {
            x = int(random(num));
            y = int(random(num));
          } while (stage.ox[x][y] != 0 || 8 < stage.xo[x][y]);
          stage.ox[j][i] = 0;
          stage.ox[x][y] = turn % 2 == 0 ? 1 : -1;
          scn = 6;
          press = false;
        }
      }
    }
  }
}

class MoveY extends Skill {
  MoveY(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void mouse() {
    fill(250, 100);
    rect(mouseX - len / 2, mouseY - len / 2, len, len);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && stage.ox[j][i] == 0 && stage.xo[j][i] < 1) {
          int x, y;
          do {
            x = int(random(num));
            y = int(random(num));
          } while (stage.ox[x][y] != (turn % 2 == 0 ? -1 : 1));
          stage.ox[j][i] = turn % 2 == 0 ? -1 : 1;
          stage.ox[x][y] = 0;
          scn = 6;
          press = false;
        }
      }
    }
  }
}

class SPdown extends Skill {
  SPdown(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    player[(turn+1)%2].sp -= int(random(0.5 * cost, 1.1 * cost));
    scn = 6;
    press = false;
  }
}

class Erase1 extends Skill {
  Erase1(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    int x, y;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (stage.ox[x][y] != (turn % 2 == 0 ? -1 : 1));
    stage.ox[x][y] = 0;
    scn = 6;
    press = false;
  }
}

class Write1 extends Skill {
  Write1(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    int x, y;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (stage.ox[x][y] != 0 || 8 < stage.xo[x][y]);
    stage.ox[x][y] = turn % 2 == 0 ? 1 : -1;
    scn = 6;
    press = false;
  }
}

class Guard1 extends Skill {
  Guard1(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    int x, y;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (8 < stage.xo[x][y]);
    for (int i = x - 1; i < x + 2; i++) {
      for (int j = y - 1; j < y + 2; j++) {
        stage.xo[j][i] += 2;
      }
    }
    scn = 6;
    press = false;
  }
}

class Turn2 extends Skill {
  Turn2(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    int x, y;
    do {
      x = int(random(num));
      y = int(random(num));
    } while (stage.ox[x][y] == 0 || 8 < stage.xo[x][y]);
    for (int i = x - 1; i < x + 2; i++) {
      for (int j = y - 1; j < y + 2; j++) {
        stage.ox[j][i] *= -1;
      }
    }
    scn = 6;
    press = false;
  }
}

class Erase2 extends Skill {
  Erase2(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void mouse() {
    fill(250, 100);
    rect(mouseX - 3 * len / 2, mouseY - 3 * len / 2, 3 * len, 3 * len);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && stage.xo[j][i] < 9) {
          int x, y;
          do {
            x = int(random(j - 1, j + 2));
            y = int(random(i - 1, i + 2));
          } while (stage.ox[x][y] != (turn % 2 == 0 ? -1 : 1));
          stage.ox[x][y] = 0;
          scn = 6;
          press = false;
        }
      }
    }
  }
}

class Write2 extends Skill {
  Write2(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void mouse() {
    fill(250, 100);
    rect(mouseX - 3 * len / 2, mouseY - 3 * len / 2, 3 * len, 3 * len);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && stage.xo[j][i] < 9) {
          int x, y;
          do {
            x = int(random(j - 1, j + 2));
            y = int(random(i - 1, i + 2));
          } while (stage.ox[x][y] != 0 || 8 < stage.xo[x][y]);
          stage.ox[x][y] = turn % 2 == 0 ? 1 : -1;
          scn = 6;
          press = false;
        }
      }
    }
  }
}

class Guard2 extends Skill {
  Guard2(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void mouse() {
    fill(250, 100);
    rect(mouseX - 3 * len / 2, mouseY - 3 * len / 2, 3 * len, 3 * len);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && stage.xo[j][i] < 9) {
          for (int k = i - 1; k < i + 2; k++) {
            for (int l = j - 1; l < j + 2; l++) {
              stage.xo[k][l] += 2;
            }
          }
          scn = 6;
          press = false;
        }
      }
    }
  }
}

class Turn3 extends Skill {
  Turn3(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        stage.ox[j][i] *= -1;
      }
    }
    scn = 6;
    press = false;
  }
}

class Erase3 extends Skill {
  Erase3(String _name, int _size, int _cost) {
    super(_name, _size, _cost);
  }
  void mouse() {
    fill(250, 100);
    rect(mouseX - len / 2, mouseY - len / 2, len, len);
  }
  void effect() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && stage.ox[j][i] == (turn % 2 == 0 ? -1 : 1)) {
          stage.ox[j][i] = 0;
          scn = 6;
          press = false;
        }
      }
    }
  }
}
