import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  final List<TextEditingController> controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Image.asset('assets/images/logo.png', width: 200, height: 200,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                    child: TextField(
                      controller: controllers[i],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              List<int> numbers = [];
              for (int i = 0; i < 5; i++) {
                int number = int.tryParse(controllers[i].text) ?? 0;
                numbers.add(number);
              }
              if (numbers.reduce((a, b) => a + b) != 30 || controllers.any((controller) => controller.text.isEmpty)) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('오류'),
                    content: Text('5개의 숫자의 합은 30이 되어야 합니다.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('확인'),
                      ),
                    ],
                  ),
                );
              } else {
                int roundWin = 0;
                int win = 0;
                int roundLose = 0;
                int lose = 0;
                int roundDraw = 0;
                int draw = 0;
                Map studentNumbers = {
                  1: [6, 6, 6, 6, 6],
                  2: [4, 8, 5, 7, 6],
                  3: [6, 10, 7, 4, 3],
                  4: [5, 10, 9, 1, 5],
                  5: [0, 10, 0 ,10, 10],
                  6: [2, 8, 9, 3, 8],
                  7: [1, 10, 3, 6, 10],
                  8: [0, 26, 1, 2, 1],
                  9: [1, 2, 3, 4, 20],
                  10: [5, 12, 9, 4, 0],
                  11: [7, 8, 3, 5, 7],
                  12: [0, 10, 10, 10, 0],
                  13: [3, 7, 13, 5, 2],
                  14: [3, 7, 2, 8, 10],
                  15: [0, 15, 7, 0, 8]
                };
                for (int i = 0; i < studentNumbers.length; i++) {
                  for(int j = 0; j < 5; j++) {
                    if (studentNumbers[i + 1][j] < numbers[j]) {
                      roundWin += 1;
                    }
                    else if(studentNumbers[i + 1][j] == numbers[j]) {
                      roundDraw += 1;
                    }
                    else {
                      roundLose += 1;
                    }
                  }
                  if(roundWin > roundLose){
                    win += 1;
                  }
                  else if(roundWin == roundLose){
                    draw += 1;
                  }
                  else{
                    lose += 1;
                  }
                }
                int score = 3 * win + 1 * draw;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Color(0xffEEEBF5),
                    title: Text('점수'),
                    content: ResultCard(winCount: win, loseCount: lose, drawCount: draw, score: score),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('확인'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('결과 확인해보기!'),

          ),
          Spacer(),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  ResultCard({super.key, required this.winCount, required this.loseCount, required this.drawCount, required this.score});
  final winCount;
  final loseCount;
  final drawCount;
  final score;


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 238, 235, 245),
      shadowColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('이번 라운드', style: TextStyle(fontSize: 30),),
          Text('이긴 부원 수: $winCount', style: TextStyle(color: Colors.blue, fontSize: 25),),
          Text('진 부원 수: $loseCount', style: TextStyle(color: Colors.red, fontSize: 25),),
          Text('비긴 부원 수: $drawCount', style: TextStyle(color: Colors.black, fontSize: 25),),
          Text('총 점수', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          Text('$score', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}