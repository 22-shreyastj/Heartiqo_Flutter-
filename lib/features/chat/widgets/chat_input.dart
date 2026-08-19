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
    widget.controller.removeListener(_handleTextChange);
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    }
    super.dispose();
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
      builder: (context) {
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
                    _buildOption(context, Icons.insert_drive_file_outlined, 'Document', Colors.indigo, 'Document attached'),
                    _buildOption(context, Icons.camera_alt_outlined, 'Camera', const Color(0xFFD41470), 'Camera opened'),
                    _buildOption(context, Icons.photo_library_outlined, 'Gallery', Colors.purple, 'Gallery opened'),
                    _buildOption(context, Icons.headset_outlined, 'Audio', Colors.orange, 'Audio attached'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOption(context, Icons.location_on_outlined, 'Location', Colors.green, 'Location shared'),
                    _buildOption(context, Icons.person_outline, 'Contact', Colors.blue, 'Contact shared'),
                    _buildOption(context, Icons.poll_outlined, 'Poll', Colors.teal, 'Poll created'),
                    _buildOption(context, Icons.mic_none_outlined, 'Voice Note', Colors.deepOrange, 'Voice note recording...'),
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

  Widget _buildOption(BuildContext context, IconData icon, String label, Color color, String snackBarMsg) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackBarMsg)));
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.12),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xFFD41470),
                size: 26,
              ),
              onPressed: () => _showAttachmentSheet(context),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.pink.shade100,
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
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey.shade500,
                        size: 22,
                      ),
                      onPressed: widget.onCameraTap ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Camera opened')),
                            );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hold to record voice message')),
                  );
                }
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF3D99),
                      Color(0xFFC40072),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD41470).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
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