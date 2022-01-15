class Title extends Event {
  int time = 0;
  boolean start_flag;
  Title() {
    EventFlagList.get("Title").write_in_flag = true;
    start_flag = false;
    blackout.FadeOut();
  }
  void operate() {
    background(50); 
    noTint();
    //textFont(serifFont);
    //textAlign(CORNER);
    //rectMode(CENTER);
    imageMode(CENTER);
    image(title,1000/2,750/2,620*ratio,620*ratio);
     drawOutlineText("press the w key",250*ratio,400*ratio,25,255,0,sin(time/5)*255 - 255/2);
    if(blackout.endflag && start_flag) { 
      println("start");
      addEvent.add(new Initialize());
      destroyFlag = true;
      EventFlagList.get("Title").write_in_flag = false;
    }
    if(key_input.KeyList.get("W").occurrence_flag) {
      blackout.FadeIn();
      start_flag = true;
    }
    time++;
  }
}

class Choice {

}

//ゲームを始める際に実行される処理
class Initialize extends Event {
  void operate() {
    collider = new Collider(6);
    objData  = new ArrayList<GameObject>();
    pl = new Player0(new Position(WIDTH/2,HEIGHT/2),PLAYER_SIZE,PLAYER_SPEED);
    stage = new Stage0();
    //back = new BackGround();
    objData.add(pl);
    addEvent.add(new GameObjectDrawing());
    addEvent.add(new Frame());
    addEvent.add(new BackGround());
    addEvent.add(new Stage0());
    addEvent.add(new Concentration_Manager());
    addEvent.add(new PlayerBulletManager());
    addEvent.add(new SoulManager());
    EventFlagList.get("Concentration").write_in_flag = false;
    destroyFlag = true;
    blackout.FadeOut();
    
  }  
}
