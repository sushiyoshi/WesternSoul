class ScoreText extends Effect {
  boolean destroyFlag = false;
  Position position;
  float target_y;
  int score;
  int time=0;
  int frame = 20;
  color cl=color(255);
  ScoreText(Position position,int score) {
    this.position=position;
    target_y = position.y-10;
    this.score=score;
  }
  void operate() {
    position.y+=(target_y-position.y)/frame;
    time++;
  }
  boolean isDestroy(boolean prev_flag) {
      if(time > frame) return true;
      return prev_flag;
  }
  void render() {
    textAlign(CORNER);
    textFont(scoreFont);
    textSize(22);
    fill(255,180);
    text(str(score), position.x, position.y,100,50);
  }
}

class Score extends GameObject{
  Position target_position;
  float speed =  20;
  int score = 100000;
  float size = 20;
  Score(Position pos,int score) {
    this.position =pos;
    this.score = score;
    this.soul = new ScoreSoul(this,size,5,0);
    image = BulletImage.get("bullet5-13");
  }
  void operate() {
    //destroyFlag = true;
    if(soul.collision) {
      destroyFlag = true;
      pl.score += score;
    }
  }
  void update() {
    target_position = pl.position.getPosition();
    ang=aim(position,target_position);
    position.x += cos(rad(ang)) * speed * base_speed;
    position.y += sin(rad(ang)) * speed * base_speed;
  }
  void render() {
    imageMode(CENTER);
    noTint();
    tint(255,50);
    if(image != null)image(image,position.x,position.y,size,size);
  }
}
class ScoreSoul extends Soul {
  boolean display_flag = false;
  float alpha = 0;
  float target_alpha = 0;
  float target_size = 0;
  float size = 0;
  ScoreSoul(Score gmobj,float collider_size,int objType,int collider_target) {
    super(gmobj,collider_size,objType,collider_target);
  }/*
    void collisionDetection(Soul target,int targetType) {
      if(targetType == 0) {
        float size = target.collider_size+this.collider_size; 
        if(isCollision(target.position,this.position,size)) {
          this.collision = true;
        }
      }
    }
    */
    void collisionDetection(Soul target,int targetType) {
      if(targetType == 0) {
        Position line_start,line_goal;
        line_start = this.position.getPosition();
        line_goal = update_Position(this.position.getPosition(),this.gmobj.ang,this.gmobj.speed);
        
        if(isCrossLinesCircle(line_start,line_goal,target)) {
          this.collision = true;
          //println(target,this,line_start.x,line_start.y,line_goal.x,line_goal.y,target.position.x,target.position.y,target.collider_size);
        }
      }
  }
}
ArrayList<Add_ScoreText_Center> ScoreText_addData;
class ScoreText_Center_Maneger extends Event{
  ArrayList<ScoreText_Center> ScoreText_CenterList = new ArrayList<ScoreText_Center>();
  int num = 0;
  ScoreText_Center_Maneger() {
    layer = 5;
    ScoreText_addData = new ArrayList<Add_ScoreText_Center>();
  }
  void operate() {
    Iterator<ScoreText_Center> it = ScoreText_CenterList.iterator();
    while(it.hasNext()) {
      ScoreText_Center sc_t = it.next();
      sc_t.operate();
      if(sc_t.destroyFlag) {        
        //println(obj);
        it.remove();
        num--;
        println("remove_text",sc_t);
      }
    }
    Iterator<Add_ScoreText_Center> it2 = ScoreText_addData.iterator();
    while(it2.hasNext()) {
      Add_ScoreText_Center ad_sc_t = it2.next();
      ScoreText_Center sc_t = ad_sc_t.new_text(num);
      ScoreText_CenterList.add(sc_t);
      num++;
      println("add_sc_t",sc_t);
    }
    destroyFlag = !EventFlagList.get("Game").flag;
  }
  
  
}
class Add_ScoreText_Center {
  String key_text;
  int score;
  Add_ScoreText_Center(String key_text,int score) {
    this.key_text = key_text;
    this.score = score;
  }
  ScoreText_Center new_text(int num) {
    float target_y = text_size*1.5*num+ 200;
    if(score == -1) target_y = 100;
    Position position = new Position(WIDTH/2,target_y+120);
    return new ScoreText_Center(position.getPosition(),key_text,score,target_y);
  }
}
float text_size = 20*ratio;
class ScoreText_Center extends GameObject{
  Position position;
  float target_y;
  float targetAlpha;
  float alpha=0;
  int score=0;
  String key_text;
  ScoreText_Center(Position position,String key_text,int score,float target_y) {
    this.position = position;
    this.key_text = key_text;
    this.score = score;
    this.target_y = target_y;
  }
  void update() {
     position.y += (target_y-position.y)/15;
     targetAlpha = time > 100 ? 0 : 255;
     alpha += (targetAlpha-alpha)/15;
     if(time > 130) {
       destroyFlag = true;
       pl.score += score;
     }
  }
  void render() {
    textFont(stateFont);
    textAlign(CENTER);
    //noTint();
    textSize(text_size);
    fill(255,alpha);
    //text(key_text + ":  " + Integer.toString(score), position.x,position.y,300*ratio,50*ratio);
    if(score != -1) drawOutlineText(key_text + ":  " + Integer.toString(score), position.x,position.y,20*ratio, 255, 0,alpha);
    else drawOutlineText(key_text, position.x,position.y,40*ratio, 255, #00bfff,alpha);
    
  }
  void operate(){
    //update();
    //render();
    //time++;
    if(!EventFlagList.get("Pause").flag) {
      update();
      if(game_timer % (1/(base_speed)) == 0) {
        time++;
      }
      //time = (time - time) < base_speed ? time : 0;
    }
    render();
    
  }
}
Bonus bonus = new Bonus();
class Bonus {
  Bonus() {
    init();
  }
  int concentration_gauge_bonus = 0; 
  int fast_shot = 0;
  int hard_shot = 0;
  float timer_zero = 0;
  void new_score() {
    fast_shot = max(0,1000000 - floor(millis() / (1000.0) - timer_zero));
    fast_shot = floor(fast_shot/100000) * 100000;
    concentration_gauge_bonus += concentration_power * 1000000;
    ScoreText_addData.add(new Add_ScoreText_Center("DirectHit!",-1));
    if(fast_shot > 1000000)ScoreText_addData.add(new Add_ScoreText_Center("Fast Shot",fast_shot));
    if(hard_shot > 1000000)ScoreText_addData.add(new Add_ScoreText_Center("Hard Shot",hard_shot));
    if(concentration_gauge_bonus > 1000000)ScoreText_addData.add(new Add_ScoreText_Center("Gauge Bonus",concentration_gauge_bonus));
    init();
  }
  void init() {
    timer_zero = millis() / (1000.0);
    concentration_gauge_bonus = 100000000;
    fast_shot = 0;
    hard_shot = 0;
  }
}
