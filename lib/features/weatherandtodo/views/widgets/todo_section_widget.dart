import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin/features/weatherandtodo/models/todo_model.dart';
import 'package:get_storage/get_storage.dart';

class TodoSectionWidget extends HookWidget {
  const TodoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = useTextEditingController();
    final todos = useState<List<TodoModel>>([]);
    final editingIndex = useState<int?>(-1);
    final storage = GetStorage();

    useEffect(() {
      final storedTodos = storage.read<List>('todos');
      if (storedTodos != null) {
        todos.value = storedTodos
            .map((todo) => TodoModel.fromJson(Map<String, dynamic>.from(todo)))
            .toList();
      }
      return null;
    }, []);

    void saveTodos(List<TodoModel> todoList) {
      storage.write('todos', todoList.map((todo) => todo.toJson()).toList());
    }

    void addTodo() {
      if (todoController.text.isEmpty) return;

      if (editingIndex.value != -1) {
        final newTodos = List<TodoModel>.from(todos.value);
        newTodos[editingIndex.value!] = TodoModel(text: todoController.text);
        todos.value = newTodos;
        editingIndex.value = -1;
      } else {
        todos.value = [...todos.value, TodoModel(text: todoController.text)];
      }

      saveTodos(todos.value);
      todoController.clear();
    }

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
      final newTodos = List<TodoModel>.from(todos.value);
      newTodos[index] = TodoModel(
        text: newTodos[index].text,
        isCompleted: !newTodos[index].isCompleted,
      );
      todos.value = newTodos;
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
            itemCount: todos.value.length,
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
