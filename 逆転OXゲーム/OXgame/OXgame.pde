int num; //マスの数
float len; //マスの幅
String win;
PImage img;
BackB backB;
ResetB resetB;
SceneB startB, skillA, stageB, skillB, okB;

int scn; //シーン変数
int turn; //ターン変数
Player[] player = new Player[2];
Skill[] skills = new Skill[14];
Stage[] stages = new Stage[7];
Stage stage;

int k; //コナミコマンド

////////////////////////////////
void setup() {
  size(1280, 720);
  textFont(createFont("MS Gothic", 1));
  num = 16;
  len = 1.0 * height / num;
  win = "";
  img = loadImage("title.png");
  startB = new SceneB("Start", color(200), width / 4, height / 6, 2);
  skillA = new SceneB("PlayerA", color(250, 150, 150), width / 4, height / 6, 3);
  stageB = new SceneB("Stage", color(250, 250, 150), width / 4, height / 6, 4);
  skillB = new SceneB("PlayerB", color(150, 200, 250), width / 4, height / 6, 5);
  okB = new SceneB("OK", color(200), width / 4, height / 6, 6);
  resetB = new ResetB("Reset", color(150), width / 9, height / 10);
  backB = new BackB("Back", color(150), width / 9, height / 10);
  reset();
}

void draw() {
  fill(150, 100, 0);
  rect(0, 0, width, height);
  fill(0, 100, 0);
  rect(4, 4, width - 8, height - 8);
  backB.update();
  backB.output(width / 8, 7 * height / 8);
  switch(scn) {
  case 0:
    exit();
    break;
  case 1: //タイトル
    fill(250);
    textSize(height / 20);
    text(win, width / 20, height / 10);
    image(img, width / 2 - width / 6, height / 8, width / 3, height / 2);
    startB.update();
    startB.output(width / 2, 3 * height / 4);
    break;
  case 2: //セレクト
    skillA.update();
    skillA.output(width / 5, height / 2);
    stageB.update();
    stageB.output(width / 2, height / 2);
    skillB.update();
    skillB.output(4 * width / 5, height / 2);
    okB.update();
    okB.output(width / 2, 3 * height / 4);
    break;
  case 3: //スキルセレクト
    player[0].output();
    for (int i = 0, j = 0; i < skills.length; j++) {
      for (int k = 0; i < skills.length && skills[i].size == j + 1; k++) {
        skills[i++].output(width / 2 + height * (j - 1) / 3, height * (k + 1) / 10, 0, 1);
      }
    }
    resetB.update();
    resetB.output(width / 2, 7 * height / 8);
    break;
  case 4: //ステージセレクト
    fill(250, 250, 150);
    textSize(height / 8);
    text("Stage: " + stage.name, (width - textWidth("Stage: " + stage.name)) / 2, height / 4);
    for (int i = 0, j = 0; i < stages.length; j++) {
      for (int k = 0; i < stages.length && k < 5; k++) {
        stages[i].b.update();
        stages[i].b.output(width * (k + 0.5) / 5, height / 2 + height * j / 10);
        i++;
      }
    }
    break;
  case 5: //スキルセレクト
    for (int i = 0, j = 0; i < skills.length; j++) {
      for (int k = 0; i < skills.length && skills[i].size == j + 1; k++) {
        skills[i++].output(width / 2 + height * (j - 1) / 3, height * (k + 1) / 10, 0, 1);
      }
    }
    player[1].output();
    resetB.update();
    resetB.output(width / 2, 7 * height / 8);
    break;
  case 6: //メインモード
  case 7: //スキルモード
    stage.update();
    stage.output();
    player[0].output();
    player[1].output();
    break;
  }
  mouse();
}

void mousePressed() {
  backB.press(width / 8, 7 * height / 8);
  switch (scn) {
  case 1: //タイトル
    startB.press(width / 2, 3 * height / 4);
    break;
  case 2: //セレクト
    skillA.press(width / 5, height / 2);
    stageB.press(width / 2, height / 2);
    skillB.press(4 * width / 5, height / 2);
    okB.press(width / 2, 3 * height / 4);
    break;
  case 3: //スキセレクト
    for (int i = 0, j = 0; i < skills.length; j++) {
      for (int k = 0; i < skills.length && skills[i].size == j + 1; k++) {
        skills[i++].press(width / 2 + height * (j - 1) / 3, height * (k + 1) / 10);
      }
    }
    resetB.press(width / 2, 7 * height / 8);
    break;
  case 4: //ステージセレクト
    for (int i = 0, j = 0; i < stages.length; j++) {
      for (int k = 0; i < stages.length && k < 5; k++) {
        stages[i++].b.press(width * (k + 0.5) / 5, height / 2 + height * j / 10);
      }
    }
    break;
  case 5: //スキルセレクト
    for (int i = 0, j = 0; i < skills.length; j++) {
      for (int k = 0; i < skills.length && skills[i].size == j + 1; k++) {
        skills[i++].press(width / 2 + height * (j - 1) / 3, height * (k + 1) / 10);
      }
    }
    resetB.press(width / 2, 7 * height / 8);
    break;
  case 6: //メインモード
    stage.press();
  case 7: //スキルモード
    player[turn%2].press();
    break;
  }
}

void keyPressed() {
  switch (scn) {
  case 6: //メインモード
  case 7: //スキルモード
    if (keyCode == UP && (k == 0 || k == 1)) k++;
    if (keyCode == DOWN && (k == 2 || k == 3)) k++;
    if (keyCode == LEFT && (k == 4 || k == 6)) k++;
    if (keyCode == RIGHT && (k == 5 || k == 7)) k++;
    if (keyCode == 'B' && k == 8) k++;
    if (keyCode == 'A' && k == 9) {
      player[turn%2].sp = 99;
      k++;
    }
    break;
  }
}

void reset() {
  scn = 1;
  turn = 0;
  player[0] = new Player("PlayerA", (width - height) / 4);
  player[1] = new Player("PlayerB", (3 * width + height) / 4);
  skills[0] = new Swap("シャンブル", 1, 12);
  skills[1] = new Turn1("グルメスパイザー", 1, 12);
  skills[2] = new MoveM("日大タックル", 1, 13);
  skills[3] = new MoveY("サイコキネシス", 1, 13);
  skills[4] = new SPdown("SPダウン", 1, 14);
  skills[5] = new Erase1("ファントム", 1, 15);
  skills[6] = new Write1("グングニル", 1, 15);
  skills[7] = new Guard1("Fence of Gaia", 1, 16); 
  skills[8] = new Turn2("イリュージョン", 2, 26);
  skills[9] = new Erase2("城之内ファイアー", 2, 28);
  skills[10] = new Write2("飛鳥文化アタック", 2, 28);
  skills[11] = new Guard2("スーパーイージス", 2, 30);
  skills[12] = new Turn3("ypaaaaaaaaaaaaaaaaaaa", 3, 49);
  skills[13] = new Erase3("お前の席ねぇから", 3, 49);
  stages[0] = new Stage("バトルドーム");
  stages[1] = new Stage("円弧のマエストロ");
  stages[2] = new Random("岡山の県北");
  stages[3] = new Fallout("もう助からないゾ");
  stages[4] = new Move("テクニシャンズ");
  stages[5] = new Erasers("黒板消し");
  stages[6] = new SPfever("チャージングGO!!");
  stage = stages[0];
  k = 0;
}

void mouse() {
  switch (scn) {
  case 6:
    noCursor();
    fill(250);
    textSize(len / 2);
    if (turn % 2 == 0) {
      text("O", mouseX - textWidth("O") / 2, mouseY + len / 8);
    } else {
      text("X", mouseX - textWidth("X") / 2, mouseY + len / 8);
    }
    break;
  default:
    cursor(ARROW);
    break;
  }
}

boolean isIn(float x, float y, float w, float h) {
  if (x < mouseX && mouseX < x + w && y < mouseY && mouseY < y + h) {
    return true;
  } else {
    return false;
  }
}
