
import 'package:clean_arcticture_learn/core/error/exceptions.dart';
import 'package:clean_arcticture_learn/core/network/network_info.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arcticture_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/core/error/failures.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';


//typedef Future<NumberTriviaModel?>? _ConcreteOrRandomChooser();
typedef Future<dynamic>? _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaRemoteDataSource? remoteDataSource;
  final NumberTriviaLocalDataSource? localDataSource;
  final NetworkInfo? networkInfo;
  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo
  });
  
  @override
  Future<Either<Failure,NumberTrivia?>>? getConcreteNumberTrivia(int? number) async {
    return await _getTrivia((){
      return remoteDataSource!.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure,NumberTrivia?>>? getRandomNumberTrivia() async{
    return await _getTrivia((){
      return remoteDataSource!.getRandomTrivia();
    });
  }

  Future<Either<Failure,NumberTrivia?>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom
  ) async{
    if(await networkInfo!.isConnected==true){
        try{
          final remoteTrivia = await getConcreteOrRandom();
          localDataSource!.cacheNumberTrivia(remoteTrivia);
          return Right(remoteTrivia);
        } catch(e){
          return Left(ServerFailure());
        } 
      }else{
        try{
          final localTrivia = await localDataSource!.getLastNumberTrivia();
          return Right(localTrivia);
        }on CacheException{
          return Left(CacheFailure());
        }
      }
  }


}