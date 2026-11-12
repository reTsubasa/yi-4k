/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4
console_audit_a01b83fc
          (char *param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,undefined4 param_5
          )

{
  undefined2 uVar1;
  short sVar2;
  undefined2 uVar3;
  undefined1 *puVar4;
  undefined4 uVar5;
  undefined2 local_61e;
  undefined2 local_61c;
  undefined2 local_61a;
  undefined1 auStack_618 [512];
  undefined1 auStack_418 [512];
  undefined1 auStack_218 [512];
  
  uVar1 = 0;
  local_61e = 0;
  local_61c = 0;
  local_61a = 0;
  matched_FUN_a04f8dec(auStack_618,0,0x200);
  matched_FUN_a04f8dec(auStack_418,0,0x200);
  matched_FUN_a04f8dec(auStack_218,0,0x200);
  if (param_1 == (char *)0x0) {
    uVar5 = 0xffffffff;
    goto LAB_a01b84fc;
  }
  local_61c = *(undefined2 *)(param_1 + 2);
  local_61e = CONCAT11(param_1[1],3);
  FUN_a02a70ec(s__I__NET_CAR___06d___s__MsgType___a056ff44,0x252,
               s_NetCar_PacketParseAndSend_a056fc38,*param_1);
  FUN_a02a70ec(s__I__NET_CAR___06d___s__Seq___0x__a056ff6c,0x253,
               s_NetCar_PacketParseAndSend_a056fc38,param_1[1]);
  FUN_a02a70ec(s__I__NET_CAR___06d___s__ServiceID_a056ff90,0x254,
               s_NetCar_PacketParseAndSend_a056fc38,param_1[2]);
  FUN_a02a70ec(s__I__NET_CAR___06d___s__MsgID___0_a056ffbc,0x255,
               s_NetCar_PacketParseAndSend_a056fc38,param_1[3]);
  if (*param_1 == '\x01') {
    if (param_1[2] == '\x01') {
      puVar4 = (undefined1 *)0x0;
    }
    else {
      if (param_1[2] != '\x02') goto LAB_a01b84f8;
      if (param_1[3] == '\x01') {
        param_1 = param_1 + 6;
        uVar3 = matched_FUN_a04f99f0(param_1);
        console_audit_a01b8134(param_1,uVar3,param_2,param_3,param_4,param_5);
        FUN_a02a70ec(s__I__NET_CAR___06d___s__RevJs_____a056ffe4,0x260,
                     s_NetCar_PacketParseAndSend_a056fc38,param_1);
        puVar4 = (undefined1 *)0x0;
      }
      else {
        if (param_1[3] != '\x02') goto LAB_a01b84f8;
        uVar1 = FUN_a01b7fb0(auStack_218,0x200);
        FUN_a02a70ec(s__I__NET_CAR___06d___s__SndJs_____a0570008,0x268,
                     s_NetCar_PacketParseAndSend_a056fc38,auStack_218);
        puVar4 = auStack_218;
      }
    }
    sVar2 = matched_FUN_a01b7c50(&local_61e,puVar4,uVar1,auStack_618);
    if (sVar2 == 0) {
      uVar5 = 0xfffffffd;
    }
    else {
      sVar2 = matched_FUN_a01b7d20(auStack_618,sVar2,auStack_418);
      if (sVar2 != 0) {
        matched_FUN_a0231f18(sVar2,auStack_418);
        return 0;
      }
      uVar5 = 0xfffffffc;
    }
  }
  else {
LAB_a01b84f8:
    uVar5 = 0xfffffffe;
  }
LAB_a01b84fc:
  FUN_a02a70ec(s__I__NET_CAR___06d___s__sent_pack_a057002c,0x27c,
               s_NetCar_PacketParseAndSend_a056fc38,uVar5);
  return uVar5;
}

