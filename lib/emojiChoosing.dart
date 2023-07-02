
import 'package:flutter/material.dart';

Icon getEmoji(int n){
  switch (n%5){
    case 0:
      return Icon(Icons.add);
    case 1:
      return Icon(Icons.account_balance_wallet);
    case 2:
      return Icon(Icons.science);
    case 3:
      return Icon(Icons.manage_search_outlined);
    case 4:
      return Icon(Icons.key_off_outlined);
    default:
      return Icon(Icons.adb_rounded);
  }

}