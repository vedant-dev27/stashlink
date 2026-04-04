import 'package:shared_preferences/shared_preferences.dart';
import 'package:stashlink/models/list_model.dart';
import 'dart:convert';

class StorageService {
  static const _key = 'link';

  static Future<List<ListModel>> loadLink() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(_key);

    if (data == null) return [];

    final jsonList = (jsonDecode(data) as List)
        .map((e) => ListModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return jsonList;
  }

  static Future<void> addLink(ListModel link) async {
    final pref = await SharedPreferences.getInstance();
    final pastData = pref.getString(_key);

    if (pastData == null) {
      final valueString = jsonEncode(
        [link.toJson()],
      );

      await pref.setString(_key, valueString);
    } else {
      final jsonList = (jsonDecode(pastData) as List)
          .map((e) => ListModel.fromJson(e as Map<String, dynamic>))
          .toList();

      jsonList.add(link);

      final data = jsonEncode(jsonList.map((e) => e.toJson()).toList());
      await pref.setString(_key, data);
    }
  }

  static Future<void> delLink(String delUrl) async {
    final pref = await SharedPreferences.getInstance();
    final pastData = pref.getString(_key);

    final jsonList = (jsonDecode(pastData!) as List)
        .map((e) => ListModel.fromJson(e as Map<String, dynamic>))
        .toList();

    for (int i = 0; i < jsonList.length; i++) {
      if (jsonList[i].url == delUrl) {
        jsonList.removeAt(i);
        break;
      }
    }

    final data = jsonEncode(jsonList.map((e) => e.toJson()).toList());
    await pref.setString(_key, data);
  }
}
