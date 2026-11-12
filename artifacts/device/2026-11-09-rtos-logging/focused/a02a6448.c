/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void print_flush_console_buffer(void)

{
  int iVar1;
  uint uVar2;
  undefined4 in_r3;
  uint uVar3;
  
  uVar2 = DAT_a144b988;
  uVar3 = DAT_a144b98c;
LAB_a02a6468:
  do {
    if (uVar3 == uVar2) {
      return;
    }
    while( true ) {
      if ((DAT_a144d998 == 0) && (DAT_a144d9a4 == 0)) {
        uVar3 = uVar2;
        DAT_a144b98c = uVar2;
        goto LAB_a02a6468;
      }
      if (uVar3 < uVar2) {
        if (DAT_a144b97c == (code *)0x0) goto LAB_a02a6468;
        iVar1 = (*DAT_a144b97c)(uVar2 - uVar3,DAT_a144b984 + uVar3,0xffffffff,uVar3,in_r3);
      }
      else {
        if (DAT_a144b97c == (code *)0x0) goto LAB_a02a6468;
        iVar1 = (*DAT_a144b97c)(DAT_a144b980 - uVar3,DAT_a144b984 + uVar3,0xffffffff,uVar3,in_r3);
      }
      uVar2 = DAT_a144b988;
      if (iVar1 < 1) break;
      DAT_a144b98c = iVar1 + DAT_a144b98c;
      if (DAT_a144b980 <= DAT_a144b98c) {
        DAT_a144b98c = 0;
      }
      uVar3 = DAT_a144b98c;
      if (DAT_a144b98c == DAT_a144b988) {
        return;
      }
    }
    uVar3 = DAT_a144b98c;
  } while( true );
}

