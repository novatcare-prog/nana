import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/report_providers.dart';
import '../../domain/report_models.dart';
import '../../services/pdf_export_service.dart';
import '../../services/csv_export_service.dart';
import '../widgets/export_button.dart';

/// ANC Coverage Report Screen
/// Shows antenatal care coverage statistics with visual charts
class AncCoverageReportScreen extends ConsumerStatefulWidget {
  const AncCoverageReportScreen({super.key});

  @override
  ConsumerState<AncCoverageReportScreen> createState() => _AncCoverageReportScreenState();
}

class _AncCoverageReportScreenState extends ConsumerState<AncCoverageReportScreen> {
  bool _isExporting = false;
  AncCoverageStats? _currentStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(ancCoverageStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ANC Coverage'),
        actions: [
          ExportButton(
            isLoading: _isExporting,
            onExportPdf: _currentStats != null ? _exportPdf : null,
            onExportCsv: _currentStats != null ? _exportCsv : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(ancCoverageStatsProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) {
          _currentStats = stats;
          return _buildContent(theme, stats);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading statistics', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(ancCoverageStatsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    if (_currentStats == null) return;
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await PdfExportService.generateAncCoverageReport(
        stats: _currentStats!,
        facilityName: 'MCH Facility',
      );
      await PdfExportService.sharePdf(pdfBytes, 'anc_coverage_report');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportCsv() async {
    if (_currentStats == null) return;
    setState(() => _isExporting = true);
    try {
      final filePath = await CsvExportService.exportAncCoverageStats(
        stats: _currentStats!,
        facilityName: 'MCH Facility',
      );
      await CsvExportService.shareFile(filePath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Widget _buildContent(ThemeData theme, AncCoverageStats stats) {
    const targetPercent = 80.0; // MOH target

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme, stats),
          const SizedBox(height: 24),

          // Target indicator
          _buildTargetCard(theme, targetPercent),
          const SizedBox(height: 24),

          // Visit breakdown
          Text(
            'Visit Coverage',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildVisitBar(theme, '1st ANC Visit', stats.firstVisitCount, 
              stats.totalActivePatients, Colors.green, targetPercent),
          _buildVisitBar(theme, '2nd ANC Visit', stats.secondVisitCount,
              stats.totalActivePatients, Colors.blue, targetPercent),
          _buildVisitBar(theme, '3rd ANC Visit', stats.thirdVisitCount,
              stats.totalActivePatients, Colors.orange, targetPercent),
          _buildVisitBar(theme, '4th+ ANC Visit', stats.fourthPlusVisitCount,
              stats.totalActivePatients, Colors.purple, targetPercent),
          
          const SizedBox(height: 24),

          // Insights
          _buildInsightsCard(theme, stats, targetPercent),
          
          const SizedBox(height: 24),

          // Legend
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AncCoverageStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.pregnant_woman, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ANC Coverage Report',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stats.totalActivePatients} active patients tracked',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard(ThemeData theme, double targetPercent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.flag, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'MOH Target: ${targetPercent.toStringAsFixed(0)}% coverage per visit',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitBar(ThemeData theme, String label, int count, 
      int total, Color color, double target) {
    final percent = total > 0 ? (count / total * 100) : 0.0;
    final meetsTarget = percent >= target;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(label, style: theme.textTheme.bodyMedium),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$count / $total',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: meetsTarget ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          meetsTarget ? Icons.check_circle : Icons.warning,
                          size: 14,
                          color: meetsTarget ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${percent.toStringAsFixed(1)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: meetsTarget ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Background
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Progress
              FractionallySizedBox(
                widthFactor: (percent / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              // Target line
              Positioned(
                left: (target / 100) * (MediaQuery.of(theme as dynamic).size.width - 32) * 0.8,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(ThemeData theme, AncCoverageStats stats, double targetPercent) {
    final insights = <String>[];
    
    final firstPercent = stats.coveragePercentage(1);
    final fourthPercent = stats.coveragePercentage(4);
    
    if (firstPercent >= targetPercent) {
      insights.add('✓ 1st visit coverage meets target');
    } else {
      insights.add('⚠ 1st visit coverage below target (${(targetPercent - firstPercent).toStringAsFixed(1)}% gap)');
    }
    
    if (fourthPercent < 50) {
      insights.add('⚠ Low 4th visit completion rate - consider reminder system');
    }
    
    final dropoff = firstPercent - fourthPercent;
    if (dropoff > 30) {
      insights.add('📉 Significant dropoff (${dropoff.toStringAsFixed(0)}%) between 1st and 4th visit');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Insights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(insight, style: theme.textTheme.bodyMedium),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ANC Coverage',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'WHO recommends at least 4 ANC visits during pregnancy. '
            'The MOH target is 80% coverage for each visit level. '
            'The dark vertical line on each bar indicates the target.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
