/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void console_audit_a01b8710(void)

{
  uint uVar1;
  int iVar2;
  byte bVar3;
  byte *pbVar4;
  char cVar5;
  byte *pbVar6;
  byte bVar7;
  undefined4 local_524;
  undefined4 local_520;
  uint local_51c;
  char local_518 [128];
  char local_498 [126];
  char acStack_41a [7];
  undefined1 local_413;
  
  pbVar6 = (byte *)(acStack_41a + 2);
  local_524 = 0;
  local_520 = 0;
  local_51c = 0;
  matched_FUN_a04f8dec(pbVar6,0,0x400);
  matched_FUN_a04f8dec(local_518,0,0x80);
  matched_FUN_a04f8dec(local_498,0,0x80);
  do {
    if (DAT_a1265430 == 0) {
      return;
    }
    matched_FUN_a03bc56c(DAT_a01b8a98,&local_524,0xffffffff);
    uVar1 = matched_FUN_a01b7b70(local_524,local_51c & 0xffff,pbVar6,0x400);
    if (uVar1 == 0) {
      uVar1 = 0xfffffffe;
LAB_a01b897c:
      FUN_a02a70ec(s__s_E__NET_CAR___06d___s__Invaild_a0570188,DAT_a06f3084,0xfc,
                   s_NetCar_CheckPaceketValid_a056fc6c,uVar1);
      matched_FUN_a01b8638(pbVar6);
      FUN_a02a70ec(s__s_E__NET_CAR___06d___s__invalid_a05701b4,DAT_a06f3084,0x2ca,
                   s_NetCar_ExecTaskEntry_a056fca0);
    }
    else {
      if (uVar1 - 7 != (uint)CONCAT11(acStack_41a[6],local_413)) {
        FUN_a02a70ec(s__s_E__NET_CAR___06d___s__TotalLe_a0570088,DAT_a06f3084,0xda,
                     s_NetCar_CheckPaceketValid_a056fc6c,uVar1,
                     (uint)CONCAT11(acStack_41a[6],local_413));
        uVar1 = 0xfffffffd;
        goto LAB_a01b897c;
      }
      if (4 < (byte)acStack_41a[2]) {
        FUN_a02a70ec(s__s_E__NET_CAR___06d___s__pPacket_a05700bc,DAT_a06f3084,0xdf,
                     s_NetCar_CheckPaceketValid_a056fc6c,acStack_41a[2]);
        uVar1 = 0xfffffffc;
        goto LAB_a01b897c;
      }
      if (2 < (byte)acStack_41a[4]) {
        FUN_a02a70ec(s__s_E__NET_CAR___06d___s__pPacket_a05700ec,DAT_a06f3084,0xe4,
                     s_NetCar_CheckPaceketValid_a056fc6c,acStack_41a[4]);
        uVar1 = 0xfffffffb;
        goto LAB_a01b897c;
      }
      if (2 < (byte)acStack_41a[5]) {
        FUN_a02a70ec(s__s_E__NET_CAR___06d___s__pPacket_a0570120,DAT_a06f3084,0xe9,
                     s_NetCar_CheckPaceketValid_a056fc6c,acStack_41a[5]);
        uVar1 = 0xfffffffa;
        goto LAB_a01b897c;
      }
      if ((uVar1 & 0xffff) == 1) {
        bVar3 = 0;
        bVar7 = pbVar6[uVar1 - 1];
        if (bVar7 != 0) goto LAB_a01b8944;
      }
      else {
        cVar5 = '\0';
        pbVar4 = pbVar6;
        bVar7 = acStack_41a[2];
        while (cVar5 = bVar7 + cVar5, pbVar4 != pbVar6 + ((uVar1 & 0xffff) - 2 & 0xffff)) {
          pbVar4 = pbVar4 + 1;
          bVar7 = *pbVar4;
        }
        bVar3 = -cVar5;
        bVar7 = pbVar6[uVar1 - 1];
        if (bVar7 != bVar3) {
LAB_a01b8944:
          FUN_a02a70ec(s__s_E__NET_CAR___06d___s__CrvCalc_a0570150,DAT_a06f3084,0xf0,
                       s_NetCar_CheckPaceketValid_a056fc6c,bVar3,bVar7);
          uVar1 = 0xfffffff9;
          goto LAB_a01b897c;
        }
      }
      if (acStack_41a[uVar1] != '\0') {
        pbVar6[uVar1 - 1] = 0;
      }
      if ((int)uVar1 < 0) goto LAB_a01b897c;
      iVar2 = console_audit_a01b83fc(pbVar6,local_518,0x80,local_498,0x80);
      if (iVar2 < 0) {
        matched_FUN_a01b8638(pbVar6);
      }
      else if ((local_518[0] != '\0') && (local_498[0] != '\0')) {
        matched_FUN_a03bc46c(&DAT_a126557c,0xffffffff);
        matched_FUN_a04f9900(&DAT_a12654f8,local_518);
        matched_FUN_a04f9900(&DAT_a12655b0,local_498);
        matched_thunk_FUN_a03c3c5c(&DAT_a126557c);
        matched_thunk_FUN_a01e656c(0xd8090010,0,0);
      }
      matched_FUN_a04f8dec(local_518,0,0x80);
      matched_FUN_a04f8dec(local_498,0,0x80);
    }
    matched_FUN_a03bc7d0(&local_524);
  } while( true );
}

