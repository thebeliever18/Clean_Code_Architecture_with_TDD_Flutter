import 'package:clean_arcticture_learn/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{

}

 void main() {
   MockDataConnectionChecker? mockDataConnectionChecker;
  NetworkInfoImpl? networkInfoImpl;
  //  final  subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //       print('hello');
  //     });

  setUp((){
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker!);
      
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',() async {
      
      //arrange
      bool checker = await DataConnectionChecker().hasConnection;
      
      //when(mockDataConnectionChecker!()).thenAnswer((_)  async => true);
    
      //act
      final result = await networkInfoImpl!.isConnected; 

      //verify
      //verify(checker);

      //expect
      expect(result, checker);
    });
  });
}