ArrayList<Enemy> EnemyList = new ArrayList<Enemy>();
ArrayList<EnemyBullet> ValidEnemyBulletList = new ArrayList<EnemyBullet>();
class PlayerBulletManager extends Event{
  float angle =  -90;
  float sp = 1;
  int time = 1;
  ArrayList<PlayerBullet> PlayerBulletList = new ArrayList<PlayerBullet>();
   PlayerBulletManager() {
    layer = -1;
    EnemyList = new ArrayList<Enemy>();
    ValidEnemyBulletList = new ArrayList<EnemyBullet>();
  }
  void operate() {
    shot();
    if(PlayerBulletList.size() > 0)collider();
  }
  void shot() {
    if(!EventFlagList.get("Pause").flag) {
      if (key_input.KeyList.get("A").flag) angle -= sp*base_speed;
      if (key_input.KeyList.get("D").flag) angle += sp*base_speed;
      if(key_input.KeyList.get("A").flag && key_input.KeyList.get("D").flag)angle =-90;
      draw_aim(pl.position.getPosition(),130*ratio,angle,60*ratio,frameCount*2,50,time > 0);
      //if(time < 0 && key_input.KeyList.get("W").occurrence_flag && !pl.deadFlag && !EventFlagList.get("Communication").flag) {
        if(time < 0 && key_input.KeyList.get("W").occurrence_flag && !EventFlagList.get("Communication").flag) {
         time= 200;
         PlayerBullet plb = new PlayerBullet(pl.position.getPosition(),angle);
         addData.add(plb);
         PlayerBulletList.add(plb);
      }
    }
    destroyFlag = !EventFlagList.get("Game").flag;
    time--;
  }
  void collider() {
    Iterator<PlayerBullet> plbit = PlayerBulletList.iterator();
    while(plbit.hasNext()) {
      PlayerBullet plb = plbit.next();
      if(plb.destroyFlag) {
        plbit.remove();
      }
      Iterator<Enemy> it = EnemyList.iterator();
      while(it.hasNext()) {
        Enemy ene= it.next();
        if(ene.destroyFlag) {
          it.remove();
        }
        plb.collisionDetection(ene.soul);
      }
      Iterator<EnemyBullet> it2 = ValidEnemyBulletList.iterator();
      while(it2.hasNext()) {
        EnemyBullet eneb = it2.next();
        if(eneb.destroyFlag) {
          it2.remove();
        }
        plb.collisionDetection(plb.soul);
      }
      
    }
    
  }
  boolean display_flag = false;
  float alpha = 0;
  float target_alpha = 0;
  void soul_render(Position position,float collider_size) {
     display_flag = EventFlagList.get("Concentration").flag;
     target_alpha =  display_flag ? 255 : 0;
     alpha += (target_alpha - alpha) / 10;
     
     //tint(255,alpha);
     //imageMode(CENTER);
     //image(oni,position.x,position.y,collider_size,collider_size);
     
     strokeWeight( 2 );  //幅は2
     fill(255,100);
     stroke(255,alpha);
     if(display_flag)ellipse( position.x,position.y,collider_size*2 ,collider_size*2);
  }
}




Position update_Position(Position pos,float ang,float dis) {
  return new Position(pos.x+cos(rad(ang))*dis,pos.y+sin(rad(ang))*dis);
}
void draw_aim(Position start_position,float radius,float angle,float size,float base_angle,float alpha,boolean is_reloading) {
  //円と起点をつなぐ線
  Position base_pos = new Position(0,0);
  Position target_position = new Position(0,0);
  target_position.x = start_position.x + cos(rad(angle)) * radius;
  target_position.y = start_position.y + sin(rad(angle)) * radius;
  float base_size;
  stroke(255,0,0,alpha);
  drawDashedLine(start_position,target_position,"0101",2);
  //円
  noFill();
  strokeWeight(4);
  ellipse(target_position.x, target_position.y, size, size);
  strokeWeight(2);
  ellipse(target_position.x, target_position.y, size/1.3, size/1.3);
  strokeWeight(2);
  ellipse(target_position.x, target_position.y, size/1.6, size/1.6);  
  //周りの三角形
  for(int i = 0;i < 4; i++) {
    float tri_angle = base_angle+i*90;
    base_pos = update_Position(target_position,tri_angle,size/1.5);
    drawTriangle(base_pos,radius/25,tri_angle,color(255,0,0));
  }
  //中央の+
  
  base_pos = target_position.getPosition();
  /*
  strokeWeight(1);
  line(base_pos.x-cos(rad(angle))*size/25,base_pos.y-sin(rad(angle))*size/25,base_pos.x+cos(rad(angle))*size/25,base_pos.y+sin(rad(angle))*size/25);
  line(base_pos.x-cos(rad(angle+90))*size/25,base_pos.y-sin(rad(angle+90))*size/25,base_pos.x+cos(rad(angle+90))*size/25,base_pos.y+sin(rad(angle+90))*size/25);
  */
  //点線
  base_size = size*0.5;
  drawDashedLine(update_Position(base_pos,angle,base_size*-1),update_Position(base_pos,angle,base_size),"0101",2);
  drawDashedLine(update_Position(base_pos,angle+90,base_size*-1),update_Position(base_pos,angle+90,base_size),"0101",2);
  
  //周りの短い線
  strokeWeight(2);
  base_size = size*0.6;
  for(int i = 0;i < 4; i++) {
    float _angle = i*90 + 45 - angle;
    line(base_pos.x+cos(rad(_angle))*base_size,base_pos.y+sin(rad(_angle))*base_size,base_pos.x+cos(rad(_angle))*base_size*0.9,base_pos.y+sin(rad(_angle))*base_size*0.9);
  }
  
  if(is_reloading) {
    imageMode(CENTER);
    tint(255,sin(frameCount/10)*255 - 255/4);
    image(reloading,target_position.x,target_position.y,size*2,size/2);
  } 
}

void drawTriangle(Position base_pos,float size,float ang,color cl) {
  fill(cl);
  triangle(base_pos.x,base_pos.y,base_pos.x-cos(rad(ang+150))*size,base_pos.y-sin(rad(ang+150))*size,base_pos.x-cos(rad(ang+210))*size,base_pos.y-sin(rad(ang+210))*size);
}

void drawDashedLine(Position start_position,Position target_position,String hasen,float strokeWeight) {
  Position  base = start_position.getPosition();
  int    j = 0;
  strokeWeight(strokeWeight);
  float n = 50;
  //点を始点・終点を含めて31個打つ
  for( int i = 0; i <= n; i++ ){
    float px = lerp( base.x, target_position.x, i/n );
    float py = lerp( base.y, target_position.y, i/n );
    
    //破線パターンが1の場合は線で結ぶ
    String ptn = hasen.substring(j,j+1);
    j++;
    //パターンの終端まで来たら、最初に戻る
    if( j >= hasen.length() ){ j = 0; }
    
    if( ptn.equals("1") == true ){
      //線で結ぶ
      line(base.x, base.y, px,py );
    } else {
      //点を打つ
      point( px, py );
    }
    
    //直前の座標を更新
    base.x = px;
    base.y = py;
  }
}
class PlayerBullet extends GameObject {
  int collider_target;
  PlayerBullet(Position position,float angle) {
    this.position = position;
    this.speed =20*ratio;
    this.ang = angle;
    this.image = BulletImage.get("bullet1-0");
    this.size = 20*ratio;
  }
  void update() {
    position = update_Position(this.position,ang,speed);
  }
  void render() {
    imageMode(CENTER);
    tint(255,150);
    pushMatrix();
    translate(position.x,position.y);
    rotate(rad(ang+90));
    image(image,0,0,size,size);
    popMatrix();
  }
  void collisionDetection(Soul target) {
     if(target.collision_flag) {
        Position line_start,line_goal;
        line_start = this.position.getPosition();
        line_goal = update_Position(this.position.getPosition(),this.ang,this.speed);
        /*
        if(isCrossLines(a,b,c,d)) {
          target.collision = true;
        }*/
        if(isCrossLinesCircle(line_start,line_goal,target)) {
          target.collision = true;
          this.destroyFlag = true;
          //println(target,this,line_start.x,line_start.y,line_goal.x,line_goal.y,target.position.x,target.position.y,target.collider_size);
        }
     }
  }
  
}

boolean isCrossLines(Position a,Position b,Position c,Position d) {
  float stack[] = {
     (c.x-d.x)*(a.y-c.y) + (c.y-d.y)*(c.x-a.x),
     (c.x-d.x)*(b.y-c.y) + (c.y-d.y)*(c.x-b.x),
     (a.x-b.x)*(c.y-a.y) + (a.y-b.y)*(a.x-c.x),
     (a.x-b.x)*(d.y-a.y) + (a.y-b.y)*(a.x-d.x),
  };
  return stack[0] * stack[1] < 0 && stack[2] * stack[3] < 0;
}

Position normalizecVec(Position vec) {
  float len = CalculationVectorLength(vec);
  Position re = new Position(vec.x/len,vec.y/len);
  return re;
}
float CalculationVectorLength(Position vec) {
  return sqrt(sq(vec.x) + sq(vec.y));
}
boolean isCrossLinesCircle(Position line_start,Position line_end,Soul circle) {
 /*
  //println(circle.collider_size);
  Position start_to_center = new Position(circle.position.x-line_start.x,circle.position.y-line_start.y);
  Position end_to_center = new Position(circle.position.x-line_end.x,circle.position.y-line_end.y);
  Position start_to_end = new Position(line_end.x-line_start.x,line_end.y-line_start.y);
  Position normal_start_to_end = normalizecVec(start_to_end);
  //println(CalculationVectorLength(normal_start_to_end));
  //外積
  float distance_projection = start_to_center.x * normal_start_to_end.y - normal_start_to_end.x * start_to_center.y;
  if(abs(distance_projection) < circle.collider_size) {
    // 始点 => 終点と始点 => 円の中心の内積を計算する
    float dot01 = start_to_center.x * start_to_end.x + start_to_center.y * start_to_end.y;
    // 始点 => 終点と終点 => 円の中心の内積を計算する
    float dot02 = end_to_center.x * start_to_end.x + end_to_center.y * start_to_end.y;
    // 二つの内積の掛け算結果が0以下なら当たり
    if (dot01 * dot02 <= 0.0f)
    {
      return true;
    }
    
    if(CalculationVectorLength(start_to_center) < circle.collider_size && CalculationVectorLength(end_to_center) < circle.collider_size){
      return true;
    }
  }
  return false;
  */
  Position start_to_center = new Position(circle.position.x-line_start.x,circle.position.y-line_start.y);
  Position end_to_center = new Position(circle.position.x-line_end.x,circle.position.y-line_end.y);
  Position start_to_end = new Position(line_end.x-line_start.x,line_end.y-line_start.y);
  Position normal_start_to_end = normalizecVec(start_to_end);
  float lenAX = normal_start_to_end.x * start_to_center.x + normal_start_to_end.y * start_to_center.y;
  float shortestDistance;
  float st_cen_len = CalculationVectorLength(start_to_center);
  float en_cen_len = CalculationVectorLength(end_to_center);
  float st_en_len = CalculationVectorLength(start_to_end);
  if(lenAX < 0) {
    shortestDistance = st_cen_len;
  } else if(lenAX > st_en_len) {
    shortestDistance = en_cen_len;
  } else {
    float cross = normal_start_to_end.x * start_to_center.y - normal_start_to_end.y * start_to_center.x;
    shortestDistance = abs(cross);
  }
  
  /*Position X = new Position(line_start.x+(normal_start_to_end.x * lenAX),line_start.y+(normal_start_to_end.y * lenAX));
  ellipse( X.x, X.y, 4, 4 );*/
  boolean hit = false;
  if(shortestDistance < circle.collider_size) {
    hit = true;
  }
  return hit;
}
