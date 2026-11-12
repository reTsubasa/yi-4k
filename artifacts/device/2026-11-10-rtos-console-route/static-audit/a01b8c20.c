/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa01b8c20, name: matched_FUN_a01b8c20.
 * Types and names may be inferred. Runtime validation not performed. */


int matched_FUN_a01b8c20(void)

{
  int iVar1;
  
  FUN_a02a70ec(s__I__NET_CAR___06d___s___Start__a05701e0,0x31c,s_NetCar_UartTaskInit_a056fc0c);
  if (DAT_a1265270 == 1) {
    iVar1 = 0;
    goto LAB_a01b8d8c;
  }
  iVar1 = matched_FUN_a03bc534(&DAT_a126543c,&DAT_a1265478,0xc,10);
  if (iVar1 == 0) {
    iVar1 = matched_FUN_a029a7d8(DAT_a13a23e4,0xa1265350,&DAT_a1265354,0x2000,0x20);
    if (iVar1 < 0) {
      iVar1 = -2;
    }
    else {
      DAT_a126534c = 1;
      DAT_a1265430 = 1;
      iVar1 = matched_analyst_task_create
                        (&DAT_a1265274,s_NetCar_CliTask_a0570200,200,matched_FUN_a01b7994,0,
                         uRama1265350,0x2000,1);
      if (iVar1 < 0) {
        iVar1 = -3;
      }
      else {
        iVar1 = matched_FUN_a029a7d8(DAT_a13a23e4,0xa1265434,&DAT_a1265438,0x4000,0x20);
        if (iVar1 < 0) {
          iVar1 = -4;
        }
        else {
          if (DAT_a1265578 == 0) {
            iVar1 = matched_FUN_a03bc458(&DAT_a126557c);
            if (iVar1 != 0) {
              iVar1 = -5;
              goto LAB_a01b8db4;
            }
            DAT_a1265578 = DAT_a1265578 + 1;
          }
          iVar1 = matched_analyst_task_create
                            (&DAT_a1265358,s_NetCar_ExecTask_a0570210,200,matched_FUN_a01b8710,0,
                             uRama1265434,0x2000,1);
          if (-1 < iVar1) {
            DAT_a1265270 = 1;
            goto LAB_a01b8d8c;
          }
          iVar1 = -6;
        }
      }
    }
  }
  else {
    iVar1 = -1;
  }
LAB_a01b8db4:
  FUN_a02a70ec(s__s_E__NET_CAR___06d___s__Init_Er_a0570240,DAT_a06f3084,0x368,
               s_NetCar_UartTaskInit_a056fc0c,iVar1);
LAB_a01b8d8c:
  FUN_a02a70ec(s__I__NET_CAR___06d___s___End__a0570220,0x36a,s_NetCar_UartTaskInit_a056fc0c);
  return iVar1;
}

