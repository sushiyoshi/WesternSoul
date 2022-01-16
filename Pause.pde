class Pause extends Event{
  ArrayList<ChoiceText> ChoiceTextList;
  int c = 0;
  ChoiceText current;
  boolean end_flag = false;
  Darkening dark;
  PImage Pause_menu_ = pause_menu_;
  int phase = 0;
  boolean choiced_flag = false;
  int option = 0;
  Pause() {
    this.layer = 6;
    EventFlagList.get("Pause").write_in_flag = true;
    dark = new Darkening();
    ChoiceTextList  = new ArrayList<ChoiceText>();
    Pause_menu_ = pause_menu_;
    ChoiceTextList.add(new Continue(320*ratio));
    ChoiceTextList.add(new ToTitle(360*ratio));
    ChoiceTextList.add(new Retry(400*ratio));
  }
  Pause(int option) {
    //GameOver
    if(option==1)println("GAMEOVER");
    this.layer = 6;
    this.option = option;
    EventFlagList.get("Pause").write_in_flag = true;
    Pause_menu_ = option==2 ? gameclear : gameover;
    dark = new Darkening();
    ChoiceTextList  = new ArrayList<ChoiceText>();
    ChoiceTextList.add(new ToTitle(360*ratio));
    ChoiceTextList.add(new Retry(400*ratio));
    c=1;
  }
  void operate() {
    dark.processing();
    imageMode(CORNER);
    noTint();
    tint(255,dark.alpha/100*255);
    
    //image(pause_menu,10,230,230,230);
    image(Pause_menu_,10*ratio,130*ratio,280*ratio,280*ratio);
    if(phase == 1) {
      if (key_input.KeyList.get("UP").occurrence_flag) c--;
      if (key_input.KeyList.get("DOWN").occurrence_flag) c++;
      //c = max(0,min(c,ChoiceTextList.size()-1));
    }
    if(c>=ChoiceTextList.size()) c=0;
    if(c<0) c=ChoiceTextList.size()-1;
    Iterator<ChoiceText> it = ChoiceTextList.iterator();
    int i=0;
    phase = 100;
    while(it.hasNext()) {
      ChoiceText chtext = it.next();
      chtext.processing();
      chtext.bool = c == i;
      if(c==i) current = chtext;
      end_flag |= chtext.animator.end_flag;
      phase = min(phase,chtext.animator.phase);
      i++;
    }
    if(phase == 1 && (key_input.KeyList.get("W").occurrence_flag || (key_input.KeyList.get("ALT").occurrence_flag && option==0)) && !choiced_flag) {
      if(key_input.KeyList.get("W").occurrence_flag){
        choiced_flag = true;
        if(c!=0)blackout.FadeIn();
        if(option==1) EventFlagList.get("Gameover").write_in_flag = false;
        if(option==2) EventFlagList.get("Gameclear").write_in_flag = false;
      }
      Destroy();
    }
    if(end_flag) {
      if(choiced_flag)current.event_operate();
      EventFlagList.get("Pause").write_in_flag = false;
      destroyFlag = true;
    }
  }
  void Destroy() {
    //println("Destroy",this);
    Iterator<ChoiceText> it = ChoiceTextList.iterator();
    if(dark.animator.phase == 1) dark.animator.current.endflag = true;
    while(it.hasNext()) {
      ChoiceText chtext = it.next();
      if(chtext.animator.phase == 1)chtext.animator.current.endflag = true;
    }
  }
  class PauseText extends ChoiceText {
    PauseText(float y) {
      super(y);
      this.base_x = 60;
      this.position.x = base_x;
    }
    void operate() {      
    }
  }
  
  class Continue extends PauseText {
    Continue(float y) {
      super(y);
      image = continue_;
      text = "一時停止を解除する";
    }
  }
  class ToTitle extends PauseText {
    ToTitle(float y) {
      super(y);
      image = return_to_title;
      text = "タイトル画面に戻る";
    }
    void event_operate() {
      EventFlagList.get("Game").write_in_flag = false;
      EventFlagList.get("Communication").write_in_flag = false;
      addEvent.add(new Title());
    }
  }
  class Retry extends PauseText {
    Retry(float y) {
      super(y);
      image = retry;
      text = "最初からもう一度";
    }
    void event_operate() {
      EventFlagList.get("Game").write_in_flag = false;
      EventFlagList.get("Communication").write_in_flag = false;
      addEvent.add(new Initialize());
    }
  }
}
abstract class ChoiceText{
  Position position = new Position(0,0);
  String text = "Defalut";
  float alpha = 255;
  float not_selected_alpha = 180;
  boolean bool = false;
  boolean destroyFlag = false;
  float vib_x =0;
  float base_x = 0;
  int time=0;
  float swing_width = 5;
  int text_color = 255;
  PImage image;
  Animation[] AnimationList = {
    new FadeIn(10,not_selected_alpha),
    new Animation(),
    new FadeOut(10,not_selected_alpha),
  };
  Animator animator = new Animator(AnimationList);
  ChoiceText(float y) {
    this.position.y = y;
  }
  void render() {
    /* 
    noTint();
     textFont(pauseFont);
     textAlign(CORNER);
     rectMode(CENTER);
     imageMode(CORNER);
     //drawOutlineText(text,position.x,position.y,23,text_color,0,alpha);
     */
     rectMode(CORNER);
     noTint();
     tint(255,alpha);
     image(image,position.x,position.y-50*ratio,70*3*ratio,30*3*ratio);
  }
  void update() {
    if(animator.phase == 1) {
      alpha = bool ? 255 : not_selected_alpha;
      text_color = bool ? #ffac88 : #ffffff;
    } else {
      alpha = animator.current.getAlpha(); 
      text_color = 255;
      //println(animator.phase,alpha,animator.current);
    }
    
    vib_x += ((bool ? 1:0)-vib_x) /5;
    position.x = base_x + swing_width * (vib_x);
  }
  void processing() {
    update();
    render();
    operate();
    animator.operate();
  }
  void operate(){}
  void event_operate(){}
}
class Darkening {
    float alpha_max = 100;
    float alpha = 0;
    Animation[] AnimationList = {
      new FadeIn(10,alpha_max),
      new Animation(),
      new FadeOut(10,alpha_max),
    };
    Animator animator = new Animator(AnimationList);
    void render() {
      rectMode(CORNER);
      noStroke();
      fill(#000000,alpha);
      rect(0,0,WIDTH+MARGIN,HEIGHT);
    }
    void update() {
      if(animator.phase == 1) {
        alpha = alpha_max;
      } else {
        alpha = animator.current.getAlpha();   
      }
    }
    void processing() {
      animator.operate();
      render();
      update();
    }
}
