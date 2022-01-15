class ScoreText extends Effect {
  boolean destroyFlag = false;
  Position position;
  float target_y;
  float score;
  int time=0;
  int frame = 20;
  color cl=color(255);
  ScoreText(Position position,float score) {
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
  int score = 10000;
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
