float concentration_power = 500;
class Concentration extends Event {
  PImage image;
  Concentration() {
    EventFlagList.get("Concentration").write_in_flag = true;
    image = concentration;
    layer = -1;
  }
  void operate() {
    base_speed = 0.25;
    if((key_input.KeyList.get("SPACE").change_flag && !EventFlagList.get("Pause").flag) || concentration_power <= 0) {
      EventFlagList.get("Concentration").write_in_flag = false;
      destroyFlag=true;
      base_speed = 1;
    }
  }
}

class Concentration_Manager extends Event{
  float bar_width = 40*2;
  float bar_height = 8*2;
  color bar_color;
  float bar_max = 500;
  int time = 0;
  boolean cooltime_flag = false;
  float target_alpha = 0;
  float alpha = 0;
  Position position;
  Concentration_Manager() {
    layer = -1;
    concentration_power = 500;
  }
  void update() {
    if(!EventFlagList.get("Pause").flag) {
      if(EventFlagList.get("Concentration").flag) {
        concentration_power--; 
      } else {
        if(time > 0)concentration_power++;
      }
    }
    concentration_power = min(bar_max,max(concentration_power,0));
    if(concentration_power == 0) cooltime_flag = true;
    if(EventFlagList.get("Concentration").change_flag && cooltime_flag) {
      time = -50;
      cooltime_flag = false;
      
    }
  }
  void render() {
    if(concentration_power < bar_max) {
      position = pl.position.getPosition();
      rectMode(CENTER);
      tint(255,50);
      strokeWeight(3);
      stroke(50);
      noFill();
      rect(position.x,position.y+pl.size, bar_width,bar_height);
      noStroke();
      fill(bar_color);
      rect(position.x,position.y+pl.size, 1/bar_max*bar_width*concentration_power,bar_height); 
    }
  }
  void color_update() {
    if(!EventFlagList.get("Concentration").flag) {
      bar_color = color(255);
    } else {
      bar_color = (time/2) % 2 == 0 ?  color(255):   color(255,0,0);
    }
  }
  void operate() {
    //back_render();
    update();
    color_update();
    render();
    destroyFlag = !EventFlagList.get("Game").flag;
    time++;
  }
  void back_render() {
    target_alpha = EventFlagList.get("Concentration").flag ? 255 : 0;
    //集中モードに入った時、背景を暗転させる
    alpha += (target_alpha - alpha) /20;
    rectMode(CORNER);
    noStroke();
    fill(#000000,alpha);
    rect(0,0,WIDTH+MARGIN,HEIGHT);
  }
}
