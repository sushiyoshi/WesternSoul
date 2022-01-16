//画像やフォントなどの読み込みを行う。このクラスが実行中、ローディング画面が表示される。
class Load extends Event implements Runnable{
  int time = 0;
  char[] ltxt=new String("NowLoading").toCharArray();
  float size = 35;
  public Load() {
    EventFlagList.get("Loading").write_in_flag = true;
    //並列処理関数runを実行
    new Thread(this).start();
  }
  //並列処理
  public void run() {
    //logo = loadImage("western_soul.png");
    //logo = loadImage("western_soul_.png");
    //logo = loadImage("logo.png");
    //frame_image = loadImage("frame.png");
    score_text = loadImage("score_text.png");
    //player_text = loadImage("player_text.png");
    //bomb_text = loadImage("bomb_text.png");
    //window = loadImage("window.png");
    //oni = loadImage("oni.png");
    //life = loadImage("life.png");
    //hoshi = loadImage("hoshi.png");
    boss_1 = loadImage("cow.png");
    //inu = loadImage("inu.png");
    background = loadImage("haikei.png");
    background2  = loadImage("title_gamen.png");
    //oni_tatie = loadImage("oni_tatie.png");
    //pause_menu = loadImage("pause_menu.png");
    pause_menu_ = loadImage("pause_menu_.png");
    continue_ = loadImage("continue.png");
    retry = loadImage("retry.png");
    return_to_title = loadImage("return_to_title.png");
    cowboy = loadImage("player.png");
    concentration = loadImage("concentration.png");
    title = loadImage("title2.png");
    reloading = loadImage("reloading.png");
    player_tatie = loadImage("player_tatie.png");
    gameover = loadImage("gameover.png");
    gameclear = loadImage("gameclear.png");
    gamestart = loadImage("gamestart.png");
    gozu = loadImage("172840.png");
    east_soul = loadImage("east_soul.png");
    magic_circle = loadImage("aiueo.png");
    title2_gunman_shadow = loadImage("title2_gunman_shadow.png");
    title2_text_shadow = loadImage("title2_text_shadow.png");
    title2_gun_shadow = loadImage("title2_gun_shadow.png");
    title2_text_eng = loadImage("title2_text_eng.png");
    title2_gun = loadImage("title2_gun.png");
    title2_text = loadImage("title2_text.png");
    title2_gunman = loadImage("title2_gunman.png");
    stateFont = loadFont("AppleSDGothicNeo-Heavy-48.vlw");
    serifFont = createFont("MS PGothic.vlw",48,true);
    //serifFont = loadFont("AppleMyungjo-48.vlw");
    //pauseFont = loadFont("LightNovelPopV2-V2-48.vlw");
    //pauseFont = loadFont("HanziPenSC-W5-48.vlw");
    pauseFont = loadFont("HannotateSC-W5-48.vlw");
    scoreFont = loadFont("Beirut-48.vlw");
    
    //serifFont = loadFont("HannotateSC-W5-48.vlw");
    textFont(serifFont, 48);
    for(int i = 0; i<=7;i++) {
      for(int j = 0; j< 14; j++) {
        String id = "bullet" + Integer.toString(i) + '-' + Integer.toString(j);
        BulletImage.put(id,loadImage(id + ".png"));
      }
    }
    
    EventFlagList.put("Game",new EventState());
    EventFlagList.put("Title",new EventState());
    EventFlagList.put("Pause",new EventState());
    EventFlagList.put("Communication",new EventState());
    EventFlagList.put("Concentration",new EventState());
    sd = loadShader("test3.glsl");
    EventFlagList.get("Loading").write_in_flag = false;
    destroyFlag = true;
    blackout = new BlackOut(BlackState.Stable);
    
  }
  //ローディング画面の描画
  void operate() {
    textSize(size);
     for (int i=0; i<ltxt.length; i++) {
      text(ltxt[i], width/2 + size * (i - ltxt.length/2), height/2 + sin(radians(frameCount+i*3)*3)*50);
     }
  }
} 
