import 'dart:convert';

import 'package:clean_arcticture_learn/core/error/exceptions.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource{
  Future<dynamic>? getLastNumberTrivia();
  Future<void>? cacheNumberTrivia(NumberTriviaModel? triviaToCache);
}


const String CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource{
  final SharedPreferences? sharedPreferences;
  NumberTriviaLocalDataSourceImpl(
    {required this.sharedPreferences});
  

  
  @override
  Future<bool>? cacheNumberTrivia(NumberTriviaModel? triviaToCache) async{
    final prefs = await SharedPreferences.getInstance();

    return  prefs.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache!.toJson(),),);
     
  }

  @override
  Future<dynamic>? getLastNumberTrivia() {
    String? jsonString = sharedPreferences!.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString!=null){
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }else{
      return Future.value(CacheException());
    }
  }

}