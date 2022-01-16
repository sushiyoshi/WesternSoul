abstract class GameObject {
  PImage image = null;
  float size=1,speed=0,ang;
  boolean destroyFlag = false;
  Position position = new Position(0,0);
  int time=0; 
  int afim_len = 8;
  int afim_count = 0;
  Position[] afterImage;
  int colider_target = 0;
  boolean collider_flag = false;
  Soul soul = null;
  
  GameObject() {
    afterImage = new Position[afim_len];
    for(int i=0;i<afim_len;i++) afterImage[i] = new Position(-1,-1);
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
    if(image != null)drawAfterimage();
    destroyFlag = isDestroy(destroyFlag);
    
  }
  void operate(){}
  abstract void update();
  void render() {
    imageMode(CENTER);
    noTint();
    if(image != null)image(image,position.x,position.y,size,size);
  }
  boolean isDestroy(boolean prev_flag) {
    if(position.x > (WIDTH + MARGIN) || position.x < MARGIN*-0.5 || position.y > (HEIGHT + MARGIN) || position.y < MARGIN * -0.5) {
      return true;
    }
    return prev_flag || !EventFlagList.get("Game").flag;
  }
  void drawAfterimage() {
    int current;
    if(EventFlagList.get("Concentration").flag) {
      for(int i = 0; i < afim_len; i++) {
        current = i + afim_count;
        current %= afim_len;
        //println("c",current,afim_count,this);
        if(afterImage[current].x == -1) break;
        imageMode(CENTER);
        tint(255,10*(afim_len-i));
        image(image,afterImage[i].x,afterImage[i].y,size,size);
      }
    }
    afterImage[afim_count] = new Position(this.position.x,this.position.y);
    afim_count++;
    afim_count %= afim_len;
  }
  
}

class GameObjectDrawing extends Event {
  GameObjectDrawing() {
    EventFlagList.get("Game").write_in_flag = true;
  }
  void operate() {
    Iterator<GameObject> it = objData.iterator();
    if(!EventFlagList.get("Pause").flag)collider.cliner.allCollisionList();
    while(it.hasNext()) {
      GameObject obj = it.next();
      obj.processing();
      if(obj.destroyFlag) {
        //println(obj);
        it.remove();
        //println("remove_obj",obj);
      }
    }
    it = addData.iterator();
    while(it.hasNext()) {
      GameObject obj = it.next();
      objData.add(obj);
      //println("add_obj",obj);
    }
    if(!EventFlagList.get("Pause").flag && key_input.KeyList.get("ALT").occurrence_flag && EventFlagList.get("Game").flag) {
      addEvent.add(new Pause());
    }
    if(EventFlagList.get("Gameover").occurrence_flag) {
      addEvent.add(new Pause(1));
    }
    if(EventFlagList.get("Gameclear").occurrence_flag) {
      addEvent.add(new GameClear());
    }
    destroyFlag = !EventFlagList.get("Game").flag;
  }
}
