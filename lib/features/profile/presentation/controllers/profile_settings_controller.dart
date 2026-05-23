import 'package:get/get.dart';

class ProfileSettingsController extends GetxController {
  final RxBool biometricsEnabled = true.obs;

  void toggleBiometrics(bool value) {
    biometricsEnabled.value = value;
  }
}
