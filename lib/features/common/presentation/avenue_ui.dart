import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../theme/avenue_theme.dart';

void goToPage(BuildContext context, AppPage page, {bool replace = false}) {
  if (replace) {
    Navigator.of(context).pushReplacementNamed(page.routeName);
    return;
  }

  Navigator.of(context).pushNamed(page.routeName);
}

void goBackOrHome(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
    return;
  }

  Navigator.of(context).pushReplacementNamed(AppPage.home.routeName);
}

class AvenueScaffold extends StatelessWidget {
  const AvenueScaffold({
    required this.body,
    super.key,
    this.topBar,
    this.bottomNavigation,
    this.floatingActionButton,
    this.backgroundColor,
  });

  final Widget body;
  final PreferredSizeWidget? topBar;
  final Widget? bottomNavigation;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AvenueColors.surface,
      appBar: topBar,
      body: body,
      bottomNavigationBar: bottomNavigation,
      floatingActionButton: floatingActionButton,
    );
  }
}

class AvenueTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AvenueTopBar({
    required this.title,
    super.key,
    this.leading,
    this.actions = const [],
    this.centerTitle = true,
    this.bottomDivider = true,
    this.titleWidget,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;
  final bool bottomDivider;
  final Widget? titleWidget;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withValues(alpha: 0.94),
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      centerTitle: centerTitle,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 8,
      title:
          titleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
      leadingWidth: leading == null ? 0 : 56,
      leading: leading,
      actions: actions,
      bottom: bottomDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: AvenueColors.outlineVariant.withValues(alpha: 0.22),
              ),
            )
          : null,
    );
  }
}

class AvenueIconButton extends StatelessWidget {
  const AvenueIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.filled = false,
    this.size = 42,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;
  final double size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: filled ? AvenueColors.surfaceLow : Colors.transparent,
        borderRadius: BorderRadius.circular(size / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Icon(
            icon,
            color: iconColor ?? AvenueColors.onSurfaceVariant,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class AvenueCard extends StatelessWidget {
  const AvenueCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
    this.color = Colors.white,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AvenueSectionHeader extends StatelessWidget {
  const AvenueSectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final actionStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AvenueColors.primary,
      fontWeight: FontWeight.w700,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(actionLabel!, style: actionStyle),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AvenueColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class AvenuePrimaryButton extends StatelessWidget {
  const AvenuePrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.fullWidth = true,
    this.height = 54,
    this.fontSize = 15,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool fullWidth;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        gradient: AvenueColors.primaryGradient,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33005BBF),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (fullWidth) {
      return child;
    }

    return IntrinsicWidth(child: child);
  }
}

class AvenueSecondaryButton extends StatelessWidget {
  const AvenueSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AvenueColors.primary, width: 1.2),
          shape: const StadiumBorder(),
          foregroundColor: AvenueColors.primary,
          textStyle: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}

class AvenuePill extends StatelessWidget {
  const AvenuePill({
    required this.label,
    super.key,
    this.backgroundColor = const Color(0x14005BBF),
    this.foregroundColor = AvenueColors.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: foregroundColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class AvenueNetworkAvatar extends StatelessWidget {
  const AvenueNetworkAvatar({
    required this.imageUrl,
    super.key,
    this.size = 40,
    this.borderWidth = 2,
    this.fallbackLabel,
  });

  final String imageUrl;
  final double size;
  final double borderWidth;
  final String? fallbackLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: AvenueColors.primaryFixed,
            alignment: Alignment.center,
            child: Text(
              fallbackLabel ?? 'A',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AvenueColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AvenueSearchField extends StatelessWidget {
  const AvenueSearchField({
    required this.hintText,
    super.key,
    this.icon = Icons.search_rounded,
  });

  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AvenueColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AvenueColors.outline, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hintText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AvenueColors.outline.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AvenueInputField extends StatelessWidget {
  const AvenueInputField({
    required this.label,
    required this.hintText,
    required this.icon,
    super.key,
    this.trailing,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final rowChildren = <Widget>[
      Icon(icon, color: AvenueColors.outline, size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          hintText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AvenueColors.outline.withValues(alpha: 0.72),
          ),
        ),
      ),
    ];

    if (trailing != null) {
      rowChildren.add(trailing!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AvenueColors.onSurfaceVariant,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AvenueColors.surfaceHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(children: rowChildren),
        ),
      ],
    );
  }
}

class AvenueNavItem {
  const AvenueNavItem({
    required this.label,
    required this.icon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final AppPage page;
}

class AvenueBottomNavigationBar extends StatelessWidget {
  const AvenueBottomNavigationBar({
    required this.items,
    required this.currentPage,
    super.key,
  });

  final List<AvenueNavItem> items;
  final AppPage? currentPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 22,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: items.map((item) {
            final selected = item.page == currentPage;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => goToPage(
                  context,
                  item.page,
                  replace:
                      item.page == AppPage.home ||
                      item.page == AppPage.adminDrawer,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AvenueColors.primaryFixed.withValues(alpha: 0.72)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 21,
                        color: selected
                            ? AvenueColors.primary
                            : AvenueColors.onSurfaceVariant.withValues(
                                alpha: 0.85,
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w700,
                          color: selected
                              ? AvenueColors.primary
                              : AvenueColors.onSurfaceVariant.withValues(
                                  alpha: 0.7,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
