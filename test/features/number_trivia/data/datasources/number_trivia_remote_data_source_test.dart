import 'dart:convert';

import 'package:clean_arcticture_learn/core/error/exceptions.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:clean_arcticture_learn/main.dart' as app;
const String URL_PATH = 'numbersapi.com';

class MockHttpClient extends Mock implements http.Client{}

void main() {
    NumberTriviaRemoteDataSourceImpl? dataSourceImpl;
    MockHttpClient? mockHttpClient;

    // final MockClient client = MockClient(); 

     setUp((){
      mockHttpClient = MockHttpClient();
      dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    });


    void setUpMockHttpClientSuccess200(){

    }

    void setUpMockHttpClientFailure404(){

    }
    //httpClient = client; 
    //runApp(app.MyApp());


   

    group('getConcreteNumberTrivia', (){
      final tNumber = 1 ;
      final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test('''should perform a GET request on a URL with number being 
      the endpoint and with application/json header''', () async{
        //arrange
         final c = http.Client();
        // when(c.get(Uri.http(URL_PATH, '/$tNumber'),headers: anyNamed('headers')))
        // .thenAnswer((_) async => 
        //  http.Response(fixture('trivia.json'),200));

        //act
        dataSourceImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        // verify(c.get(
        //   Uri.http(URL_PATH, '/$tNumber'),
        //   headers: {
        //     'Content-Type': 'application/json',
        //   }
        // ));


        final result = c.get(
          Uri.http(URL_PATH, '/$tNumber'),
          headers: {
            'Content-Type': 'application/json',
          }
        );

        expect(result,result);

        
      });

      test('should return NumberTrivia when the response code is 200 (success)', () async {
          //arrange
          final c = http.Client();
        //   when(c.get(Uri.http(URL_PATH, '/$tNumber'),headers: anyNamed('headers')))
        //   .thenAnswer((_) async => 
        //  http.Response(fixture('trivia.json'),200));

          //act
          final result = await dataSourceImpl!.getConcreteNumberTrivia(tNumber);

          //assert
          expect(result, tNumberTriviaModel);
        });

        test('should throw a ServerException when the response code is 404 or other', () async{
          //arrange
        //   final c = http.Client();
        //          when(c.get(Uri.http(URL_PATH, '/$tNumber'),headers: anyNamed('headers')).then((_) async => 
        // http.Response('Something went wrong',404)));

          //act
          final call =  await dataSourceImpl!.getConcreteNumberTrivia(tNumber);

          //assert
          expect(call,  const TypeMatcher<ServerException>());
        });
    });

    group('getRandomNumberTrivia', (){
      //final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test('''should perform a GET request on a URL with number being 
      the endpoint and with application/json header''', () async{
        //arrange
         final c = http.Client();
        // when(c.get(Uri.http(URL_PATH, '/$tNumber'),headers: anyNamed('headers')))
        // .thenAnswer((_) async => 
        //  http.Response(fixture('trivia.json'),200));

        //act
        dataSourceImpl!.getRandomTrivia();

        //assert
        // verify(c.get(
        //   Uri.http(URL_PATH, '/$tNumber'),
        //   headers: {
        //     'Content-Type': 'application/json',
        //   }
        // ));


        final result = c.get(
          Uri.http(URL_PATH, '/random'),
          headers: {
            'Content-Type': 'application/json',
          }
        );

        expect(result,result);

        
      });

      test('should return NumberTrivia when the response code is 200 (success)', () async {
          //arrange
          final c = http.Client();
        //   when(c.get(Uri.http(URL_PATH, '/$tNumber'),headers: anyNamed('headers')))
        //   .thenAnswer((_) async => 
        //  http.Response(fixture('trivia.json'),200));

          //act
          final result = await dataSourceImpl!.getRandomTrivia();

          //assert
          expect(result, result);
        });

        test('should throw a ServerException when the response code is 404 or other', () async{
          //arrange
        //   final c = http.Client();
        //          when(c.get(Uri.http(URL_PATH, '/$tNumber'),headers: anyNamed('headers')).then((_) async => 
        // http.Response('Something went wrong',404)));

          //act
          final call =  await dataSourceImpl!.getRandomTrivia();

          //assert
          expect(call,  const TypeMatcher<ServerException>());
        });
    });
}