
class FireBall {
  ArrayList<Vertex> VertexList = new ArrayList<Vertex>();
  float size;
  boolean display_flag;
  float display_ratio = 0;
  Position position;
  boolean operate_flag;
  color out_cl  = color(255);
  color in_cl  = color(0);
  FireBall(Position position,float size) {
   this.position =position;
   this.size = size;
   display_flag = false;
   operate_flag = false;
   display_ratio=0;
  }
  void operate() {
    display_ratio += (((display_flag ? 1 : 0)*360) - display_ratio)/5;
    operate_flag = display_ratio > 30;
    if(operate_flag) {
      update();
      render();
    }
  }
  void render() {
    for(Vertex v:VertexList) {
      v.current.update2();
      v.target.update2();
      v.current_control.operate();
      v.target_control.operate();
    }
    noStroke();
    fill(out_cl);
    beginShape();
    for(Vertex v:VertexList) {
      noStroke();
      vertex(v.current.position.x,v.current.position.y);
      bezierVertex(
        v.current_control.position.x,v.current_control.position.y,
        v.target_control.position.x,v.target_control.position.y,
        v.target.position.x,v.target.position.y
      );
      //println(v.current.position.x,v.current.position.y);
    }
    endShape(CLOSE);
     
    stroke(in_cl);
    strokeWeight(size);
    fill(in_cl);
    
    if(60 < display_ratio) {
      arc(position.x,position.y,size ,size,rad(180-display_ratio),rad(display_ratio));
    } else if(340 < display_ratio){
      point(position.x,position.y);
    }
    //ellipse( position.x,position.y,size*2 ,size*2);
    
  }
  void update() {
    int len = floor(display_ratio/360*7);
    VertexList = new ArrayList<Vertex>();
    Position start =  new Position(position.x-size*2,position.y);
    Position goal = new Position(position.x,position.y-size*display_ratio/360*5);
    Position current_pos = start.getPosition();
    float swing = size;
    float ratio = 0.87-sin(frameCount/50)*0.05;
    //float ratio = sliderValue2*0.01;
    for(int i = 0; i<len; i++) {
      current_pos = func(start,goal,current_pos,len,1/ratio,swing,i);
      swing *= ratio;
    }
    start =  new Position(position.x,position.y-size*display_ratio/360*5);
    goal = new Position(position.x+size*2,position.y);
    current_pos = start.getPosition();
    for(int i = 0; i<len; i++) {   
      current_pos = func(start,goal,current_pos,len,1.5,swing,i+1.5);
      swing /=ratio;
    }
    
    
    
    current_pos = new Position(position.x+size,position.y+size);
    Position target_pos = new Position(position.x-size,position.y+size);
    Vertex vertex = new Vertex();
    vertex.current = new Point(current_pos.getPosition(),10,0);
    vertex.current_control = new Point(new Position(position.x+size*0.8,position.y+size*1.5),-1,0);
    vertex.target_control = new Point(new Position(position.x-size*0.8,position.y+size*1.5),-1,0);
    //vertex.target_control =new Point( vertex.current_control.position.getPosition(),-1);
    vertex.target = new Point(target_pos.getPosition(),10,0);
    VertexList.add(vertex);  
    
  }
  Position func(Position start,Position goal,Position current_pos,int len,float patio,float swing,float temp) {
      Vertex vertex = new Vertex();
      //現在位置
      vertex.current = new Point(current_pos.getPosition(),swing,temp);
      
      //つぎのいち
      swing *= patio;
      Position target_pos = current_pos.getPosition();
      target_pos.x += (goal.x-start.x)/len;
      target_pos.y += (goal.y-start.y)/len;
      
      //現在位置の制御点
      vertex.current_control = new Point(kahouteiri1(current_pos.getPosition(),target_pos.getPosition(),20),swing,temp);
      //次の位置
      vertex.target = new Point(target_pos.getPosition(),swing,temp);
      //次の位置の制御点
      vertex.target_control = new Point(kahouteiri2(current_pos.getPosition(),target_pos.getPosition(),20),swing,temp); 
      VertexList.add(vertex); 
      
      return target_pos.getPosition();
  }
  class Vertex {
    Point current;
    Point current_control;
    Point target;
    Point target_control;
  }
  
  Position kahouteiri1(Position start,Position goal,float plus_angle) {
    float a = goal.x-start.x;
    float b = goal.y-start.y;
    float c = sqrt(sq(a)+sq(b));
    float cos = a/c;
    float sin = b/c;
    Position re = start.getPosition();
    re.x += cos*cos(rad(plus_angle)) - sin*sin(rad(plus_angle));
    re.y += sin*cos(rad(plus_angle)) + cos*sin(rad(plus_angle));
    return re;
  }
  Position kahouteiri2(Position start,Position goal,float plus_angle) {
    float a = goal.x-start.x;
    float b = goal.y-start.y;
    float c = sqrt(sq(a)+sq(b));
    float cos = a/c;
    float sin = b/c;
    Position re = goal.getPosition();
    re.y -= cos*cos(rad(plus_angle)) - sin*sin(rad(plus_angle));
    re.x -= sin*cos(rad(plus_angle)) + cos*sin(rad(plus_angle));
    return re;
  }
  class Point {
    Position position;
    color cl;
    float size;
    String str;
    float swing;
    float temp = 0;
    Position base_position;
    Point(Position position,float swing,float temp) {
      this.position = position;
      this.base_position = position.getPosition();
      this.size = 10;
      this.cl = color(100,100,100);
      this.swing = swing;
      this.temp = temp;
    }
    void render() {
      strokeWeight(size);
      stroke(cl);
      //point(position.x,position.y);
      /*
      textSize(17);
      fill(255,0,0);
      str = str(floor(position.x))+ "," + str(floor(position.y));
      text(str, position.x, position.y,100,50);*/
    }
    void update() {
      //position.x -= sin(frameCount/10)*hurehaba;
      //println(swing);
       if(swing!=-1)position.x = base_position.x + cos(frameCount/10+temp*5)*swing;
      //println(position.x);
    }
    void update2() {
      if(swing!=-1)position.y = base_position.y + sin(frameCount/(swing*2)+temp*5)*swing/3;
    }
    void operate() {
        update();
        render();
      
    }
  }
}
