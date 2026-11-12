/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void image_sof(undefined4 param_1)

{
  char cVar1;
  
  DAT_a1704300 = param_1;
  if (DAT_a17045da == '\0') {
    matched_FUN_a037efa8();
  }
  if (*(int *)(DAT_a1a30f20 + 0x18) != 0) {
    (**(code **)(DAT_a1a30f20 + 0x18))(4,&DAT_a1704128);
  }
  cVar1 = matched_FUN_a0506418(DAT_a1704190 * 1000,DAT_a170418c);
  DAT_a1702c50 = cVar1 + '\x01';
  image_command_dispatch(0xb03,0,&DAT_a1702c54,0);
  if ((DAT_a0757b28 & 2) != 0) {
    FUN_a02a70ec(s_SofTime__d__CurrFrameTime__d_a05fe7bc,param_1,DAT_a1702c50);
  }
  return;
}

