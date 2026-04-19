import 'package:flutter/widgets.dart';

import 'app/avenue_app.dart';
import 'core/supabase/supabase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseBootstrap = await SupabaseBootstrap.initialize();

  runApp(AvenueApp(supabaseBootstrap: supabaseBootstrap));
}
