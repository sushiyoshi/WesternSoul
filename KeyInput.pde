class KeyInput {
  HashMap<String,EventState> KeyList = new HashMap<String,EventState>();
  KeyInput() {
    KeyList.put("RIGHT",new EventState());
    KeyList.put("LEFT",new EventState());
    KeyList.put("UP",new EventState());
    KeyList.put("DOWN",new EventState());
    KeyList.put("SHIFT",new EventState());
    KeyList.put("Z",new EventState());
    KeyList.put("X",new EventState());
    KeyList.put("C",new EventState());
    KeyList.put("W",new EventState());
    KeyList.put("A",new EventState());
    KeyList.put("S",new EventState());
    KeyList.put("D",new EventState());
    KeyList.put("CONTROL",new EventState());
    KeyList.put("ESC",new EventState());
    KeyList.put("ALT",new EventState());
    KeyList.put("SPACE",new EventState());
  }
  void operate() {
    for(String k: KeyList.keySet()) {
      KeyList.get(k).update();
    }
  }
}

void keyPressed() {
//void keyPressed() {
    if (keyCode == RIGHT) key_input.KeyList.get("RIGHT").write_in_flag = true;
    if (keyCode == LEFT)  key_input.KeyList.get("LEFT").write_in_flag = true;
    if (keyCode == UP)  key_input.KeyList.get("UP").write_in_flag = true;
    if (keyCode == DOWN)  key_input.KeyList.get("DOWN").write_in_flag = true;
    if (keyCode == SHIFT) key_input.KeyList.get("SHIFT").write_in_flag = true;
    if (keyCode == 'Z') key_input.KeyList.get("Z").write_in_flag = true;
    if (keyCode == 'X') key_input.KeyList.get("X").write_in_flag = true;
    if (keyCode == 'A') key_input.KeyList.get("A").write_in_flag = true;
    if (keyCode == 'S') key_input.KeyList.get("S").write_in_flag = true;
    if (keyCode == 'W') key_input.KeyList.get("W").write_in_flag = true;
    if (keyCode == 'D') key_input.KeyList.get("D").write_in_flag = true;
    if (keyCode == 'C') key_input.KeyList.get("C").write_in_flag = true;
    if (keyCode == ' ') key_input.KeyList.get("SPACE").write_in_flag = true;
    if (keyCode == CONTROL) key_input.KeyList.get("CONTROL").write_in_flag = true;
    if (keyCode == ESC) key_input.KeyList.get("ESC").write_in_flag = true;
    if (keyCode == ALT) key_input.KeyList.get("ALT").write_in_flag = true;
}
void keyReleased() {
     if (keyCode == RIGHT) key_input.KeyList.get("RIGHT").write_in_flag = false;
    if (keyCode == LEFT)  key_input.KeyList.get("LEFT").write_in_flag = false;
    if (keyCode == UP)  key_input.KeyList.get("UP").write_in_flag = false;
    if (keyCode == DOWN)  key_input.KeyList.get("DOWN").write_in_flag = false;
    if (keyCode == SHIFT) key_input.KeyList.get("SHIFT").write_in_flag = false;
    if (keyCode == 'Z') key_input.KeyList.get("Z").write_in_flag = false;
    if (keyCode == 'X') key_input.KeyList.get("X").write_in_flag = false;
    if (keyCode == 'A') key_input.KeyList.get("A").write_in_flag = false;
    if (keyCode == 'D') key_input.KeyList.get("D").write_in_flag = false;
    if (keyCode == 'S') key_input.KeyList.get("S").write_in_flag = false;
    if (keyCode == 'W') key_input.KeyList.get("W").write_in_flag = false;
    if (keyCode == 'C') key_input.KeyList.get("C").write_in_flag = false;
    if (keyCode == ' ') key_input.KeyList.get("SPACE").write_in_flag = false;
    if (keyCode == CONTROL) key_input.KeyList.get("CONTROL").write_in_flag = false;
    if (keyCode == ESC) key_input.KeyList.get("ESC").write_in_flag = false;
    if (keyCode == ALT) key_input.KeyList.get("ALT").write_in_flag = false;
}
