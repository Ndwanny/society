import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/models.dart';

class Club260MessagesScreen extends StatefulWidget {
  const Club260MessagesScreen({super.key});

  @override
  State<Club260MessagesScreen> createState() => _Club260MessagesScreenState();
}

class _Club260MessagesScreenState extends State<Club260MessagesScreen> {
  final _messageController = TextEditingController();
  UserModel? _selectedUser;
  bool _isRecording = false;
  List<MessageModel> _messages = [
    MessageModel(
      id: '1',
      senderId: 'other',
      senderName: 'Naledi Moyo',
      type: MessageType.text,
      text: 'Hey! Did you see the latest Code260 comic? 😭',
      sentAt: DateTime.now().subtract(const Duration(minutes: 12)),
      isMine: false,
    ),
    MessageModel(
      id: '2',
      senderId: 'me',
      senderName: 'Me',
      type: MessageType.text,
      text: 'Yes!! Sol\'s storyline is so powerful. The body image arc really hits different.',
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
      isMine: true,
    ),
    MessageModel(
      id: '3',
      senderId: 'other',
      senderName: 'Naledi Moyo',
      type: MessageType.text,
      text: 'Exactly. And Moni\'s advice in Issue 2 made me tear up a little 🥲',
      sentAt: DateTime.now().subtract(const Duration(minutes: 8)),
      isMine: false,
    ),
    MessageModel(
      id: '4',
      senderId: 'me',
      senderName: 'Me',
      type: MessageType.text,
      text: 'Same! "You\'re never alone in the big, beautiful sky of life" 💙',
      sentAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isMine: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    _selectedUser ??= UserModel.mockUsers[1];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.darkGray,
              border: Border(
                  bottom: BorderSide(color: AppColors.borderColor)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.white),
                  onPressed: () => context.go('/club260/feed'),
                ),
                const SizedBox(width: 8),
                Text(
                  'Messages',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                // Call icons
                IconButton(
                  icon: const Icon(Icons.call_outlined,
                      color: AppColors.textGray),
                  onPressed: () => _showCallDialog(context, false),
                  tooltip: 'Voice Call',
                ),
                IconButton(
                  icon: const Icon(Icons.videocam_outlined,
                      color: AppColors.textGray),
                  onPressed: () => _showCallDialog(context, true),
                  tooltip: 'Video Call',
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                // Conversations list
                if (isWide)
                  Container(
                    width: 280,
                    decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: AppColors.borderColor)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            style: GoogleFonts.poppins(
                                color: AppColors.white),
                            decoration: InputDecoration(
                              hintText: 'Search messages...',
                              hintStyle: GoogleFonts.poppins(
                                  color: AppColors.textMuted),
                              prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.textGray,
                                  size: 18),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: AppColors.cardBg,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: UserModel.mockUsers
                                .map((user) =>
                                    _ConversationTile(
                                      user: user,
                                      isSelected: _selectedUser?.id ==
                                          user.id,
                                      onTap: () => setState(
                                          () => _selectedUser = user),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Chat area
                Expanded(
                  child: Column(
                    children: [
                      // Chat header
                      if (_selectedUser != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.borderColor)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    AppColors.teal.withOpacity(0.2),
                                child: Text(
                                  _selectedUser!.displayName[0],
                                  style: GoogleFonts.poppins(
                                      color: AppColors.teal),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedUser!.displayName,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.success,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Online',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.textGray,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // Messages
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[
                                _messages.length - 1 - index];
                            return _MessageBubble(message: msg);
                          },
                        ),
                      ),

                      // Input area
                      _MessageInput(
                        controller: _messageController,
                        isRecording: _isRecording,
                        onSend: _sendMessage,
                        onRecord: _toggleRecording,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'me',
        senderName: 'Me',
        type: MessageType.text,
        text: text,
        sentAt: DateTime.now(),
        isMine: true,
      ));
      _messageController.clear();
    });
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (!_isRecording) {
      // Simulate sending voice note
      setState(() {
        _messages.add(MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          senderName: 'Me',
          type: MessageType.audio,
          audioDuration: const Duration(seconds: 12),
          sentAt: DateTime.now(),
          isMine: true,
        ));
      });
    }
  }

  void _showCallDialog(BuildContext context, bool isVideo) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.teal.withOpacity(0.2),
                child: Text(
                  _selectedUser?.displayName[0] ?? 'U',
                  style: GoogleFonts.poppins(
                    color: AppColors.teal,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _selectedUser?.displayName ?? 'User',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isVideo ? 'Video call starting...' : 'Calling...',
                style: GoogleFonts.poppins(color: AppColors.textGray),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'end_call',
                    onPressed: () => Navigator.pop(ctx),
                    backgroundColor: AppColors.error,
                    child: const Icon(Icons.call_end),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final UserModel user;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.teal.withOpacity(0.08),
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.teal.withOpacity(0.15),
            child: Text(
              user.displayName[0],
              style: GoogleFonts.poppins(color: AppColors.teal),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.black, width: 1.5),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        user.displayName,
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '@${user.username}',
        style: GoogleFonts.poppins(
          color: AppColors.textGray,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          left: message.isMine ? 60 : 0,
          right: message.isMine ? 0 : 60,
        ),
        child: Column(
          crossAxisAlignment: message.isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!message.isMine) ...[
              Text(
                message.senderName,
                style: GoogleFonts.poppins(
                  color: AppColors.teal,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMine
                    ? AppColors.teal
                    : AppColors.cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(
                      message.isMine ? 16 : 4),
                  bottomRight: Radius.circular(
                      message.isMine ? 4 : 16),
                ),
                border: message.isMine
                    ? null
                    : Border.all(color: AppColors.borderColor),
              ),
              child: message.type == MessageType.audio
                  ? _AudioMessage(isMine: message.isMine)
                  : Text(
                      message.text ?? '',
                      style: GoogleFonts.poppins(
                        color: message.isMine
                            ? AppColors.black
                            : AppColors.offWhite,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}',
              style: GoogleFonts.poppins(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioMessage extends StatelessWidget {
  final bool isMine;
  const _AudioMessage({required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_arrow,
          color: isMine ? AppColors.black : AppColors.teal,
          size: 20,
        ),
        const SizedBox(width: 8),
        Container(
          width: 120,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomPaint(
            painter: _WaveformPainter(
              color: isMine ? AppColors.black : AppColors.teal,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '0:12',
          style: GoogleFonts.poppins(
            color: isMine
                ? AppColors.black.withOpacity(0.7)
                : AppColors.textGray,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  _WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final heights = [
      0.3, 0.6, 0.9, 0.5, 0.8, 0.4, 1.0, 0.7, 0.5, 0.9,
      0.3, 0.6, 0.8, 0.4, 0.7, 0.5, 0.9, 0.3, 0.6, 0.8,
    ];
    final spacing = size.width / heights.length;

    for (int i = 0; i < heights.length; i++) {
      final x = i * spacing + spacing / 2;
      final h = size.height * heights[i];
      final y = (size.height - h) / 2;
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + h),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => old.color != color;
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isRecording;
  final Function(String) onSend;
  final VoidCallback onRecord;

  const _MessageInput({
    required this.controller,
    required this.isRecording,
    required this.onSend,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.textGray),
            onPressed: () {},
          ),
          Expanded(
            child: isRecording
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: AppColors.coral.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.coral,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recording...',
                          style: GoogleFonts.poppins(
                            color: AppColors.coral,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : TextField(
                    controller: controller,
                    style: GoogleFonts.poppins(
                      color: AppColors.offWhite,
                      fontSize: 14,
                    ),
                    onSubmitted: onSend,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: GoogleFonts.poppins(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: AppColors.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isRecording
                  ? AppColors.coral
                  : AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isRecording ? Icons.stop : Icons.mic_outlined,
                color: isRecording
                    ? AppColors.white
                    : AppColors.textGray,
              ),
              onPressed: onRecord,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send,
                  color: AppColors.black, size: 18),
              onPressed: () => onSend(controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
