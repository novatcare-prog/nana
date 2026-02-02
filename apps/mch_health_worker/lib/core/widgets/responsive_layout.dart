import 'package:flutter/material.dart';

/// Responsive layout helper for desktop-optimized views
/// Provides constrained widths and multi-column layouts for larger screens

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// A responsive grid that adapts to screen size
/// Shows items in a grid with constrained card widths
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final double minCardWidth;
  final double maxCardWidth;
  final double spacing;
  final double runSpacing;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.minCardWidth = 280,
    this.maxCardWidth = 400,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal column count based on available width
        final availableWidth = constraints.maxWidth;
        final columnCount = (availableWidth / minCardWidth).floor().clamp(1, 4);
        final cardWidth =
            (availableWidth - (spacing * (columnCount - 1))) / columnCount;
        final constrainedCardWidth =
            cardWidth.clamp(minCardWidth, maxCardWidth);

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: constrainedCardWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// A two-column desktop layout with configurable flex ratios
class DesktopTwoColumnLayout extends StatelessWidget {
  final Widget leftColumn;
  final Widget rightColumn;
  final int leftFlex;
  final int rightFlex;
  final double dividerWidth;
  final double breakpoint;

  const DesktopTwoColumnLayout({
    super.key,
    required this.leftColumn,
    required this.rightColumn,
    this.leftFlex = 4,
    this.rightFlex = 6,
    this.dividerWidth = 1,
    this.breakpoint = 900,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < breakpoint) {
      // Stack vertically on smaller screens
      return Column(
        children: [
          leftColumn,
          rightColumn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: leftFlex,
          child: leftColumn,
        ),
        if (dividerWidth > 0)
          VerticalDivider(width: dividerWidth, thickness: dividerWidth),
        Expanded(
          flex: rightFlex,
          child: rightColumn,
        ),
      ],
    );
  }
}

/// Constrained width card that doesn't stretch on desktop
class ConstrainedCard extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? color;
  final ShapeBorder? shape;

  const ConstrainedCard({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.margin,
    this.padding,
    this.elevation,
    this.color,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Card(
        elevation: elevation,
        color: color,
        margin: margin ?? EdgeInsets.zero,
        shape: shape,
        child:
            padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

/// Responsive breakpoints helper
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeDesktop;

  /// Returns the number of columns for a grid based on screen width
  static int getGridColumnCount(BuildContext context,
      {int minColumns = 1, int maxColumns = 4}) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return minColumns;
    if (width < tablet) return (minColumns + 1).clamp(minColumns, maxColumns);
    if (width < desktop) return (minColumns + 2).clamp(minColumns, maxColumns);
    return maxColumns;
  }
}

/// A wrapper that centers content with max width for desktop views
class CenteredContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  const CenteredContent({
    super.key,
    required this.child,
    this.maxWidth = 1000,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// A responsive list/grid view that switches layout based on screen size
class ResponsiveListGrid extends StatelessWidget {
  final List<Widget> children;
  final double gridMinCardWidth;
  final double gridMaxCardWidth;
  final double spacing;
  final EdgeInsets padding;
  final ScrollController? controller;

  const ResponsiveListGrid({
    super.key,
    required this.children,
    this.gridMinCardWidth = 320,
    this.gridMaxCardWidth = 450,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(16),
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        if (!isWide) {
          // Mobile: standard list
          return ListView.separated(
            controller: controller,
            padding: padding,
            itemCount: children.length,
            separatorBuilder: (_, __) => SizedBox(height: spacing),
            itemBuilder: (_, index) => children[index],
          );
        }

        // Desktop: wrapped grid with constrained cards
        final columnCount =
            (constraints.maxWidth / gridMinCardWidth).floor().clamp(2, 3);
        final cardWidth = ((constraints.maxWidth -
                    padding.horizontal -
                    (spacing * (columnCount - 1))) /
                columnCount)
            .clamp(gridMinCardWidth, gridMaxCardWidth);

        return SingleChildScrollView(
          controller: controller,
          padding: padding,
          child: Center(
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: children.map((child) {
                return SizedBox(
                  width: cardWidth,
                  child: child,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
