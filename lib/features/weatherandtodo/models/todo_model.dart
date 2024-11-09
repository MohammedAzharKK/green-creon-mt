class TodoModel {
  String text;
  bool isCompleted;

  TodoModel({
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isCompleted': isCompleted,
      };

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        text: json['text'],
        isCompleted: json['isCompleted'],
      );
}
