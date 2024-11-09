class TodoModel {
  String text;
  bool isCompleted;

  TodoModel({
    required this.text,
    this.isCompleted = false,
  });

//to json to store in device
  Map<String, dynamic> toJson() => {
        'text': text,
        'isCompleted': isCompleted,
      };

  //from json to fetch from device
  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        text: json['text'],
        isCompleted: json['isCompleted'],
      );
}
