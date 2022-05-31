import 'package:bloc/bloc.dart';
import 'package:clean_arcticture_learn/core/error/failures.dart';
import 'package:clean_arcticture_learn/core/usecases/usecase.dart';
import 'package:clean_arcticture_learn/core/util/input_converter.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE='Server Failure';
const String CACHE_FAILURE_MESSAGE='Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE='Invalid Input - The number must be a positive integer or zer.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia? getConcreteNumberTrivia;
  final GetRandomNumberTrivia? getRandomNumberTrivia;
  final InputConverter? inputConverter;
  NumberTriviaBloc(
    {
      required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter,
    }
  ) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async{
      if(event is GetTriviaForConcreteNumber) {
        if(event.numberString==null){
          emit(const Error(message: 'Input value is empty'));
        }else{
          final inputEither=inputConverter!.stringToUnsignedInteger(event.numberString!);
        
          await inputEither!.fold(
          (failure) async => emit(const Error(message: 'INVALID_INPUT_FAILURE_MESSAGE')), 
        (integer) async { 
          emit(Loading());
          final failureOrTrivia = await getConcreteNumberTrivia!(Params(number: integer));
          
          emit(
             _eitherLoadedOrErrorState(failureOrTrivia)
          );
      }
        );
        }
        
      }else if(event is GetTriviaForRandomNumber) {
          emit(Loading());
          final failureOrTrivia =  await getRandomNumberTrivia!(NoParams());
          
          emit(
            _eitherLoadedOrErrorState(failureOrTrivia)
          );
      }
    });
  }

  NumberTriviaState _eitherLoadedOrErrorState(Either<Failure, NumberTrivia?>? failureOrTrivia) {
    return failureOrTrivia!.fold(
            (failure)  =>  Error(
              message: _mapFailureToMessage(failure)), 
        (trivia) => Loaded(trivia: trivia!));
  }

  NumberTriviaState get initialState => Empty();

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
