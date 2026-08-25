import 'dart:async';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSend;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onMicTap;
  final VoidCallback? onEmojiTap;

  const ChatInput({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onSend,
    this.onChanged,
    this.onAttachmentTap,
    this.onCameraTap,
    this.onMicTap,
    this.onEmojiTap,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _hasText = false;
  late FocusNode _effectiveFocusNode;

  bool _isRecordingVoice = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _hasText = widget.controller.text.trim().isNotEmpty;
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    widget.controller.removeListener(_handleTextChange);
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    }
    super.dispose();
  }

  void _startVoiceRecording() {
    setState(() {
      _isRecordingVoice = true;
      _recordingSeconds = 0;
    });
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecordingVoice) {
        setState(() {
          _recordingSeconds++;
        });
      }
    });
  }

  void _cancelVoiceRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecordingVoice = false;
      _recordingSeconds = 0;
    });
  }

  void _sendVoiceRecording() {
    final secs = _recordingSeconds > 0 ? _recordingSeconds : 3;
    final minutes = (secs ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');
    _cancelVoiceRecording();
    widget.controller.text = '🎙️ Voice Message ($minutes:$seconds)';
    widget.onSend();
  }

  void _showEventModal(BuildContext context) {
    final TextEditingController eventNameController =
        TextEditingController(text: 'Coffee & Chat Date');
    final TextEditingController eventLocationController =
        TextEditingController(text: 'Olive Bistro, Jubilee Hills');
    DateTime selectedDate = DateTime.now().add(const Duration(days: 2));
    TimeOfDay selectedTime = const TimeOfDay(hour: 18, minute: 30);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final dateStr =
                '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}';
            final timeStr = selectedTime.format(context);

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD41470).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.event_available_rounded,
                          color: Color(0xFFD41470),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Create & Share Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Event Name
                  const Text(
                    'Event Name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Coffee Date, Movie Night',
                      prefixIcon: const Icon(Icons.event, color: Color(0xFFD41470), size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date & Time Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined,
                                        color: Color(0xFFD41470), size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dateStr,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    selectedTime = picked;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: Color(0xFFD41470), size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        timeStr,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                  ),
                  const SizedBox(height: 16),

                  // Location
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: eventLocationController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Olive Bistro, Jubilee Hills',
                      prefixIcon: const Icon(Icons.location_on_outlined,
                          color: Color(0xFFD41470), size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Send Event Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
                      label: const Text(
                        'Send Event Invitation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD41470),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        final title = eventNameController.text.trim().isEmpty
                            ? 'Event'
                            : eventNameController.text.trim();
                        final loc = eventLocationController.text.trim().isEmpty
                            ? 'Selected Location'
                            : eventLocationController.text.trim();

                        Navigator.pop(ctx);
                        widget.controller.text =
                            '📅 Event: $title\n🗓️ Date: $dateStr\n⏰ Time: $timeStr\n📍 Location: $loc';
                        widget.onSend();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[(month - 1) % 12];
  }

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded, color: Colors.green, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Location Sharing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Option 1: Share Live Location
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.my_location_rounded, color: Colors.green, size: 22),
                  ),
                  title: const Text(
                    'Share Live Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: const Text(
                    'Share real-time location updates for a set duration',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showLiveLocationDurationPicker(context);
                  },
                ),
                const Divider(height: 1),

                // Option 2: Send Your Current Location
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on_rounded, color: Colors.blue, size: 22),
                  ),
                  title: const Text(
                    'Send Your Current Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: const Text(
                    'Send your exact current GPS coordinates',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.controller.text =
                        '📍 Current Location: Jubilee Hills, Hyderabad (3.2 km away)';
                    widget.onSend();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLiveLocationDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Live Location Duration',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.timer_outlined, color: Color(0xFFD41470)),
                  title: const Text('15 Minutes'),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.controller.text =
                        '📡 Live Location: Sharing real-time location for 15 minutes';
                    widget.onSend();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timer_outlined, color: Color(0xFFD41470)),
                  title: const Text('1 Hour'),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.controller.text =
                        '📡 Live Location: Sharing real-time location for 1 hour';
                    widget.onSend();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timer_outlined, color: Color(0xFFD41470)),
                  title: const Text('8 Hours'),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.controller.text =
                        '📡 Live Location: Sharing real-time location for 8 hours';
                    widget.onSend();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDocumentPickerModal(BuildContext context) {
    final docs = [
      {'name': 'Project_Proposal_2026.pdf', 'size': '1.4 MB', 'icon': Icons.picture_as_pdf, 'color': Colors.red},
      {'name': 'Heartiqo_Design_Specs.pdf', 'size': '3.8 MB', 'icon': Icons.picture_as_pdf, 'color': Colors.red},
      {'name': 'Financial_Summary.xlsx', 'size': '850 KB', 'icon': Icons.table_chart, 'color': Colors.green},
      {'name': 'Meeting_Minutes.docx', 'size': '420 KB', 'icon': Icons.description, 'color': Colors.blue},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Document',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...docs.map((doc) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (doc['color'] as Color).withValues(alpha: 0.12),
                        child: Icon(doc['icon'] as IconData, color: doc['color'] as Color),
                      ),
                      title: Text(doc['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(doc['size'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      onTap: () {
                        Navigator.pop(ctx);
                        widget.controller.text = '📄 ${doc['name']} (${doc['size']})';
                        widget.onSend();
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGalleryPickerModal(BuildContext context) {
    final photos = [
      {'title': 'Sunset Skyline', 'icon': Icons.wb_sunny_outlined, 'color': Colors.orange},
      {'title': 'Beach Vacation', 'icon': Icons.beach_access, 'color': Colors.blue},
      {'title': 'Coffee & Bakery', 'icon': Icons.local_cafe_outlined, 'color': Colors.brown},
      {'title': 'Concert Night', 'icon': Icons.music_note, 'color': Colors.purple},
      {'title': 'Mountain Trek', 'icon': Icons.landscape, 'color': Colors.green},
      {'title': 'City Lights', 'icon': Icons.location_city, 'color': Colors.teal},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Photo from Gallery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final item = photos[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        widget.controller.text = '🖼️ Photo: ${item['title']}';
                        widget.onSend();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (item['color'] as Color).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              item['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAudioPickerModal(BuildContext context) {
    final tracks = [
      {'title': 'Voice_Memo_0824.m4a', 'duration': '0:45', 'size': '520 KB'},
      {'title': 'Chill_Acoustic_Melody.mp3', 'duration': '3:12', 'size': '3.2 MB'},
      {'title': 'Podcast_Episode_12.mp3', 'duration': '14:30', 'size': '12.8 MB'},
      {'title': 'Instrumental_Track.wav', 'duration': '2:15', 'size': '4.1 MB'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Audio File',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...tracks.map((track) => ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFFFF0F5),
                        child: Icon(Icons.audiotrack, color: Color(0xFFD41470)),
                      ),
                      title: Text(track['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('${track['duration']} • ${track['size']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      onTap: () {
                        Navigator.pop(ctx);
                        widget.controller.text = '🎵 Audio: ${track['title']} (${track['duration']})';
                        widget.onSend();
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactPickerModal(BuildContext context) {
    final contacts = [
      {'name': 'Sarah Smith', 'phone': '+1 (555) 0199', 'avatar': 'S'},
      {'name': 'Alex Smith', 'phone': '+1 (555) 0142', 'avatar': 'A'},
      {'name': 'Emily Watson', 'phone': '+1 (555) 0188', 'avatar': 'E'},
      {'name': 'Michael Jordan', 'phone': '+1 (555) 0177', 'avatar': 'M'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Share Contact Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...contacts.map((c) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(c['avatar']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ),
                      title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(c['phone']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      trailing: const Icon(Icons.send_rounded, size: 18, color: Colors.blue),
                      onTap: () {
                        Navigator.pop(ctx);
                        widget.controller.text = '👤 Contact: ${c['name']} (${c['phone']})';
                        widget.onSend();
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPollModal(BuildContext context) {
    final qController = TextEditingController(text: 'Weekend plan ideas?');
    final opt1Controller = TextEditingController(text: 'Coffee & Chat');
    final opt2Controller = TextEditingController(text: 'Movie Night');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.poll_outlined, color: Colors.teal, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Create a Poll',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Question', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: qController,
                decoration: InputDecoration(
                  hintText: 'Ask a question...',
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Options', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: opt1Controller,
                decoration: InputDecoration(
                  hintText: 'Option 1',
                  prefixIcon: const Icon(Icons.looks_one_outlined, size: 20, color: Colors.teal),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: opt2Controller,
                decoration: InputDecoration(
                  hintText: 'Option 2',
                  prefixIcon: const Icon(Icons.looks_two_outlined, size: 20, color: Colors.teal),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final q = qController.text.trim().isEmpty ? 'Poll' : qController.text.trim();
                    final o1 = opt1Controller.text.trim().isEmpty ? 'Option 1' : opt1Controller.text.trim();
                    final o2 = opt2Controller.text.trim().isEmpty ? 'Option 2' : opt2Controller.text.trim();
                    Navigator.pop(ctx);
                    widget.controller.text = '📊 Poll: $q\n1. $o1\n2. $o2';
                    widget.onSend();
                  },
                  child: const Text('Create & Send Poll', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCameraModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_off_rounded, color: Colors.white, size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade800, width: 1),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.camera_rounded,
                        size: 80,
                        color: Colors.grey.shade800,
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(radius: 4, backgroundColor: Colors.red),
                              SizedBox(width: 6),
                              Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 20,
                        child: Text(
                          'Tap shutter to capture photo',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showGalleryPickerModal(context);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.controller.text = '📷 Photo Attachment';
                      widget.onSend();
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD41470),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch_outlined, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    if (widget.onAttachmentTap != null) {
      widget.onAttachmentTap!();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOption(ctx, Icons.insert_drive_file_outlined, 'Document', Colors.indigo, () {
                      _showDocumentPickerModal(context);
                    }),
                    _buildOption(ctx, Icons.event_outlined, 'Event', const Color(0xFFD41470), () {
                      _showEventModal(context);
                    }),
                    _buildOption(ctx, Icons.photo_library_outlined, 'Gallery', Colors.purple, () {
                      _showGalleryPickerModal(context);
                    }),
                    _buildOption(ctx, Icons.headset_outlined, 'Audio', Colors.orange, () {
                      _showAudioPickerModal(context);
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOption(ctx, Icons.location_on_outlined, 'Location', Colors.green, () {
                      _showLocationModal(context);
                    }),
                    _buildOption(ctx, Icons.person_outline, 'Contact', Colors.blue, () {
                      _showContactPickerModal(context);
                    }),
                    _buildOption(ctx, Icons.poll_outlined, 'Poll', Colors.teal, () {
                      _showPollModal(context);
                    }),
                    _buildOption(ctx, Icons.mic_none_outlined, 'Voice Note', Colors.deepOrange, () {
                      _startVoiceRecording();
                    }),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, Color color, VoidCallback onTapAction) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTapAction();
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EmojiPickerSheet(
        controller: widget.controller,
        focusNode: _effectiveFocusNode,
        onChanged: widget.onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecordingVoice) {
      final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 26),
                onPressed: _cancelVoiceRecording,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$minutes:$seconds',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Recording audio...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendVoiceRecording,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF3D99),
                        Color(0xFFC40072),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.pink.shade100,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Color(0xFFD41470),
                        size: 22,
                      ),
                      onPressed: () {
                        if (widget.onEmojiTap != null) {
                          widget.onEmojiTap!();
                        } else {
                          _showEmojiPicker(context);
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _effectiveFocusNode,
                        onChanged: widget.onChanged,
                        maxLines: 4,
                        minLines: 1,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Transform.rotate(
                        angle: -0.6,
                        child: const Icon(
                          Icons.attach_file_rounded,
                          color: Color(0xFFD41470),
                          size: 22,
                        ),
                      ),
                      onPressed: () => _showAttachmentSheet(context),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFFD41470),
                        size: 22,
                      ),
                      onPressed: () {
                        if (widget.onCameraTap != null) {
                          widget.onCameraTap!();
                        } else {
                          _showCameraModal(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                if (_hasText) {
                  widget.onSend();
                } else if (widget.onMicTap != null) {
                  widget.onMicTap!();
                } else {
                  _startVoiceRecording();
                }
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF3D99),
                      Color(0xFFC40072),
                    ],
                  ),
                ),
                child: Icon(
                  _hasText ? Icons.send : Icons.mic,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiPickerSheet extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const _EmojiPickerSheet({
    required this.controller,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<_EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<_EmojiPickerSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'Recent Emoji',
      'icon': Icons.access_time_rounded,
      'emojis': ['❤️', '😊', '😂', '👍', '🔥', '🎉', '🥳', '🙏', '💯', '✨', '😍', '💖', '😎', '👏', '🙌', '😭'],
    },
    {
      'title': 'Smileys & Emotions',
      'icon': Icons.sentiment_satisfied_alt_rounded,
      'emojis': [
        '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂',
        '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍', '🤩',
        '😘', '😗', '😚', '😙', '😋', '😛', '😜', '🤪',
        '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🤐', '🤨',
        '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥',
        '😌', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕',
        '🤢', '🤮', '🤧', '🥵', '🥶', '🥴', '😵', '🤯',
        '🤠', '🥳', '😎', '🤓', '🧐', '😕', '😟', '🙁',
        '😮', '😯', '😲', '😳', '🥺', '😦', '😧', '😨',
        '😰', '😥', '😢', '😭', '😱', '😖', '😣', '😞',
        '😓', '😩', '😫', '🥱', '😤', '😡', '🤬', '😈',
        '👿', '💀', '☠️', '💩', '🤡', '👹', '👺', '👻',
        '👽', '👾', '🤖', '❤️', '🧡', '💛', '💚', '💙',
        '💜', '🖤', '🤍', '🤎', '💔', '❣️', '💕', '💞',
        '💓', '💗', '💖', '💘', '💝', '💟', '💋', '💯',
        '🔥', '✨', '🌟',
      ],
    },
    {
      'title': 'People',
      'icon': Icons.person_outline_rounded,
      'emojis': [
        '👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤏', '✌️',
        '🤞', '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕',
        '👇', '☝️', '👍', '👎', '✊', '👊', '🤛', '🤜',
        '👏', '🙌', '👐', '🤲', '🤝', '🙏', '✍️', '💅',
        '🤳', '💪', '🦵', '🦶', '👂', '🦻', '👃', '🧠',
        '🫀', '🫁', '🦷', '🦴', '👀', '👁️', '👅', '👄',
        '👶', '🧒', '👦', '👧', '🧑', '👨', '👩', '👱‍♀️',
        '👱‍♂️', '🧔', '👵', '👴', '👮‍♂️', '👮‍♀️', '🕵️‍♂️', '💂‍♂️',
        '👷‍♂️', '🤴', '👸', '👳‍♂️', '👰', '🤰', '👼', '🦸‍♂️',
        '🦹‍♂️', '🧙‍♂️', '🧚‍♂️', '🧛‍♂️', '🧜‍♂️', '🧝‍♂️', '💆‍♂️', '💇‍♂️',
        '🚶‍♂️', '🏃‍♂️', '💃', '🕺', '🏄‍♂️', '🏊‍♂️', '🚴‍♂️',
      ],
    },
    {
      'title': 'Nature & Animals',
      'icon': Icons.pets_rounded,
      'emojis': [
        '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
        '🐻‍❄️', '🐨', '🐯', '🦁', '🐮', '🐷', '🐽', '🐸',
        '🐵', '🙈', '🙉', '🙊', '🐒', '🐔', '🐧', '🐦',
        '🐤', '🐣', '🐥', '🦆', '🦅', '🦉', '🦇', '🐺',
        '🐗', '🐴', '🦄', '🐝', '🐛', '🦋', '🐌', '🐞',
        '🐜', '🦟', '🦗', '🕷️', '🦂', '🐢', '🐍', '🦎',
        '🦖', '🦕', '🐙', '🦑', '🦐', '🦞', '🦀', '🐡',
        '🐠', '🐟', '🐬', '🐳', '🐋', '🦈', '🦭', '🐊',
        '🐅', '🐆', '🦓', '🦍', '🦧', '🐘', '🦛', '🦏',
        '🐪', '🐫', '🦒', '🦘', '🦬', '🐃', '🐂', '🐄',
        '🐎', '🐖', '🐏', '🐑', '🦙', '🐐', '🦌', '🐕',
        '🐩', '🐈', '🐓', '🦃', '🦚', '🦜', '🦢', '🦩',
        '🕊️', '🐇', '🦝', '🦨', '🦡', '🦦', '🦥', '🦔',
        '🌵', '🎄', '🌲', '🌳', '🌴', '🌱', '🌿', '☘️',
        '🍀', '🎍', '🪴', '🎋', '🍃', '🍂', '🍁', '🍄',
        '🌾', '💐', '🌷', '🌹', '🥀', '🌺', '🌸', '🌼',
        '🌻', '🌞', '🌝', '🌛', '🌜', '🌚', '🌕', '🌖',
        '🌗', '🌘', '🌑', '🌒', '🌓', '🌔', '🌙', '🌎',
        '🌍', '🌏', '🪐', '💫', '⭐', '🌟', '✨', '⚡',
        '💥', '🔥', '🌈', '☀️', '🌤️', '⛅', '🌥️', '☁️',
        '🌦️', '🌧️', '⛈️', '🌩️', '❄️', '☃️', '⛄', '💧',
        '💦', '☔', '🌊',
      ],
    },
    {
      'title': 'Food & Drink',
      'icon': Icons.local_pizza_outlined,
      'emojis': [
        '🍏', '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇',
        '🍓', '🫐', '🍈', '🍒', '🍑', '🥭', '🍍', '🥥',
        '🥝', '🍅', '🍆', '🥑', '🥦', '🥬', '🥒', '🌶️',
        '🫑', '🌽', '🥕', '🫒', '🧄', '🧅', '🥔', '🍠',
        '🥐', '🥯', '🍞', '🥖', '🥨', '🧀', '🥚', '🍳',
        '🧈', '🥞', '🧇', '🥓', '🥩', '🍗', '🍖', '🦴',
        '🌭', '🍔', '🍟', '🍕', '🫓', '🥪', '🥙', '🧆',
        '🌮', '🌯', '🫔', '🥗', '🥘', '🫕', '🥫', '🍝',
        '🍜', '🍲', '🍛', '🍣', '🍱', '🥟', '🦪', '🍤',
        '🍙', '🍚', '🍘', '🍥', '🥠', '🥮', '🍢', '🍡',
        '🍧', '🍨', '🍦', '🥧', '🧁', '🍰', '🎂', '🍮',
        '🍭', '🍬', '🍫', '🍿', '🍩', '🍪', '🌰', '🥜',
        '🍯', '🥛', '☕', '🫖', '🍵', '🧃', '🥤', '🧋',
        '🍶', '🍺', '🍻', '🥂', '🍷', '🥃', '🍸', '🍹',
        '🍾', '🧊', '🥄', '🍴', '🍽️', '🥣', '🥡', '🥢',
      ],
    },
    {
      'title': 'Travel & Places',
      'icon': Icons.directions_car_outlined,
      'emojis': [
        '🚗', '🚕', '🚙', '🚌', '🏣', '🚎', '🏎️', '🚓',
        '🚑', '🚒', '🚐', '🛻', '🚚', '🚛', '🚜', '🛴',
        '🚲', '🛵', '🏍️', '🛺', '🚨', '🚔', '🚍', '🚘',
        '🚖', '🚃', '🚋', '🚝', '🚄', '🚅', '🚆', '🚇',
        '🚈', '🚉', '🚊', '🚞', '🚌', '🚏', '🛣️', '🛤️',
        '⛽', '🚥', '🚦', '🛑', '🚧', '⚓', '⛵', '🛶',
        '🚤', '🛳️', '⛴️', '🛥️', '🚢', '✈️', '🛩️', '🛫',
        '🛬', '🪂', '💺', '🚁', '🚀', '🛸', '🛎️', '🧳',
        '⌛', '⏳', '⌚', '⏰', '⏱️', '⏲️', '🕰️', '🌡️',
        '🏰', '🏯', '🏟️', '🗽', '🗼', '⛩️', '🕋', '🕌',
        '🕍', '🏙️', '🏞️', '🌅', '🌄', '🌉', '🌌',
      ],
    },
    {
      'title': 'Events & Activities',
      'icon': Icons.sports_soccer_outlined,
      'emojis': [
        '🎉', '🎊', '🎈', '🎂', '🎁', '🎗️', '🎟️', '🎫',
        '🎖️', '🏆', '🏅', '🥇', '🥈', '🥉', '⚽', '⚾',
        '🥎', '🏀', '🏐', '🏈', '🏉', '🎾', '🥏', '🎳',
        '🏏', '🏑', '🏒', '🥍', '🏓', '🏸', '🥊', '🥋',
        '<ctrl42>', '⛳', '⛸️', '🎣', '🤿', '🎽', '🎿', '🛷',
        '🥌', '🎯', '🪀', '🪁', '🎱', '🔮', '🪄', '🧿',
        '🎮', '🕹️', '🎰', '🎲', '🧩', '🧸', '🪅', '🪆',
        '♠️', '♥️', '♦️', '♣️', '♟️', '🃏', '🀄', '🎴',
        '🎭', '🖼️', '🎨', '🧵', '🪡', '🧶', '🎼', '🎵',
        '🎶', '🎙️', '🎤', '🎧', '📻', '🎷', '🪗', '🎸',
        '🎹', '🎺', '🎻', '🪕', '🥁', '🎬', '🏹',
      ],
    },
    {
      'title': 'Objects',
      'icon': Icons.lightbulb_outline_rounded,
      'emojis': [
        '💡', '🔦', '🏮', '🪔', '📔', '📕', '📖', '📗',
        '📘', '📙', '📚', '📓', '📒', '📃', '📜', '📄',
        '📰', '🗞️', '📑', '🔖', '🏷️', '💰', '🪙', '💴',
        '💵', '💶', '💷', '💸', '💳', '🧾', '✉️', '📧',
        '📨', '📩', '📤', '📥', '📦', '📫', '📪', '📬',
        '📭', '📮', '🗳️', '✏️', '✒️', '🖋️', '🖊️', '🖌️',
        '🖍️', '📝', '💼', '📁', '📂', '🗂️', '📅', '📆',
        '📇', '📈', '📉', '📊', '📋', '📌', '📍', '📎',
        '📏', '📐', '✂️', '🗃️', '🗄️', '🗑️', '🔒', '🔓',
        '🔏', '🔐', '🔑', '🗝️', '🔨', '🪓', '⛏️', '⚒️',
        '🛠️', '🗡️', '⚔️', '💣', '🛡️', '⚰️', '⚱️', '🏺',
        '🔮', '📿', '🧿', '💈', '🔬', '🔭', '🩺', '💊',
        '💉', '🩸', '🧬', '🦠', '🧫', '🧪', '🌡️', '🧹',
        '🧺', '🧻', '🚽', '🚰', '🛁', '🧼', '🪥', '🪒',
        '🧽', '🧴', '🗝️', '🚪', '🪑', '🛏️', '🛋️', '🛒',
        '👓', '🕶️', '🥽', '👑', '👒', '🎩', '🎓', '🧢',
        '💄', '💍', '💎',
      ],
    },
    {
      'title': 'Flags',
      'icon': Icons.flag_outlined,
      'emojis': [
        '🚩', '🏳️', '🏴', '🏴‍☠️', '🏁', '🏳️‍🌈', '🏳️‍⚧️', '🇺🇸',
        '🇬🇧', '🇮🇳', '🇨🇦', '🇦🇺', '🇩🇪', '🇫🇷', '🇮🇹', '🇪🇸',
        '🇯🇵', '🇰🇷', '🇨🇳', '🇧🇷', '🇲🇽', '🇷🇺', '🇿🇦', '🇦🇪',
        '🇸🇦', '🇸🇬', '🇳🇿', '🇨🇭', '🇳🇱', '🇸🇪', '🇳🇴', '🇩🇰',
        '🇫🇮', '🇵🇱', '🇦🇹', '🇧🇪', '🇮🇪', '🇵🇹', '🇬🇷', '🇹🇷',
        '🇪🇬', '🇮どもの', '🇲🇾', '🇹🇭', '🇻🇳', '🇵🇭', '🇵🇰', '🇧🇩',
        '🇦🇷', '🇨🇱', '🇨🇴', '🇵🇪', '🇺🇦',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onEmojiSelect(String emoji) {
    final currentText = widget.controller.text;
    final selection = widget.controller.selection;
    final start = selection.start >= 0 ? selection.start : currentText.length;
    final end = selection.end >= 0 ? selection.end : currentText.length;
    final newText = currentText.replaceRange(start, end, emoji);
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: start + emoji.length,
    );
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = _categories[_tabController.index];

    return SizedBox(
      height: 420,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    currentCategory['icon'] as IconData,
                    color: const Color(0xFFD41470),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentCategory['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: const Color(0xFFD41470),
                labelColor: const Color(0xFFD41470),
                unselectedLabelColor: Colors.grey.shade500,
                indicatorWeight: 2.5,
                tabAlignment: TabAlignment.start,
                tabs: _categories.map((cat) {
                  return Tab(
                    icon: Icon(cat['icon'] as IconData, size: 20),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((cat) {
                  final List<String> emojis = List<String>.from(cat['emojis']);
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: emojis.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final emoji = emojis[index];
                      return InkWell(
                        onTap: () => _onEmojiSelect(emoji),
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}