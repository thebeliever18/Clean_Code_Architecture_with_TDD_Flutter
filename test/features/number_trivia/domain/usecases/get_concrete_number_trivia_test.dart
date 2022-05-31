import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{

}

void main(){
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  
  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);


  test('should get trivia for the number form the repository', ()
  async
  {
    //arrange
    when(mockNumberTriviaRepository!.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async=> Right(tNumberTrivia));

    //act
    final result = await usecase!(Params(number: tNumber));

    //assert
    expect(result, Right(tNumberTrivia));

    verify(mockNumberTriviaRepository!.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);

  });
}