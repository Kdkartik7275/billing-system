import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Deducts a freshly-completed bill's quantities from stock immediately,
/// then stamps the bill so the once-daily sync reconciliation skips it.
///
/// Before this existed, stock was only reduced when [BillSyncScheduler]
/// ran — up to 24 hours after the sale — so the same unit could be sold
/// repeatedly until then. Reduction now happens at sale time, locally,
/// which also means it keeps working with no connectivity.
///
/// The stamp is written *after* the deduction so a crash in between leaves
/// the bill unstamped, and the daily reconciliation still picks it up.
/// That direction is deliberate: reducing twice is a data-corrupting error,
/// while reducing late is merely a delay.
class ApplyBillStockReductionUsecase
    implements UseCaseWithParams<List<AppliedStockReduction>, BillEntity> {
  final StockRepository stockRepository;
  final BillRepository billRepository;

  ApplyBillStockReductionUsecase({
    required this.stockRepository,
    required this.billRepository,
  });

  @override
  ResultFuture<List<AppliedStockReduction>> call(BillEntity bill) async {
    if (bill.stockApplied) return const Right([]);

    final lines = bill.items
        .map(
          (item) =>
              SaleStockLine(productId: item.productId, quantity: item.quantity),
        )
        .toList();

    if (lines.isEmpty) {
      await billRepository.markStockApplied(bill.id);
      return const Right([]);
    }

    final result = await stockRepository.applySaleLocally(
      lines: lines,
      warehouseId: bill.warehouseId,
      billId: bill.id,
      performedByUserId: bill.cashierId.isEmpty ? null : bill.cashierId,
    );

    return result.fold<ResultFuture<List<AppliedStockReduction>>>(
      (failure) async => left(failure),
      (applied) async {
        await billRepository.markStockApplied(bill.id);
        return right(applied);
      },
    );
  }
}
