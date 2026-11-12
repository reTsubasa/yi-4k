/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa023e230, name: FUN_a023e230.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_a023e230(int param_1)

{
  int iVar1;
  int iVar2;
  int local_58;
  undefined4 local_54;
  undefined4 local_50;
  undefined4 local_4c;
  undefined4 local_48;
  undefined4 local_44;
  int local_40 [10];
  
  if (DAT_a143b5fc == '\0') {
    iVar1 = FUN_a029a7d8(_DAT_a13a23e4,&DAT_a143bb48,0xa143b53c,0x400,0x20);
    if (-1 < iVar1) {
      if (param_1 == 0) {
        FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a3278,DAT_a06f3080);
      }
      else {
        FUN_a047628c(&local_58);
        local_54 = *(undefined4 *)(param_1 + 0x1c);
        local_58 = param_1;
        iVar1 = FUN_a04762c8(&local_58);
        if (iVar1 == 0) {
          iVar1 = FUN_a047623c(FUN_a023d1cc);
          if (iVar1 != 0) {
            FUN_a02a70ec(s__s_______Register_remote_command_a05a3304,DAT_a06f3080);
          }
          iVar1 = FUN_a0476b2c(local_40);
          if (iVar1 == 0) {
            local_40[0] = 1;
            iVar1 = FUN_a0476bb4(local_40,&local_50);
            if (iVar1 == 0) {
              _DAT_a143bb38 = local_50;
              _DAT_a143bb3c = local_4c;
              FUN_a01b65e0(&DAT_a143bb38);
              iVar1 = FUN_a0476f24(&local_50,&LAB_a0242a68);
              if (iVar1 == 0) {
                iVar1 = FUN_a0476264(FUN_a023d1cc);
                if (iVar1 == 0) {
                  iVar1 = FUN_a0477148(local_40);
                }
                else {
                  FUN_a02a70ec(s__s_______Register_remote_data_ca_a05a3450,DAT_a06f3080);
                  iVar1 = FUN_a0477148(local_40);
                }
                if (iVar1 == 0) {
                  iVar1 = FUN_a04771d0(local_40,&local_48);
                  if (iVar1 == 0) {
                    iVar1 = FUN_a0477404(&local_48,FUN_a023f840);
                    if (iVar1 == 0) {
                      _DAT_a143f5dc = local_48;
                      _DAT_a143f5e0 = local_44;
                      FUN_a04f8dec(0xa143bb50,0,0x3a7c);
                      iVar1 = FUN_a03bc534(0xa143f528,0xa143f350,0x20,8);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a35b0,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc2bc(0xa143f450,s_AppLib_Net_Control_Manager_a05a35f4,0xa6,
                                           FUN_a0242e2c,0,0xa143bb50,0x3800,1);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a3610,DAT_a06f3080,
                                     s_AppLib_Net_Control_Manager_a05a35f4,iVar1);
                        return iVar1;
                      }
                      iVar1 = thunk_FUN_a03c0bc4(0xa143f450,1);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>___a05a3658,DAT_a06f3080,
                                     s_AppLib_Net_Control_Manager_a05a35f4,2,iVar1);
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc458(DAT_a023e808);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a36a4,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc458(DAT_a023e80c);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a36f0,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc458(0xa143f668);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a3734,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc458(0xa143b488);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a377c,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc458(0xa143b704);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a37c4,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc458(0xa143b4ec);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a380c,DAT_a06f3080,iVar1)
                        ;
                        return iVar1;
                      }
                      iVar1 = FUN_a03bc49c(0xa143b5c4);
                      if (iVar1 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_C_a05a3854,DAT_a06f3080);
                        return -1;
                      }
                      FUN_a0473f18(local_40);
                      local_40[0] = param_1;
                      iVar2 = FUN_a0473f54(local_40);
                      if (iVar2 != 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<InitJso_a05a3898,DAT_a06f3080);
                        return -1;
                      }
                      FUN_a0476214(FUN_a023d1cc);
                      iVar2 = FUN_a0476380();
                      if (iVar2 < 0) {
                        FUN_a02a70ec(s__s_AppLib___NetControl__<InitLin_a05a38e8,DAT_a06f3080);
                        return -1;
                      }
                      FUN_a03bc46c(DAT_a023e808,0xffffffff);
                      _DAT_a143b4c4 = iVar1;
                      thunk_FUN_a03c3c5c(DAT_a023e808);
                      DAT_a143b5fc = 1;
                      return 0;
                    }
                    FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a3554,DAT_a06f3080,iVar1);
                  }
                  else {
                    FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a34f0,DAT_a06f3080);
                  }
                }
                else {
                  FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a3488,DAT_a06f3080);
                }
              }
              else {
                FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a33f8,DAT_a06f3080);
              }
            }
            else {
              FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a339c,DAT_a06f3080);
            }
          }
          else {
            FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a333c,DAT_a06f3080);
          }
        }
        else {
          FUN_a02a70ec(s__s_AppLib___NetControl__<InitNet_a05a32b4,DAT_a06f3080);
        }
      }
      return -1;
    }
    iVar1 = -1;
    FUN_a02a70ec(s__s_AppLib___NetControl__<Init>_A_a05a3230,DAT_a06f3080);
  }
  else {
    iVar1 = 0;
    FUN_a02a70ec(s__AppLib___NetControl__<Init>_ini_a05a3204);
  }
  return iVar1;
}

