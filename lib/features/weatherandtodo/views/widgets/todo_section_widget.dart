import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin/features/weatherandtodo/models/todo_model.dart';
import 'package:get_storage/get_storage.dart';

class TodoSectionWidget extends HookWidget {
  const TodoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = useTextEditingController();

    //to store todos in a list
    final todos = useState<List<TodoModel>>([]);

    final editingIndex = useState<int?>(-1);

    //object for get storage to save in device memmory
    final storage = GetStorage();

    useEffect(() {
      //to get todos from device after opening the app
      final storedTodos = storage.read<List>('todos');
      if (storedTodos != null) {
        //converting json to dart object
        todos.value = storedTodos
            .map((todo) => TodoModel.fromJson(Map<String, dynamic>.from(todo)))
            .toList();
      }
      return null;
    }, []);

    void saveTodos(List<TodoModel> todoList) {
      // converting todo list from dart object to json
      storage.write('todos', todoList.map((todo) => todo.toJson()).toList());
    }

    void addTodo() {
      // to check weather there is text to save in todo
      if (todoController.text.isEmpty && todoController.text.trim().isEmpty)
        return;

      // Check if the text is not empty and not only whitespace
      if (editingIndex.value != -1) {
        final newTodos = List<TodoModel>.from(todos.value);
        newTodos[editingIndex.value!] =
            TodoModel(text: todoController.text.trim());
        todos.value = newTodos;
        editingIndex.value = -1;
      } else {
        //adding the todo to the todo list
        if (todoController.text.trim().isNotEmpty) {
          todos.value = [
            ...todos.value,
            TodoModel(text: todoController.text.trim())
          ];
        }
      }

      saveTodos(todos.value);
      todoController.clear();
    }

    /// removing from the list and from the device
    /// [index]=is the selected index passing from the homepage
    void removeTodo(int index) {
      final newTodos = List<TodoModel>.from(todos.value);
      newTodos.removeAt(index);
      todos.value = newTodos;
      saveTodos(todos.value);
    }

    void editTodo(int index) {
      todoController.text = todos.value[index].text;
      editingIndex.value = index;
    }

    void toggleTodo(int index) {
      // Create a copy of the existing todos list to avoid changing the original list
      final newTodos = List<TodoModel>.from(todos.value);

      // Update the isCompleted status of the todo at the specified index
      newTodos[index] = TodoModel(
        text: newTodos[index].text, // Keep the current text
        isCompleted:
            !newTodos[index].isCompleted, // Toggle the isCompleted status
      );

      // Update the todos list with the new list
      todos.value = newTodos;

      // Save the updated todos list to storage
      saveTodos(todos.value);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Todo List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                    hintText: editingIndex.value != -1
                        ? "Edit todo"
                        : "Add a new todo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (_) => addTodo(),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: addTodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  editingIndex.value != -1 ? "Update" : "Add",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todos.value
                .length, //length of the todos defined by checking the length of todo list
            itemBuilder: (context, index) {
              final todo = todos.value[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => toggleTodo(index),
                  ),
                  title: Text(
                    todo.text,
                    style: TextStyle(
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                      color: todo.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editTodo(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removeTodo(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
