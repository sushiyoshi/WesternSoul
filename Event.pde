//
public class EventComparator implements Comparator<Event> {
  @Override
  public int compare(Event e1, Event e2) {
    return e1.layer < e2.layer ?  -1 : 1;
  }
}

abstract class Event {
  boolean destroyFlag = false;
  int layer = 0;
  void operate(){}
}

class EventState {
  boolean write_in_flag = false;
  boolean flag = false;
  boolean prev_flag = false;
  boolean change_flag = false;
  boolean occurrence_flag = false;
  void update() {
      flag = write_in_flag; 
      change_flag = flag != prev_flag;
      if(change_flag) prev_flag = flag;
      occurrence_flag = change_flag && flag;
  }
}

class EventStateManager {
  void operate() {
    for(String k: EventFlagList.keySet()) {
      EventFlagList.get(k).update();
    }
  }
}
class GameClear extends Event {
  int time = 0;
  GameClear() {
    println("RING");
  }
  void operate() { 
    destroyFlag = !EventFlagList.get("Game").flag;
    if(time == 150) {
      Serif[] serif = {
        new Serif("test\n","gunman"),
      };
      Picture[] pic = {
        new Picture(player_tatie,"gunman",true),
        new Picture(boss_1,"Gozu",false)
      };
      //com = new Communication(serif,pic);
      addEvent.add(new Communication(serif,pic));
    }
    if(!EventFlagList.get("Pause").flag)time++;
    if(time > 200 && !EventFlagList.get("Pause").flag && !EventFlagList.get("Communication").flag) {
       destroyFlag = true;
       addEvent.add(new Pause(2));
       println("OMAFAFAFA");
    }
  }
}

void EnemyAllDelete() {
  DestroyFlagList.get("Enemy").write_in_flag = !DestroyFlagList.get("Enemy").write_in_flag;
}
void EnemyBulletAllDelete() {
  DestroyFlagList.get("EnemyBullet").write_in_flag = !DestroyFlagList.get("EnemyBullet").write_in_flag;
}
