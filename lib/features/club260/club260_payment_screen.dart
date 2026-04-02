import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';

class Club260PaymentScreen extends StatefulWidget {
  final String plan;
  final String billing;

  const Club260PaymentScreen({
    super.key,
    required this.plan,
    required this.billing,
  });

  @override
  State<Club260PaymentScreen> createState() => _Club260PaymentScreenState();
}

class _Club260PaymentScreenState extends State<Club260PaymentScreen> {
  int _methodIndex = 0; // 0=MoMo, 1=Airtel, 2=Card
  bool _processing = false;
  bool _success = false;

  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  static const _plans = {
    'explorer': {'name': 'Explorer', 'price': 'Free', 'color': 0xFF888888},
    'member': {'name': 'Member', 'price': 'ZMW 150', 'color': 0xFF00BFA6},
    'advocate': {'name': 'Advocate', 'price': 'ZMW 350', 'color': 0xFFFFB800},
  };

  static const _planAnnual = {
    'explorer': 'Free',
    'member': 'ZMW 120',
    'advocate': 'ZMW 280',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String get _price {
    if (widget.plan == 'explorer') return 'Free';
    final isAnnual = widget.billing == 'annual';
    return isAnnual
        ? _planAnnual[widget.plan] ?? 'ZMW 0'
        : (_plans[widget.plan]?['price'] as String?) ?? 'ZMW 0';
  }

  Color get _planColor {
    return Color((_plans[widget.plan]?['color'] as int?) ?? 0xFF888888);
  }

  String get _planName =>
      (_plans[widget.plan]?['name'] as String?) ?? 'Explorer';

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _processing = false;
      _success = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final ac = AuthController.instance;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: _success ? _SuccessView(plan: _planName, color: _planColor) : SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 60 : 20,
          vertical: 48,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _paymentForm(ac)),
                      const SizedBox(width: 32),
                      SizedBox(width: 280, child: _orderSummary()),
                    ],
                  )
                : Column(
                    children: [
                      _orderSummary(),
                      const SizedBox(height: 32),
                      _paymentForm(ac),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _paymentForm(AuthController ac) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete your order',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          ac.email ?? '',
          style: GoogleFonts.poppins(
            color: AppColors.textGray,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 32),

        // Payment method tabs
        Text(
          'PAYMENT METHOD',
          style: GoogleFonts.poppins(
            color: AppColors.textGray,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _methodTab(0, 'MTN MoMo', '📱'),
            const SizedBox(width: 10),
            _methodTab(1, 'Airtel Money', '📲'),
            const SizedBox(width: 10),
            _methodTab(2, 'Card', '💳'),
          ],
        ),
        const SizedBox(height: 28),

        if (_methodIndex < 2) ...[
          _label('Mobile Number'),
          _field(
            _phoneController,
            hint: '+260 97X XXX XXX',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.teal.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teal.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.teal, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You will receive a payment prompt on your phone. Approve it to complete your subscription.',
                    style: GoogleFonts.poppins(
                      color: AppColors.teal,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          _label('Name on card'),
          _field(_nameController, hint: 'Full Name'),
          const SizedBox(height: 16),
          _label('Card number'),
          _field(
            _cardNumberController,
            hint: '1234 5678 9012 3456',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            maxLength: 19,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Expiry'),
                    _field(_expiryController,
                        hint: 'MM / YY',
                        keyboardType: TextInputType.number,
                        maxLength: 7),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('CVV'),
                    _field(_cvvController,
                        hint: '•••',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscure: true),
                  ],
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _processing ? null : _pay,
            style: ElevatedButton.styleFrom(
              backgroundColor: _planColor,
              foregroundColor: AppColors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: _planColor.withOpacity(0.5),
            ),
            child: _processing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.plan == 'explorer'
                        ? 'Activate Free Plan'
                        : 'Pay $_price',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline,
                size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              'Secure & encrypted payment',
              style: GoogleFonts.poppins(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _orderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _planColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER SUMMARY',
            style: GoogleFonts.poppins(
              color: AppColors.textGray,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _planColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              _planName.toUpperCase(),
              style: GoogleFonts.poppins(
                color: _planColor,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.billing == 'annual' ? 'Annual' : 'Monthly'} plan',
                style: GoogleFonts.poppins(
                  color: AppColors.offWhite,
                  fontSize: 14,
                ),
              ),
              Text(
                _price,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (widget.billing == 'annual' && widget.plan != 'explorer') ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Annual saving',
                    style: GoogleFonts.poppins(
                        color: AppColors.teal, fontSize: 13)),
                Text('20% off',
                    style: GoogleFonts.poppins(
                        color: AppColors.teal,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
          const SizedBox(height: 20),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.teal, size: 16),
              const SizedBox(width: 8),
              Text('7-day free trial',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGray, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.teal, size: 16),
              const SizedBox(width: 8),
              Text('Cancel anytime',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGray, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.teal, size: 16),
              const SizedBox(width: 8),
              Text('Instant access',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGray, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _methodTab(int index, String label, String emoji) {
    final active = _methodIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _methodIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? AppColors.teal.withOpacity(0.1)
                : AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  active ? AppColors.teal.withOpacity(0.5) : AppColors.borderColor,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: active ? AppColors.teal : AppColors.textGray,
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: AppColors.textGray,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller, {
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
        filled: true,
        fillColor: AppColors.cardBg,
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.teal),
        ),
      ),
    );
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final String plan;
  final Color color;
  const _SuccessView({required this.plan, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.4), width: 2),
              ),
              child: Icon(Icons.check_rounded, color: color, size: 52),
            ),
            const SizedBox(height: 32),
            Text(
              "You're in!",
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Welcome to the $plan plan.\nYour community is waiting.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.textGray,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/club260/feed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: AppColors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Go to My Feed',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card number formatter ────────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
