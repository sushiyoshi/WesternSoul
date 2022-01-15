class Soul {
    Position position = new Position(0,0);
    float collider_size = 3;
    int objType;
    int collider_target;
    boolean collision = false;
    boolean collision_flag = true;
    FireBall fireball;
    GameObject gmobj;
    
    HashMap<String,EventState> collisionList = new HashMap<String,EventState>();
    Soul(GameObject gmobj,float collider_size,int objType,int collider_target) {
      this.gmobj = gmobj; 
      this.collider_size = collider_size;
      this.objType = objType;
      this.collider_target = collider_target;
      this.position = gmobj.position.getPosition();
      collider.cliner.regist(this);
    }
    void operate() {
      if(gmobj != null) {
        update();
        //if(gmobj.collider_flag) render();
        render();
      }
    }
    void update() {
      position = gmobj.position.getPosition();
    }
    void render() {
       
    }
    void collisionDetection(Soul target,int targetType) {
      if(collider_target == targetType && target.collision_flag) {
        float size = target.collider_size+this.collider_size; 
        if(isCollision(target.position,this.position,size)) {
          target.collision = true;
          
        }
      }
    }
    boolean isCollision(Position pos1,Position pos2,float size) {
      return sq(pos1.x-pos2.x) + sq(pos1.y-pos2.y) < sq(size);
    }
}

class SoulManager extends Event{
  SoulManager() {
    layer = 2;
  }
  void operate() {
    Iterator<GameObject> it = objData.iterator();
    while(it.hasNext()) {
      GameObject obj = it.next();
      if(obj.soul != null)obj.soul.operate();
    }
    destroyFlag = !EventFlagList.get("Game").flag;
  }
}
