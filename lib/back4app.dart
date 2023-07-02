import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Back4app {
  static final String baseUrl_ = 'https://parseapi.back4app.com/classes';

  static Future<void> initParse() async {
    final keyApplicationId = 'w42NPnOihW95qEUpAOGJjqESNCdJ8Li0npHQR6Lh';
    final keyClientKey = 'dM2Hcs9rhrX1TjnS5xCY8bk64GfUsGbFrvDd8cV1';
    final keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);
    
    var todoFlutter = ParseObject('TodoFlutter');
    //   ..set('message', 'some test message')
    //   ..set('watched', 6.3);
    await todoFlutter.save();
  }
}
