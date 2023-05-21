import '../models/messageModel.dart';

var wordsList = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
];

List<MessageModel> messages = [
  MessageModel(
      message: 'is it E?',
      user: UserModel(
        id: '1',
        name: 'Player 1',
      ),
      id: "1",
      time: DateTime.now().toString()),
  MessageModel(
      message: 'Maybe C?',
      user: UserModel(
        id: '2',
        name: 'Player 2',
      ),
      id: "2",
      time: DateTime.now().toString()),
  MessageModel(
      message: 'Not it is D,Guessed Right?',
      user: UserModel(
        id: '3',
        name: 'Player 3',
      ),
      id: "3",
      time: DateTime.now().toString()),
];
