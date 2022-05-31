import 'dart:convert';

import 'package:clean_arcticture_learn/core/error/exceptions.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

const String URL_PATH = 'numbersapi.com';
abstract class NumberTriviaRemoteDataSource{
  ////calls the http://numbersapi.com/{number} endpoint.
  ////throws a [ServerException] for all error codes.
  Future<dynamic>? getConcreteNumberTrivia(int? number);


  ////calls the http://numbersapi.com/random endpoint
  ////throws a [ServerException] for all error codes.
  Future<dynamic>? getRandomTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource{
  
  http.Client? client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  

  Future<dynamic>? getConcreteNumberTrivia(int? number) {
    return _getTriviFromUrl(URL_PATH,number);
  }
  

  @override
  Future<dynamic>? getRandomTrivia() {
    return _getTriviFromUrlRandom(URL_PATH);
  }

  Future<dynamic> _getTriviFromUrl(String url,int? number) async{
    var client = http.Client();
    try{
      final response = await client.get(Uri.http(url,'/$number'),
      headers: {'Content-Type':'application/json'}
      );
      if(response.statusCode==200){
        return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    }catch(e){
      return Future.value(ServerException());
    }
  }

  Future<dynamic> _getTriviFromUrlRandom(String url) async{
    var client = http.Client();
    try{
      final response = await client.get(Uri.http(url,'/random'),
      headers: {'Content-Type':'application/json'}
      );
      if(response.statusCode==200){
        return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    }catch(e){
      return Future.value(ServerException());
    }
  }

  
  
}