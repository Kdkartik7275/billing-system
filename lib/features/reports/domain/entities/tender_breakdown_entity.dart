class TenderBreakdownEntity {
  final double cash;
  final double upi;
  final double card;
  final double wallet;
  final double other;

  const TenderBreakdownEntity({
    this.cash = 0,
    this.upi = 0,
    this.card = 0,
    this.wallet = 0,
    this.other = 0,
  });

  double get total => cash + upi + card + wallet + other;

  TenderBreakdownEntity copyWith({
    double? cash,
    double? upi,
    double? card,
    double? wallet,
    double? other,
  }) {
    return TenderBreakdownEntity(
      cash: cash ?? this.cash,
      upi: upi ?? this.upi,
      card: card ?? this.card,
      wallet: wallet ?? this.wallet,
      other: other ?? this.other,
    );
  }
}
