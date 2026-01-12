import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/facility_providers.dart';

/// A searchable facility selector widget with county filtering
/// Designed for 10,000+ facilities - uses server-side search
class SearchableFacilitySelector extends ConsumerStatefulWidget {
  final String? selectedFacilityId;
  final ValueChanged<Facility?> onSelected;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const SearchableFacilitySelector({
    super.key,
    this.selectedFacilityId,
    required this.onSelected,
    this.labelText = 'Health Facility',
    this.hintText = 'Type to search facilities...',
    this.validator,
    this.enabled = true,
  });

  @override
  ConsumerState<SearchableFacilitySelector> createState() =>
      _SearchableFacilitySelectorState();
}

class _SearchableFacilitySelectorState
    extends ConsumerState<SearchableFacilitySelector> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isExpanded = false;
  bool _isLoading = false;
  String _searchQuery = '';
  Facility? _selectedFacility;
  List<Facility> _searchResults = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    
    // Load initial facility if ID is provided
    if (widget.selectedFacilityId != null) {
      _loadInitialFacility();
    }
  }

  Future<void> _loadInitialFacility() async {
    try {
      final facilities = await ref.read(facilitiesProvider.future);
      final found = facilities.firstWhere(
        (f) => f.id == widget.selectedFacilityId,
        orElse: () => throw Exception('Not found'),
      );
      if (mounted) {
        setState(() {
          _selectedFacility = found;
          _searchController.text = found.name;
        });
      }
    } catch (e) {
      // Facility not found, ignore
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_isExpanded) {
      setState(() => _isExpanded = true);
      if (_searchQuery.isEmpty) {
        _searchFacilities(''); // Load some initial results
      }
    }
  }

  Future<void> _searchFacilities(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(facilityRepositoryProvider);
      List<Facility> results;
      
      if (query.isEmpty) {
        // Load first 50 facilities as default
        final allFacilities = await repository.getAllFacilities();
        results = allFacilities.take(50).toList();
      } else {
        // Search by query
        results = await repository.searchFacilities(query);
      }
      
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error searching: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _onFacilitySelected(Facility facility) {
    setState(() {
      _selectedFacility = facility;
      _searchController.text = facility.name;
      _isExpanded = false;
      _searchResults = [];
    });
    _focusNode.unfocus();
    widget.onSelected(facility);
  }

  void _clearSelection() {
    setState(() {
      _selectedFacility = null;
      _searchController.clear();
      _searchQuery = '';
      _searchResults = [];
    });
    widget.onSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Field
        TextFormField(
          controller: _searchController,
          focusNode: _focusNode,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.local_hospital),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSelection,
                  )
                : const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _isExpanded = true;
            });
            // Debounce search
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_searchQuery == value) {
                _searchFacilities(value);
              }
            });
          },
          onTap: () {
            setState(() => _isExpanded = true);
            if (_searchResults.isEmpty) {
              _searchFacilities('');
            }
          },
          validator: widget.validator,
        ),
        
        // Selected Facility Display
        if (_selectedFacility != null && !_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, 
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedFacility!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_selectedFacility!.county ?? ''} • ${_selectedFacility!.subCounty ?? ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    setState(() => _isExpanded = true);
                    _searchFacilities('');
                  },
                ),
              ],
            ),
          ),
        
        // Dropdown Panel
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          
          // Results Container
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _searchQuery.isEmpty 
                            ? 'Recent Facilities' 
                            : 'Search Results',
                        style: theme.textTheme.labelLarge,
                      ),
                      const Spacer(),
                      if (_isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      TextButton(
                        onPressed: () {
                          setState(() => _isExpanded = false);
                          _focusNode.unfocus();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                
                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                
                // Results List
                if (_errorMessage == null)
                  Flexible(
                    child: _isLoading && _searchResults.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : _searchResults.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: theme.colorScheme.outline,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? 'Start typing to search facilities'
                                          : 'No facilities found for "$_searchQuery"',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final facility = _searchResults[index];
                                  final isSelected = 
                                      facility.id == _selectedFacility?.id;
                                  
                                  return ListTile(
                                    dense: true,
                                    selected: isSelected,
                                    selectedTileColor: theme.colorScheme
                                        .primaryContainer.withOpacity(0.3),
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.surfaceVariant,
                                      child: Icon(
                                        Icons.local_hospital,
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white
                                            : theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    title: Text(
                                      facility.name,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${facility.county ?? 'Unknown'} • ${facility.subCounty ?? ''}',
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: isSelected
                                        ? Icon(Icons.check_circle,
                                            color: theme.colorScheme.primary,
                                            size: 20)
                                        : null,
                                    onTap: () => _onFacilitySelected(facility),
                                  );
                                },
                              ),
                  ),
                
                // Footer hint
                if (_searchResults.length >= 50)
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Showing first 50 results. Refine your search for more.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                // Can't find facility button
                const Divider(height: 1),
                InkWell(
                  onTap: () async {
                    // Import and show dialog
                    final result = await _showRequestDialog();
                    if (result == true) {
                      // Refresh the search
                      _searchFacilities(_searchQuery);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Can't find your facility? Request to add it",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<bool?> _showRequestDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => const _RequestFacilityDialog(),
    );
  }
}

/// Inline Request Facility Dialog
class _RequestFacilityDialog extends StatefulWidget {
  const _RequestFacilityDialog();

  @override
  State<_RequestFacilityDialog> createState() => _RequestFacilityDialogState();
}

class _RequestFacilityDialogState extends State<_RequestFacilityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _facilityNameController = TextEditingController();
  final _kmhflCodeController = TextEditingController();
  final _countyController = TextEditingController();
  final _subCountyController = TextEditingController();
  
  bool _isLoading = false;
  String? _selectedCounty;

  final List<String> _counties = [
    'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo-Marakwet',
    'Embu', 'Garissa', 'Homa Bay', 'Isiolo', 'Kajiado',
    'Kakamega', 'Kericho', 'Kiambu', 'Kilifi', 'Kirinyaga',
    'Kisii', 'Kisumu', 'Kitui', 'Kwale', 'Laikipia',
    'Lamu', 'Machakos', 'Makueni', 'Mandera', 'Marsabit',
    'Meru', 'Migori', 'Mombasa', 'Murang\'a', 'Nairobi',
    'Nakuru', 'Nandi', 'Narok', 'Nyamira', 'Nyandarua',
    'Nyeri', 'Samburu', 'Siaya', 'Taita-Taveta', 'Tana River',
    'Tharaka-Nithi', 'Trans Nzoia', 'Turkana', 'Uasin Gishu',
    'Vihiga', 'Wajir', 'West Pokot',
  ];

  @override
  void dispose() {
    _facilityNameController.dispose();
    _kmhflCodeController.dispose();
    _countyController.dispose();
    _subCountyController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      
      await supabase.from('facility_requests').insert({
        'facility_name': _facilityNameController.text.trim(),
        'kmhfl_code': _kmhflCodeController.text.trim().isEmpty 
            ? null 
            : _kmhflCodeController.text.trim(),
        'county': _selectedCounty,
        'sub_county': _subCountyController.text.trim().isEmpty 
            ? null 
            : _subCountyController.text.trim(),
        'requested_by': user?.id,
        'status': 'pending',
      });

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Request submitted! Admin will review it.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add_business, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Request Facility'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _facilityNameController,
                decoration: const InputDecoration(
                  labelText: 'Facility Name *',
                  hintText: 'e.g., Juja Modern Hospital',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kmhflCodeController,
                decoration: const InputDecoration(
                  labelText: 'KMHFL Code (if known)',
                  hintText: 'e.g., 12345',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'County *',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCounty,
                items: _counties.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c),
                )).toList(),
                onChanged: (v) => setState(() => _selectedCounty = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subCountyController,
                decoration: const InputDecoration(
                  labelText: 'Sub-County (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submitRequest,
          child: _isLoading 
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}

