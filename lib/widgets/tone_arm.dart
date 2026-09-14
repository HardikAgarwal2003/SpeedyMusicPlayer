import 'package:flutter/material.dart';

class ToneArm extends StatefulWidget {
  final bool isPlaying;

  const ToneArm({
    super.key,
    required this.isPlaying,
  });

  @override
  State<ToneArm> createState() => _ToneArmState();
}

class _ToneArmState extends State<ToneArm>
    with SingleTickerProviderStateMixin {
  late final AnimationController _armController;

  @override
  void initState() {
    super.initState();

    _armController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: widget.isPlaying ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant ToneArm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying) {
      _armController.forward();
    } else {
      _armController.reverse();
    }
  }

  @override
  void dispose() {
    _armController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 245,
      child: AnimatedBuilder(
        animation: _armController,
        builder: (context, child) {
          final curvedValue = Curves.easeOutBack.transform(
            _armController.value,
          );

          // Resting: -0.48 radians. Playing: -0.08 radians.
          final angle = -0.48 + (curvedValue * 0.40);

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Fixed turntable pivot.
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF252525),
                  border: Border.all(
                    color: Colors.white24,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Color(0xFF8A8A8A),
                  ),
                ),
              ),

              // Moving arm, rotating around its top edge.
              Transform.rotate(
                angle: angle,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 8,
                        height: 175,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF1F1F1),
                              Color(0xFF7A7A7A),
                              Color(0xFF2A2A2A),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 5,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),
                        child: const Icon(
                          Icons.remove_rounded,
                          color: Color(0xFF76E8BE),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}