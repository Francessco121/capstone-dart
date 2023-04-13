import 'dart:ffi';

extension CharArrayExtensions on Array<Char> {
  String readNullTerminatedString([int offset = 0]) {
    final bytes = <int>[];
    int i = offset;
    while (true) {
      final c = this[i++];
      if (c == 0) {
        break;
      }

      bytes.add(c);
    }

    return String.fromCharCodes(bytes);
  }
}
