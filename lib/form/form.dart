import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../api/flutterfire_api.dart';
import '../firebase_options.dart';
import '../custom_widgets/custom_colors.dart';
import '../custom_widgets/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyCustomForm());
  //FirebaseApi.getGames();
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final androidBuildController = TextEditingController();
  final gameNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final gameDescriptionController = TextEditingController();
  final gameInstructionsController = TextEditingController();
  final linuxBuildController = TextEditingController();
  final webBuildController = TextEditingController();
  final backgroundImageController = TextEditingController();
  final webLinkController = TextEditingController();
  final PrimitiveWrapper _physicalPercentage = PrimitiveWrapper(0);
  final PrimitiveWrapper _cognitivePercentage = PrimitiveWrapper(0);
  final PrimitiveWrapper _socialPercentage = PrimitiveWrapper(0);
  final PrimitiveWrapper _celluloCount = PrimitiveWrapper(0);
  Uint8List _file1 = Uint8List(0);
  Uint8List _file2 = Uint8List(0);
  Uint8List _file3 = Uint8List(0);
  Uint8List _file4 = Uint8List(0);
  ImageProvider? _previewBackgroundImage;

  @override
  void initState() {
    gameNameController.addListener(() {
      setState(() {
        gameNameController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    backgroundImageController.dispose();
    androidBuildController.dispose();
    gameNameController.dispose();
    companyNameController.dispose();
    gameDescriptionController.dispose();
    linuxBuildController.dispose();
    webBuildController.dispose();
    webLinkController.dispose();
    super.dispose();
  }

  ///Check if there is at least one build for the game
  bool _checkAtLeastOne(TextEditingController web, TextEditingController linux,
      TextEditingController apk) {
    return !(_isNull(web) && _isNull(linux) && _isNull(apk));
  }

  ///Check if the given controller is null
  bool _isNull(TextEditingController controller) {
    return controller.text == null ||
        controller.text.isEmpty ||
        controller.text == 'No file selected !';
  }

  ///Submit the form
  _submitFiles() async {
    String gameName = gameNameController.text;
    fs.Reference? webBuildRef = _isNull(webBuildController)
        ? null
        : FlutterfireApi.ref.child(gameName).child(webBuildController.text);
    fs.Reference? linuxBuildRef = _isNull(linuxBuildController)
        ? null
        : FlutterfireApi.ref.child(gameName).child(linuxBuildController.text);
    fs.Reference? androidBuildRef = _isNull(androidBuildController)
        ? null
        : FlutterfireApi.ref.child(gameName).child(androidBuildController.text);
    fs.Reference? imageRef = _isNull(backgroundImageController)
        ? null
        : FlutterfireApi.ref.child(gameName).child(backgroundImageController.text);
    String webLink = _isNull(webLinkController) ? '' : webLinkController.text;

    FlutterfireApi.uploadFile(_file1, webBuildRef);
    FlutterfireApi.uploadFile(_file2, linuxBuildRef);
    FlutterfireApi.uploadFile(_file3, androidBuildRef);
    FlutterfireApi.uploadFile(_file4, imageRef);

    String? linuxBuild = await linuxBuildRef?.getDownloadURL();
    String? androidBuild = await androidBuildRef?.getDownloadURL();
    String? webBuild = await webBuildRef?.getDownloadURL();
    String? image = await imageRef?.getDownloadURL();


    print(gameName);
    print(image);
    FlutterfireApi.createNewGame(
        gameName,
        companyNameController.text,
        gameDescriptionController.text,
        gameInstructionsController.text,
        webBuild ?? "",
        webLink,
        linuxBuild ?? "",
        androidBuild ?? "",
        image ?? "",
        _physicalPercentage.value,
        _cognitivePercentage.value,
        _socialPercentage.value,
        _celluloCount.value);
  }

  //TODO Refaire la fonction ?
  _searchFiles(TextEditingController controller) async {
    FilePickerResult? result;
    int fileNumber;
    if (controller == linuxBuildController || controller == webBuildController) {
      if (controller == webBuildController) {
        fileNumber = 1;
      } else {
        fileNumber = 2;
      }
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'gz'],
      );
    } else if (controller == androidBuildController) {
      fileNumber = 3;
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['apk'],
      );
    } else {
      fileNumber = 4;
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpeg', 'jpg'],
      );

    }

    setState(() {
    if (result != null) {
      try {
        if (fileNumber == 1) {
          _file1 = result.files.single.bytes!;
        }
        if (fileNumber == 2) {
          _file2 = result.files.single.bytes!;
        }
        if (fileNumber == 3) {
          _file3 = result.files.single.bytes!;
        }
        if (fileNumber == 4) {
          _file4 = result.files.single.bytes!;
        }
        _previewBackgroundImage = Image.memory(result.files.single.bytes!).image;
        controller.text = "Selected file: " + result.files.single.name;
      } catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
      controller.text = 'No file selected !';
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: CustomColors.greenColor.shade900,
              title: const Text('Upload a game')),
          body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter the game company name',
                          labelText: 'Game company name',
                        ),
                        controller: companyNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter the game name',
                          labelText: 'Game name',
                        ),
                        controller: gameNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter the game description',
                          labelText: 'Game description',
                        ),
                        controller: gameDescriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter the game instructions (how to play)',
                          labelText: 'Game Instructions (how to play)',
                        ),
                        controller: gameInstructionsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter a web build zip',
                          labelText: 'Web build',
                        ),
                        controller: webBuildController,
                        validator: (value) {
                          if (!_checkAtLeastOne(
                              webBuildController, linuxBuildController, androidBuildController)) {
                            return 'Please enter at least one build';
                          }
                          return null;
                        },
                        onTap: () => {_searchFiles(webBuildController)},
                      ),
                      TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter a web link',
                            labelText: 'Web link',
                          ),
                          controller: webLinkController
                          ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter a linux build zip',
                          labelText: 'Linux build',
                        ),
                        controller: linuxBuildController,
                        validator: (value) {
                          if (!_checkAtLeastOne(
                              webBuildController, linuxBuildController, androidBuildController)) {
                            return 'Please enter at least one build';
                          }
                          return null;
                        },
                        onTap: () => {_searchFiles(linuxBuildController)},
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter an apk build',
                          labelText: 'Android build',
                        ),
                        enableInteractiveSelection: false,
                        controller: androidBuildController,
                        validator: (value) {
                          if (!_checkAtLeastOne(
                              webBuildController, linuxBuildController, androidBuildController)) {
                            return 'Please enter at least one build';
                          }
                          return null;
                        },
                        onTap: () => {_searchFiles(androidBuildController)},
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter a background image',
                          labelText: 'Background image',
                        ),
                        enableInteractiveSelection: false, //useless btw
                        controller: backgroundImageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a background image';
                          }
                          return null;
                        },
                        onTap: () => {_searchFiles(backgroundImageController)},
                      ),
                      _previewImage(),
                      _sliderCustom("How physical is your game ?",
                          Colors.deepOrangeAccent,
                          Colors.deepOrangeAccent.shade100.withOpacity(.5),
                          _physicalPercentage,
                          Ionicons.ios_fitness,
                          100),
                      _sliderCustom("How cognitive is your game ?",
                          Colors.lightBlueAccent,
                          Colors.lightBlueAccent.shade100.withOpacity(.5),
                          _cognitivePercentage,
                          MaterialCommunityIcons.brain,
                          100),
                      _sliderCustom("How social is your game ?",
                          Colors.greenAccent,
                          Colors.greenAccent.shade100.withOpacity(.5),
                          _socialPercentage,
                          MaterialIcons.people,
                          100),
                      _sliderCustom("How many Cellulos does your game use ?",
                          Colors.grey.shade400,
                          Colors.grey.shade200,
                          _celluloCount,
                          Icons.hexagon,
                          4),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            _submitFiles();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                )),
          )),
    );
  }

  Widget _sliderCustom(String _text, Color _activeColor, Color _inactiveColor, PrimitiveWrapper _count, IconData _icon, int _max){
    return Row(children: [
      Text(_text),
      SfSliderTheme(
          data: SfSliderThemeData(
              activeTrackColor: _activeColor,
              inactiveTrackColor: _inactiveColor,
              thumbColor: Colors.white,
              thumbRadius: 20,
              tooltipBackgroundColor: _activeColor
          ),
          child: SfSlider(
            value: _count.value,
            max: _max,
            stepSize: 1,
            showLabels: true,
            enableTooltip: true,
            thumbIcon: Icon(
                _icon,
                color: _activeColor,
                size: 30.0),
            onChanged: (dynamic value) {
              setState(() {
                _count.value = value;
              });
            },
          ))
    ]);
  }

  Widget _previewImage(){
    return Stack(
      children: [
        Container(
          child: SizedBox(
              height: 200,
              child: Center(
                  child: Text(
                    gameNameController.value.text,
                    style: Style.bannerStyle(),
                  ))),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: _previewBackgroundImage ?? Image.asset('graphics/logo_chili.png').image,
                fit: BoxFit.fitWidth),
          ),
        )
      ],
    );
  }
}

class PrimitiveWrapper {
  var value;
  PrimitiveWrapper(this.value);
}
