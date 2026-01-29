import 'package:get_storage/get_storage.dart';

class TooltipStorage {
  static final box = GetStorage();
  static const String hideTooltipsKey = "hide_tooltips";

  static bool shouldShow() {
    return !(box.read(hideTooltipsKey) ?? false);
  }

  static void hideForever() {
    box.write(hideTooltipsKey, true);
  }
}
