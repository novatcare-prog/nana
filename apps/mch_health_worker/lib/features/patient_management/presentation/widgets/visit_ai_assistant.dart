import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../ai/providers/ai_providers.dart';
import '../../../ai/services/clinical_support_service.dart';

/// Expandable pre-visit AI briefing panel shown at the top of ANC Visit Recording.
class VisitAiAssistant extends ConsumerStatefulWidget {
  final String patientId;

  const VisitAiAssistant({super.key, required this.patientId});

  @override
  ConsumerState<VisitAiAssistant> createState() => _VisitAiAssistantState();
}

class _VisitAiAssistantState extends ConsumerState<VisitAiAssistant>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final briefingAsync =
        ref.watch(patientClinicalBriefingProvider(widget.patientId));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header — always visible
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome,
                        size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✨ AI Pre-Visit Briefing',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          briefingAsync.isLoading
                              ? 'Generating briefing…'
                              : briefingAsync.hasError
                                  ? 'AI unavailable — tap to try again'
                                  : _isExpanded
                                      ? 'Tap to collapse'
                                      : 'Tap to view AI insights',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (briefingAsync.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  else
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.expand_more, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: briefingAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => _ErrorContent(
                onRetry: () => ref.invalidate(
                    patientClinicalBriefingProvider(widget.patientId)),
              ),
              data: (briefing) => _BriefingContent(briefing: briefing),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Briefing content ─────────────────────────────────────────────────────────

class _BriefingContent extends StatelessWidget {
  final ClinicalBriefing briefing;
  const _BriefingContent({required this.briefing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24, height: 8),
          const SizedBox(height: 8),

          if (briefing.alertsAndWarnings.isNotEmpty) ...[
            _Section(
              icon: Icons.warning_amber_rounded,
              title: 'Alerts',
              iconColor: const Color(0xFFFFB74D),
              items: briefing.alertsAndWarnings,
            ),
            const SizedBox(height: 12),
          ],

          if (briefing.overdueScreenings.isNotEmpty) ...[
            _Section(
              icon: Icons.science_outlined,
              title: 'Overdue Screenings',
              iconColor: const Color(0xFF80CBC4),
              items: briefing.overdueScreenings,
            ),
            const SizedBox(height: 12),
          ],

          if (briefing.suggestedQuestions.isNotEmpty) ...[
            _Section(
              icon: Icons.help_outline,
              title: 'Suggested Questions',
              iconColor: const Color(0xFFCE93D8),
              items: briefing.suggestedQuestions,
            ),
          ],

          if (briefing.visitSummaryTemplate.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Note Starter',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    briefing.visitSummaryTemplate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.auto_awesome,
                  size: 10, color: Colors.white.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text(
                'Powered by Gemini',
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final List<String> items;

  const _Section({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 13)),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorContent({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.white60, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'AI briefing unavailable. Check connection.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text('Retry', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
