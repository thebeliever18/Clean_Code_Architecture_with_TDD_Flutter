import 'package:clean_arcticture_learn/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String? inputStr;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number'
          ),
          onChanged: ((value) {
          inputStr = value;
        } ),
        onSubmitted: (_){
          addConcrete();
        },
        ),
        SizedBox(height:10),
        Row(children: [
          Expanded(
            child: ElevatedButton(
              
              child: Text('Search'),
              
              style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white, // foreground color
                        primary: Theme.of(context).colorScheme.primary, // Background color
                  ),
              onPressed: addConcrete
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: ElevatedButton(
              
              child: Text('Get Random Trivia'),
              
              style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black, // foreground color
                        primary: Colors.grey, // Background color
                  ),
              onPressed: addRandom
            ),
          )

        ],)
      ],
    );
  }

  void addConcrete(){
    controller.clear();
      BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}