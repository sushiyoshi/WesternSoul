//オブジェクトの動作を定義するクラス
class Animation {
  float alpha =  0;
  boolean endflag= false;
  float frame = 0;
  void operate(){}
  float getAlpha() {
   return alpha; 
  }
}

class FadeIn extends Animation {
  float max = 255;
  FadeIn(float frame,float max) {
    this.max = max;
    this.frame = frame;
    alpha = 0;
  }
  FadeIn(float frame) {
    this.frame = frame;
    alpha = 0;
  }
  void operate() {
    alpha += max/frame;
    if(alpha >= max) endflag = true;
  }
}

class FadeOut extends Animation {
  float max = 255;
  FadeOut(float frame,float max) {
    this.max = max;
    this.frame = frame;
    alpha = max;
  }
  FadeOut(float frame) {
    this.frame = frame;
    alpha = 255;
  }
  void operate() {
    alpha -= max/frame;
    if(alpha <= 1) endflag = true;
  }
}


class Animator {
  Animation[] AnimationList;
  Animation current;
  boolean end_flag = false;
  int phase = 0;
  Animator(Animation[] AnimationList) {
    this.AnimationList = AnimationList;
    current = AnimationList[0];
  }
  void operate() {
    current =  AnimationList[phase];
    if(!end_flag) current.operate();
    if(current.endflag) {
      phase++;
      if(AnimationList.length <= phase) {
        end_flag = true;
      } else {
        current =  AnimationList[phase];
      }
    }
  }
}

/*
class Animation {
  Animation[] AnimationLink;
  float alpha =  0;
  boolean endflag= false;
  float frame = 0;
  void operate(){}
  float getAlpha() {
   return alpha; 
  }
}


class Animator {
}*/
