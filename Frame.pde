class Frame extends Event {
  float ang = 40,alpha = 0,frame = 40;
  Frame() {
    this.layer = 10;
  }
  void frame() {
    /*
    noStroke();
    rectMode(CORNER);
    fill(60);
    rect(0,0,335,20);
    rect(335,0,305,480);
    rect(0,0,20,480);
    rect(0,460,335,20);
    */
    imageMode(CORNER);
    image(background,0,0,1000,750);
    imageMode(CENTER);
    image(score_text,400*ratio,112*ratio,80*ratio,40*ratio);
  }
  
  void logo() {
    ang += (0-ang)/frame;
    alpha += (255-alpha)/frame;
    tint(255,alpha);
    
    //pushMatrix();
    //translate(200*ratio,70*ratio);
    //translate(350*ratio,180*ratio);
    //rotate(rad(ang));
    imageMode(CENTER);
    //image(logo,0,0,300,200);
    //image(title,0,0,300*ratio,300*ratio);
    image(title,1000/2*ratio,620/2*ratio,620*ratio,620*ratio);
    //popMatrix();
  }
  void score() {
    textFont(stateFont);
    textAlign(CORNER);
    String score_text = Integer.toString(pl.score);
    int len = score_text.length();
    for(int i = 12; i > len && i > 0; i--) {
      score_text = '0' + score_text;
    }
    fill(255,255);
    drawOutlineText(score_text,465*ratio,100*ratio,23*ratio,255,0,255);
    //text(score_text,465*ratio,63*ratio,23*ratio,255);
  }
  void operate() {
    imageMode(CORNER);
    noTint();
    frame();
    logo();
    //image(window,15,320,340,150);
    score();
    destroyFlag = !EventFlagList.get("Game").flag;
  }
}
