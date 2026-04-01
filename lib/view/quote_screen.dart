import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/quote-model.dart';
import '../service/quote_service.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  QuoteModel? quote;
  bool isLoading = true;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    loadQuote();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> loadQuote() async {
    setState(() => isLoading = true);
    _animController.reset();

    final data = await QuoteService.fetchQuote();

    setState(() {
      quote = data;
      isLoading = false;
    });
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xED1B1B1B),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DAILY",
                        style: GoogleFonts.georama(
                          fontSize: 11,
                          letterSpacing: 4,
                          color: Colors.white.withOpacity(0.35),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Quotes",
                        style: GoogleFonts.georama(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFE8B86D).withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "✦",
                        style: GoogleFonts.georama(
                          color: Color(0xFFE8B86D),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 0),
                child: Row(
                  children: [
                    Container(width: 36, height: 1.5, color: Color(0xFFE8B86D)),
                    SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 1.5,
                      color: Color(0xFFE8B86D).withOpacity(0.3),
                    ),
                  ],
                ),
              ),


              Expanded(
                child: Center(
                  child: isLoading
                      ? _buildLoader()
                      : quote == null
                      ? _buildError()
                      : _buildQuote(),
                ),
              ),


              if (!isLoading) _AnimatedButton(onTap: loadQuote),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        color: Color(0xFFE8B86D),
      ),
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wifi_off_rounded,
          color: Colors.white.withOpacity(0.2),
          size: 40,
        ),
        SizedBox(height: 16),
        Text(
          "Couldn't load a quote",
          style: GoogleFonts.georama(
            color: Colors.white.withOpacity(0.4),

            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildQuote() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "\u201C",
              style: GoogleFonts.georama(
                fontSize: 96,
                height: 0.85,
                color: Color(0xFFE8B86D).withOpacity(0.18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),


            Text(
              '"${quote!.q}"',
              style: GoogleFonts.georama(
                fontSize: 22,
                height: 1.65,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 32),

            Row(
              children: [
                Container(width: 20, height: 1, color: Color(0xFFE8B86D)),
                SizedBox(width: 10),
                Text(
                  '"${quote!.a}"',
                  style: GoogleFonts.georama(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFE8B86D).withOpacity(0.85),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  _AnimatedButton({required this.onTap});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Color(0xFFE8B86D).withOpacity(0.5),
              width: 1,
            ),
            color: Color(0xFFE8B86D).withOpacity(0.07),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New Quote",
                style: GoogleFonts.georama(
                  fontSize: 15,
                  letterSpacing: 1.2,
                  color: Color(0xFFE8B86D),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: Color(0xFFE8B86D).withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
