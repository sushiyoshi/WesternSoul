abstract class Player extends GameObject{
  int score=0;
  //boolean deadFlag = false;
  //boolean controlFlag = true;
  Player (Position position,float size,float speed) {
    this.position = position;
    this.size = size;
    this.speed = speed;
    soul = new PlayerSoul(this,size/7,0,4);
    this.image = cowboy;
    this.colider_target = 4;
  }
  //座標の更新　及び表示
  void update() {
      //if(!deadFlag) {
      //  if(soul.collision)  {
      //    deadFlag = true;
      //    controlFlag = false;
      //    time = 0;
      //    position = new Position(WIDTH/2,HEIGHT);
      //  }
      //} else {
      //  deadProcessing();
      //}
      if(soul.collision) {
        EventFlagList.get("Gameover").write_in_flag = true;
        soul.collision = false;
        destroyFlag = true;
      }  
      //if(controlFlag) {
        float sp = (key_input.KeyList.get("SHIFT").flag ? speed/2.5 : speed) * base_speed;
        if (key_input.KeyList.get("RIGHT").flag) position.x+=sp;
        if (key_input.KeyList.get("LEFT").flag) position.x-=sp;
        if (key_input.KeyList.get("UP").flag) position.y-=sp;
        if (key_input.KeyList.get("DOWN").flag) position.y+=sp;
      //}
      position.x=max(position.x,35);
      position.x=min(position.x,WIDTH-5);
      position.y=max(position.y,25);
      position.y=min(position.y,HEIGHT-35);
  }
  void render() {
    /*
    if(deadFlag) stroke(200,10,70);
    else stroke(2,200,45);
    */
    //if(deadFlag) tint(200,150);
    //else noTint();
    noTint();
    //float alpha = deadFlag ? 40 : 0;
    imageMode(CENTER);
    //image(oni,position.x,position.y,size,size);
    image(image,position.x,position.y,size,size);
  }
  //void deadProcessing() {
  //  if(time < 60) {
  //    position.y-=1.5*base_speed;
  //  } else if(time == 150) {
  //    deadFlag = false;
  //  } else {
  //    controlFlag = true;
  //  }
  //  soul.collision = false;
  //}
}

class Player0 extends Player {
  GameObject target = null;
  Player0(Position position,float size,float speed) {
    super(position,size,speed);
    //this.image = oni;
  }
  void operate(){
  }
  float aim(Position a,Position b) {
    return atan2(b.y-a.y,b.x-a.x) * 180 / PI;
  }
}

class PlayerSoul extends Soul {
  boolean display_flag = false;
  float alpha = 0;
  float target_alpha = 0;
  PlayerSoul(GameObject gmobj,float collider_size,int objType,int collider_target) {
    super(gmobj,collider_size,objType,collider_target);
    fireball = new FireBall(gmobj.position.getPosition(),collider_size/1.5);
    fireball.in_cl = color(255);
    fireball.out_cl = color(255,0,0);
    objType = 0;
  }
  void render() {
     display_flag = key_input.KeyList.get("SHIFT").flag;  
     fireball.display_flag = display_flag;
     fireball.position = gmobj.position.getPosition();
     fireball.operate();
   }
   void collisionDetection(Soul target,int targetType) {
     if(targetType == 5) {
        float size = target.collider_size+this.collider_size; 
        if(isCollision(target.position,this.position,size)) {
          target.collision = true;
        }
      } 
     if(collider_target == targetType) { 
        float size = target.collider_size+this.collider_size; 
        if(isCollision(target.position,this.position,size)) {
          this.collision = true;
        }
      }
    }
}
