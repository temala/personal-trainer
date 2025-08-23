import 'package:flutter/material.dart';

/// Swipeable exercise card that handles left/right swipe gestures
class SwipeableExerciseCard extends StatefulWidget {
  const SwipeableExerciseCard({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.swipeThreshold = 100.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.leftSwipeColor = Colors.red,
    this.rightSwipeColor = Colors.orange,
    this.leftSwipeIcon = Icons.thumb_down,
    this.rightSwipeIcon = Icons.skip_next,
    this.leftSwipeText = "Don't like",
    this.rightSwipeText = "Skip for now",
    this.showSwipeHints = true,
  });

  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double swipeThreshold;
  final Duration animationDuration;
  final Color leftSwipeColor;
  final Color rightSwipeColor;
  final IconData leftSwipeIcon;
  final IconData rightSwipeIcon;
  final String leftSwipeText;
  final String rightSwipeText;
  final bool showSwipeHints;

  @override
  State<SwipeableExerciseCard> createState() => _SwipeableExerciseCardState();
}

class _SwipeableExerciseCardState extends State<SwipeableExerciseCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  double _dragDistance = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          // Background indicators
          if (_isDragging) _buildSwipeBackground(),

          // Main card
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    _isDragging
                        ? Offset(_dragDistance, 0)
                        : _slideAnimation.value,
                child: Transform.scale(
                  scale: _isDragging ? 1.0 : _scaleAnimation.value,
                  child: widget.child,
                ),
              );
            },
          ),

          // Swipe hints overlay
          if (widget.showSwipeHints && !_isDragging) _buildSwipeHints(),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground() {
    final screenWidth = MediaQuery.of(context).size.width;
    final swipeProgress = (_dragDistance.abs() / widget.swipeThreshold).clamp(
      0.0,
      1.0,
    );
    final isLeftSwipe = _dragDistance < 0;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: (isLeftSwipe ? widget.leftSwipeColor : widget.rightSwipeColor)
              .withOpacity(swipeProgress * 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment:
              isLeftSwipe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isLeftSwipe) const SizedBox(width: 32),
            Opacity(
              opacity: swipeProgress,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLeftSwipe ? widget.leftSwipeIcon : widget.rightSwipeIcon,
                    color:
                        isLeftSwipe
                            ? widget.leftSwipeColor
                            : widget.rightSwipeColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLeftSwipe ? widget.leftSwipeText : widget.rightSwipeText,
                    style: TextStyle(
                      color:
                          isLeftSwipe
                              ? widget.leftSwipeColor
                              : widget.rightSwipeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isLeftSwipe) const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeHints() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              widget.rightSwipeColor.withOpacity(0.1),
              Colors.transparent,
              widget.leftSwipeColor.withOpacity(0.1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Row(
          children: [
            // Right swipe hint
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.rightSwipeIcon,
                      color: widget.rightSwipeColor.withOpacity(0.6),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.rightSwipeText,
                      style: TextStyle(
                        color: widget.rightSwipeColor.withOpacity(0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Center space
            const Expanded(child: SizedBox()),

            // Left swipe hint
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.leftSwipeIcon,
                      color: widget.leftSwipeColor.withOpacity(0.6),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.leftSwipeText,
                      style: TextStyle(
                        color: widget.leftSwipeColor.withOpacity(0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragDistance = 0.0;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDistance += details.delta.dx;
      // Limit drag distance to prevent excessive movement
      _dragDistance = _dragDistance.clamp(-200.0, 200.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final shouldTriggerSwipe =
        _dragDistance.abs() > widget.swipeThreshold || velocity.abs() > 500;

    if (shouldTriggerSwipe) {
      if (_dragDistance < 0) {
        // Left swipe
        _triggerLeftSwipe();
      } else {
        // Right swipe
        _triggerRightSwipe();
      }
    } else {
      // Return to center
      _resetPosition();
    }
  }

  void _triggerLeftSwipe() {
    _slideAnimation = Tween<Offset>(
      begin: Offset(_dragDistance / MediaQuery.of(context).size.width, 0),
      end: const Offset(-1.5, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward().then((_) {
      widget.onSwipeLeft?.call();
      _resetCard();
    });

    setState(() {
      _isDragging = false;
    });
  }

  void _triggerRightSwipe() {
    _slideAnimation = Tween<Offset>(
      begin: Offset(_dragDistance / MediaQuery.of(context).size.width, 0),
      end: const Offset(1.5, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward().then((_) {
      widget.onSwipeRight?.call();
      _resetCard();
    });

    setState(() {
      _isDragging = false;
    });
  }

  void _resetPosition() {
    _slideAnimation = Tween<Offset>(
      begin: Offset(_dragDistance / MediaQuery.of(context).size.width, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward().then((_) {
      _resetCard();
    });

    setState(() {
      _isDragging = false;
    });
  }

  void _resetCard() {
    _animationController.reset();
    setState(() {
      _dragDistance = 0.0;
      _isDragging = false;
    });
  }
}

/// Exercise card with swipe functionality
class ExerciseSwipeCard extends StatelessWidget {
  const ExerciseSwipeCard({
    super.key,
    required this.exerciseName,
    required this.exerciseDescription,
    this.exerciseImage,
    this.sets,
    this.reps,
    this.duration,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onTap,
  });

  final String exerciseName;
  final String exerciseDescription;
  final Widget? exerciseImage;
  final int? sets;
  final int? reps;
  final String? duration;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SwipeableExerciseCard(
      onSwipeLeft: onSwipeLeft,
      onSwipeRight: onSwipeRight,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise image/animation area
                if (exerciseImage != null) ...[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: exerciseImage!,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Exercise name
                Text(
                  exerciseName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Exercise description
                Text(
                  exerciseDescription,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Exercise details
                Row(
                  children: [
                    if (sets != null) ...[
                      _buildDetailChip(
                        icon: Icons.repeat,
                        label: '$sets sets',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (reps != null) ...[
                      _buildDetailChip(
                        icon: Icons.fitness_center,
                        label: '$reps reps',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (duration != null) ...[
                      _buildDetailChip(
                        icon: Icons.timer,
                        label: duration!,
                        color: Colors.orange,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
