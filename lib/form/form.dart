import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

import '../api/firebase_api.dart';
import '../firebase_options.dart';
import '../main/custom_colors.dart';

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
  final apkController = TextEditingController();
  final gameNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final gameDescriptionController = TextEditingController();
  final linuxController = TextEditingController();
  final webController = TextEditingController();
  final backgroundImageController = TextEditingController();
  final webLinkController = TextEditingController();
  Uint8List _file1 = Uint8List(0);
  Uint8List _file2 = Uint8List(0);
  Uint8List _file3 = Uint8List(0);
  Uint8List _file4 = Uint8List(0);

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    backgroundImageController.dispose();
    apkController.dispose();
    gameNameController.dispose();
    companyNameController.dispose();
    gameDescriptionController.dispose();
    linuxController.dispose();
    webController.dispose();
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
  _submitFiles() {
    String gameDescription = (gameDescriptionController.text);
    String companyName = (companyNameController.text);
    String gameName = (gameNameController.text);

    fs.Reference? webRef = _isNull(webController)
        ? null
        : FirebaseApi.ref.child(gameName).child(webController.text);
    fs.Reference? linuxRef = _isNull(linuxController)
        ? null
        : FirebaseApi.ref.child(gameName).child(linuxController.text);
    fs.Reference? apkRef = _isNull(apkController)
        ? null
        : FirebaseApi.ref.child(gameName).child(apkController.text);
    fs.Reference? imageRef = _isNull(backgroundImageController)
        ? null
        : FirebaseApi.ref.child(gameName).child(backgroundImageController.text);
    String webLink = _isNull(webLinkController) ? '' : webLinkController.text;

    FirebaseApi.uploadFile(_file1, webRef);
    FirebaseApi.uploadFile(_file2, linuxRef);
    FirebaseApi.uploadFile(_file3, apkRef);
    FirebaseApi.uploadFile(_file4, imageRef);

    FirebaseApi.createNewGame(companyName, gameName, gameDescription, webRef,
        linuxRef, apkRef, imageRef, webLink);
  }

  //TODO Refaire la fonction ?
  _searchFiles(TextEditingController controller) async {
    FilePickerResult? result;
    int fileNumber;
    if (controller == linuxController || controller == webController) {
      if (controller == webController) {
        fileNumber = 1;
      } else {
        fileNumber = 2;
      }
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'gz'],
      );
    } else if (controller == apkController) {
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

        controller.text = result.files.single.name;
      } catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
      controller.text = 'No file selected !';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: CustomColors.greenColor, title: const Text('Upload a game')),
        body: Form(
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
                      hintText: 'Enter the game name',
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
                      hintText: 'Enter a web build zip',
                      labelText: 'Web build',
                    ),
                    controller: webController,
                    validator: (value) {
                      if (!_checkAtLeastOne(
                          webController, linuxController, apkController)) {
                        return 'Please enter at least one build';
                      }
                      return null;
                    },
                    onTap: () => {_searchFiles(webController)},
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter a web link',
                        labelText: 'Web link',
                      ),
                      controller: webLinkController
                    /* validator: (value) {
                  if (!_checkAtLeastOne(webController, linuxController, apkController)) {
                    return 'Please enter at least one build';
                  }
                  return null;
                },*/
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a linux build zip',
                      labelText: 'Linux build',
                    ),
                    controller: linuxController,
                    validator: (value) {
                      if (!_checkAtLeastOne(
                          webController, linuxController, apkController)) {
                        return 'Please enter at least one build';
                      }
                      return null;
                    },
                    onTap: () => {_searchFiles(linuxController)},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter an apk build',
                      labelText: 'Android build',
                    ),
                    enableInteractiveSelection: false,
                    controller: apkController,
                    validator: (value) {
                      if (!_checkAtLeastOne(
                          webController, linuxController, apkController)) {
                        return 'Please enter at least one build';
                      }
                      return null;
                    },
                    onTap: () => {_searchFiles(apkController)},
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
                  SizedBox(height: 20),
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
      ),
    );
  }
}
