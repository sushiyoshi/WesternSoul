class Frame extends Event {
  float alpha = 0,frame = 40;
  long disp_score = 0;
  float score_y = 60*ratio;
  TitleLogo logo = new TitleLogo(new Position(1000/2*ratio,620/2*ratio),620*ratio);
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
    image(score_text,400*ratio,score_y+10*ratio,80*ratio,40*ratio);
  }
  
  void logo() {
    //ang += (0-ang)/frame;
    alpha += (255-alpha)/frame;
    tint(255,alpha);
    
    //pushMatrix();
    //translate(200*ratio,70*ratio);
    //translate(350*ratio,180*ratio);
    //rotate(rad(ang));
    imageMode(CENTER);
    //image(logo,0,0,300,200);
    //image(title,0,0,300*ratio,300*ratio);
    //image(title,1000/2*ratio,620/2*ratio,620*ratio,620*ratio);
    //popMatrix();
    logo.render();
  }
  void score() {
    disp_score += (pl.score - disp_score) /20;
    textFont(stateFont);
    textAlign(CORNER);
    String score_text = Long.toString(disp_score);
    int len = score_text.length();
    for(int i = 12; i > len && i > 0; i--) {
      score_text = '0' + score_text;
    }
    fill(255,255);
    drawOutlineText(score_text,465*ratio,score_y,23*ratio,255,0,255);
    //text(score_text,465*ratio,63*ratio,23*ratio,255);
  }
  void east_soul() {
    imageMode(CENTER);
    noTint();
    image(east_soul,480*ratio,score_y+80*ratio,100*ratio,66*ratio);
    textAlign(CENTER);
    textFont(stateFont);
    drawOutlineText(Integer.toString(bosshp),540*ratio,score_y+65*ratio,40*ratio,255,0,255);
  }
  void operate() {
    imageMode(CORNER);
    noTint();
    frame();
    logo();
    //image(window,15,320,340,150);
    score();
    east_soul();
    destroyFlag = !EventFlagList.get("Game").flag;
  }
}
