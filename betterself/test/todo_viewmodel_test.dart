import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:betterself/viewmodels/todo_viewmodel.dart';
import 'package:betterself/models/task.dart';
import 'mock.dart'; // Import the mock file
import 'todo_viewmodel_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot
])
void main() {
  setupFirebaseMocks(); // Set up the Firebase mocks

  group('TodoViewModel Tests', () {
    late TodoViewModel viewModel;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
    late MockQuery<Map<String, dynamic>> mockQuery;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>>
        mockQueryDocumentSnapshot;

    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp();
    });

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
      mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
      mockQuery = MockQuery<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocumentSnapshot =
          MockQueryDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockCollectionReference.where(any, isEqualTo: anyNamed('isEqualTo')))
          .thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'id': '1',
        'title': 'Test Task',
        'description': 'Description',
        'dueDate': Timestamp.fromDate(DateTime.now()), // Use Timestamp here
        'isCompleted': false,
        'quadrant': 1,
        'priority': 1,
        'userId': 'test_user'
      });

      viewModel = TodoViewModel();
      viewModel.setFirestore(mockFirestore); // Set the mock Firestore instance
    });

    test('Add and remove task', () async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        dueDate: DateTime.now(),
        isCompleted: false,
        quadrant: 1,
        priority: 1,
        userId: 'test_user',
      );

      await viewModel.addTask(task, 'test_user');
      expect(viewModel.tasks.length, 1);
      expect(viewModel.tasks[0].id, task.id);

      await viewModel.removeTask(task.id);
      expect(viewModel.tasks.length, 0);
    });

    test('Update task', () async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        dueDate: DateTime.now(),
        isCompleted: false,
        quadrant: 1,
        priority: 1,
        userId: 'test_user',
      );

      await viewModel.addTask(task, 'test_user');
      final updatedTask = Task(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        dueDate: DateTime.now(),
        isCompleted: false,
        quadrant: 1,
        priority: 1,
        userId: 'test_user',
      );

      await viewModel.updateTask(updatedTask);
      expect(viewModel.tasks.length, 1);
      expect(viewModel.tasks[0].title, 'Updated Task');
    });

    test('Complete task', () async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        dueDate: DateTime.now(),
        isCompleted: false,
        quadrant: 1,
        priority: 1,
        userId: 'test_user',
      );

      await viewModel.addTask(task, 'test_user');
      await viewModel.completeTask(task.id);
      expect(viewModel.completedTasks.length, 1);
      expect(viewModel.completedTasks[0].isCompleted, true);
    });

    test('Load tasks', () async {
      await viewModel.loadTasks('test_user');
      expect(viewModel.tasks.length, 1);
      expect(viewModel.tasks[0].title, 'Test Task');
    });

    test('Clear tasks', () async {
      await viewModel.loadTasks('test_user');
      expect(viewModel.tasks.length, 1);

      viewModel.clearData();
      expect(viewModel.tasks.length, 0);
    });
  });
}
