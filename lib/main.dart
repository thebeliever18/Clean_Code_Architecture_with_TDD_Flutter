import 'package:clean_arcticture_learn/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arcticture_learn/injection_container.dart' as di;
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: Color.fromARGB(255, 95, 226, 123),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)
      ),
      home:  const NumberTriviaPage(),
    );
  }
}
