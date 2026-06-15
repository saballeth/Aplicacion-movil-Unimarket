import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'responsive_constants.dart';

/// Widget base responsivo para cards
/// Adapta automáticamente el tamaño y espaciado según el dispositivo
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final VoidCallback? onTap;
  final Border? border;

  const ResponsiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.onTap,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? 
      EdgeInsets.all(ResponsiveHelper.getPadding(
        context,
        mobilePadding: ResponsiveConstants.paddingMedium,
      ));

    final responsiveMargin = margin ??
      EdgeInsets.all(ResponsiveHelper.getPadding(
        context,
        mobilePadding: ResponsiveConstants.paddingSmall,
      ));

    final responsiveRadius = borderRadius ?? ResponsiveConstants.radiusLarge;

    return Container(
      margin: responsiveMargin,
      child: Card(
        elevation: elevation ?? 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveRadius),
          side: border?.left ?? BorderSide.none,
        ),
        color: backgroundColor ?? Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(responsiveRadius),
          child: Padding(
            padding: responsivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Widget responsivo para grillas
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  const ResponsiveGridView({
    Key? key,
    required this.children,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getGridColumns(context);
    final spacing = mainAxisSpacing ?? 
      ResponsiveHelper.getPadding(context, mobilePadding: ResponsiveConstants.paddingMedium);

    return GridView.builder(
      padding: padding ?? EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: spacing,
        crossAxisSpacing: crossAxisSpacing ?? spacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

/// Widget responsivo para lista horizontal
class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final double? itemSpacing;
  final ScrollPhysics? physics;

  const ResponsiveListView({
    Key? key,
    required this.children,
    this.padding,
    this.itemSpacing,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = itemSpacing ?? 
      ResponsiveHelper.getPadding(context, mobilePadding: ResponsiveConstants.paddingMedium);

    return ListView.separated(
      padding: padding ?? EdgeInsets.symmetric(horizontal: spacing),
      separatorBuilder: (context, index) => SizedBox(width: spacing),
      itemCount: children.length,
      scrollDirection: Axis.horizontal,
      physics: physics ?? const BouncingScrollPhysics(),
      itemBuilder: (context, index) => children[index],
      shrinkWrap: true,
    );
  }
}

/// Widget responsivo para container con tamaño limitado
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveHelper.getMaxContentWidth(context);
    final padding = this.padding ?? 
      EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getPadding(
          context,
          mobilePadding: ResponsiveConstants.paddingLarge,
        ),
      );

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        alignment: alignment,
        child: child,
      ),
    );
  }
}

/// Widget responsivo para botón
class ResponsiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;

  const ResponsiveButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = fontSize ??
      ResponsiveHelper.getFontSize(context, mobileSize: ResponsiveConstants.fontMedium);
    final buttonHeight = ResponsiveHelper.getButtonHeight(context);
    final padding = ResponsiveHelper.getPadding(
      context,
      mobilePadding: ResponsiveConstants.paddingMedium,
    );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue,
        foregroundColor: textColor ?? Colors.white,
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        minimumSize: Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveConstants.radiusLarge),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  SizedBox(width: padding / 2),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: responsiveFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: padding / 2),
                  trailingIcon!,
                ],
              ],
            ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Widget responsivo para espacio
class ResponsiveSpace extends StatelessWidget {
  final double? horizontal;
  final double? vertical;

  const ResponsiveSpace({
    Key? key,
    this.horizontal,
    this.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: horizontal,
      height: vertical,
    );
  }
}
