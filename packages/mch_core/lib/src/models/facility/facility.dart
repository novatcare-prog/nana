class Facility {
  final String id;
  final String name; // In Dart, we keep it simple as 'name'
  final String kmhflCode;
  final String? county; // Added based on your repo usage
  final String? subCounty; // Added common field

  Facility({
    required this.id,
    required this.name,
    required this.kmhflCode,
    this.county,
    this.subCounty,
  });

  // 1. READING FROM DB (The Translator)
  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'] as String,
      
      // ✅ CRITICAL FIX: 
      // Look for 'facility_name' from DB, map it to 'name' in App.
      // We use '??' to provide a fallback if the DB returns null.
      name: (json['facility_name'] ?? json['name'] ?? '') as String,
      
      kmhflCode: json['kmhfl_code'] as String? ?? '',
      county: json['county'] as String?,
      subCounty: json['sub_county'] as String?,
    );
  }

  // 2. WRITING TO DB (The Translator)
  // Used in createFacility and updateFacility
  Map<String, dynamic> toJson() {
    return {
      // We don't usually send ID for inserts (Supabase generates it), 
      // but we might need it for updates.
      'id': id, 
      
      // ✅ CRITICAL FIX:
      // specificy the exact column name Supabase expects
      'facility_name': name, 
      
      'kmhfl_code': kmhflCode,
      'county': county,
      'sub_county': subCounty,
    };
  }
}