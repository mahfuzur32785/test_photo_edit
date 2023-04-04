import 'dart:convert';

import '../model/data_model.dart';
import 'package:http/http.dart' as http;

class ApiHttpService{
  Future<List<Meme>> getDataList() async {

    List<Meme> dataList = [];

    var url = 'https://api.imgflip.com/get_memes';
    var response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      var getData = jsonDecode(response.body);
      print(getData);

      for(var i in getData["data"]["memes"]) {
        dataList.add(Meme.fromMap(i));
      }
      return dataList;
    }
    return dataList;
  }
}