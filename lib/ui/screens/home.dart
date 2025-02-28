import 'package:flutter/material.dart';
import 'package:its_test_task/constants/constants.dart';

import '../../utils/html_utils.dart';
import '../../utils/ui_utils.dart';
import '../common_widgets/image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _fabKey = GlobalKey();
  bool isImageVisible = false;
  final textController = TextEditingController();
  final buttonStyle = TextButton.styleFrom(
    shape: RoundedRectangleBorder(),
    backgroundColor: Colors.white,
  );
  final focusNode = FocusNode();

  @override
  void initState() {
    textController.text = imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: isImageVisible
                  ? FutureBuilder<double?>(
                      future: getNetworkImageAspectRatio(textController.text).timeout(Duration(seconds: 5)),
                      builder: (context, snapshot) {
                        var aspectRatio = 1.0;
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 40, height: 40, child: CircularProgressIndicator()),
                            ],
                          );
                        }
                        if (snapshot.hasData) {
                          aspectRatio = snapshot.data!;
                        }
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: GestureDetector(
                            child: ImageFromHtml(isImageVisible: isImageVisible, imageAddress: textController.text),
                            onDoubleTap: () {
                              requestFullscreenOnImage();
                            },
                          ),
                        );
                      })
                  : AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    onTap: () {
                      focusNode.requestFocus();
                    },
                    decoration: InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isImageVisible = true;
                    });
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {
          showContextMenu(context, dialogWidth: 250, fabKey: _fabKey, buttons: [
            TextButton(
              style: buttonStyle,
              onPressed: () {
                toggleFullScreen();
                Navigator.pop(context);
              },
              child: Text('Enter fullscreen', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              style: buttonStyle,
              onPressed: () {
                toggleFullScreen(exitFullScreen: true);
                Navigator.pop(context);
              },
              child: Text('Exit fullscreen', style: TextStyle(color: Colors.black)),
            ),
          ]);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
