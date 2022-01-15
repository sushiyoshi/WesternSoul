abstract class Effect extends GameObject {
  float targetSize = 10,max,frame,sizeFrame = 1,ang=90;
  Position target = new Position(0,0);
  String moveType = "DEFAULT";
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
  void myResize() {
    size += (targetSize-size) / sizeFrame;
  }
}
class Explosion extends Effect {
  float alpha = 255;
  Explosion(Position position,float size,float frame,PImage image) {
    this.position = position;
    this.targetSize = size;
    this.sizeFrame = frame;
    this.image = image;
  }
  void operate() {
    myResize();
    alpha +=  (0-alpha)/sizeFrame;
    tint(255,alpha);
    time++;
  }
  boolean isDestroy(boolean prev_flag) {
      if(time > sizeFrame) return true;
      return prev_flag;
  }
  void render() {
    imageMode(CENTER);
    if(image != null)image(image,position.x,position.y,size,size);
    //rect(position.x,position.y,size,size);
    
  }
}
/*
class Explosion extends Effect {
}*/

class Appearance extends Effect {
  float alpha = 0;
  Appearance(Position position,float size,float frame,PImage image) {
    this.position = position;
    this.targetSize = size;
    this.sizeFrame = frame;
    this.image = image;
    this.size = size*2;
  }
  void operate() {
    myResize();
    alpha +=  (400-alpha)/sizeFrame;
    tint(255,alpha);
    time++;
  }
  boolean isDestroy(boolean prev_flag) {
      if(time > sizeFrame) return true;
      return prev_flag;
  }
  void render() {
    imageMode(CENTER);
    if(image != null)image(image,position.x,position.y,size,size);
    //rect(position.x,position.y,size,size);
    
  }
}

class Afterimage extends Effect {
  float destroyTime = 5;
  float alpha = 255;
  Afterimage(Position position,PImage image) {
    this.position = position;
    this.image = image;
  }
  void operate() {
    alpha +=  (0-alpha)/destroyTime;
    tint(255,alpha);
    time++;
  }
  boolean isDestroy(boolean prev_flag) {
      if(time > destroyTime) return true;
      return  prev_flag;
  }
}

void drawOutlineText(String text, float x, float y, float size, int fgColor, int bgColor,float alpha) {
  float outlineWidth = (float)(size / 24.0);
  textSize(size);
  fill(bgColor,alpha);
  text(text, x - outlineWidth, y + size - outlineWidth);
  text(text, x + outlineWidth, y + size - outlineWidth);
  text(text, x - outlineWidth, y + size + outlineWidth);
  text(text, x + outlineWidth, y + size + outlineWidth);
  fill(fgColor,alpha);
  text(text, x, y + size);
  //println(text);
  
}
