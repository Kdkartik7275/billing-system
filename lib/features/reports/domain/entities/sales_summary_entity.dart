class SalesSummaryEntity {
  final double totalSales;
  final int totalBills;

  final double voidAmount;
  final int voidCount;

  final double discountsGiven;
  final int discountedBillCount;

  final double refunds;
  final int refundCount;

  final double taxAmount;

  const SalesSummaryEntity({
    this.totalSales = 0,
    this.totalBills = 0,
    this.voidAmount = 0,
    this.voidCount = 0,
    this.discountsGiven = 0,
    this.discountedBillCount = 0,
    this.refunds = 0,
    this.refundCount = 0,
    this.taxAmount = 0,
  });

  SalesSummaryEntity copyWith({
    double? totalSales,
    int? totalBills,
    double? voidAmount,
    int? voidCount,
    double? discountsGiven,
    int? discountedBillCount,
    double? refunds,
    int? refundCount,
    double? taxAmount,
  }) {
    return SalesSummaryEntity(
      totalSales: totalSales ?? this.totalSales,
      totalBills: totalBills ?? this.totalBills,
      voidAmount: voidAmount ?? this.voidAmount,
      voidCount: voidCount ?? this.voidCount,
      discountsGiven: discountsGiven ?? this.discountsGiven,
      discountedBillCount: discountedBillCount ?? this.discountedBillCount,
      refunds: refunds ?? this.refunds,
      refundCount: refundCount ?? this.refundCount,
      taxAmount: taxAmount ?? this.taxAmount,
    );
  }
}
