class IncomeSource {
  String id;
  String userId;
  String source;
  double amount;
  String currency; // Added currency field

  IncomeSource({
    required this.id,
    required this.userId,
    required this.source,
    required this.amount,
    required this.currency, // Added currency field
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'source': source,
      'amount': amount,
      'currency': currency, // Added currency field
    };
  }

  factory IncomeSource.fromMap(Map<String, dynamic> map) {
    return IncomeSource(
      id: map['id'],
      userId: map['userId'],
      source: map['source'],
      amount: map['amount'],
      currency: map['currency'], // Added currency field
    );
  }
}
