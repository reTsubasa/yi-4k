/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03cd46c, name: matched_FUN_a03cd46c.
 * Types and names may be inferred. Runtime validation not performed. */


void matched_FUN_a03cd46c(void)

{
  int iVar1;
  
  FUN_a02a70ec(s_AmbaLink__SpinLock_0x_08x__0x_08_a060ee20,DAT_a14452e8,DAT_a14452ec);
  FUN_a02a70ec(s_AmbaLink__Mutex_0x_08x_a060ee44,DAT_a14452f0);
  if (DAT_a1445324 == 0) {
    FUN_a02a70ec(s__s__pBytePool_is_NULL__a060ee60,s_AmbaLink_Init_a060ed48);
    return;
  }
  DAT_a17e014c = DAT_a1445324;
  if ((DAT_a17e0118 == 0) && (iVar1 = matched_FUN_a03bc49c(), iVar1 != 0)) {
    FUN_a02a70ec(s__s__can_t_not_create_AmbaLink_ev_a060ee78,s_AmbaLink_Init_a060ed48);
  }
  iVar1 = matched_FUN_a03cf18c(0);
  if (iVar1 != 0) {
    FUN_a02a70ec(s__s__AmbaBiss_Init_failed___0x_x__a060eea4,s_AmbaLink_Init_a060ed48);
  }
  matched_FUN_a029e06c();
  matched_analyst_t_register(s_ambalink_a060ed70,matched_tcmd_ambalink);
  return;
}

