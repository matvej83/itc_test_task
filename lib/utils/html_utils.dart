import 'dart:html' as html;

// Method to trigger the full-screen mode
void requestFullscreen() {
  if (html.document.documentElement != null && html.document.documentElement?.requestFullscreen != null) {
    html.document.documentElement?.requestFullscreen();
  }
}

// Method to trigger the full-screen mode on image action
void requestFullscreenOnImage() {
  final html.Element? imageElement = html.document.querySelector('img');
  if (imageElement != null) {
    requestFullscreen();
  }
}

// Function to enable or disable full screen mode in the browser
void toggleFullScreen({bool exitFullScreen = false}) {
  final html.Element? documentElement = html.document.documentElement;
  var isInFullScreen = html.document.fullscreenElement != null;
  if (isInFullScreen && exitFullScreen) {
    html.document.exitFullscreen();
  } else if (!isInFullScreen && !exitFullScreen) {
    documentElement?.requestFullscreen();
  }
}
