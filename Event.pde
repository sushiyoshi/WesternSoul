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

void EnemyAllDelete() {
  DestroyFlagList.get("Enemy").write_in_flag = !DestroyFlagList.get("Enemy").write_in_flag;
}
void EnemyBulletAllDelete() {
  DestroyFlagList.get("EnemyBullet").write_in_flag = !DestroyFlagList.get("EnemyBullet").write_in_flag;
}
