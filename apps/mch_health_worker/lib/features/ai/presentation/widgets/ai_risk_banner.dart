import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/ai_risk_assessment.dart';
import '../../providers/ai_providers.dart';

/// AI Risk Assessment banner card shown at the top of patient detail screen.
class AiRiskBanner extends ConsumerWidget {
  final String patientId;

  const AiRiskBanner({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentAsync = ref.watch(patientRiskAssessmentProvider(patientId));

    return assessmentAsync.when(
      loading: () => const _RiskBannerSkeleton(),
      error: (error, _) => _RiskBannerError(
        onRetry: () => ref
            .read(patientRiskAssessmentProvider(patientId).notifier)
            .refresh(patientId),
      ),
      data: (assessment) => _RiskBannerContent(
        assessment: assessment,
        onRefresh: () => ref
            .read(patientRiskAssessmentProvider(patientId).notifier)
            .refresh(patientId),
      ),
    );
  }
}

// ── Content ──────────────────────────────────────────────────────────────────

class _RiskBannerContent extends StatefulWidget {
  final AiRiskAssessment assessment;
  final VoidCallback onRefresh;

  const _RiskBannerContent({required this.assessment, required this.onRefresh});

  @override
  State<_RiskBannerContent> createState() => _RiskBannerContentState();
}

class _RiskBannerContentState extends State<_RiskBannerContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.assessment;
    final color = _riskColor(a.riskLevel);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'AI Risk Assessment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      a.riskLevel.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (a.isFromCache)
                    Tooltip(
                      message: 'Cached result — tap refresh to update',
                      child: Icon(Icons.history, size: 14, color: Colors.grey[500]),
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: widget.onRefresh,
                    tooltip: 'Refresh AI assessment',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Summary (always visible)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Text(
              a.summary,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),

          // Score bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Risk Score: ${a.riskScore}/100',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: a.riskScore / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expandable section: risk factors + recommendations
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (a.riskFactors.isNotEmpty) ...[
                  const Divider(height: 1),
                  _ExpandedSection(
                    title: 'Risk Factors',
                    icon: Icons.warning_amber_rounded,
                    color: color,
                    items: a.riskFactors,
                  ),
                ],
                if (a.recommendations.isNotEmpty) ...[
                  const Divider(height: 1),
                  _ExpandedSection(
                    title: 'Recommended Actions',
                    icon: Icons.check_circle_outline,
                    color: Colors.teal,
                    items: a.recommendations,
                  ),
                ],
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Icon(Icons.smart_toy_outlined, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  'Powered by Gemini AI  ·  ${_timeAgo(a.assessedAt)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Colors.green[700]!;
      case RiskLevel.medium:
        return Colors.orange[700]!;
      case RiskLevel.high:
        return Colors.deepOrange[700]!;
      case RiskLevel.critical:
        return Colors.red[800]!;
      case RiskLevel.unknown:
        return Colors.grey[600]!;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ExpandedSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _ExpandedSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 12, height: 1.4)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading skeleton ──────────────────────────────────────────────────────────

class _RiskBannerSkeleton extends StatefulWidget {
  const _RiskBannerSkeleton();

  @override
  State<_RiskBannerSkeleton> createState() => _RiskBannerSkeletonState();
}

class _RiskBannerSkeletonState extends State<_RiskBannerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.blue.withOpacity(_animation.value)),
                  const SizedBox(width: 8),
                  _Shimmer(width: 150, height: 14, opacity: _animation.value),
                  const Spacer(),
                  _Shimmer(width: 80, height: 22, opacity: _animation.value, radius: 20),
                ],
              ),
              const SizedBox(height: 12),
              _Shimmer(width: double.infinity, height: 12, opacity: _animation.value),
              const SizedBox(height: 6),
              _Shimmer(width: 200, height: 12, opacity: _animation.value),
              const SizedBox(height: 10),
              Row(
                children: [
                  _Shimmer(width: 80, height: 10, opacity: _animation.value),
                  const SizedBox(width: 8),
                  Expanded(child: _Shimmer(width: double.infinity, height: 6, opacity: _animation.value, radius: 4)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.smart_toy_outlined, size: 12, color: Colors.grey.withOpacity(_animation.value)),
                  const SizedBox(width: 4),
                  _Shimmer(width: 120, height: 10, opacity: _animation.value),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double width, height, opacity, radius;
  const _Shimmer({
    required this.width,
    required this.height,
    required this.opacity,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(opacity),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

// ── Error state ───────────────────────────────────────────────────────────────

class _RiskBannerError extends StatelessWidget {
  final VoidCallback onRetry;
  const _RiskBannerError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.cloud_off, color: Colors.grey[400], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'AI assessment unavailable',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
