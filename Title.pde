class Title extends Event {
  int time = 0;
  boolean start_flag;
  boolean press_ok_flag = false;
  TitleLogo logo = new TitleLogo(new Position(1000/2,750/2),620*ratio);
  Title() {
    println("title");
    EventFlagList.get("Title").write_in_flag = true;
    start_flag = false;
    blackout.FadeOut();
  }
  void operate() {
    if(time > 80) press_ok_flag = true;
    background(50); 
    noTint();
    //textFont(serifFont);
    //textAlign(CORNER);
    //rectMode(CENTER);
    //imageMode(CORNER);
    //image(background2,0,0,1000,750);
    //sd.set("time", millis() / (1000.0));
    //sd.set("resolution", (float)width, (float)height);  
    //sd.set("skycolor",0.2,0.1,0.9);
    //filter(sd);
    imageMode(CENTER);
    //image(title,1000/2,750/2,620*ratio,620*ratio);
    logo.render();
    textFont(stateFont);
     textAlign(CENTER);
    if(press_ok_flag)drawOutlineText("press the w key",1000/2,400*ratio,25,255,0,sin(time/5)*255 - 255/2);
    if(blackout.endflag && start_flag) { 
      println("start");
      addEvent.add(new Initialize());
      destroyFlag = true;
      EventFlagList.get("Title").write_in_flag = false;
    }
    if(press_ok_flag && key_input.KeyList.get("W").occurrence_flag) {
      blackout.FadeIn();
      start_flag = true;
    }
    time++;
  }
}

class Choice {

}
class TitleLogo {
  Position position = new Position(0,0);
  float size = 620*ratio;
  //Position title2_text_pos = new Position(0,0);
  HashMap<String,Peace> PeaceList = new HashMap<String,Peace>();
  TitleLogo(Position position,float size) {
    this.position = position;
    this.size =size;
    int startFrame = 20;
    PeaceList.put("title2_gunman_shadow" ,new Peace(title2_gunman_shadow,new Position(position.x -20,position.y),620*ratio,0, startFrame+60));
    PeaceList.put("title2_gunman" ,new Peace(title2_gunman,new Position(position.x -20,position.y),620*ratio,0, startFrame));
    PeaceList.put("title2_text_shadow" ,new Peace(title2_text_shadow,this.position.getPosition(),620*ratio,20, startFrame + 20));
    PeaceList.put("title2_gun_shadow" ,new Peace(title2_gun_shadow,new Position(position.x +20,position.y),620*ratio,0, startFrame+60));
    PeaceList.put("title2_gun" ,new Peace(title2_gun,new Position(position.x +20,position.y),620*ratio,0, startFrame));
    PeaceList.put("title2_text" ,new Peace(title2_text,this.position.getPosition(),620*ratio,45, startFrame + 20));
    PeaceList.put("title2_text_eng" ,new Peace(title2_text_eng,this.position.getPosition(),620*ratio,-30, startFrame + 30));
    //PeaceList.put("title2_text" ,new Peace(this.position.getPosition(),620*ratio,45,30));
  }
  void render() {
    //title2_gunman_shadow,title2_text_shadow,title2_gun_shadow,title2_text_eng,title2_gun,title2_text
    imageMode(CENTER);
    //image(title2_gunman_shadow,position.x,position.y,size,size);
    //image(title2_gunman,position.x,position.y,size,size);
    //image(title2_text_shadow,position.x,position.y,size,size);
    //image(title2_gun_shadow,position.x,position.y,size,size);
    //image(title2_gun,position.x,position.y,size,size);
    //image(title2_text,title2_text_pos.x,title2_text_pos.y,size,size);
    //image(title2_text_eng,position.x,position.y,size,size);
    for(String k: PeaceList.keySet()) {
      PeaceList.get(k).render();
    }
  }
  class Peace {
    Position position = new Position(0,0);
    float alpha = 0;
    float targetAlpha = 0;
    boolean displayFlag = true;
    float size = 620*ratio;
    float ang;
    float frame = 20;
    boolean move_flag = false;
    int time = 0;
    int targetTime = 0;
    PImage img;
    Peace(PImage img,Position position,float size,float ang,int targetTime) {
    //Peace(Position position,float size,float ang,int targetTime) {
      this.position = position;
      println("peace:",position.x);
      this.size =size;
      this.ang = ang;
      this.targetTime = targetTime;
      this.targetAlpha = 255;
      this.img = img;
    }
    void render() {
      if(targetTime < time) move_flag = true;
      if(move_flag) ang += (0-ang)/frame;
      pushMatrix();
      //translate( position.x + img.width/2, position.y + img.height/2 );
      translate( position.x , position.y );
      rotate(rad(ang));
      targetAlpha = displayFlag ? 255 : 0;
      if(move_flag)position.x += (TitleLogo.this.position.x-position.x)/frame;
      if(move_flag)position.y += (TitleLogo.this.position.y-position.y)/frame;
      if(move_flag)alpha += (targetAlpha -alpha) /frame;
      tint(255,alpha);
      image(img,0,0,size,size);
      //image(title2_text,0,0,size,size);
      popMatrix();
      time++;
    }
  }
}

//ゲームを始める際に実行される処理
class Initialize extends Event {
  void operate() {
    collider = new Collider(6);
    objData  = new ArrayList<GameObject>();
    pl = new Player0(new Position(WIDTH/2,HEIGHT-50),PLAYER_SIZE,PLAYER_SPEED);
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
    addEvent.add(new ScoreText_Center_Maneger());
    EventFlagList.get("Concentration").write_in_flag = false;
    destroyFlag = true;
    blackout.FadeOut();
    
  }  
}
