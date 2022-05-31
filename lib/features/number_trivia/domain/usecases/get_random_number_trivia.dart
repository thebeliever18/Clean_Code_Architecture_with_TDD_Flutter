import 'package:clean_arcticture_learn/core/error/failures.dart';
import 'package:clean_arcticture_learn/core/usecases/usecase.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia?,NoParams>{
  final NumberTriviaRepository? repository;
  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia?>?>? call(params) async{
    return await repository?.getRandomNumberTrivia();
  }
}

