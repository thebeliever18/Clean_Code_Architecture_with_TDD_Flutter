import 'package:clean_arcticture_learn/core/error/failures.dart';
import 'package:clean_arcticture_learn/core/usecases/usecase.dart';
import 'package:clean_arcticture_learn/core/util/input_converter.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{

}
class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia{
  
}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia{

}

class MockInputConverter extends Mock implements InputConverter{

}

void main(){
  NumberTriviaBloc? bloc;
  // MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  //MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;
  GetConcreteNumberTrivia? getConcreteNumberTrivia;
  GetRandomNumberTrivia? getRandomNumberTrivia;
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  setUp((){
    // mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    //mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    mockNumberTriviaRepository=MockNumberTriviaRepository();
    getConcreteNumberTrivia = GetConcreteNumberTrivia(mockNumberTriviaRepository);
    getRandomNumberTrivia = GetRandomNumberTrivia(mockNumberTriviaRepository);
    bloc = NumberTriviaBloc(getConcreteNumberTrivia: getConcreteNumberTrivia, 
    getRandomNumberTrivia: getRandomNumberTrivia, inputConverter: mockInputConverter);
  
  });

  test('initialState should be empty',(){
    //assert
    expect(bloc!.initialState,Empty());
  });

  group('GetTriviaForConcreteNumber', (){
    const tNumberString="1";
    const tNumberParsed =1;
    final tNumberTrivia=NumberTrivia(number: 1,text: 'test trivia');

    void setUpMockInputConverterSuccess() => when(mockInputConverter!.stringToUnsignedInteger(tNumberString)).thenReturn(const Right(tNumberParsed));



    test('should call the inputConverter to validate and convert the string to an unsigned integer', () async{
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter!.stringToUnsignedInteger(tNumberString));
      //assert
      verify(mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });

    // [] <-- this square bracket denotes state
    test('should emit [Error] when the input is invalid',() async{
      //arrange
      when(mockInputConverter!.stringToUnsignedInteger('ojh')).thenReturn(Left(InvalidInputFailure()));

      //act
      bloc!.add(const GetTriviaForConcreteNumber('ojh'));

      //assert
      List expected=[
       const Error(message: 'INVALID_INPUT_FAILURE_MESSAGE')
      ];  
       expectLater(bloc!.stream, emitsInOrder(expected));

    });


    test('should get data from the concrete use case',() async {
      //arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia!(const Params(number: tNumberParsed))).thenAnswer((realInvocation) async=> Right(tNumberTrivia));

      //act
      bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(getConcreteNumberTrivia!(const Params(number: tNumberParsed)));
      //assert
      verify(getConcreteNumberTrivia!(const Params(number: tNumberParsed)));
    }); 


    test('should emit [Loading, Loaded] when data is gotten successfully',() async{
      //arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia!(const Params(number: tNumberParsed))).thenAnswer((realInvocation) async=> Right(tNumberTrivia));
      


      //assert later
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
    }); 

    test('should emit [Loading, Error] when getting data fails',() async{
      //arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia!(const Params(number: tNumberParsed))).thenAnswer((realInvocation) async=> Left(ServerFailure()));
      
      //assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with a proper message for the error when the getting data fails',() async{
      //arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia!(const Params(number: tNumberParsed))).thenAnswer((realInvocation) async=> Left(CacheFailure()));
      
      //assert later
      final expected = [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
    }); 
  });



  group('GetTriviaForRandomNumber', (){
    
    final tNumberTrivia=NumberTrivia(number: 1,text: 'test trivia');

    test('should get data from the random use case',() async {
      //arrange
      when(getRandomNumberTrivia!(NoParams())).thenAnswer((realInvocation) async=> Right(tNumberTrivia));

      //act
      bloc!.add(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTrivia!(NoParams()));
      //assert
      verify(getRandomNumberTrivia!(NoParams()));
    }); 


    test('should emit [Loading, Loaded] when data is gotten successfully',() async{
      //arrange
      when(getRandomNumberTrivia!(NoParams())).thenAnswer((realInvocation) async=> Right(tNumberTrivia));
      


      //assert later
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForRandomNumber());
    }); 

    test('should emit [Loading, Error] when getting data fails',() async{
      //arrange
      when(getRandomNumberTrivia!(NoParams())).thenAnswer((realInvocation) async=> Left(ServerFailure()));

      //assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] with a proper message for the error when the getting data fails',() async{
      //arrange
      when(getRandomNumberTrivia!(NoParams())).thenAnswer((realInvocation) async=> Left(CacheFailure()));
      
      //assert later
      final expected = [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForRandomNumber());
    }); 
  });




}