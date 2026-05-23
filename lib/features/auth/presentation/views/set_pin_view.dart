import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/set_pin_controller.dart';

class SetPinView extends StatelessWidget {
  const SetPinView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetPinController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          'Security PIN',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Lock Shield Icon Circle
                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF7E6), // Light gold tint
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            color: AppColors.secondaryDark,
                            size: 44,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      
                      const Text(
                        'Set Security PIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Create a 4-digit security PIN to quickly log in and authorize requests.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0F3A5F),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      
                      // 4 dots representing the PIN digits
                      Obx(() {
                        final length = controller.pin.value.length;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            final isFilled = index < length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFilled
                                    ? AppColors.primary
                                    : const Color(0xFFE2E8F0),
                                border: Border.all(
                                  color: isFilled
                                      ? AppColors.primary
                                      : const Color(0xFFCBD5E1),
                                  width: 2,
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                      
                      const SizedBox(height: 48),
                      
                      // Custom Numeric Keypad
                      _buildKeypad(controller),
                    ],
                  ),
                ),
              ),
            ),
            
            // Setup PIN Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value || controller.pin.value.length < 4
                      ? null
                      : () => controller.submitPin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 2,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Setup PIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(SetPinController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('1', controller),
            _buildKeypadButton('2', controller),
            _buildKeypadButton('3', controller),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('4', controller),
            _buildKeypadButton('5', controller),
            _buildKeypadButton('6', controller),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('7', controller),
            _buildKeypadButton('8', controller),
            _buildKeypadButton('9', controller),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Backspace/delete button
            _buildIconButton(
              Icons.backspace_outlined,
              controller.removeDigit,
            ),
            _buildKeypadButton('0', controller),
            // Dummy spacer or checkmark button (we will submit using the bottom primary button)
            const SizedBox(width: 72, height: 72),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit, SetPinController controller) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: () => controller.addDigit(digit),
        borderRadius: BorderRadius.circular(36),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(36),
        child: Center(
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
