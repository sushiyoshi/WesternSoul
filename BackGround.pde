//背景オブジェクト　シェーダを表示するだけ
class vec3 {
  float x,y,z;
  vec3(float x,float y,float z) {
    this.x=x;
    this.y=y;
    this.z=z;
  }
}

vec3 targetSkycolor = new vec3(0.15,0.2,0.2);
class BackGround extends Event{
  vec3 skycolor = new vec3(0.15,0.2,0.2);
  int i = 0;
  BackGround () {
    layer = -5;
  }
  void operate() {
     sd.set("time", millis() / (1000.0));
     sd.set("resolution", (float)width, (float)height);  
     sd.set("skycolor",skycolor.x,skycolor.y,skycolor.z);
     filter(sd);
     skycolor.x += (targetSkycolor.x-skycolor.x)/30;
     skycolor.y += (targetSkycolor.y-skycolor.y)/30;
     skycolor.z += (targetSkycolor.z-skycolor.z)/30;
     destroyFlag = !EventFlagList.get("Game").flag;
  }
}
