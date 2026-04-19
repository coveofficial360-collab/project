import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../theme/avenue_theme.dart';

enum _LoginRole {
  resident('Resident'),
  guard('Guard'),
  admin('Admin');

  const _LoginRole(this.label);

  final String label;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginRole _selectedRole = _LoginRole.resident;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _LoginBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _BrandSection(theme: theme),
                      const SizedBox(height: 40),
                      _RoleSelector(
                        selectedRole: _selectedRole,
                        onRoleSelected: (role) {
                          setState(() {
                            _selectedRole = role;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      _InputGroup(
                        label: 'Identity',
                        icon: Icons.alternate_email_rounded,
                        hintText: 'Email or Phone Number',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _InputGroup(
                        label: 'Security',
                        icon: Icons.lock_outline_rounded,
                        hintText: 'Enter Password',
                        obscureText: _obscurePassword,
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          splashRadius: 20,
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AvenueColors.outline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: AvenueColors.primary,
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _PrimaryActionButton(
                        label: 'Login',
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AvenueColors.onSurfaceVariant,
                            ),
                            children: [
                              const TextSpan(text: 'New to the community? '),
                              TextSpan(
                                text: 'Sign Up',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AvenueColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const _DividerLabel(label: 'or continue with'),
                      const SizedBox(height: 28),
                      const Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              label: 'Google',
                              leading: _GoogleMark(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _SocialButton(
                              label: 'Apple',
                              leading: Icon(
                                Icons.apple,
                                color: AvenueColors.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Elevating Modern Living',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w700,
                            color: AvenueColors.onSurfaceVariant.withValues(
                              alpha: 0.32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    final target = switch (_selectedRole) {
      _LoginRole.admin => AppPage.adminDrawer,
      _LoginRole.resident || _LoginRole.guard => AppPage.home,
    };

    Navigator.of(context).pushReplacementNamed(target.routeName);
  }
}

class _BrandSection extends StatelessWidget {
  const _BrandSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AvenueColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33005BBF),
                blurRadius: 26,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.domain_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Avenue360',
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          'Experience the Digital Concierge',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AvenueColors.onSurfaceVariant.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selectedRole,
    required this.onRoleSelected,
  });

  final _LoginRole selectedRole;
  final ValueChanged<_LoginRole> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AvenueColors.surfaceHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: _LoginRole.values.map((role) {
          final isSelected = role == selectedRole;
          return Expanded(
            child: GestureDetector(
              onTap: () => onRoleSelected(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AvenueColors.surfaceLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  role.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AvenueColors.primary
                        : AvenueColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InputGroup extends StatelessWidget {
  const _InputGroup({
    required this.label,
    required this.icon,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.1,
              color: AvenueColors.outline,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: AvenueColors.surfaceHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: AvenueColors.outline),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: AvenueColors.outline.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AvenueColors.primaryGradient,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33005BBF),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0x4DC1C6D6), thickness: 1, height: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.4,
              color: AvenueColors.outline,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0x4DC1C6D6), thickness: 1, height: 1),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.leading});

  final String label;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AvenueColors.surfaceLowest,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ColoredBox(color: AvenueColors.surface),
        Positioned(
          top: -80,
          right: -60,
          child: _BlurredOrb(
            size: 240,
            color: AvenueColors.primaryFixed.withValues(alpha: 0.55),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -40,
          child: _BlurredOrb(
            size: 180,
            color: AvenueColors.secondaryFixed.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}

class _BlurredOrb extends StatelessWidget {
  const _BlurredOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
