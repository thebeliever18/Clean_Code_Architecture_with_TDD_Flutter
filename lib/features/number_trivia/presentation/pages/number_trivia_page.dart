import 'package:clean_arcticture_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcticture_learn/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_arcticture_learn/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:clean_arcticture_learn/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia App'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
      
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      //lazy: false,
      create: (context) => sl<NumberTriviaBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0,),
            //top half
             BlocBuilder<NumberTriviaBloc,NumberTriviaState?>(
                builder: (c,state){
                  if(state is Empty){
                    return const MessageDisplay(message: 'Start Searching',);
                  } else if (state is Loading){
                    return const LoadingWidget();
                  }
                  else if (state is Loaded){
                    //return const MessageDisplay(message: state.trivia.number,);
                  return TriviaDisplay(numberTrivia: state.trivia);

                  }
                  else if(state is Error){
                    return MessageDisplay(message: state.message);
                  }
                return const CircularProgressIndicator();
              }),
            
            SizedBox(height: 20,),
            //bottom half
            TriviaControls()
          ],
        ),
      ),
    ),
    
    );
  }
}







