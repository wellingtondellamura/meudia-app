import 'package:flutter/material.dart';

class MeuDiaButton extends StatefulWidget {
  const MeuDiaButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.variant = MeuDiaButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final MeuDiaButtonVariant variant;

  @override
  State<MeuDiaButton> createState() => _MeuDiaButtonState();
}

class _MeuDiaButtonState extends State<MeuDiaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: SizedBox(
        height: 52,
        width: widget.isExpanded ? double.infinity : null,
        child: FilledButton.icon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          icon: widget.isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(widget.icon),
          style: FilledButton.styleFrom(
            backgroundColor: widget.variant == MeuDiaButtonVariant.primary
                ? theme.colorScheme.primary
                : Colors.white,
            foregroundColor: widget.variant == MeuDiaButtonVariant.primary
                ? Colors.white
                : theme.colorScheme.primary,
            side: widget.variant == MeuDiaButtonVariant.primary
                ? null
                : BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: Text(widget.label),
        ),
      ),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: child,
    );
  }
}

enum MeuDiaButtonVariant { primary, secondary }
