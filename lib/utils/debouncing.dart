import 'dart:async';


class Debouncer {
  final Duration delay = const Duration(milliseconds: 500);
  Timer? _timer;

  run(Function action) {
    _timer?.cancel();
    _timer = Timer(delay, action as void Function());
  }
}
