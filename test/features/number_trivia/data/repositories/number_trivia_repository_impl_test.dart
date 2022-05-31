import 'package:clean_arcticture_learn/core/error/exceptions.dart';
import 'package:clean_arcticture_learn/core/error/failures.dart';
import 'package:clean_arcticture_learn/core/network/network_info.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{
  
}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{

}

class MockNetworkInfo extends Mock implements NetworkInfo{

}

void main(){
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  group(
  'getConcreteNumberTrivia', (){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia? tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', (){
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((realInvocation) async => true);

      //act
      repository!.getConcreteNumberTrivia(tNumber);


      //assert
      verify(mockNetworkInfo!.isConnected);
      
    });

    group('device is online', (){
    setUp((){
      when(mockNetworkInfo!.isConnected).thenAnswer((realInvocation) async => true);
    });

    test('should return remote data when the call to remote data source is successful', 
    () async {
      //arrange
      when(mockRemoteDataSource!.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => tNumberTriviaModel);
    
      //act
      final result = await repository!.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTrivia)));
    
    });

    test('should cache the data locally when the call to remote data source is successful', () async{
      //arrange
      when(mockRemoteDataSource!.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => tNumberTriviaModel);

      //act
      await repository!.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
      verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
    });

    test('should return server failure when the call to remote data source is unsuccessful', ()
    async {
      //arrange
      when(mockRemoteDataSource!.getConcreteNumberTrivia(any)).thenThrow(ServerException());

      //act
      final result = await repository!.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(ServerFailure()));
    });

    group('device is offline', (){
    setUp((){
      when(mockNetworkInfo!.isConnected).thenAnswer((realInvocation) async => false);
    });

    test('should return last locally cached data when the cached data is present', 
    () async {
      //arrange
      when(mockLocalDataSource!.getLastNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

      //act
      final result = await repository!.getConcreteNumberTrivia(tNumber);

      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource!.getLastNumberTrivia());
      expect(result, Right(tNumberTrivia));

    });

    test('should return last locally cached data when the cached data is present', 
    () async {
      //arrange
      when(mockLocalDataSource!.getLastNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

      //act
      final result = await repository!.getConcreteNumberTrivia(tNumber);

      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource!.getLastNumberTrivia());
      expect(result, Right(tNumberTrivia));
    });

    test('should return cachefailure when there is no cached data present',(() async{
      //arrange
      when(mockLocalDataSource!.getLastNumberTrivia()).thenThrow(CacheException());

      //act
      final result = await repository!.getConcreteNumberTrivia(tNumber);

      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource!.getLastNumberTrivia());
      expect(result, Left(CacheFailure()));
    }));
  });

  });
  });

  group(
  'getRandomNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia? tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', (){
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((realInvocation) async => true);

      //act
      repository!.getRandomNumberTrivia();


      //assert
      verify(mockNetworkInfo!.isConnected);
      
    });

    group('device is online', (){
    setUp((){
      when(mockNetworkInfo!.isConnected).thenAnswer((realInvocation) async => true);
    });

    test('should return remote data when the call to remote data source is successful', 
    () async {
      //arrange
      when(mockRemoteDataSource!.getRandomTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);
    
      //act
      final result = await repository!.getRandomNumberTrivia();

      //assert
      verify(mockRemoteDataSource!.getRandomTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    
    });

    test('should cache the data locally when the call to remote data source is successful', () async{
      //arrange
      when(mockRemoteDataSource!.getRandomTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

      //act
      await repository!.getRandomNumberTrivia();

      //assert
      verify(mockRemoteDataSource!.getRandomTrivia());
      verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
    });

    test('should return server failure when the call to remote data source is unsuccessful', ()
    async {
      //arrange
      when(mockRemoteDataSource!.getRandomTrivia()).thenThrow(ServerException());

      //act
      final result = await repository!.getRandomNumberTrivia();

      //assert
      verify(mockRemoteDataSource!.getRandomTrivia());
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(ServerFailure()));
    });

    group('device is offline', (){
    setUp((){
      when(mockNetworkInfo!.isConnected).thenAnswer((realInvocation) async => false);
    });

    test('should return last locally cached data when the cached data is present', 
    () async {
      //arrange
      when(mockLocalDataSource!.getLastNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

      //act
      final result = await repository!.getRandomNumberTrivia();

      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource!.getLastNumberTrivia());
      expect(result, Right(tNumberTrivia));

    });

    test('should return last locally cached data when the cached data is present', 
    () async {
      //arrange
      when(mockLocalDataSource!.getLastNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

      //act
      final result = await repository!.getRandomNumberTrivia();

      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource!.getLastNumberTrivia());
      expect(result, Right(tNumberTrivia));
    });

    test('should return cachefailure when there is no cached data present',(() async{
      //arrange
      when(mockLocalDataSource!.getLastNumberTrivia()).thenThrow(CacheException());

      //act
      final result = await repository!.getRandomNumberTrivia();

      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource!.getLastNumberTrivia());
      expect(result, Left(CacheFailure()));
    }));
  });

  });
  });

  
}