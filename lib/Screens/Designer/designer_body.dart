import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:panorama/panorama.dart';
import 'package:image_picker/image_picker.dart';
import 'room_equipment_object.dart';
import 'draggable_equipment.dart';
import 'image_options.dart';

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({Key? key}) : super(key: key);
  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen>
    with SingleTickerProviderStateMixin {
  bool panoMode = true;
  bool _showDeleteButton = false;
  bool _isDeleteButtonActive = false;
  List<Widget> addedEquipment = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  late File _image;

  Future getImage() async {
    start = false;
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  List<Widget> getRoomEquipment() {
    List<Widget> roomEquipment = [];
    for (int i = 1; i < 4; i++) {
      Widget image = RoomEquipmentObject(
        img: 'assets/Room Equipment/e $i.png',
        tapped: () {
          setState(() {
            addedEquipment.add(DraggableEquipment(
                key: Key(addedEquipment.length.toString()),
                onDragStart: () {
                  setState(() {
                    _showDeleteButton = true;
                  });
                },
                onDragEnd: (offset, key) {
                  setState(() {
                    _showDeleteButton = false;
                  });
                  if (offset.dy > (MediaQuery.of(context).size.height - 100)) {
                    addedEquipment.removeWhere((widget) => widget.key == key);
                  }
                },
                onDragUpdate: (offset, key) {
                  if (offset.dy > (MediaQuery.of(context).size.height - 100)) {
                    if (!_isDeleteButtonActive) {
                      setState(() {
                        _isDeleteButtonActive = true;
                      });
                    }
                  } else {
                    if (_isDeleteButtonActive) {
                      setState(() {
                        _isDeleteButtonActive = false;
                      });
                    }
                  }
                },
                child: Image(
                    image: AssetImage('assets/Room Equipment/e $i.png'))));
          });
        },
      );
      roomEquipment.add(image);
    }
    return roomEquipment;
  }

  bool start = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _key,
      drawer: Drawer(
        width: 200,
         // icon: IconThemeData(color: Colors.black)
        child: ListView(
          children: getRoomEquipment(),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: panoMode
                ? Panorama(
                    child: start
                        ? Image.asset('assets/images/360 room.jpeg')
                        : Image.file(_image))
                : start
                    ? Image.asset('assets/images/360 room.jpeg')
                    : Image.file(_image),
          ),
          IconButton(
              onPressed: () {
                _key.currentState?.openDrawer();
              },
              color: Colors.black,
              icon: const Icon(Icons.menu)),
          for (int i = 0; i < addedEquipment.length; i++) addedEquipment[i],
          if (_showDeleteButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Icon(
                  Icons.delete,
                  size: _isDeleteButtonActive ? 38 : 28,
                  color: _isDeleteButtonActive ? Colors.red : Colors.black,
                ),
              ),
            )
        ],
      ),
      floatingActionButton: ImageOptions(
        onGalleryPressed: () {
          getImage();
        },
        onModePressed: (mode) {
          setState(() {
            panoMode = mode;
          });
        },
        onSphereCapturePressed: () async {
          await LaunchApp.openApp(
            androidPackageName: 'com.google.android.street',
            //androidPackageName: 'com.instagram.android',
            openStore: false,
          );
        },
      ),
    );
  }
}

class PanoImage extends StatelessWidget {
  const PanoImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Came in Pano');
    return Panorama(
        animSpeed: 1,
        child: Image.asset('assets/Room Equipment/360 room.jpeg'));
  }
}

class SimpleImage extends StatelessWidget {
  const SimpleImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Came in simple');
    return Image.asset('assets/Room Equipment/360 room.jpeg');
  }
}

// class PanoImage extends StatelessWidget {
//   const PanoImage({
//     Key? key,
//     required this.start,
//     required File image,
//   })  : _image = image,
//         super(key: key);
//
//   final bool start;
//   final File _image;
//
//   @override
//   Widget build(BuildContext context) {
//     print('Came in Simple');
//     return Panorama(
//       zoom: 1,
//       child: start
//           ? Image.asset('assets/Room Equipment/360 room.jpeg')
//           : Image.file(_image),
//     );
//   }
// }
// class SimpleImage extends StatelessWidget {
//   const SimpleImage({
//     Key? key,
//     required this.start,
//     required File image,
//   })  : _image = image,
//         super(key: key);
//
//   final bool start;
//   final File _image;
//
//   @override
//   Widget build(BuildContext context) {
//     print('Came in pano');
//     return start? Image.asset('assets/Room Equipment/360 room.jpeg') : Image.file(_image);
//   }
// }
