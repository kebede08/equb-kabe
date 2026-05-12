import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = 60;
  Timer? _timer;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.verifyOtp(
        phoneNumber: widget.phoneNumber,
        otp: _otp,
      );
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    try {
      await _authService.resendOtp(widget.phoneNumber);
      _startResendTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sms_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a 6-digit code to\n${Formatters.maskPhone(widget.phoneNumber)}',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // OTP input
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                onChanged: (value) => setState(() => _otp = value),
                onCompleted: (value) {
                  setState(() => _otp = value);
                  _verifyOtp();
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: AppColors.surface,
                  inactiveFillColor: AppColors.surfaceVariant,
                  selectedFillColor: AppColors.primaryLight,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
              ),
              const SizedBox(height: 32),

              AppButton(
                label: 'Verify',
                onPressed: _verifyOtp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: AppColors.textGray),
                  ),
                  _canResend
                      ? TextButton(
                          onPressed: _resendOtp,
                          child: const Text('Resend'),
                        )
                      : Text(
                          'Resend in ${_resendSeconds}s',
                          style: const TextStyle(color: AppColors.textGray),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
