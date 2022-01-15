BlackOut blackout;
class BlackOut extends Event {
  float alpha = 255;
  float target_alpha = 0;
  int phase = 0;
  float frame = 10;
  float dis;
  boolean endflag = false;
  BlackState state;
  BlackOut(BlackState state) {
    this.state = state;
    layer = 100;
  }
  void operate() {
    if(state == BlackState.FadeIn) {
      target_alpha = 255;
      endflag = false;
    } else if(state == BlackState.FadeOut) {
      target_alpha = 0;
      endflag = false;
    }
    dis=target_alpha-alpha;
    if(alpha > 0.01){
       rectMode(CORNER);
       noStroke();
       noTint();
       fill(#000000,alpha);
       rect(0,0,1280,960);
    }
    if(abs(dis) < 0.01) {
      state = BlackState.Stable;
      endflag = true;
    } else {
      alpha += (dis)/frame;
    }
  }
  public void FadeIn() {
    state = BlackState.FadeIn;
  }
  public void FadeOut() {
    state = BlackState.FadeOut;
  }
}
protected enum BlackState{
    FadeIn,
    Stable,
    FadeOut
};
