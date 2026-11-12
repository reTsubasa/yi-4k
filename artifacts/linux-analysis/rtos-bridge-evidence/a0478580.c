/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0478580, name: FUN_a0478580.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_a0478580(undefined4 *param_1)

{
  undefined4 uVar1;
  undefined4 local_20;
  undefined4 *local_1c;
  
  if (param_1 == (undefined4 *)0x0) {
    FUN_a02a70ec(s__s__InitCfg_is_NULL___a06261b8,s_AmpNetEventNotifier_init_a06260e8);
    uVar1 = 0xffffffff;
  }
  else if (DAT_a1a30ef4 == '\0') {
    _DAT_a1a30ef8 = *param_1;
    DAT_a1a30ef4 = '\x01';
    _DAT_a1a30efc = FUN_a03cd2d8(param_1[2]);
    local_20 = 1;
    local_1c = (undefined4 *)FUN_a03cd2d8(8);
    local_1c[1] = 1;
    *local_1c = &DAT_a0478418;
    FUN_a03caab4(0x10000009,1,s_LINK_RPC_SVC_EVENTNOTIFIER_a06261d0,param_1[1],_DAT_a1a30efc,
                 param_1[2],&local_20,1);
    FUN_a03cd264(local_1c);
    _DAT_a1a30ef0 = FUN_a03c4e94(0,0x20000009,1);
    uVar1 = 0;
  }
  else {
    uVar1 = 0;
  }
  return uVar1;
}

