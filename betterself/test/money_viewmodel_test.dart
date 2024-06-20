import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betterself/viewmodels/money_viewmodel.dart';
import 'package:betterself/models/expense.dart';
import 'package:betterself/models/income_source.dart';
import 'money_viewmodel_test.mocks.dart';
import 'mock.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  FirebaseAuth,
  User,
  QuerySnapshot,
  DocumentSnapshot
])
void main() {
  setupFirebaseMocks();

  group('MoneyViewModel Tests', () {
    late MoneyViewModel viewModel;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

    setUpAll(() async {
      await Firebase.initializeApp();
    });

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
      mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) async => {});
      when(mockDocumentReference.delete()).thenAnswer((_) async => {});
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_user');

      viewModel = MoneyViewModel();
      viewModel.setFirestore(mockFirestore);
      viewModel.setFirebaseAuth(mockFirebaseAuth);
    });

    test('Add and remove expense', () async {
      final expense = Expense(
        id: '1',
        userId: 'test_user',
        amount: 100,
        category: 'Food',
        currency: '\$',
        date: DateTime(2022, 10, 10),
        description: 'Grocery shopping',
      );

      await viewModel.addExpense(expense);
      expect(viewModel.expenses.length, 1);
      expect(viewModel.expenses[0].id, expense.id);

      await viewModel.removeExpense(expense.id);
      expect(viewModel.expenses.length, 0);
    });

    test('Update expense', () async {
      final expense = Expense(
        id: '2',
        userId: 'test_user',
        amount: 50,
        category: 'Transport',
        currency: '€',
        date: DateTime(2022, 10, 11),
        description: 'Bus ticket',
      );

      await viewModel.addExpense(expense);
      final updatedExpense = Expense(
        id: '2',
        userId: 'test_user',
        amount: 60,
        category: 'Transport',
        currency: '€',
        date: DateTime(2022, 10, 11),
        description: 'Train ticket',
      );

      await viewModel.updateExpense(updatedExpense);
      expect(viewModel.expenses.length, 1);
      expect(viewModel.expenses[0].amount, 60);
      expect(viewModel.expenses[0].description, 'Train ticket');
    });

    test('Add and remove income source', () async {
      final source = IncomeSource(
        id: '1',
        userId: 'test_user',
        source: 'Salary',
        amount: 1000,
        currency: '\$',
      );

      await viewModel.addIncomeSource(source);
      expect(viewModel.budget.incomeSources.length, 1);
      expect(viewModel.budget.incomeSources[0].id, source.id);

      await viewModel.removeIncomeSource(source.id);
      expect(viewModel.budget.incomeSources.length, 0);
    });

    test('Update income source', () async {
      final source = IncomeSource(
        id: '2',
        userId: 'test_user',
        source: 'Freelance work',
        amount: 500,
        currency: '€',
      );

      await viewModel.addIncomeSource(source);
      final updatedSource = IncomeSource(
        id: '2',
        userId: 'test_user',
        source: 'Freelance project',
        amount: 700,
        currency: '€',
      );

      await viewModel.updateIncomeSource(updatedSource);
      expect(viewModel.budget.incomeSources.length, 1);
      expect(viewModel.budget.incomeSources[0].amount, 700);
      expect(viewModel.budget.incomeSources[0].source, 'Freelance project');
    });

    test('Set budget', () async {
      await viewModel.setBudget(5000);
      expect(viewModel.budget.totalAmount, 5000);
    });

    test('Load expenses and budget', () async {
      when(mockFirestore.collection('expenses'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.where('userId', isEqualTo: 'test_user'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(mockFirestore.collection('budgets'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('test_user'))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);

      when(mockQuerySnapshot.docs).thenReturn([]);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      await viewModel.loadExpensesAndBudget('test_user');
      expect(viewModel.expenses.length,
          0); // Assuming no expenses returned from mock
      expect(viewModel.budget.totalAmount,
          0); // Assuming no budget returned from mock
    });
  });
}
