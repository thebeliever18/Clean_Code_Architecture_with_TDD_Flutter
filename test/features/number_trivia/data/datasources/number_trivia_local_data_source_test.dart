import 'dart:convert';

import 'package:clean_arcticture_learn/core/error/exceptions.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferencesNumberTriviaLocalDataSource extends Mock implements SharedPreferences{
  
}

void main(){
  NumberTriviaLocalDataSourceImpl? dataSourceImpl;
  MockSharedPreferencesNumberTriviaLocalDataSource? mockSharedPreferencesNumberTriviaLocalDataSource;


  setUp((){
    mockSharedPreferencesNumberTriviaLocalDataSource = MockSharedPreferencesNumberTriviaLocalDataSource();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferencesNumberTriviaLocalDataSource);

  });

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from sharedprefences when there is one in the cache',() async{
      //arrange
      when(mockSharedPreferencesNumberTriviaLocalDataSource!.getString(CACHED_NUMBER_TRIVIA)).thenReturn(fixture('trivia_cached.json'));
      
      //act
      NumberTriviaModel? result = await dataSourceImpl!.getLastNumberTrivia();
      
      
      //assert
      
      verify(mockSharedPreferencesNumberTriviaLocalDataSource!.getString(CACHED_NUMBER_TRIVIA));
      expect(result,tNumberTriviaModel);
    });
    
    test('should throw cache expection when there is not the cached value',() async{
      
      //arrange
      when(mockSharedPreferencesNumberTriviaLocalDataSource!.getString(CACHED_NUMBER_TRIVIA)).thenReturn(null);

      //act
      final call =  await dataSourceImpl!.getLastNumberTrivia();

      //assert
      //verify(mockSharedPreferencesNumberTriviaLocalDataSource!.getString(CACHED_NUMBER_TRIVIA));
      expect(call,  const TypeMatcher<CacheException>());
    });
  });

    group('cacheNumberTrivia', ()  {
      final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);

      test('should call sharedpreferences to cache the data', () async{
        //arrange
        final prefs = await SharedPreferences.getInstance();


        //act
        final result = await dataSourceImpl!.cacheNumberTrivia(tNumberTriviaModel);


        //assert
        String expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        //verify(prefs.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
        expect(expectedJsonString, prefs.getString(CACHED_NUMBER_TRIVIA));
        expect(expectedJsonString, prefs.getString(CACHED_NUMBER_TRIVIA));

      });
    });



}