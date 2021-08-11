class Stage {
  String name;
  int p = 5;
  int[][] ox = new int[num][num]; //0: null, 1: A, -1: B
  int[][] xo = new int[num][num]; //0: 書ける, 1<8: 書けない, 9: 使わない
  StageB b; //ステージ選択ボタン

  Stage(String _name) {
    name = _name;
    b = new StageB(this, color(250, 250, 150), width / 6, height / 16);
    String[] s = loadStrings(name + ".txt");
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        xo[j][i] = int(s[i*num+j]);
      }
    }
  }

  void update() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (xo[j][i] < 9) { //使えるマスのとき
          int[] sum = new int[4];
          for (int k = 0; k < p; k++) { //マスの合計を求める
            if (j + k < num) sum[0] += ox[j+k][i]; //右
            if (i + k < num) sum[1] += ox[j][i+k]; //下
            if (j + k < num && i + k < num) sum[2] += ox[j+k][i+k]; //右下
            if (j + k < num && 0 <= i - k) sum[3] += ox[j+k][i-k]; //右上
          }
          for (int k = 0; k < 4; k++) {
            if (sum[k] == p) { //合計がpのとき
              win = player[0].name + " win!"; //PlayerAの勝ち
              reset();
            } else if (sum[k] == -p) { //合計が-pのとき
              win = player[1].name + " win!"; //PlayerBの勝ち
              reset();
            }
          }
        }
      }
    }
  }

  void output() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (xo[j][i] < 9) { //使えるマスのとき
          stroke(250);
          if (0 < xo[j][i]) { //書けないマスのとき
            fill(150);
          } else { //通常マスのとき
            noFill();
          }
          rect((width - height) / 2 + len * j, len * i, len, len);
          fill(250); 
          textSize(2 * len / 3);
          if (ox[j][i] == 1) { //PlayerAのマスのとき
            text("O", (width - height + len - textWidth("O")) / 2 + len * j, len * (i + 0.75));
          } else if (ox[j][i] == -1) { //PlayerBのマスのとき
            text("X", (width - height + len - textWidth("X")) / 2 + len * j, len * (i + 0.75));
          }
        }
      }
    }
    noStroke();
    fill(250);
    ellipse(width / 2, height / 2, 8, 8);
    display();
  }

  void press() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (isIn((width - height) / 2 + len * j, len * i, len, len) && ox[j][i] == 0 && xo[j][i] < 1) {
          if (player[turn%2].sp < 99) { //spが99未満のとき
            player[turn%2].sp++; //spを更新する
          }
          ox[j][i] = (turn % 2 == 0) ? 1 : -1; //oxを更新する
          gimmick(); //ギミックを発動する
          reduce(); //マスの値を更新する
          turn++; //ターンを進める
        }
      }
    }
  }

  void reduce() {
    for (int i = 0; i < num; i++) {
      for (int j = 0; j < num; j++) {
        if (0 < xo[j][i] && xo[j][i] < 9) { //書けないマスのとき
          xo[j][i]--; //マスの値を更新する
        }
      }
    }
  }

  void gimmick() {
    //override
  }

  void display() {
    //override
  }
}

class Random extends Stage {
  Random(String _name) {
    super(_name);
    for (int i = 0, n = int(random(num / 3, num / 2)); i < n; i++) {
      int x = int(random(1, num - 1));
      int y = int(random(1, num - 1));
      int s = int(random(1, num));
      int w = int(random(1, 2 * s / 3));
      for (int j = 0; j < s / w; j++) {
        for (int k = 0; k < w; k++) {
          xo[(x+k)%num][(y+j)%num] = 9;
        }
      }
    }
  }
}

class Fallout extends Stage {
  int n = 9, r = int(random(2, n));
  Fallout(String _name) {
    super(_name);
  }
  void gimmick() {
    if (turn == r) {
      int x, y, z;
      do {
        x = int(random(num));
        y = int(random(num));
        z = int(random(2));
      } while (stage.xo[x][y] != 0);
      stage.ox[x][y] = 0;
      stage.xo[x][y] = 9;
      stage.ox[x+z%2][y+(z+1)%2] = 0;
      stage.xo[x+z%2][y+(z+1)%2] = 9;
      r += int(random(2, n));
    }
  }
}

class Move extends Stage {
  int n = 8;
  Move(String _name) {
    super(_name);
  }
  void gimmick() {
    if (n - turn % (n + 1) == 0) {
      int x, y, tmp;
      do {
        x = int(random(2, num - 2));
        y = int(random(2, num - 2));
      } while (x == y);
      if (1 < random(2)) {
        for (int i = 0; i < num; i++) {
          tmp = ox[i][x];
          ox[i][x] = ox[i][y];
          ox[i][y] = tmp;
        }
      } else {
        for (int i = 0; i < num; i++) {
          tmp = ox[x][i];
          ox[x][i] = ox[y][i];
          ox[y][i] = tmp;
        }
      }
    }
  }
  void display() {
    fill(250, 250, 150);
    textSize(height / 20);
    if (n - turn % (n + 1) == 0) {
      text("Change!", width / 2 - textWidth("Change!") / 2, height / 10);
    } else {
      text(n - turn % (n + 1), width / 2 - textWidth(n - turn % (n + 1) + "") / 2, height / 10);
    }
  }
}

class Erasers extends Stage {
  E[] e = new E[2];
  Erasers(String _name) {
    super(_name);
    for (int i = 0; i < e.length; i++) {
      e[i] = new E();
    }
  }
  void gimmick() {
    for (int i = 0; i < e.length; i++) {
      e[i].update();
    }
  }
  void display() {
    for (int i = 0; i < e.length; i++) {
      e[i].output();
    }
  }
  class E {
    int x, y;
    E() {
      do {
        x = int(random(num / 4, 3 * num / 4));
        y = int(random(num / 4, 3 * num / 4));
      } while (xo[x][y] != 0);
    }
    void update() {
      int vx, vy;
      do {
        vx = int(random(-2, 2));
        vy = int(random(-2, 2));
      } while (xo[x+vx][y+vy] == 9 || vx == 0 && vy == 0);
      x += vx;
      y += vy;
      ox[x][y] = 0;
    }
    void output() {
      noStroke();
      fill(0, 0, 100);
      ellipse((width - height + len) / 2 + len * x, len * y + 3 * len / 5, len, len /2);
      fill(200, 100, 0);
      rect((width - height) / 2 + len * x, len * y + len / 6, len, len / 2);
      fill(0);
      rect((width - height) / 2 + len * x + 2 * len / 5, len * y + len / 6, len / 5, len / 2);
    }
  }
}

class SPfever extends Stage {
  S[] s = new S[int(random(12, 20))];
  SPfever(String _name) {
    super(_name);
    for (int i = 0; i < s.length; i++) {
      s[i] = new S();
    }
  }
  void gimmick() {
    for (int i = 0; i < s.length; i++) {
      s[i].update();
    }
  }
  void display() {
    for (int i = 0; i < s.length; i++) {
      s[i].output();
    }
  }
  class S {
    int x, y;
    boolean b = true;
    S() {
      do {
        x = int(random(num));
        y = int(random(num));
      } while (xo[x][y] != 0);
    }
    void update() {
      if (isIn((width - height) / 2 + len * x, len * y, len, len) && b) {
        player[turn%2].sp += int(random(-3, 9));
        b = false;
      }
    }
    void output() {
      if (b) {
        noStroke();
        fill(250, 250, 150);
        text("?", (width - height + len - textWidth("?")) / 2 + len * x, len * (y + 0.75));
      }
    }
  }
}
