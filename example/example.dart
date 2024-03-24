// Based on the official C example: http://www.capstone-engine.org/lang_c.html

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:capstone/capstone.dart';
import 'package:ffi/ffi.dart';

final code = Uint8List.fromList('\x55\x48\x8b\x05\xb8\x13\x00\x00'.codeUnits);

void main() {
  final cs = Capstone(DynamicLibrary.open('capstone.dll'));

  final arena = Arena();

  try {
    final handle = arena.allocate<csh>(sizeOf<csh>());

    if (cs.open(cs_arch.X86, cs_mode.$64, handle) != cs_err.OK) {
      exit(-1);
    }

    arena.using(handle, (handle) => cs.close(handle));

    final codePtr = arena.allocate<Uint8>(code.length);
    for (int i = 0; i < code.length; i++) {
      codePtr[i] = code[i];
    }

    final insn = arena.allocate<Pointer<cs_insn>>(sizeOf<Size>());
    final count =
        cs.disasm(handle.value, codePtr, code.length, 0x1000, 0, insn);

    arena.using(insn, (insts) => cs.free(insts.value, count));

    if (count > 0) {
      for (int j = 0; j < count; j++) {
        final i = insn.value[j];
        final mnemonic = i.mnemonic.readNullTerminatedString();
        final op = i.op_str.readNullTerminatedString();

        print('0x${i.address.toRadixString(16)}:\t$mnemonic\t\t$op');
      }
    } else {
      print('ERROR: Failed to disassemble given code!');
    }
  } finally {
    arena.releaseAll();
  }

  exit(0);
}
