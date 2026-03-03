import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const NexaApp());
}

class NexaApp extends StatelessWidget {
  const NexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nexa',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090B13),
        fontFamily: 'Roboto',
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _showLogin = false;
  String? _username;

  void _goToLogin() => setState(() => _showLogin = true);

  void _enterChat(String name) => setState(() => _username = name.trim());

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offsetAnim = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(
          position: offsetAnim,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _username != null
          ? ChatScreen(key: const ValueKey('chat'), username: _username!)
          : _showLogin
              ? LoginScreen(
                  key: const ValueKey('login'),
                  onContinue: _enterChat,
                )
              : SplashScreen(
                  key: const ValueKey('splash'),
                  onStart: _goToLogin,
                ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onStart});

  final VoidCallback? onStart;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String _line1 = '';
  String _line2 = '';
  bool _showStart = false;

  final String _fullLine1 = 'نيكسا ليس مجرد عميل… بل هو المستقبل';
  final String _fullLine2 = 'مصنوع بفخر من طلاب عرب';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();
    _typewriter();
  }

  Future<void> _typewriter() async {
    for (int i = 1; i <= _fullLine1.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 55));
      if (!mounted) return;
      setState(() => _line1 = _fullLine1.substring(0, i));
    }

    await Future<void>.delayed(const Duration(milliseconds: 180));

    for (int i = 1; i <= _fullLine2.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 42));
      if (!mounted) return;
      setState(() => _line2 = _fullLine2.substring(0, i));
    }

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (mounted) setState(() => _showStart = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF070910), Color(0xFF281A52), Color(0xFF0E1F3D)],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Opacity(
                opacity: 0.16,
                child: CustomPaint(
                  painter: ParticlePainter(_controller.value),
                ),
              );
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'Nexa',
                      style: TextStyle(
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _line1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _line2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedOpacity(
                    opacity: _showStart ? 1 : 0,
                    duration: const Duration(milliseconds: 450),
                    child: _showStart
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9E6CFF),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 38,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 16,
                              shadowColor: const Color(0xFF9E6CFF),
                            ),
                            onPressed: () {
                              if (widget.onStart != null) {
                                widget.onStart!();
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const AppShell(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'ابدأ (Start)',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onContinue});

  final ValueChanged<String> onContinue;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF080A12), Color(0xFF131C2F)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'اكتب اسمك',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _continue(),
                    decoration: InputDecoration(
                      hintText: 'مثال: أحمد',
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.32),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C7BFF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('دخول'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _continue() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    widget.onContinue(name);
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.username});

  final String username;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _typing = false;
  bool _showCodePanel = false;
  String _codeSample = '';

  @override
  void initState() {
    super.initState();
    _messages.add(
      Message(
        text:
            'أهلًا يا ${widget.username} 👋\nأنا Nexa… مش مجرد AI.\nأنا شريكك في كل فكرة مجنونة 💡🔥',
        isBot: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add(Message(text: input, isBot: false));
      _controller.clear();
      _typing = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));

    final lower = input.toLowerCase();
    final isCodeIntent = lower.contains('code') ||
        lower.contains('كود') ||
        lower.contains('flutter') ||
        lower.contains('python') ||
        lower.contains('javascript');

    String response;
    if (lower.contains('bug') || lower.contains('خطأ')) {
      response = 'مممم… واضح إن في Bug مستخبي هنا 😏 خليني أطلعه.';
    } else if (isCodeIntent) {
      response = 'تمام… خليني أبنيها صح 👨‍💻\nفتحت لك وضع الكود على طول.';
      _codeSample = '''void main() {
  print('Hello from Nexa 🚀');
}
''';
      _showCodePanel = true;
    } else {
      response =
          'فهمت عليك ✅\nخلّينا نكمّلها خطوة بخطوة بشكل احترافي، وبنفس الوقت بسيط وواضح.';
    }

    setState(() {
      _typing = false;
      _messages.add(Message(text: response, isBot: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (_showCodePanel) ...[
                Expanded(
                  child: CodePanel(
                    code: _codeSample,
                    onClose: () => setState(() => _showCodePanel = false),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: _showCodePanel ? 2 : 1,
                child: _buildChatPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatPanel() {
    return Container(
      decoration: _glass(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9A63FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Nexa',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, index) {
                if (_typing && index == _messages.length) {
                  return const TypingIndicator();
                }
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    constraints: const BoxConstraints(maxWidth: 360),
                    decoration: BoxDecoration(
                      color: msg.isBot
                          ? Colors.white.withValues(alpha: 0.09)
                          : const Color(0xFF6E7EFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg.text, style: const TextStyle(height: 1.4)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.28),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B68FF),
                  ),
                  child: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _glass() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: Colors.white.withValues(alpha: 0.05),
      border: Border.all(color: Colors.white24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

class CodePanel extends StatelessWidget {
  const CodePanel({
    super.key,
    required this.code,
    required this.onClose,
  });

  final String code;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0E1425),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text('Code Preview', style: TextStyle(fontSize: 16)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Run'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied ✅')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Copy'),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                code,
                style: const TextStyle(
                  color: Color(0xFF97FFD4),
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  Message({required this.text, required this.isBot});

  final String text;
  final bool isBot;
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                return Row(
                  children: List.generate(3, (i) {
                    final phase = ((t + i * 0.18) % 1.0);
                    final scale = 0.6 + (phase < 0.5 ? phase : 1 - phase) * 0.9;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.scale(
                        scale: scale,
                        child: const Icon(Icons.circle, size: 8),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          const Text('Nexa يكتب...'),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFBFA2FF);
    for (int i = 0; i < 32; i++) {
      final dx = (size.width / 32) * i;
      final offsetY = (i.isEven ? 55 : 90) * (progress + 0.2);
      final dy = (size.height - (offsetY % size.height)).abs();
      canvas.drawCircle(Offset(dx, dy), 1.5 + (progress * 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
