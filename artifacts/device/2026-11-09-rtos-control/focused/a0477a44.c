/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 lnxcmd_rpc_handler(undefined4 param_1,int param_2)

{
  if (DAT_a1a30c28 == (code *)0x0) {
    FUN_a02a70ec(s_Netctrl_Cmd_Rcv_FP_is_NULL_point_a0625cac);
    return 0xfffffffa;
  }
  (*DAT_a1a30c28)();
  *(undefined4 *)(param_2 + 8) = 0;
  *(undefined4 *)(param_2 + 0xc) = 0;
  return 0;
}

