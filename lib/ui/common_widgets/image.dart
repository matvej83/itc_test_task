import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class ImageFromHtml extends StatefulWidget {
  const ImageFromHtml({super.key, required this.isImageVisible, required this.imageAddress});

  final bool isImageVisible;
  final String imageAddress;

  @override
  State<ImageFromHtml> createState() => _ImageFromHtmlState();
}

class _ImageFromHtmlState extends State<ImageFromHtml> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: HtmlElementView.fromTagName(
        isVisible: widget.isImageVisible,
        tagName: 'img',
        onElementCreated: (element) {
          element as web.HTMLImageElement;
          element.src = widget.imageAddress;
        },
      ),
    );
  }
}
