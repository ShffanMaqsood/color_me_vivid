import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

typedef ModeChanged = void Function(bool mode);

class ImageOptions extends StatefulWidget {
  const ImageOptions(
      {Key? key,
      required this.onGalleryPressed,
      required this.onModePressed,
      required this.onSphereCapturePressed})
      : super(key: key);

  final VoidCallback onGalleryPressed;
  final ModeChanged onModePressed;
  final VoidCallback onSphereCapturePressed;

  @override
  State<ImageOptions> createState() => _ImageOptionsState();
}

class _ImageOptionsState extends State<ImageOptions>
    with TickerProviderStateMixin {
  bool _isImageOptionsOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animationIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  late double _fabHeight;

  @override
  void initState() {
    _fabHeight = 56;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animationIcon = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _buttonColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.75, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget panoModeSwitch() {
    return Visibility(
      visible: _isImageOptionsOpened,
      child: LiteRollingSwitch(
        iconOn: const IconData(0xf0787, fontFamily: 'MaterialIcons'),
        iconOff: Icons.image_outlined,
        textOn: '360',
        textOff: 'Normal',
        value: true,
        onTap: () {},
        onDoubleTap: () {},
        onSwipe: () {},
        onChanged: (bool mode) {
          widget.onModePressed(mode);

        }
      ),
    );
  }

  Widget captureSphereButton() {
    return Visibility(
      visible: _isImageOptionsOpened,
      child: SizedBox(
        width: 130,
        height: 45,
        child: ElevatedButton.icon(
            onPressed: () {
          widget.onSphereCapturePressed();
          _animationController.reverse();
          _isImageOptionsOpened = false;
        },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              )
            )
          ),
          icon: const ImageIcon(AssetImage('assets/360 icon.png')), label: const Text('360 Capture'),
        ),
      ),
    );
  }

  Widget openGalleryButton() {
    return Visibility(
      visible: _isImageOptionsOpened,
      child: SizedBox(
        width: 130,
        height: 45,
        child: ElevatedButton.icon(
          onPressed: () {
            widget.onGalleryPressed();
            _animationController.reverse();
            _isImageOptionsOpened = false;
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  )
              )
          ),
          icon: const Icon(Icons.image_outlined), label: const Text('Gallery'),
        ),
      ),
    );
  }

  Widget buttonToggle() {
    return FloatingActionButton(
      onPressed: animate,
      backgroundColor: _buttonColor.value,
      child: const  Icon(Icons.add_a_photo_outlined)
      // AnimatedIcon(
      //   icon: AnimatedIcons.menu_close,
      //   progress: _animationIcon,
      // ),
    );
  }

  animate() {
    if (!_isImageOptionsOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isImageOptionsOpened = !_isImageOptionsOpened;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform:
              Matrix4.translationValues(0.0, _translateButton.value * 3, 0.0),
          child: panoModeSwitch(),
        ),
        Transform(
          transform:
              Matrix4.translationValues(0.0, _translateButton.value * 2, 0.0),
          child: captureSphereButton(),
        ),
        Transform(
          transform:
              Matrix4.translationValues(0.0, _translateButton.value, 0.0),
          child: openGalleryButton(),
        ),
        buttonToggle()
      ],
    );
  }
}
