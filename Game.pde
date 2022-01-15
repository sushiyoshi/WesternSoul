//弾幕、敵キャラの動作や会話など、ゲームの内容を設定する
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
          new Serif("これからは弾幕の時代","Gozu"),
          new Serif("旧世代のガンマンは侵略の邪魔だ！\nここで散るべし！","Gozu"),
        };
        Picture[] pic = {
          new Picture(player_tatie,"gunman",true),
          new Picture(boss_1,"Gozu",false)
        };
        //com = new Communication(serif,pic);
        addEvent.add(new Communication(serif,pic));
        //EnemyAllDelete();
        //EnemyBulletAllDelete();
        Boss boss = new Boss(new Position(10,10),6);
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
    Boss(Position position,int hp) {
      super(position,hp);
      size = 80.0*ratio;
      image = boss_1;
      soul.fireball.in_cl = color(255);
      soul.fireball.out_cl = #ff8c00;
      
    }
    boolean isDestroy(boolean prev_flag) {
      if(soul.collision) {
        hp--;
        pl.score += shotScore;
        soul.collision = false;
        //EnemyAllDelete();
        EnemyBulletAllDelete();
        time = 0;
        println("hp:" + hp);
      }
      if(position.x > (WIDTH + MARGIN) || position.x < MARGIN*-0.5 || position.y > (HEIGHT + MARGIN) || position.y < MARGIN * -0.5) {
        prev_flag=true;
      }
      if(hp <= 0) {
        pl.score += defeatScore;
        addData.add(new Explosion(position.getPosition(),100.0,10.0,image));
        prev_flag=true;
      }
      if(prev_flag) {
        
      }
      return prev_flag;
    }
    void render() {
      noTint();
      imageMode(CENTER);
      image(image,position.x,position.y,size,size);
    }
    void operate() {
      if(step == 0) {
        targetMode(new Position(160*ratio,80*ratio),20,1.5*ratio);
        time=0;
      }
      if(hp == 6) {
        if(time == 0) {
          type = 0;
        }
        if(type % 3 == 0 && step == 1) {
          targetSkycolor.z = 0.9;
          if(time == 1) {
            targetMode(new Position(160*ratio + random(-100,100),80*ratio + random(0,-20)),20,1.5*ratio);
          }
          if(time >= 50) {
            
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
      } else if(hp == 4) {
        targetSkycolor.z = 0.0;
        if(time > 15) {
          if(time % 100 == 99) {
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
        }
      }else if(hp == 2) {
        targetSkycolor.x = 0.9;
        if(time > 15) {
          if(time % 100 == 99) {
            for(int i = 0;i<5;i++) {
               float aim_ang = aim(position,pl.position.getPosition());
               for(int j = 0; j<10; j++) {
                 Position pos = position.getPosition();
                 float ang = aim_ang + (i*20-40);
                 pos.x += cos(rad(ang)) * 15*ratio;
                 pos.y += sin(rad(ang)) * 15*ratio;
                 EnemyBullet bl = new EnemyBullet1(pos,ang,j*0.5+3);
                 createObject(bl);
               }
             }
          }
        }
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
        this.image = oni;
        this.speed = speed*ratio;
        this.ang = ang;
        this.size = 110;
        addData.add(new Explosion(position.getPosition(),size,20,image));
        ValidEnemyBulletList.add(this);
        soul.collider_size = 40;
        
      }
    }
  }
    class Enemy0 extends Enemy {
    Enemy0(Position position,int hp) {
      super(position,hp);
      speed = 2.0*ratio;        
      image = inu;
      size = 30.0*ratio;
      soul.collider_size = 5*ratio;
    }
    void render() {
      imageMode(CENTER);
      noTint();
      if(image != null)image(image,position.x,position.y,size,size*1.8);
      
    }
    void operate() {  
      if(time % 100 == 1 && (time / 100) <= 3) { 
        for(int i = 0; i<18; i++) {
          EnemyBullet0 bl = new EnemyBullet0(this.position.getPosition(),i*20);
          createObject(bl);
        }
      }
    }
    class EnemyBullet0 extends EnemyBullet {
      float accele;
      EnemyBullet0(Position pos,float ang) {
        super(pos);
        this.ang = ang;
        this.image = BulletImage.get("bullet0-1");
        addData.add(new Explosion(position.getPosition(),70,10,image));
      }
      void operate() {
        if(time == 0) {
          speed = 4.0;
          accele = -0.1;
        }
        if(time == 10) {
          speed = 0.0;
          accele = 0.0;
        }
        if(time ==  100) {
          speed = 2.0;
          ang = aim(position,pl.position.getPosition());
        }
      }
    }
  }
}
