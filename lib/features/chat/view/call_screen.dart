import 'dart:async';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String name;
  final String image;
  final bool isVideo;

  const CallScreen({
    super.key,
    required this.name,
    required this.image,
    this.isVideo = false,
  });

  static void startCall(
    BuildContext context, {
    required String name,
    required String image,
    bool isVideo = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallScreen(
          name: name,
          image: image,
          isVideo: isVideo,
        ),
      ),
    );
  }

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isVideoOn = true;
  bool _isFrontCamera = true;
  bool _isConnected = false;
  int _callDurationSeconds = 0;
  Timer? _timer;
  Timer? _connectTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _isVideoOn = widget.isVideo;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate connecting call after 2 seconds
    _connectTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDurationSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _connectTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildAvatar(double size) {
    final image = widget.image;
    final name = widget.name;

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: const Color(0xFFFFDDEB),
        child: ClipOval(
          child: Image.network(
            image,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: const Color(0xFFD41470),
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: const Color(0xFFFFDDEB),
      child: ClipOval(
        child: Image.asset(
          image,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: const Color(0xFFD41470),
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.4,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1017),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Video Preview (for Video Call) or Dark Gradient Background
            if (widget.isVideo && _isVideoOn)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2C1320), Color(0xFF12080D)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAvatar(140),
                        const SizedBox(height: 20),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF381525), Color(0xFF12080D)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFF3B70).withValues(alpha: 0.15),
                          ),
                          child: _buildAvatar(130),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isConnected
                            ? _formatDuration(_callDurationSeconds)
                            : (widget.isVideo ? 'Calling Video...' : 'Ringing...'),
                        style: TextStyle(
                          color: _isConnected
                              ? Colors.greenAccent
                              : const Color(0xFFFFB3C6),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),

            // Top Header Overlay for Video Call
            if (widget.isVideo)
              Positioned(
                top: 16,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isConnected ? Colors.green : Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isConnected
                                ? _formatDuration(_callDurationSeconds)
                                : 'Connecting...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cameraswitch_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFrontCamera = !_isFrontCamera;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isFrontCamera
                                  ? 'Switched to front camera'
                                  : 'Switched to back camera',
                            ),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Self Video PIP (Picture-in-Picture) box for Video Call
            if (widget.isVideo && _isVideoOn)
              Positioned(
                top: 80,
                right: 20,
                child: Container(
                  width: 90,
                  height: 125,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 40,
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom Call Action Controls Bar
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mute Button
                      _buildControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: _isMuted ? 'Muted' : 'Mute',
                        isActive: _isMuted,
                        onTap: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                      ),

                      // Video Toggle Button (for Video Calls)
                      if (widget.isVideo)
                        _buildControlButton(
                          icon: _isVideoOn
                              ? Icons.videocam
                              : Icons.videocam_off,
                          label: _isVideoOn ? 'Video On' : 'Video Off',
                          isActive: !_isVideoOn,
                          onTap: () {
                            setState(() {
                              _isVideoOn = !_isVideoOn;
                            });
                          },
                        ),

                      // Speaker Button
                      _buildControlButton(
                        icon: _isSpeakerOn
                            ? Icons.volume_up
                            : Icons.volume_down,
                        label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
                        isActive: _isSpeakerOn,
                        onTap: () {
                          setState(() {
                            _isSpeakerOn = !_isSpeakerOn;
                          });
                        },
                      ),

                      // End Call Button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Call with ${widget.name} ended'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent,
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'End',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black87 : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
