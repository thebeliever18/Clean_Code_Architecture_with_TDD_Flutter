import 'package:clean_arcticture_learn/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type,Params>{
  Future<Either<Failure,Type>?>? call(Params params);
  
}
class NoParams{
  
}