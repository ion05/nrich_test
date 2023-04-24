import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool imageUploaded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Material(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Pick an Image'),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image == null) return;

                      final request = http.MultipartRequest(
                        'POST',
                        Uri.parse('https://codelime.in/api/remind-app-token'),
                      );
                      request.files.add(
                        await http.MultipartFile.fromPath(
                          'file',
                          image.path,
                        ),
                      );
                      final response = await request.send().then((value) {
                        if (value.statusCode == 200) {
                          setState(() {
                            imageUploaded = true;
                          });
                        } else {
                          print('Image Not Uploaded');
                        }
                      });
                    },
                    child: Text('Photo'),
                  ),
                  Text(imageUploaded ? "Image Uploaded" : "")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
