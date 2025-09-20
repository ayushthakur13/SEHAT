import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoCallService {
  static final VideoCallService _instance = VideoCallService._internal();
  factory VideoCallService() => _instance;
  VideoCallService._internal();

  /// Join a video meeting with the given room code and user details
  Future<void> joinMeeting({
    required String roomCode,
    required String userName,
    String? userEmail,
    String? userAvatar,
    bool isAudioMuted = false,
    bool isVideoMuted = false,
  }) async {
    try {
      print('🎥 Joining video meeting: $roomCode');
      
      if (kIsWeb) {
        // For web platform, open Jitsi Meet in a new tab
        final url = _buildJitsiMeetUrl(roomCode, userName, isAudioMuted, isVideoMuted);
        await _launchUrl(url);
        print('✅ Opened video meeting in new tab: $url');
      } else {
        // For mobile platforms, use the Jitsi Meet SDK
        await _joinMobileMeeting(roomCode, userName, isAudioMuted, isVideoMuted);
        print('✅ Successfully joined video meeting');
      }
    } catch (e) {
      print('❌ Error joining video meeting: $e');
      rethrow;
    }
  }

  /// Build Jitsi Meet URL for web platform
  String _buildJitsiMeetUrl(String roomCode, String userName, bool isAudioMuted, bool isVideoMuted) {
    final baseUrl = 'https://meet.jit.si/$roomCode';
    final params = <String, String>{
      'userInfo.displayName': userName,
      'config.startWithAudioMuted': isAudioMuted.toString(),
      'config.startWithVideoMuted': isVideoMuted.toString(),
      'config.enableWelcomePage': 'false',
      'config.enableClosePage': 'true',
      'config.enableInsecureRoomNameWarning': 'false',
      'config.enableNoisyMicDetection': 'true',
      'config.enableLayerSuspension': 'true',
      'config.channelLastN': '-1',
      'config.startScreenSharing': 'false',
      'config.enableEmailInStats': 'false',
      'featureFlags.unsafe-room-warning.enabled': 'false',
      'featureFlags.welcomepage.enabled': 'false',
      'featureFlags.invite.enabled': 'false',
      'featureFlags.live-streaming.enabled': 'false',
      'featureFlags.recording.enabled': 'false',
      'featureFlags.tile-view.enabled': 'true',
      'featureFlags.meeting-password.enabled': 'false',
      'featureFlags.close-page.enabled': 'true',
    };
    
    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$baseUrl?$queryString';
  }

  /// Launch URL in new tab/window
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  /// Join meeting on mobile platforms (placeholder for future mobile implementation)
  Future<void> _joinMobileMeeting(String roomCode, String userName, bool isAudioMuted, bool isVideoMuted) async {
    // This would be implemented for mobile platforms using the Jitsi Meet SDK
    // For now, we'll just open the web version
    final url = _buildJitsiMeetUrl(roomCode, userName, isAudioMuted, isVideoMuted);
    await _launchUrl(url);
  }

  /// Leave the current meeting
  Future<void> leaveMeeting() async {
    try {
      if (kIsWeb) {
        // On web, we can't programmatically close the tab
        // The user needs to close the tab manually
        print('ℹ️ Please close the video call tab manually');
      } else {
        // For mobile platforms, this would use the Jitsi Meet SDK
        print('ℹ️ Video call will be handled by the Jitsi Meet app');
      }
    } catch (e) {
      print('❌ Error leaving video meeting: $e');
      rethrow;
    }
  }

  /// Generate a unique room code for the consultation
  String generateRoomCode(String doctorId, String patientId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'sehat-consult-$doctorId-$patientId-$timestamp';
  }

  /// Generate a room code for scheduled appointments
  String generateAppointmentRoomCode(String appointmentId) {
    return 'sehat-appointment-$appointmentId';
  }
}
