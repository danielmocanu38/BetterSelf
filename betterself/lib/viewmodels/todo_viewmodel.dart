import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class TodoViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoViewModel() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await loadTasks(user.uid);
    }
  }

  Future<void> addTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      task.userId = user.uid;
      task.priority = _tasks.where((t) => t.quadrant == task.quadrant).length;
      _tasks.add(task);
      await _firestore.collection('tasks').doc(task.id).set(task.toMap());
      notifyListeners();
    }
  }

  Future<void> removeTask(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final taskToRemove = _tasks.firstWhere((task) => task.id == id);
      _tasks.removeWhere((task) => task.id == id);
      _tasks
          .where((task) => task.quadrant == taskToRemove.quadrant)
          .toList()
          .asMap()
          .forEach((index, task) {
        task.priority = index;
        _firestore.collection('tasks').doc(task.id).set(task.toMap());
      });
      await _firestore.collection('tasks').doc(id).delete();
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        await _firestore.collection('tasks').doc(task.id).set(task.toMap());
        notifyListeners();
      }
    }
  }

  List<Task> getTasksByQuadrant(int quadrant) {
    return _tasks.where((task) => task.quadrant == quadrant).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  Future<void> changeTaskPriority(String id, int newPriority) async {
    final task = _tasks.firstWhere((task) => task.id == id);
    final quadrantTasks =
        _tasks.where((t) => t.quadrant == task.quadrant).toList();

    quadrantTasks.removeWhere((t) => t.id == id);
    quadrantTasks.insert(newPriority, task);

    for (int i = 0; i < quadrantTasks.length; i++) {
      quadrantTasks[i].priority = i;
    }

    for (var t in quadrantTasks) {
      _tasks[_tasks.indexWhere((tsk) => tsk.id == t.id)] = t;
      await _firestore.collection('tasks').doc(t.id).set(t.toMap());
    }

    notifyListeners();
  }

  Future<void> updateTaskPriorities(List<Task> tasks) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var task in tasks) {
        await _firestore.collection('tasks').doc(task.id).set(task.toMap());
      }
      notifyListeners();
    }
  }

  Future<void> completeTask(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = true;
      await _firestore
          .collection('tasks')
          .doc(_tasks[index].id)
          .set(_tasks[index].toMap());
      notifyListeners();
    }
  }

  Future<void> loadTasks(String userId) async {
    _isLoading = true;
    final taskSnapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    _tasks.clear();

    for (var doc in taskSnapshot.docs) {
      _tasks.add(Task.fromMap(doc.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshTasks() {
    // You can refetch tasks from the data source or reset the state as needed
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      loadTasks(user.uid);
    }
  }

  void clearData() {
    _tasks.clear();
    notifyListeners();
  }
}
