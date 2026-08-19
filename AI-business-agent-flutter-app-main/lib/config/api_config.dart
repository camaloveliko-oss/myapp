/// External integration settings.
///
/// Replace the placeholder values at release time or pass them with
/// `--dart-define=BACKEND_URL=...` so secrets do not live in git.
class ApiConfig {
  // Node.js Backend URL
  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );
  
  static const baseUrl = String.fromEnvironment(
    'TOCHKA_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );
  static const aiApiKey = String.fromEnvironment('TOCHKA_AI_API_KEY');
  static const mapsProvider = '2gis';
  static const twoGisKey = String.fromEnvironment('TWOGIS_API_KEY');
  static const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'ai-agent-app-be146');
  static const firebaseWebApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
    defaultValue: '',
  );
  static const stripePublishableKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
  static const posApiBaseUrl = String.fromEnvironment('POS_API_BASE_URL');
  static const posApiKey = String.fromEnvironment('POS_API_KEY');

  static bool get hasAiKey => aiApiKey.isNotEmpty;
  static bool get hasPaymentsKey => stripePublishableKey.isNotEmpty;
}
