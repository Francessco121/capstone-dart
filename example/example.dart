// Based on the official C example: http://www.capstone-engine.org/lang_c.html

import 'dart:ffi';
import 'dart:typed_data';

import 'package:capstone/capstone.dart';
import 'package:ffi/ffi.dart';

final code = Uint8List.fromList('\x55\x48\x8b\x05\xb8\x13\x00\x00'.codeUnits);

int main() {
  final cs = Capstone(DynamicLibrary.open('capstone.dll'));

  final arena = Arena();

  try {
    final handle = arena.allocate<csh>(sizeOf<csh>());

    if (cs.open(cs_arch.CS_ARCH_X86, cs_mode.CS_MODE_64, handle) != cs_err.OK) {
      return -1;
    }

    arena.using(handle, (handle) => cs.close(handle));

    final codePtr = arena.allocate<Uint8>(code.lengthInBytes);
    for (int i = 0; i < code.length; i++) {
      codePtr[i] = code[i];
    }

    final insn = arena.allocate<Pointer<cs_insn>>(sizeOf<Size>());
    final count =
        cs.disasm(handle.value, codePtr, code.lengthInBytes, 0x1000, 0, insn);

    arena.using(insn, (insts) => cs.free(insts.value, count));

    if (count > 0) {
      for (int i = 0; i < count; i++) {
        print('0x${insn.value[i].address.toRadixString(16)}:\t' +
            '${insn.value[i].mnemonic.readNullTerminatedString()}\t\t' +
            '${insn.value[i].op_str.readNullTerminatedString()}');
      }
    } else {
      print('ERROR: Failed to disassemble given code!');
    }
  } finally {
    arena.releaseAll();
  }

  return 0;
}
