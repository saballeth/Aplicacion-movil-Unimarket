enum PaymentType { paypal, creditCard, debitCard, bankTransfer }

class PaymentMethod {
  final String id;
  final String name;
  final PaymentType type;
  final String? accountNumber;
  final String? bankName;
  final bool isSaved;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.accountNumber,
    this.bankName,
    this.isSaved = false,
  });

  String get displayName {
    switch (type) {
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.creditCard:
        return 'Tarjeta de Crédito';
      case PaymentType.debitCard:
        return 'Tarjeta de Débito';
      case PaymentType.bankTransfer:
        return 'Transferencia Bancaria';
    }
  }

  String get displayAccount {
    if (accountNumber != null && accountNumber!.length > 4) {
      final masked = '*' * (accountNumber!.length - 4) + accountNumber!.substring(accountNumber!.length - 4);
      return '$bankName - $masked';
    }
    return name;
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) => PaymentMethod(
    id: map['id'] as String,
    name: map['name'] as String,
    type: PaymentType.values[map['type'] as int],
    accountNumber: map['accountNumber'] as String?,
    bankName: map['bankName'] as String?,
    isSaved: map['isSaved'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type.index,
    'accountNumber': accountNumber,
    'bankName': bankName,
    'isSaved': isSaved,
  };
}
