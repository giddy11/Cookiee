import 'package:flutter/material.dart';

const _brandColor = Color(0xFF00BCD4);

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double size;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(icon: Icons.remove, onTap: onDecrement, size: size),
        SizedBox(
          width: size + 8,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        _StepButton(icon: Icons.add, onTap: onIncrement, size: size),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _StepButton({required this.icon, required this.onTap, required this.size});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _brandColor.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: size * 0.55, color: _brandColor),
        ),
      ),
    );
  }
}
