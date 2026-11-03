import 'package:flutter_launcher_icons/android.dart' as android;
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:image/image.dart';
import 'package:test/test.dart';

// unit tests for the GoHighLevel fork customisations
void main() {
  group('GHL fork: adaptive icon rescale', () {
    test('parses scale factor and fill color', () {
      final config = Config.fromJson({
        'adaptive_icon_foreground_scale_factor': 0.49,
        'adaptive_icon_foreground_scale_fill_color': '#07223D',
      });

      expect(config.adaptiveIconRescaleFactor, 0.49);
      expect(config.adaptiveIconScaleFillColor, '#07223D');
      expect(config.hasAdaptiveIconRescale, isTrue);
    });

    test('rescale disables the default inset', () {
      final config = Config.fromJson({
        'adaptive_icon_foreground_scale_factor': 0.5,
      });

      expect(config.effectiveAdaptiveIconForegroundInset, 0);
    });

    test('keeps upstream inset when no scale factor is set', () {
      final config = Config.fromJson({'adaptive_icon_foreground_inset': 10});

      expect(config.hasAdaptiveIconRescale, isFalse);
      expect(config.effectiveAdaptiveIconForegroundInset, 10);
    });

    test('rescaleImage centres the image on a larger square canvas', () {
      final image = Image(width: 40, height: 20, numChannels: 4);
      fill(image, color: ColorRgba8(255, 0, 0, 255));

      final scaled = android.rescaleImage(image, 0.5);

      expect(scaled.width, 80);
      expect(scaled.height, 80);
      expect(scaled.getPixel(40, 40).r, 255);
      expect(scaled.getPixel(0, 0).a, 0);
    });
  });

  group('GHL fork: iOS remove alpha background', () {
    test('background_color_ios wins when set', () {
      final config = Config.fromJson({
        'background_color_ios': '#123456',
        'adaptive_icon_background': '#07223D',
      });

      expect(config.iosBackgroundColor, '#123456');
    });

    test('falls back to a hex adaptive_icon_background', () {
      final config = Config.fromJson({'adaptive_icon_background': '#07223D'});

      expect(config.iosBackgroundColor, '#07223D');
    });

    test('ignores an image adaptive_icon_background and uses white', () {
      final config = Config.fromJson({
        'adaptive_icon_background': 'assets/background.png',
      });

      expect(config.iosBackgroundColor, '#ffffff');
    });
  });
}
