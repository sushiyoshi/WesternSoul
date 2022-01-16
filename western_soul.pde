 import java.util.Iterator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.ArrayDeque;
import java.util.Comparator; 
//定数
final float ratio = 1.56;
final float PLAYER_SIZE = 80.0;
final float PLAYER_SPEED = 12.0;
final float WIDTH = 340*ratio;
final float HEIGHT = 480*ratio;
float MARGIN = 100;
int game_timer = 0;
float base_speed = 1;

Collider collider;
KeyInput key_input = new KeyInput();
Player pl;
Stage stage;
BackGround back;

//二点の距離
float distance(Position a,Position b) {
    return sqrt(sq(a.x-b.x) + sq(a.y-b.y));
}
//角度→ラジアン
float rad(float ang) {
    return ang / 180  * PI;
}
float aim(Position a,Position b) {
    return atan2(b.y-a.y,b.x-a.x) * 180 / PI;
}
//二次元座標
class Position {
  float x,y;
  Position(float x,float y) {
    this.x = x;
    this.y = y;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  Position getPosition() {
    return new Position(x,y);
  }
 
}

//全ゲームオブジェクトのリスト
ArrayList<GameObject> objData;
//後でobjDataに追加するゲームオブジェクトを保存しておく。
ArrayList<GameObject> addData = new ArrayList<GameObject>();

//全イベントオブジェクトのリスト
ArrayList<Event> EventList;
//後でEventListに追加するイベントオブジェクトを保存しておく。
ArrayList<Event> addEvent;

//画像データ
PImage player_text,score_text,boss_1,background,
pause_menu,continue_,retry,return_to_title,pause_menu_,cowboy,title,concentration,
reloading,player_tatie,gameover,quit,gamestart,
title2_gunman_shadow,title2_text_shadow,title2_gun_shadow,title2_text_eng,title2_gun,title2_text,title2_gunman,gozu,magic_circle,east_soul;
//フォントデータ
PFont stateFont,serifFont,pauseFont,scoreFont;

//弾幕に使う弾の画像データ
HashMap<String,PImage> BulletImage = new HashMap<String,PImage>();
//背景用シェーダ
PShader sd;
//Eventが発生しているか、フラグ管理用リスト
HashMap<String,EventState> EventFlagList = new HashMap<String,EventState>();
HashMap<String,EventState> DestroyFlagList = new HashMap<String,EventState>();

EventStateManager esm = new EventStateManager();

void setup() {
  addEvent = new ArrayList<Event>();
  EventList  = new ArrayList<Event>();
  //WIDTH *= ratio;
  //HEIGHT *= ratio;
  size(1000,750,P2D);
  //fullScreen(P2D);
  ellipseMode(CENTER);
  rectMode(CENTER);
  colorMode(RGB,256);
  EventFlagList.put("Game",new EventState());
  EventFlagList.put("Title",new EventState());
  EventFlagList.put("Pause",new EventState());
  EventFlagList.put("Communication",new EventState());
  EventFlagList.put("Concentration",new EventState());
  EventFlagList.put("Loading",new EventState());
  EventFlagList.put("Gameover",new EventState());
  DestroyFlagList.put("Enemy",new EventState());
  DestroyFlagList.put("EnemyBullet",new EventState());
  //ローディング開始
  addEvent.add(new Load());
}
void draw() {
    //全消し
    background(0); 
    //スペースキーを押すと、精神集中モードに入る
    if(key_input.KeyList.get("SPACE").occurrence_flag && !EventFlagList.get("Pause").flag && concentration_power > 50) {
      concentration_power-=50;
      bonus.concentration_gauge_bonus -= 1000000;
      addEvent.add(new Concentration());
    }
    if(EventFlagList.get("Loading").change_flag && !EventFlagList.get("Loading").flag) {
      addEvent.add(blackout);
      addEvent.add(new Title());
    }
    //全イベントオブジェクトの処理を実行する。
    Iterator<Event> it_event = EventList.iterator();
    while(it_event.hasNext()) {
      //println(millis());
      Event ev = it_event.next();
      //イベントオブジェクトの処理関数
      ev.operate();
      //消去フラグが立っていたら、消去
      if(ev.destroyFlag) {
        it_event.remove();
        println("remove",ev);
      }
    }
    boolean sort_flag = false;
    //新たなイベントオブジェクトを追加する。
    it_event = addEvent.iterator();
    while(it_event.hasNext()) {
      sort_flag = true;
      Event ev = it_event.next();
      EventList.add(ev);
      println("add",ev);
    }
    //イベントオブジェクトの追加処理が行われたら、レイヤ順にソートを行い、描画順序を更新する。
    if(sort_flag) Collections.sort(EventList,new EventComparator());
    //println(frameRate,i);
    //キー入力
    key_input.operate();
    //消去フラグ管理
    for(String k: DestroyFlagList.keySet()) {
      DestroyFlagList.get(k).update();
    }
    //イベントのフラグ管理情報を更新
    esm.operate();
    game_timer++;
    //追加予約用リストを初期化
    addEvent  = new ArrayList<Event>();
    addData  = new ArrayList<GameObject>();
    ScoreText_addData  = new ArrayList<Add_ScoreText_Center>();
  
}
