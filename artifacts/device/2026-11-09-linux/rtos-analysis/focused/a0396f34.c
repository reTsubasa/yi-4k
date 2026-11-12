/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void eis_main_task(void)

{
  bool bVar1;
  bool bVar2;
  bool bVar3;
  uint uVar4;
  int iVar5;
  uint uVar6;
  uint uVar7;
  bool bVar8;
  undefined4 uVar9;
  uint local_174;
  uint local_160;
  uint local_138;
  int local_134;
  undefined4 local_130;
  undefined4 local_12c;
  undefined1 *local_128;
  undefined4 local_124;
  undefined1 auStack_120 [100];
  undefined4 local_bc;
  int local_b8;
  
  local_160 = local_160 & 0xffff0000;
  DAT_a170bcfc = 0;
  bVar1 = false;
  bVar2 = false;
  bVar3 = false;
  bVar8 = true;
  uVar6 = 0xffffffff;
  local_134 = 5;
  uVar7 = 0xffffffff;
  local_174 = 0xffffffff;
  uVar9 = 0xf;
  do {
    while( true ) {
      do {
        if (DAT_a170bcfc == 0) {
          if (!bVar8) {
            FUN_a02a70ec(s_eis_stop____a0601754);
            matched_FUN_a048e5cc(uVar9);
            matched_FUN_a02c1298(0x1a,matched_FUN_a0397500);
            matched_FUN_a02c1298(0x1c,matched_FUN_a03974d4);
            matched_FUN_a03bc4f0(&DAT_a170bb88,0xffffffff);
            image_command_dispatch(0x1001,0,0,0);
          }
          matched_thunk_FUN_a03c4218(&DAT_a170bd04);
          matched_FUN_a03bc3f0(&DAT_a170bc98,0xffffffff);
          FUN_a02a70ec(s_eis_init____task_ver__d_a0601760,0x1339ec9);
          image_command_dispatch(0x10ff,0xff,0,0);
          if (DAT_a170bd00 == 0) {
            uVar9 = 0;
          }
          else {
            uVar9 = 5;
          }
          image_command_dispatch(0x1012,uVar9,0,0);
          image_command_dispatch(0x1004,0x10a,0,0);
          image_command_dispatch(0x100a,DAT_a0757b68,0,0);
          FUN_a02a70ec(s_eis_range__d_a0601778,DAT_a0757b68);
          iVar5 = matched_FUN_a02210d4();
          if (iVar5 == 0) {
            FUN_a02a70ec(s_eis_init_without_rotation____a0601788);
            image_command_dispatch(0x1007,0,0,0);
          }
          else {
            image_command_dispatch(0x1007,1,4,0);
          }
          image_command_dispatch(0x1006,1,0,0);
          image_command_dispatch(0x1002,0,0,0);
          image_command_dispatch(0x1003,0,0,0);
          image_command_dispatch(0x1000,0,0,0);
          matched_FUN_a03bc4f0(&DAT_a170bb88,0xffffffff);
          bVar1 = false;
          matched_FUN_a02c11b0(0x1a,matched_FUN_a0397500);
          bVar3 = false;
          matched_FUN_a02c11b0(0x1c,matched_FUN_a03974d4);
          local_12c = 1000;
          local_130 = 1000;
          local_128 = &LAB_a03974c4;
          bVar2 = true;
          bVar8 = false;
          local_124 = 0;
          uVar9 = matched_FUN_a048e4bc(&local_130,0xffffffff);
          FUN_a02a70ec(s_eis_timer___d______d___d__a06017a8,uVar9,local_12c,local_130);
          matched_thunk_FUN_a03c4218(&DAT_a170bcdc);
          uVar6 = 0xffffffff;
          uVar7 = 0xffffffff;
          local_174 = 0xffffffff;
          DAT_a170bc88 = 0xffffffff;
          DAT_a170bc8c = 0xffffffff;
        }
        matched_FUN_a03bc4ac(&DAT_a170bb88,0xffff,1,&local_138,0xffffffff);
      } while ((DAT_a170bcfc & 0xfffffffb) == 0);
      if (DAT_a170bcfc == 3) {
        DAT_a170bcfc = 1;
        matched_thunk_FUN_a03c4218(&DAT_a170bcbc);
      }
      if (DAT_a170bcfc != 2) break;
      DAT_a170bcfc = 0;
      matched_thunk_FUN_a03c4218(&DAT_a170bb68);
    }
    if ((local_138 & 8) != 0) {
      if (bVar2) {
        if (uVar7 < DAT_a170ba84) {
          local_174 = DAT_a170ba84 - uVar7 >> 1;
          if (local_174 == 0) {
            local_174 = 1;
            bVar3 = false;
            bVar2 = false;
          }
          else {
            bVar2 = false;
            bVar3 = false;
          }
        }
        else {
          bVar2 = true;
        }
      }
      image_command_dispatch(0x100d,DAT_a170ba84,0,0);
    }
    uVar4 = DAT_a170bc90;
    if ((local_138 & 4) != 0) {
      DAT_a170bc88 = DAT_a170bc90;
      DAT_a170bc8c = DAT_a170ba88;
      DAT_a170ba8c = DAT_a170bc94;
      DAT_a170bcb8 = DAT_a170bd24;
      if (*(code **)(DAT_a1a30f20 + 0x18) != (code *)0x0) {
        (**(code **)(DAT_a1a30f20 + 0x18))(local_160 | 4,auStack_120);
      }
      bVar1 = true;
      bVar3 = true;
      iVar5 = matched_FUN_a0506418(local_b8 * 1000,local_bc);
      image_command_dispatch(0x100e,uVar4,0,0);
      image_command_dispatch(0x1011,&local_134,0,0);
      uVar6 = iVar5 - local_134;
      uVar7 = uVar4;
    }
    if ((local_138 & 1) != 0) {
      image_command_dispatch(0x100f,0,0,0);
    }
    uVar4 = matched_FUN_a048e63c();
    if (uVar7 < uVar4) {
      if ((local_174 <= uVar4 - uVar7) && (bVar3)) {
        bVar3 = false;
        DAT_a170ba88 = 0;
      }
      if ((uVar6 <= uVar4 - uVar7) && (bVar1)) {
        bVar1 = false;
        matched_FUN_a03bc4e8(&DAT_a170bb88,0x10000);
      }
    }
  } while( true );
}

