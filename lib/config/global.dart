enum GameStatus { pause, run, gameover }

class Global {
  static double deviceWidth = 0;
  static double deviceHeight = 0;

  static GameStatus status = GameStatus.gameover;
  static int level = 1;
  static double gameSpeed = 100;
  static int score = 0;
  static double timer = 0;

  static bool isPause() => status == GameStatus.pause;
  static bool isRun() => status == GameStatus.run;
  static bool isOver() => status == GameStatus.gameover;
}
