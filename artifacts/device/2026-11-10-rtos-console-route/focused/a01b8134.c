/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4
console_audit_a01b8134
          (undefined4 param_1,uint param_2,undefined4 param_3,undefined4 param_4,undefined4 param_5,
          undefined4 param_6)

{
  undefined4 uVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  undefined1 auStack_98 [128];
  
  matched_FUN_a04f8dec(auStack_98,0,0x80);
  if (param_2 < 0x80) {
    uVar1 = matched_FUN_a04f99f0(param_1);
    iVar2 = matched_FUN_a01b577c(param_1,uVar1);
    if (iVar2 == 0) {
      FUN_a02a70ec(s__s_E__NET_CAR___06d___s__Josn_pr_a056fddc,DAT_a06f3084,0x212,
                   s_NetCar_JsonPraseVehicleInfo_a057032c);
      uVar1 = 0xfffffffe;
    }
    else {
      matched_FUN_a01b7e08(iVar2,s_VehicleID_a056fe08,auStack_98,0x80);
      FUN_a02a70ec(s__I__NET_CAR___06d___s__VehicleID_a056fe14,0x216,
                   s_NetCar_JsonPraseVehicleInfo_a057032c,auStack_98);
      matched_FUN_a04f8dec(auStack_98,0,0x80);
      iVar3 = matched_FUN_a01b7d5c(iVar2,s_WifiInfo_a056fe3c);
      if (iVar3 == 0) {
        FUN_a02a70ec(s__s_E__NET_CAR___06d___s__Sub_Jos_a056fe48,DAT_a06f3084,0x21d,
                     s_NetCar_JsonPraseVehicleInfo_a057032c);
        uVar1 = 0xfffffffd;
      }
      else {
        iVar4 = matched_FUN_a01b7e08(iVar3,s_STA_SSID_a054f774 + 4,auStack_98,0x80);
        if (-1 < iVar4) {
          matched_FUN_a04f93c4(param_3,param_4,s_Create_SYS_ID___s_a0635564 + 0x10,auStack_98);
          FUN_a02a70ec(s__I__NET_CAR___06d___s__SSID___s__a056fe78,0x223,
                       s_NetCar_JsonPraseVehicleInfo_a057032c,auStack_98,param_3);
          matched_FUN_a04f8dec(auStack_98,0,0x80);
        }
        iVar4 = matched_FUN_a01b7e08(iVar3,&DAT_a056fd88,auStack_98,0x80);
        if (-1 < iVar4) {
          FUN_a02a70ec(s__I__NET_CAR___06d___s__Mac___s_a056fea4,0x229,
                       s_NetCar_JsonPraseVehicleInfo_a057032c,auStack_98);
          matched_FUN_a04f8dec(auStack_98,0,0x80);
        }
        iVar4 = matched_FUN_a01b7e08(iVar3,&DAT_a056fec4,auStack_98,0x80);
        if (-1 < iVar4) {
          matched_FUN_a04f93c4(param_5,param_6,s_Create_SYS_ID___s_a0635564 + 0x10,auStack_98);
          FUN_a02a70ec(s__I__NET_CAR___06d___s__Pwd___s__C_a056fec8,0x22f,
                       s_NetCar_JsonPraseVehicleInfo_a057032c,auStack_98,param_5);
          matched_FUN_a04f8dec(auStack_98,0,0x80);
        }
        iVar3 = matched_FUN_a01b7e08(iVar3,s_Extend_a056fd94,auStack_98,0x80);
        if (-1 < iVar3) {
          FUN_a02a70ec(s__I__NET_CAR___06d___s__Extend____a056fef8,0x234,
                       s_NetCar_JsonPraseVehicleInfo_a057032c,auStack_98);
          matched_FUN_a04f8dec(auStack_98,0,0x80);
        }
        matched_FUN_a01b57bc(iVar2);
        FUN_a02a70ec(s__I__NET_CAR___06d___s__Json_pras_a056ff1c,0x238,
                     s_NetCar_JsonPraseVehicleInfo_a057032c);
        uVar1 = 0;
      }
    }
  }
  else {
    FUN_a02a70ec(s__s_E__NET_CAR___06d___s__js_stri_a056fda0,DAT_a06f3084,0x20b,
                 s_NetCar_JsonPraseVehicleInfo_a057032c,0x80,param_2);
    uVar1 = 0xffffffff;
  }
  return uVar1;
}

