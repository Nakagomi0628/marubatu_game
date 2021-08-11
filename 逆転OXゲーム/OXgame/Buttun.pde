class Buttun {
  int cnt = 0;
  float w, h;
  boolean press = false;
  String msg;
  color[] cols = {color(0), color(250)};

  Buttun(String _msg, color _col, float _w, float _h) {
    msg = _msg;
    cols[0] = _col;
    w = _w;
    h = _h;
  }

  void update() {
    if (press) {
      cnt++;
      if (6 < cnt) {
        cnt = 0;
        press = false;
        effect();
      }
    }
  }

  void output(float x, float y) {
    noStroke();
    fill(cols[cnt%2]);
    rect(x - w / 2, y - h / 2, w, h);
    fill(0);
    textSize(h / 2);
    text("  " + msg, x - w / 2, y + h / 6);
  }

  void press(float x, float y) {
    press = isIn(x - w / 2, y - h / 2, w, h);
  }

  void effect() {
    //override
  }
}

class BackB extends Buttun {
  BackB(String _msg, color _col, float _w, float _h) {
    super(_msg, _col, _w, _h);
  }
  void effect() {
    switch (scn) {
    case 1: //タイトル
    case 2: //セレクト
      scn--; //一つ前のシーンに戻る
      break;
    case 3: //スキルセレクト
    case 4: //ステージセレクト
    case 5: //スキルセレクト
      scn = 2; //シーン2に戻る
      break;
    case 6: //メインモード
    case 7: //スキルモード
      reset(); //リセットする
      break;
    }
  }
}

class ResetB extends Buttun {
  ResetB(String _msg, color _col, float _w, float _h) {
    super(_msg, _col, _w, _h);
  }
  void effect() {
    switch (scn) {
    case 3: //スキルセレクト
      player[0].reset(); //PlayerAのスキルをリセット
      break;
    case 5: //スキルセレクト
      player[1].reset(); //PlayerBのスキルをリセット
      break;
    }
  }
}

class SceneB extends Buttun {
  int n;
  SceneB(String _msg, color _col, float _w, float _h, int _n) {
    super(_msg, _col, _w, _h);
    n = _n;
  }
  void effect() {
    scn = n; //シーンをnにする
  }
}

class StageB extends Buttun {
  Stage s;
  StageB(Stage _s, color _col, float _w, float _h) {
    super(_s.name, _col, _w, _h);
    s = _s;
  }
  void effect() {
    stage = s; //ステージをsにする
  }
}
