import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/navigation/main_navigation_scaffold.dart';  // ← Changed this line
import 'core/providers/facility_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    const ProviderScope(
      child: MCHHealthWorkerApp(),
    ),
  );
}

class MCHHealthWorkerApp extends ConsumerWidget {
  const MCHHealthWorkerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-select first facility on app start
    ref.watch(autoSelectFacilityProvider);
    
    return MaterialApp(
      title: 'MCH Health Worker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigationScaffold(),  // ← Changed this line
    );
  }
}

// Supabase client accessor (getter instead of final for compile-time constant)
SupabaseClient get supabase => Supabase.instance.client;