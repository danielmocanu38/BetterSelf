import 'package:flutter_test/flutter_test.dart';
import 'package:betterself/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task model should be instantiated correctly', () {
      final task = Task(
        id: '1',
        userId: 'test_user',
        title: 'Test Task',
        description: 'Description',
        dueDate: DateTime.now(),
        isCompleted: false,
        priority: 1,
        quadrant: 0,
      );

      expect(task.id, '1');
      expect(task.userId, 'test_user');
      expect(task.title, 'Test Task');
      expect(task.description, 'Description');
      expect(task.dueDate, isNotNull);
      expect(task.isCompleted, false);
      expect(task.priority, 1);
      expect(task.quadrant, 0);
    });

    test('Task model should convert to map correctly', () {
      final task = Task(
        id: '1',
        userId: 'test_user',
        title: 'Test Task',
        description: 'Description',
        dueDate: DateTime.now(),
        isCompleted: false,
        priority: 1,
        quadrant: 0,
      );

      final taskMap = task.toMap();
      expect(taskMap['id'], '1');
      expect(taskMap['userId'], 'test_user');
      expect(taskMap['title'], 'Test Task');
      expect(taskMap['description'], 'Description');
      expect(taskMap['dueDate'], isNotNull);
      expect(taskMap['isCompleted'], false);
      expect(taskMap['priority'], 1);
      expect(taskMap['quadrant'], 0);
    });

    test('Task model should be instantiated from map correctly', () {
      final taskMap = {
        'id': '1',
        'userId': 'test_user',
        'title': 'Test Task',
        'description': 'Description',
        'dueDate': DateTime.now().toIso8601String(),
        'isCompleted': false,
        'priority': 1,
        'quadrant': 0,
      };

      final task = Task.fromMap(taskMap);

      expect(task.id, '1');
      expect(task.userId, 'test_user');
      expect(task.title, 'Test Task');
      expect(task.description, 'Description');
      expect(task.dueDate, isNotNull);
      expect(task.isCompleted, false);
      expect(task.priority, 1);
      expect(task.quadrant, 0);
    });
  });
}
