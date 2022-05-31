import 'dart:convert';

import 'package:clean_arcticture_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  const tNumberTriviaModel = NumberTriviaModel(number:1,text:'Test Text');

  test('should be a sub class of number trivia entity', () async{
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', (){
    test('should return a valid model when the JSON number is an integer',
    () async
    {
      //arrange
      final Map<String,dynamic> jsonMap = json.decode(fixture('trivia.json'));    
    
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    
    },
  );
  
  test('should return a valid model when the JSON number is regarded s a double', ()
  async {
    //arrange
    final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
    
    //act
    final result = NumberTriviaModel.fromJson(jsonMap);


    //assert
    expect(result, tNumberTriviaModel);
  });
  
  
  },
  );

  group('toJson', (){
    test('should return a JSON map containing the proper data', () async{
      
      //act
      final result=tNumberTriviaModel.toJson();


      //assert
      final Map expectedMap = {
        "text":"Test Text",
        "number":1,
      }; 
      expect(result,expectedMap);
    });
  });
}