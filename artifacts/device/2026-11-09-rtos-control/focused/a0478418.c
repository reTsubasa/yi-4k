/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void event_notify_rpc_handler(undefined4 *param_1,int param_2)

{
  undefined4 uStack_14;
  undefined4 uStack_10;
  undefined4 *puStack_c;
  
  if (DAT_a1a30ef8 != (code *)0x0) {
    uStack_14 = *param_1;
    puStack_c = param_1 + 2;
    uStack_10 = param_1[1];
    (*DAT_a1a30ef8)(0,uStack_14,&uStack_14);
  }
  *(undefined4 *)(param_2 + 0xc) = 0;
  *(undefined4 *)(param_2 + 8) = 1;
  return;
}

