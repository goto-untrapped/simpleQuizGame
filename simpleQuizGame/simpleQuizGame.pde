String status = "start"; //<>//
String[] inputLines;
String[][] questionLines;

String questionText;
int correctIndex;
String[] choiceText;

int SELECT_START_POSX = 50;
int SELECT_FINISH_POSX = 150;
int SELECT_START_TEXT_POSY = 100;
int SELECT_START_JUDGE_POSY = 80;
int SELECT_SPAN = 30;

HashMap<String, Integer> answerMap = new HashMap<String, Integer>();
int questionNo = 0;
int done = 0;
int score = 0;

float questionTextPosX;

void setup() {
  size(500, 400);
  background(50);
  PFont font = createFont("MS Gothic", 24);
  textFont(font);

  inputLines = loadStrings("question.txt");
  questionLines = new String[inputLines.length][];
  for (int i = 0; i < questionLines.length; i++) {
    String[] questionLine = split(inputLines[i], ",");
    questionLines[i] = questionLine;
  }

  questionTextPosX = width;
}

void draw() {
  switch (status) {
  case "start":
    initalize();
    showStart();
    break;
  case "Q":
    initalize();
    readQuestion(questionNo);
    displayQuestion();
    break;
  case "correct":
  case "wrong":
    initalize();
    displayResultForOne(status);
    break;
  case "result":
    initalize();
    displayResult();
    break;
  case "exitGame":
    exitGame();
    break;
  default:
    print("something wrong");
  }
}

void initalize() {
  background(50);
  textAlign(RIGHT);
  text("click and go next page...", width - 30, height - 30);
  textAlign(LEFT);
}

void showStart() {
  textAlign(CENTER);
  text("How many questions can you answer?", width/2, height/2);
  textAlign(LEFT);
}

void mousePressed() {
  if (status.equals("start")) {
    status = "Q";
  } else if (status.equals("Q")) {
    if (mouseX > SELECT_START_POSX && mouseX < SELECT_FINISH_POSX
      && mouseY > SELECT_START_JUDGE_POSY && mouseY < 190) {
      String keyStatus = status + str(questionNo);
      int judgeAnswerIndex = answerMap.get(keyStatus) - 1;
      boolean judge = selectAnswer(judgeAnswerIndex);
      if (judge == true) {
        status = "correct";
        score++;
      } else if (judge == false) {
        status = "wrong";
      }
      done++;
    }
  } else if (status.equals("correct") || status.equals("wrong")) {
    questionNo++;
    status = "Q";
    if (done == inputLines.length) {
      status = "result";
    }
  } else if (status == "result") {
    status = "exitGame";
  }
}

void readQuestion(int index) {
  questionText = questionLines[index][0];
  correctIndex = parseInt(questionLines[index][1]);
  choiceText = new String[questionLines[index].length - 2];
  for (int i = 0; i < questionLines[index].length - 2; i++) {
    choiceText[i] = questionLines[index][i + 2];

    String keyStr = "Q" + str(index);
    answerMap.put(keyStr, correctIndex);
  }
}

void displayQuestion() {
  displayQuestionText();
  for (int i = 0; i < choiceText.length; i++) {
    text(choiceText[i], SELECT_START_POSX, SELECT_START_TEXT_POSY + i * SELECT_SPAN);
  }
}

void displayQuestionText() {
  //fill(50);
  //rect(SELECT_START_POSX, SELECT_START_POSX, width, SELECT_SPAN);
  //fill(255);
  text(questionText, questionTextPosX, 50);
  questionTextPosX = questionTextPosX - 2;
  float w = textWidth(questionText);
  if (questionTextPosX < -w) {
    questionTextPosX = width;
  }
}

boolean selectAnswer(int index) {
  if (mouseY > SELECT_START_JUDGE_POSY + index * SELECT_SPAN
    && mouseY < SELECT_START_JUDGE_POSY + (index + 1) * SELECT_SPAN) {
    return true;
  } else {
    return false;
  }
}

void displayResultForOne(String status) {
  textAlign(CENTER);
  text("You're " + status + "!", width/2, height/2);
  textAlign(LEFT);
}

void displayResult() {
  textAlign(CENTER);
  text("You're score is " + score, width/2, height/2);
  if (score == done) {
    text("Wow!", width/2, height/1.7);
  }
  text("Thank you for playing.", width/2, height/1.5);

  textAlign(LEFT);
}

void exitGame() {
  exit();
}
