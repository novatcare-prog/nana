import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/journal_provider.dart';
import '../../domain/models/journal_entry.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  final JournalEntry? entry; // If null, creating new entry

  const JournalEntryScreen({super.key, this.entry});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = [
    'My Feelings',
    'Symptoms',
    'Doctor Visit',
    'Baby Movement',
    'Milestone',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.entry?.content ?? '');
    _selectedDate = widget.entry?.date ?? DateTime.now();
    _selectedCategory = widget.entry?.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(journalControllerProvider.notifier);
    bool success;

    if (widget.entry != null) {
      // Update
      final updatedEntry = widget.entry!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        date: _selectedDate,
        category: _selectedCategory,
      );
      success = await controller.updateEntry(updatedEntry);
    } else {
      // Create
      success = await controller.addEntry(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        date: _selectedDate,
        category: _selectedCategory,
      );
    }

    if (success && mounted) {
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to save entry. Please try again.')),
      );
    }
  }

  Future<void> _deleteEntry() async {
    if (widget.entry == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(journalControllerProvider.notifier)
          .deleteEntry(widget.entry!.id);

      if (success && mounted) {
        context.pop();
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;
    final state = ref.watch(journalControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: isLoading ? null : _deleteEntry,
            ),
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            onPressed: isLoading ? null : _saveEntry,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date Picker Row
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.grey, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('MMM d, yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              initialValue: _categories.contains(_selectedCategory)
                  ? _selectedCategory
                  : null,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label_outline),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Baby kicked today!',
                border: OutlineInputBorder(),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Please enter a title' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Content
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Details',
                hintText: 'Write about your day...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Please write something' : null,
            ),
          ],
        ),
      ),
    );
  }
}
