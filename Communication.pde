//会話イベント
class Communication extends Event{  
  Picture[] StandingPicture;
  Serif[] serifList;
  int serifLength;
  String text;
  String sp_text;
  int num = 0;
  PImage image;
  float y = 360*ratio;
  Communication(Serif[] serifList,Picture[] StandingPicture) {
    EventFlagList.get("Communication").write_in_flag = true;
    this.serifList = serifList;
    this.StandingPicture = StandingPicture;
    serifLength = serifList.length;
    layer = 4;
  }
  void operate() {
    if(num >= serifLength || !EventFlagList.get("Communication").flag)  {
      EventFlagList.get("Communication").write_in_flag = false;
      destroyFlag = true;
    } else {
      Serif speaking = serifList[num];
      sp_text = speaking.speaker_text;
      int len = StandingPicture.length;
      for(int i = 0; i<len; i++) {
        StandingPicture[i].operate(sp_text);
      }
      rectMode(CORNER);
      noStroke();
      fill(20,150);
      rect(30*ratio,y,310*ratio,65*ratio);
      
      textFont(serifFont);
      textAlign(CORNER);
      noTint();
      textSize(14*ratio);
      fill(255,255);
      text(speaking.text, 40*ratio, y+20,300*ratio,50*ratio);
      if((key_input.KeyList.get("W").occurrence_flag || key_input.KeyList.get("CONTROL").flag) && !EventFlagList.get("Pause").flag) num++;
    }
  }
}
class Serif {
  String text;
  String speaker_text;
  Serif(String text,String speaker_text) {
    this.text = text;
    this.speaker_text = speaker_text;
  }
}
class Picture {
  PImage image;
  String name;
  float speaker_y = 330*ratio;
  float notSpeaker_y = 340*ratio;
  Position position = new Position(0,notSpeaker_y-30*ratio);
  float targetY = notSpeaker_y;
  float frame = 5;
  Picture(String name) {
    this.name = name;
    position.x  = 40*ratio;
  }
  Picture(PImage image,String name,boolean pos) {
    this.image = image;
    this.name = name;
    position.x  = pos ? 90*ratio : 290*ratio;
  }
  void update() {
    position.y += (targetY-position.y) /frame;
  }
  void operate(String str) {
    boolean bool = name == str;
    targetY = bool ? speaker_y : notSpeaker_y;
    imageMode(CENTER);
    if(bool) {
      noTint();
    } else {
      tint(100,150);
    }
    update();
    float size = bool ? 1.2:1.0;
    image(image,position.x,position.y,320*size*ratio,320*size*ratio);
  }
}
