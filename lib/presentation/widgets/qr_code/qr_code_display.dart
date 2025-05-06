// lib/presentation/widgets/qr_code/qr_code_display.dart

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeDisplay extends StatelessWidget {
  final String data;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final String? label;

  const QRCodeDisplay({
    super.key,
    required this.data,
    this.size = 200.0,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.padding = const EdgeInsets.all(16.0),
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: size,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              errorStateBuilder: (context, error) {
                return Center(
                  child: Text(
                    'Error generating QR code: ${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                );
              },
              embeddedImage: null, // You can add a logo in the center if needed
              embeddedImageStyle: null,
            ),
            if (label != null) ...[
              const SizedBox(height: 12),
              Text(
                label!,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
