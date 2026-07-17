import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';

class RequestShopRegistrationUseCase
    implements UseCaseWithParams<void, RequestShopRegistrationParams> {
  final AuthenticationRepository repository;

  RequestShopRegistrationUseCase({required this.repository});

  @override
  ResultFuture<void> call(RequestShopRegistrationParams params) {
    return repository.requestShopRegistration(
      shopName: params.shopName,
      ownerName: params.ownerName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      address: params.address,
      additionalInformation: params.additionalInformation,
    );
  }
}

class RequestShopRegistrationParams {
  final String shopName;
  final String ownerName;
  final String email;
  final int phoneNumber;
  final String address;
  final String? additionalInformation;

  RequestShopRegistrationParams({
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.additionalInformation,
  });
}
