import 'package:flutter/widgets.dart';

import 'app/avenue_app.dart';
import 'core/notifications/resident_notifications_controller.dart';
import 'core/push/push_notification_service.dart';
import 'core/supabase/supabase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseBootstrap = await SupabaseBootstrap.initialize();

  if (supabaseBootstrap.isReady) {
    ResidentNotificationsController.instance;
    await PushNotificationService.instance.initialize();
  }

  runApp(AvenueApp(supabaseBootstrap: supabaseBootstrap));
}
