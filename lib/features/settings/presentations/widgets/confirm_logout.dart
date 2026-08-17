import 'package:billing_system/core/config/routes/app_routes.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const _LogoutConfirmDialog(),
  );
}

class _LogoutConfirmDialog extends StatefulWidget {
  const _LogoutConfirmDialog();

  @override
  State<_LogoutConfirmDialog> createState() => _LogoutConfirmDialogState();
}

class _LogoutConfirmDialogState extends State<_LogoutConfirmDialog> {
  static const _danger = Color(0xFFEF4444);
  static const _dangerDark = Color(0xFFDC2626);

  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    final success = await Get.find<UserController>().logout();

    if (!mounted) return;

    if (success) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      setState(() => _isLoggingOut = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _dangerDark,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Couldn\'t log out. Please try again.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _close() {
    if (_isLoggingOut) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.sizeOf(context).width;

          final isVeryNarrow = screenWidth < 360;
          final isMobile = screenWidth < 600;

          final horizontalPadding = isVeryNarrow ? 20.0 : 28.0;
          final verticalPadding = isMobile ? 24.0 : 28.0;

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  isMobile ? 20 : 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _CloseButton(onPressed: _isLoggingOut ? null : _close),
                      ],
                    ),

                    SizedBox(height: isMobile ? 4 : 2),

                    // Icon
                    Container(
                      width: isMobile ? 60 : 64,
                      height: isMobile ? 60 : 64,
                      decoration: BoxDecoration(
                        color: _danger.withValues(alpha: 0.09),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: _danger.withValues(alpha: 0.13),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: _danger,
                          size: 27,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Title
                    Text(
                      'Log out?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 21,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: Colors.grey.shade900,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Description
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 370),
                      child: Text(
                        'Are you sure you want to log out? '
                        'Local data on this device will be cleared.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 13.5 : 14,
                          height: 1.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Information box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Your account data will remain safe and '
                              'you can sign in again anytime.',
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.4,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Actions
                    if (isVeryNarrow)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _CancelButton(
                              enabled: !_isLoggingOut,
                              onPressed: _close,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: _LogoutButton(
                              isLoading: _isLoggingOut,
                              onPressed: _handleLogout,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _CancelButton(
                              enabled: !_isLoggingOut,
                              onPressed: _close,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LogoutButton(
                              isLoading: _isLoggingOut,
                              onPressed: _handleLogout,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _CancelButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        side: BorderSide(
          color: enabled ? const Color(0xFFD1D5DB) : const Color(0xFFE5E7EB),
        ),
        foregroundColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LogoutButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(
          0xFFEF4444,
        ).withValues(alpha: 0.55),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? const SizedBox(
                key: ValueKey('loading'),
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Log out',
                key: ValueKey('text'),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}
