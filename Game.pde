//弾幕、敵キャラの動作や会話など、ゲームの内容を設定する
int bosshp = 0;
class Stage0 extends Stage {
  int step = 0;
  Position[] Enemy0Pattern = {
    new Position(200*ratio,10),
    new Position(100*ratio,10),
    new Position(300*ratio,10),
    new Position(150*ratio,10),
    new Position(250*ratio,10)
  };
  void game() {
    if(step == 0) {
      targetSkycolor = new vec3(0.15,0.2,0.2);
      //for(int i = 0; i < 5; i++) {
      //  if(time == (i+1)*40) {
      //    Enemy0 en = new Enemy0(Enemy0Pattern[i],1);
      //    addData.add(en);
      //  }
      //}
      if(time == 0) {
        Serif[] serif = {
          new Serif("お前か？\n決闘を申し込んできたのは","gunman"),
          new Serif("いかにも","Gozu"),
          new Serif("俺は牛頭(ごず)\n極東からこの地を侵略するためにやってきた","Gozu"),
          new Serif("その侵略者がなぜ俺なんかに？","gunman"),
          new Serif("お前はこの土地で一番の腕を持つガンマンだと聞いた","Gozu"),
          new Serif("つまりお前を倒せば我ら「弾幕ガンマン」の力は絶対的なものになる","Gozu"),
          new Serif("弾幕文化の拡大は\n神より与えられた我らの使命！","Gozu"),
          new Serif("旧世代のガンマンなど\nこの手で葬り去ってくれる！","Gozu"),
        };
        Picture[] pic = {
          new Picture(player_tatie,"gunman",true),
          new Picture(boss_1,"Gozu",false)
        };
        //com = new Communication(serif,pic);
        addEvent.add(new Communication(serif,pic));
        //EnemyAllDelete();
        //EnemyBulletAllDelete();
        Boss boss = new Boss(new Position(10,80*ratio),1);
        addData.add(boss);
      }
      if(time > 0 && !EventFlagList.get("Pause").flag && !EventFlagList.get("Communication").flag) {
        step++;
        time = 0;
      }
    }   
  }
 
  class Boss extends Enemy {
    int type = 0;
    int count = 0;
    int ii = 0;
    float img_ang = 0;
    float target_img_ang = 0;
    float target_alpha = 255;
    float alpha = 255;
    MagicCircle magicCircle;
    Boss(Position position,int hp) {
      super(position,hp);
      size = 80.0*ratio;
      image = boss_1;
      soul.fireball.in_cl = color(255);
      soul.fireball.out_cl = #ff8c00;
      soul.collision_flag = false;
      magicCircle = new MagicCircle();
      bosshp = hp;
    }
    class MagicCircle {
      Position position;
      float ang = 0;
      float size = 300;
      Position outer_position;
      MagicCircle() {
        position = Boss.this.position.getPosition();
        outer_position = position.getPosition();
      }
      void operate() {
        update();
        render();
      }
      void update() {
        position.x = Boss.this.position.x;
        position.y = Boss.this.position.y;
        outer_position.x += (position.x-outer_position.x)/10;
        outer_position.y += (position.y-outer_position.y)/10;
        bosshp = hp;
      }
      void render() {
        stroke(80,100);
        noFill();
        //tint(255,10);
        //strokeWeight(10);
        //ellipse(position.x,position.y,size,size);
        ang +=0.5;
        
        pushMatrix();
        //translate( position.x + img.width/2, position.y + img.height/2 );
        translate( position.x , position.y );
        rotate(rad(ang));
        imageMode(CENTER);
        tint(255,100);
        image(magic_circle,0,0,size,size);
        popMatrix();
        
        strokeWeight(10);
        ellipse(outer_position.x,outer_position.y,size*1.5,size*1.5);
        
      }
     
    }
    boolean isDestroy(boolean prev_flag) {
      if(soul.collision) {
        hp--;
        pl.score += shotScore;
        soul.collision = false;
        //EnemyAllDelete();
        EnemyBulletAllDelete();
        time = 0;
        soul.collision_flag = false;
        println("hp:" + hp);  
        bonus.new_score();
      }
      if(position.x > (WIDTH + MARGIN) || position.x < MARGIN*-0.5 || position.y > (HEIGHT + MARGIN) || position.y < MARGIN * -0.5) {
        prev_flag=true;
      }
      if(hp <= 0) {
        pl.score += defeatScore;
        addData.add(new Explosion(position.getPosition(),100.0,10.0,image));
        prev_flag=true;
        EventFlagList.get("Gameclear").write_in_flag = true;
      }
      if(prev_flag) {
        
      }
      return prev_flag;
    }
    void render() {
      target_alpha = soul.collision_flag || step == 0 ? 255 : 0;
      target_img_ang = soul.collision_flag || step == 0 ? 0 : 90;
      img_ang += (target_img_ang-img_ang)/10;
      alpha += (target_alpha-alpha)/10;
      drawAfterImageFlag = soul.collision_flag;
      
      pushMatrix();
      //translate( position.x + img.width/2, position.y + img.height/2 );
      translate( position.x , position.y );
      rotate(rad(img_ang));
      imageMode(CENTER);
      tint(255,alpha);
      image(image,0,0,size,size);
      popMatrix();
      magicCircle.operate();
    }
    void operate() {
      if(step == 0) {
        targetMode(new Position(160*ratio,80*ratio),10,5*ratio);
        time=0;
      }
      if(hp == 3) {
        if(time == 0) {
          type = 0;
        }
        if(type % 3 == 0 && step == 1) {
          targetSkycolor.z = 0.9;
          if(time == 1) {
            targetMode(new Position(160*ratio + random(-100,100),80*ratio + random(0,-20)),20,1.5*ratio);
          }
          if(time >= 50) {
            soul.collision_flag = false;
            for(int i = 0; i< 2; i++) {
              Position pos = position.getPosition();
              float ang = random(0,360);
              pos.x += cos(rad(ang)) * 20*ratio;
              pos.y += sin(rad(ang)) * 20*ratio;
              EnemyBullet bl = new EnemyBullet0(pos,ang,random(2.0,5.0),int(random(0,12) ) );
              createObject(bl);
            }
            if(time >= 150) {
              if(time >= 300 || random(0,100) == 0) {
                type++;
                time = 1;
              }
            }
          }
        }
        if(type % 3 == 1) {
          if(time == 20) {
            targetMode(new Position(max(20,min(WIDTH-100,position.x + 50*random(1,3)*ratio * (random(0,1)*2-1))),max(100,min(70,position.y + 20*random(1,3)*ratio * (random(0,1)*2-1)))),20, 1);
          }
          
          if(time >= 20 && time % 8 == 1 && time <= 100) {
            soul.collision_flag = true;
             for(int i = 0;i<5;i++) {
               float aim_ang = aim(position,pl.position.getPosition());
               for(int j = 0; j<3; j++) {
                 Position pos = position.getPosition();
                 float ang = aim_ang + (i*20-40);
                 pos.x += cos(rad(ang)) * 15*ratio;
                 pos.y += sin(rad(ang)) * 15*ratio;
                 EnemyBullet bl = new EnemyBullet1(pos,ang,j*0.5+3);
                 createObject(bl);
               }
             }
          }
          if(time >= 100) {
            soul.collision_flag = false;
             type++;
             time = 1;
          }
        }
        if(type % 3 == 2) {
          if(time >= 150) {
            time = 0;
            type++;
            count++;
          }
        }
        if(time % 80 == 0) {
          /*
          int len = 3;
          float aim_ang = aim(position,pl.position.getPosition());
          for(int i = 0; i<len; i++) {
            Position pos = position.getPosition();
            float ang = aim_ang + i*360/len;
            pos.x += cos(rad(ang)) * 15*ratio;
            pos.y += sin(rad(ang)) * 15*ratio;
            EnemyBullet bl = new EnemyBullet2(pos,ang,0.8);
            createObject(bl);
          }*/
        }
      } else if(hp == 2) {
        if(time == 0) {
          soul.collision_flag = false;
          targetMode(new Position(160*ratio + random(-100,100),80*ratio + random(0,-20)),20,1.5*ratio);
        }
        targetSkycolor.z = 0.0;
        
        if(time == 150) {
          Position target_pos = new Position(WIDTH/2,HEIGHT-300);
          for(int i = 0; i< 6; i++) {
            Position ipos = target_pos.getPosition();
            ipos.x += cos(rad(i*60)) * 30*ratio;
            ipos.y += sin(rad(i*60)) * 30*ratio;
            EnemyBullet bl  =  new EnemyBullet4(position.getPosition(),i*60,3,80,i*2,ipos.getPosition());
            createObject(bl);
          }
        }
        if(time > 400) {
          soul.collision_flag = 200 < time % 500 && time % 500 < 300;
          if(time % 12 == 9) {
            for(int i = 0; i< 8; i++) {
              EnemyBullet bl  =  new EnemyBullet5(position.getPosition(),i*45 + sin(time*0.1)*90.0,3,time%120/10);
              createObject(bl);
            }
          }
          if(time % 500 == 499) {
            targetMode(new Position(160*ratio + random(-100,100),80*ratio + random(0,-20)),20,1.5*ratio);
          }
        }
      }else if(hp == 1) {
        if(time == 1) {
          targetSkycolor.y = 0.5;
          count = 0;
        }
        if(time %250 == 80) {
          targetMode(new Position(160*ratio + random(100,180) * (1 - 2*random(0,1)),200*ratio + random(100,200) * (1 - 2*random(0,1))),40,1.5*ratio);
        }
        if(200 < time % 500 && time % 500 < 400 && time > 1000) {
          soul.collision_flag = true;
        } else {
          soul.collision_flag = false;
        }
        //if(100 < time && time <= 180) {
        //  if(time % 10 == 0) {
        //    float ang = 45*(time-100)/10;
        //    EnemyBullet bl =  new EnemyBullet7(position.getPosition(),ang);
        //    createObject(bl);
        //  }
        //}
        if(time == 100) {
          for(int i = 0; i< 8; i++) {
            float ang = 45*i;
            EnemyBullet bl =  new EnemyBullet7(position.getPosition(),ang,i);
            createObject(bl);
          }
        }
        ii += sin((time-100)*0.012)*10;
        if(time % (max(100,800-count*100)) == 0 && time != 0){
          count++;
          println("count",count);
        }
        count = min(4,count);
      }
    }
    class EnemyBullet0 extends EnemyBullet {
      EnemyBullet0(Position pos,float ang,float speed,int col) {
          super(pos);
          this.ang = ang;
          this.speed = speed*ratio;
          image = BulletImage.get("bullet6-" + Integer.toString(col));
          
          addData.add(new Appearance(position.getPosition(),size,20,image));
      }
      void operate() {
        if(Boss.this.type == Boss.this.count * 3 + 1) {
          speed = 0;
          accele = 0;
          image = BulletImage.get("bullet0-12");
        }
        if(Boss.this.type == Boss.this.count * 3 + 2 && Boss.this.time == 30) {
          accele = 0.01;
          ang = random(0,360);
        }
      }
    }
    class EnemyBullet1 extends EnemyBullet {
      EnemyBullet1(Position pos, float ang,float speed) {
        super(pos);
        this.ang = ang;
        this.speed = speed*ratio;
        this.image = BulletImage.get("bullet0-8");
        size =20*ratio;
        addData.add(new Appearance(position.getPosition(),size,15,image));

      }
      void operate() {}
    }
    class EnemyBullet2 extends EnemyBullet {
      EnemyBullet2(Position pos, float ang,float speed) {
        super(pos);
        //this.image = BulletImage.get("bullet5-9");
        this.image = cowboy;
        this.speed = speed*ratio;
        this.ang = ang;
        this.size = 110;
        addData.add(new Explosion(position.getPosition(),size,20,image));
        ValidEnemyBulletList.add(this);
        soul.collider_size = 40;
        
      }
    }
    
    class EnemyBullet3 extends EnemyBullet {
      int phase = 0;
      int col = 0;
      EnemyBullet3(Position pos,float ang,float speed,int col) {
        super(pos);
        //this.image = BulletImage.get("bullet5-9");
        this.speed = speed*ratio;
        this.ang = ang;
        this.col = col;
        image = BulletImage.get("bullet2-" + Integer.toString(col));
      }
      void operate() {
        if(phase == 0) {
          if(position.x > WIDTH+15 || position.x < 10 || position.y > HEIGHT-10 || position.y < 10) {
            phase = 1;
            image = BulletImage.get("bullet7-" + Integer.toString(col));
            ang = aim(position,pl.position.getPosition());
            speed = 0;
            time =0;
          }
        } else if(phase == 1) {
          if(time > 80) {
            speed = 4;
          }
        }
      }
      void render() {
        imageMode(CENTER);
        noTint();
        pushMatrix();
        translate( position.x , position.y );
        rotate(rad(ang+90));
        imageMode(CENTER);
        if(phase == 1)image(image,0,0,size,size*1.4); else image(image,0,0,size,size);
        popMatrix();
      }
    }
    
    class EnemyBullet4 extends EnemyBullet {
      int phase = 0;
      Position target_pos;
      int k = 0;
      int col;
      EnemyBullet4(Position pos,float ang,float speed,float size,int col,Position target_pos) {
        super(pos);
        //this.image = BulletImage.get("bullet5-9");
        this.speed = speed*ratio;
        this.ang = ang;
        image = gozu;
        this.size = size;
        this.target_pos = target_pos;
        this.col = col;
        soul.collider_size = size/40;
      }
      void operate() {
        if(phase == 0) {
          if(time > 10) {
            phase = 1;
          }
        } else if(phase == 1) {
          targetMode(target_pos.getPosition(),10,5*ratio);
          if(time > 120) {
            phase = 2;
          }
        } else if(phase == 2) {
          if(time % 10 == 1) {
            for(int i = 0; i< 2; i++) {
              Position pos = position.getPosition();
              float ang = k + i * 180;
              pos.x += cos(rad(ang)) * 20*ratio;
              pos.y += sin(rad(ang)) * 20*ratio;
              EnemyBullet bl  = new EnemyBullet3(pos,ang,3,col);
              createObject(bl);
            }
            k+=6;
          }
        }
      }
    }
    class EnemyBullet5 extends EnemyBullet {
      EnemyBullet5(Position pos,float ang,float speed,int col) {
          super(pos);
          this.ang = ang;
          this.speed = speed*ratio;
          image = BulletImage.get("bullet5-" + Integer.toString(col));
          soul.collider_size = size/20;
      }
    }
    class EnemyBullet6 extends EnemyBullet {
      Position target_pos = new Position(0,0);
      int num  = 0;
      EnemyBullet6(Position pos, float ang,float speed,Position target_pos,int num) {
        super(pos);
        this.ang = ang;
        this.speed = speed*ratio;
        this.image = BulletImage.get("bullet4-12");
        this.target_pos = target_pos;
        size =20*ratio;
        addData.add(new Appearance(position.getPosition(),size,15,image));
        this.num =num;
      }
      void operate() {
        if(time == 1) {
          targetMode(target_pos.getPosition(),10,100);
        }
        if(time == 40) {
          image = BulletImage.get("bullet0-0");
        }
        if(time == 50) {
          ang = aim(position,pl.position.getPosition());
          target_pos = new Position(position.x + cos(rad(ang))* 50,position.y + sin(rad(ang))* 50);
          targetMode(target_pos.getPosition(),10,50);
          image = BulletImage.get("bullet4-0");
        }
        if(time == 140) {
          image = BulletImage.get("bullet0-9");
        }
        if(time == 150) {
          ang = aim(position,pl.position.getPosition());
          speed = 10;
          moveType = "DEFAULT";
          image = BulletImage.get("bullet4-9");
        }
        
      }
      void render() {
        imageMode(CENTER);
        noTint();
        pushMatrix();
        translate( position.x , position.y );
        rotate(rad(ang+90));
        imageMode(CENTER);
        //if(phase == 1)image(image,0,0,size,size*1.4); else image(image,0,0,size,size);
        image(image,0,0,size,size);
        popMatrix();
      }
     }
     class EnemyBullet7 extends EnemyBullet {    
       float radi = 0;
       float target_radi = 90;
       EnemyBullet7(Position pos,float ang,int num) {
         super(pos);
         this.ang = ang;
         image = gozu;
         size = 50;
         time += num * 10;
         
       }
       void update() {
         radi += (target_radi-radi)/30;
         //println(floor(ang),floor(a),floor(ang+a));
         position.x = Boss.this.position.x + cos(rad(ang+Boss.this.ii))* radi;
         position.y = Boss.this.position.y + sin(rad(ang+Boss.this.ii))* radi;
       }
       void operate() {
         int temp = 250-Boss.this.count * 25;
         if(time % temp  == floor(temp*0.6)) {
           float aim_ang = Boss.this.ii + ang+90;
           for(int i = 0; i<16; i++) {
             //Position pos = position.getPosition();
             //float ang = aim_ang + (i*20-40);
             //pos.x += cos(rad(ang)) * 15*ratio;
             //pos.y += sin(rad(ang)) * 15*ratio;
             //EnemyBullet bl = new EnemyBullet1(pos,ang,j*0.5+3);
             Position pos = position.getPosition();
             Position target_pos = position.getPosition();
             pos.x += cos(rad(aim_ang)) * 15*ratio;
             pos.y += sin(rad(aim_ang)) * 15*ratio;
             target_pos.x += cos(rad(aim_ang)) * (i*5*ratio + 100);
             target_pos.y += sin(rad(aim_ang)) * (i*5*ratio + 100);
             EnemyBullet bl = new EnemyBullet6(pos.getPosition(),rad(aim_ang),0,target_pos.getPosition(),i);
             //EnemyBullet6(Position pos, float ang,float speed,Position target_pos)
             createObject(bl);
           }
         }
       }
       
     }
  }
}
