class CashReconciliationEntity  {
  final double openingCashFloat;
  final double cashSales;
  final double cashRefunds;
  final double payouts;
  final double expectedCash;
  final double? countedCash;
  final double? variance;

  const CashReconciliationEntity({
    this.openingCashFloat = 0,
    this.cashSales = 0,
    this.cashRefunds = 0,
    this.payouts = 0,
    this.expectedCash = 0,
    this.countedCash,
    this.variance,
  });

  CashReconciliationEntity copyWith({
    double? openingCashFloat,
    double? cashSales,
    double? cashRefunds,
    double? payouts,
    double? expectedCash,
    double? countedCash,
    double? variance,
  }) {
    return CashReconciliationEntity(
      openingCashFloat:
          openingCashFloat ?? this.openingCashFloat,
      cashSales:
          cashSales ?? this.cashSales,
      cashRefunds:
          cashRefunds ?? this.cashRefunds,
      payouts:
          payouts ?? this.payouts,
      expectedCash:
          expectedCash ?? this.expectedCash,
      countedCash:
          countedCash ?? this.countedCash,
      variance:
          variance ?? this.variance,
    );
  }

}