import '../services/base_api_service.dart';
import '../config/api_config.dart';

class NetworkDebugHelper {
  static final BaseApiService _apiService = BaseApiService();
  
  /// Test authentication headers and token state
  static Future<void> debugAuthHeaders() async {
    print('🔧 === Network Debug Helper ===');
    
    // 1. Check auth token state
    print('\n🔑 Auth Token State:');
    await _apiService.debugAuthState();
    
    // 2. Test health endpoint (no auth required)
    print('\n🏥 Health Check (No Auth Required):');
    try {
      final isHealthy = await _apiService.checkHealth();
      print('✅ Health check result: $isHealthy');
    } catch (e) {
      print('❌ Health check failed: $e');
    }
    
    // 3. Test a protected endpoint to see headers
    print('\n🔒 Testing Protected Endpoint Headers:');
    try {
      await _apiService.get(ApiConfig.doctorDashboardEndpoint);
      print('✅ Protected endpoint accessible');
    } catch (e) {
      print('❌ Protected endpoint failed: $e');
      print('Note: This might be expected if not authenticated yet');
    }
    
    print('\n🔧 === Debug Complete ===\n');
  }
  
  /// Test for rate limiting by making multiple quick requests
  static Future<void> testRateLimit() async {
    print('🚫 === Rate Limit Test ===');
    print('Making 5 quick requests to test rate limiting...');
    
    for (int i = 1; i <= 5; i++) {
      try {
        print('Request $i...');
        await _apiService.checkHealth();
        print('✅ Request $i succeeded');
        
        // Small delay to avoid overwhelming
        await Future.delayed(Duration(milliseconds: 100));
      } catch (e) {
        print('❌ Request $i failed: $e');
        if (e.toString().contains('429')) {
          print('🚫 Rate limit detected on request $i');
          break;
        }
      }
    }
    
    print('🚫 === Rate Limit Test Complete ===\n');
  }
  
  /// Compare headers between successful and failed requests
  static Future<void> compareRequestHeaders() async {
    print('📊 === Header Comparison ===');
    
    // This will show the exact headers being sent in the console
    print('Check the console output for request headers when making API calls.');
    print('Look for:');
    print('  📤 Headers: {Authorization: Bearer <token>, ...}');
    print('  🚫 Rate limit exceeded (429) - for 429 errors');
    print('  🔍 Request headers: {...} - detailed header info on errors');
    
    print('📊 === Header Comparison Complete ===\n');
  }
}
