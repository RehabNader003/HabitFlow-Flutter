
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_habits/enum.dart';

class Shared {
   static SharedPreferences? sharedPreferences;

 static init() async {
    sharedPreferences= await SharedPreferences.getInstance();
  }
   // string data
  static putString({required sharedKeys key, required String value}){// named optional  parameters
    sharedPreferences!.setString(key.name, value);
  }
  static getString({required sharedKeys key}){
    return sharedPreferences!.getString(key.name) ?? " ";
  }

  // Boolen data
   static putBooLean({required sharedKeys key, required bool value}){
    sharedPreferences?.setBool(key.name, value);
}
  static getBoolean({required sharedKeys key}){
    return sharedPreferences!.getBool(key.name) ?? false;
  }

    // Integer data
  static putInteger({required sharedKeys key, required int value}){// named optional  parameters
    sharedPreferences!.setInt(key.name, value);
  }
  static getInteger({required sharedKeys  key}){
    return sharedPreferences!.getInt(key.name) ?? 0;
  }

    // Double data
  static putDouble({required sharedKeys key, required double value}){// named optional  parameters
    sharedPreferences!.setDouble(key.name, value);
  }
  static getDouble({required sharedKeys key}){
    return sharedPreferences!.getDouble(key.name) ?? 0.0;
  }
  static deleteData(){// clear all Data
    sharedPreferences!.clear();
  }
  static removeData({ required sharedKeys key}){ // delete a spesefic element
    sharedPreferences!.remove(key.name);
  }

  static void putBOOL({required sharedKeys key, required bool value}) {}

}