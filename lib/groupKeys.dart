
String groupKey = 'sample';

var allowedLetters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";

bool chekGroupKey(String key){
  bool approved = true;
  for (int i=0; i<key.length; i++){
    if(!allowedLetters.contains(key[i])){
      approved = false;
      break;
    }
  }
  return approved && key.length > 5;
}