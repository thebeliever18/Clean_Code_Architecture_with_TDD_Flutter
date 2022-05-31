import 'package:clean_arcticture_learn/core/usecases/usecase.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{

}

void main(){
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  setUp((){
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
    }
  );

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test random', number: 2);

  test('random number trivia test', () async{
    
    //arrange
    when(mockNumberTriviaRepository!.getRandomNumberTrivia()).thenAnswer((realInvocation) async=> Right(tNumberTrivia));


    //act
    final result = await usecase!(NoParams());


    //assert
    expect(result,Right(tNumberTrivia));
    verify(mockNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);

  });

  
}