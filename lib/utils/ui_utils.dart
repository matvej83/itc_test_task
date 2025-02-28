import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void showContextMenu(
  BuildContext context, {
  required double dialogWidth,
  required GlobalKey<State<StatefulWidget>> fabKey,
  required List<Widget> buttons,
}) {
  final renderBox = fabKey.currentContext?.findRenderObject() as RenderBox;
  final buttonPosition = renderBox.localToGlobal(Offset.zero); // Button position in global coordinates
  final buttonSize = renderBox.size;
  // Get screen size
  final screenSize = MediaQuery.of(context).size;

  // Calculate the top position for the dialog (above the button)
  double topPosition = buttonPosition.dy - 150; // Adjust 150 as needed to control the dialog height
  double leftPosition =
      buttonPosition.dx + (buttonSize.width / 2) - (dialogWidth / 2); // Center the dialog above the button

  // Ensure the dialog doesn't go off-screen (top side)
  if (topPosition < 0) {
    topPosition = buttonPosition.dy + buttonSize.height + 10;
  }

  // Ensure the dialog doesn't go off-screen (left side)
  if (leftPosition < 0) {
    leftPosition = 10; // Add padding from the left
  }

  // Ensure the dialog doesn't go off-screen (right side)
  if (leftPosition + dialogWidth > screenSize.width) {
    leftPosition = screenSize.width - dialogWidth; // Add padding from the right
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          Positioned(
            left: leftPosition,
            top: topPosition,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 250,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: buttons,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Function to get network image aspect ratio
Future<double?> getNetworkImageAspectRatio(String imageUrl) async {
  ui.Image? img;
  //Loads the image using Image.network(imageUrl)
  try {
    final image = Image.network(imageUrl);
    final Completer<ui.Image> completer = Completer<ui.Image>();

    //Resolves the image using ImageProvider.resolve(), which loads the image asynchronously
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    //Calculates and returns aspect ratio (width / height)
    img = await completer.future;
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return img != null ? img.width / img.height : 1.0;
}
