//敵、弾
abstract class EnemyObject extends GameObject{
  float accele = 0,ang=90,frame,max;
  EnemyObject() {
    speed = 1;
    size =15*ratio;
  }
  Position target = new Position(-1,-1);
  String moveType = "DEFAULT"; 
  boolean moveFlag = false;
  void update() {
    switch(moveType) {
      case "TARGET":
      targetMove();
      break;
      default:
      defaultMove();
      break;
    }
  }
  void defaultMove() {
    position.x += cos(rad(ang)) * speed * base_speed;
    position.y += sin(rad(ang)) * speed * base_speed;
    speed += accele * (base_speed * base_speed);
  }
  void targetMove() {
    float targetSpeed,defaultSpeed,speed;
    targetSpeed = (target.x-position.x) / frame;
    defaultSpeed = cos(rad(aim(position,target))) * max;
    speed =  abs(targetSpeed) < abs(defaultSpeed) ? targetSpeed : defaultSpeed;
    position.x += speed * base_speed;
    targetSpeed = (target.y-position.y) / frame;
    defaultSpeed = sin(rad(aim(position,target))) * max;
    speed =  abs(targetSpeed) < abs(defaultSpeed) ? targetSpeed : defaultSpeed;
    position.y += speed * base_speed;
  }
  void createObject(EnemyObject obj) {
    addData.add(obj);
  }
  /*
  void move(Position target,float speed) {
    ang = aim(position,target);
    this.speed = speed;
    float dis = distance(position,target);
    accele = sq(speed)/(2*dis) * -1.0; 
  }*/
  void targetMode(Position target,float frame,float max) {
    moveType = "TARGET";
    this.target = target;
    this.frame = frame;
    this.max = max;
  }
}
//ステージ
abstract class Stage extends Event {
  int time = 0;
  Stage() {
    layer = -1;
  }
  void operate() {
    if(!EventFlagList.get("Pause").flag &&game_timer % (1/base_speed) == 0) {
      game(); 
      time++;
    }
    destroyFlag = !EventFlagList.get("Game").flag;
  }
  void game(){}
  //敵
 
}
 abstract class Enemy extends EnemyObject{
  int hp;
  float defeatScore = 1000;
  float shotScore = 100;
  Enemy(Position position,int hp) {
    this.position = position;
    this.hp = hp;
    this.colider_target = 1;
    EnemyList.add(this);
    soul = new EnemySoul(this,size,3,1);
  }
  boolean isDestroy(boolean prev_flag) {
    if(soul.collision) {
      hp--;
      pl.score += shotScore;
      soul.collision = false;
    }
    if(position.x > (WIDTH + MARGIN) || position.x < MARGIN*-0.5 || position.y > (HEIGHT + MARGIN) || position.y < MARGIN * -0.5) {
      return true;
    }
    if(hp <= 0) {
      pl.score += defeatScore;
      addData.add(new Explosion(position.getPosition(),100.0,10.0,image));
      return true;
    }
    return prev_flag;
  }
  void processing() {
    if(!EventFlagList.get("Pause").flag) {
      update();
      if(game_timer % (1/(base_speed)) == 0) {
        operate();
        time++;
      }
      //time = (time - time) < base_speed ? time : 0;
    }
    render();
    drawAfterimage();
    //if(soul != null)soul.operate();
    
    destroyFlag |= DestroyFlagList.get("Enemy").change_flag;
    destroyFlag = isDestroy(destroyFlag);
  }
  EnemyBullet defaultEnemyBullet() {
    return new EnemyBullet(this.position.getPosition());
  }
}

//敵が発射する弾
class EnemyBullet extends EnemyObject{
  int score = 10000;
  EnemyBullet(Position pos) {
    this.colider_target = 0;
    this.position =pos;
    soul = new Soul(this,size/5,4,0);
  }
  void processing() {
    if(!EventFlagList.get("Pause").flag) {
      update();
      if(game_timer % (1/(base_speed)) == 0) {
        operate();
        time++;
      }
      //time = (time - time) < base_speed ? time : 0;
    }
    render();
    drawAfterimage();
    destroyFlag |= DestroyFlagList.get("EnemyBullet").change_flag;
    if(DestroyFlagList.get("EnemyBullet").change_flag){
      addData.add(new ScoreText(position.getPosition(),score));
      addData.add(new Score(position.getPosition(),score));
    }
    destroyFlag = isDestroy(destroyFlag);
  }
}

class EnemySoul extends Soul {
  boolean display_flag = false;
  float alpha = 0;
  float target_alpha = 0;
  float target_size = 0;
  float size = 0;
  EnemySoul(Enemy gmobj,float collider_size,int objType,int collider_target) {
    super(gmobj,collider_size,objType,collider_target);
    objType = 4;
    fireball = new FireBall(gmobj.position.getPosition(),collider_size/2);
  }
  void render() {
        display_flag = EventFlagList.get("Concentration").flag;
       fireball.display_flag = display_flag;
       fireball.position = gmobj.position.getPosition();
       fireball.operate();
    }
}
