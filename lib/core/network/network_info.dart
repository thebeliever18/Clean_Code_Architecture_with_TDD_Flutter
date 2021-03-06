

import 'package:data_connection_checker_tv/data_connection_checker.dart';
abstract class NetworkInfo{
  Future<bool?>? get isConnected; 
}

class NetworkInfoImpl implements NetworkInfo{
  DataConnectionChecker? dataConnectionChecker;
  NetworkInfoImpl(this.dataConnectionChecker);
  
  @override
  Future<bool?>? get isConnected => Future.value(true);
}