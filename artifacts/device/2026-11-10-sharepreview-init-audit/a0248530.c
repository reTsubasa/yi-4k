/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 sharepreview_init(int *param_1)

{
  ushort uVar1;
  ushort uVar2;
  char cVar3;
  undefined4 *puVar4;
  int iVar5;
  undefined4 uVar6;
  int iVar7;
  int iVar8;
  undefined4 *puVar9;
  undefined4 *local_d0;
  undefined4 local_cc;
  char local_c8 [4];
  char acStack_c4 [4];
  char acStack_c0 [4];
  char acStack_bc [4];
  char local_b8 [4];
  undefined2 local_b4 [2];
  char acStack_b0 [4];
  char acStack_ac [4];
  char local_a8 [4];
  char acStack_a4 [4];
  char acStack_a0 [4];
  char acStack_9c [4];
  char local_98 [4];
  char acStack_94 [4];
  char acStack_90 [4];
  undefined2 local_8c;
  char local_29;
  
  cVar3 = DAT_a1443d18;
  local_d0 = (undefined4 *)0x0;
  local_cc = 0;
  if (DAT_a1443d18 != '\0') {
    matched_FUN_a04f93c4(local_c8,0xa0,s_already_inited__u__a05a83f4,DAT_a1443d18);
    local_29 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
                 s__Audio__Non_Init_a055c96c + 0xc,local_c8);
    puVar4 = DAT_a1443d44;
    puVar9 = DAT_a1443d38;
    DAT_a1443d44[1] = 0;
    puVar9[1] = 0;
    matched_analyst_dcache_flush(puVar4,0x38);
    matched_analyst_dcache_flush(DAT_a1443d38,8);
    return 0;
  }
  if (param_1 == (int *)0x0) {
    matched_FUN_a04f93c4(local_c8,0xa0,s_Invalid_conf__p__a05a8408,0);
    local_29 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s__Audio__Non_Init_a055c96c + 0xc,local_c8);
    uVar6 = 0xffffffff;
  }
  else {
    iVar5 = videoanal_is_initialized();
    if (iVar5 == 0) {
      local_c8[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0];
      local_c8[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[1];
      local_c8[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[2];
      local_c8[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[3];
      acStack_c4[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[4];
      acStack_c4[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[5];
      acStack_c4[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[6];
      acStack_c4[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[7];
      acStack_c0[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[8];
      acStack_c0[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[9];
      acStack_c0[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[10];
      acStack_c0[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xb];
      acStack_bc[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xc];
      acStack_bc[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xd];
      acStack_bc[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xe];
      acStack_bc[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xf];
      local_b8[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x10];
      local_b8[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x11];
      local_b8[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x12];
      local_b8[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x13];
      local_b4 = (undefined2  [2])s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc._20_4_;
      acStack_b0[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x18];
      acStack_b0[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x19];
      acStack_b0[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1a];
      acStack_b0[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1b];
      acStack_ac[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1c];
      acStack_ac[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1d];
      acStack_ac[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1e];
      acStack_ac[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1f];
      local_a8[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x20];
      local_a8[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x21];
      local_a8[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x22];
      local_a8[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x23];
      acStack_a4[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x24];
      acStack_a4[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x25];
      acStack_a4[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x26];
      acStack_a4[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x27];
      acStack_a0[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x28];
      acStack_a0[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x29];
      acStack_a0[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2a];
      acStack_a0[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2b];
      acStack_9c[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2c];
      acStack_9c[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2d];
      acStack_9c[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2e];
      acStack_9c[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2f];
      local_98[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x30];
      local_98[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x31];
      local_98[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x32];
      local_98[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x33];
      acStack_94[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x34];
      acStack_94[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x35];
      acStack_94[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x36];
      acStack_94[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x37];
      acStack_90[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x38];
      acStack_90[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x39];
      acStack_90[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x3a];
      acStack_90[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x3b];
      local_8c = (undefined2)ram0xa05a82f8;
      local_29 = 0;
      FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                   s__Audio__Non_Init_a055c96c + 0xc,local_c8);
      uVar6 = 0xffffffff;
    }
    else {
      iVar5 = *param_1;
      if (iVar5 == 0) {
        matched_FUN_a04f93c4(local_c8,0xa0,s_Invalid_MemoryPool__p__a05a841c,0);
        local_29 = 0;
        FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                     s__Audio__Non_Init_a055c96c + 0xc,local_c8);
        uVar6 = 0xfffffffe;
      }
      else {
        uVar1 = *(ushort *)(param_1 + 5);
        if (uVar1 == 0) {
          matched_FUN_a04f93c4(local_c8,0xa0,s_Invalid_FrameWidth__u__a05a8434,0);
          local_29 = (char)uVar1;
          FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                       s__Audio__Non_Init_a055c96c + 0xc,local_c8);
          uVar6 = 0xfffffffd;
        }
        else {
          uVar2 = *(ushort *)((int)param_1 + 0x16);
          if (uVar2 == 0) {
            matched_FUN_a04f93c4(local_c8,0xa0,s_Invalid_FrameHeight__u__a05a844c,0);
            local_29 = (char)uVar2;
            FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                         s__Audio__Non_Init_a055c96c + 0xc,local_c8);
            uVar6 = 0xfffffffc;
          }
          else {
            iVar8 = (uint)uVar2 * (uint)uVar1;
            DAT_a1443d30 = (undefined2)param_1[4];
            DAT_a1443d32 = *(undefined2 *)((int)param_1 + 0x12);
            iVar7 = iVar8 * 3 + 0x38;
            DAT_a1443d20 = iVar5;
            DAT_a1443d34 = uVar1;
            DAT_a1443d36 = uVar2;
            iVar5 = matched_FUN_a029a7d8(iVar5,&local_d0,&local_cc,iVar7,0x20);
            if (iVar5 == 0) {
              matched_FUN_a04f8dec(local_d0,0,iVar7);
              DAT_a1443d3c = iVar7;
              local_d0[1] = 0;
              *local_d0 = local_cc;
              iVar5 = DAT_a1443d20;
              DAT_a1443d44 = local_d0;
              puVar9 = local_d0 + 0xe;
              local_d0[0xc] = (undefined4 *)((int)puVar9 + iVar8);
              local_d0[0xd] = (undefined1 *)((int)puVar9 + iVar8 * 2);
              local_d0[0xb] = puVar9;
              local_d0 = puVar9;
              iVar5 = matched_FUN_a029a7d8(iVar5,&local_d0,&local_cc,8,0x20);
              if (iVar5 == 0) {
                DAT_a1443d48 = 8;
                *(undefined1 *)local_d0 = 0;
                *(undefined1 *)((int)local_d0 + 1) = 0;
                *(undefined1 *)((int)local_d0 + 2) = 0;
                *(undefined1 *)((int)local_d0 + 3) = 0;
                *(undefined1 *)(local_d0 + 1) = 0;
                *(undefined1 *)((int)local_d0 + 5) = 0;
                *(undefined1 *)((int)local_d0 + 6) = 0;
                *(undefined1 *)((int)local_d0 + 7) = 0;
                *local_d0 = local_cc;
                local_d0[1] = 0;
                DAT_a1443d38 = local_d0;
                sharepreview_register(param_1[1],param_1[2]);
                DAT_a1443d18 = '\x01';
                uVar6 = 0;
              }
              else {
                local_c8[0] = s_Fail_to_create_buffer_a05a8464[0];
                local_c8[1] = s_Fail_to_create_buffer_a05a8464[1];
                local_c8[2] = s_Fail_to_create_buffer_a05a8464[2];
                local_c8[3] = s_Fail_to_create_buffer_a05a8464[3];
                acStack_c4[0] = s_Fail_to_create_buffer_a05a8464[4];
                acStack_c4[1] = s_Fail_to_create_buffer_a05a8464[5];
                acStack_c4[2] = s_Fail_to_create_buffer_a05a8464[6];
                acStack_c4[3] = s_Fail_to_create_buffer_a05a8464[7];
                acStack_c0[0] = s_Fail_to_create_buffer_a05a8464[8];
                acStack_c0[1] = s_Fail_to_create_buffer_a05a8464[9];
                acStack_c0[2] = s_Fail_to_create_buffer_a05a8464[10];
                acStack_c0[3] = s_Fail_to_create_buffer_a05a8464[0xb];
                acStack_bc[0] = s_Fail_to_create_buffer_a05a8464[0xc];
                acStack_bc[1] = s_Fail_to_create_buffer_a05a8464[0xd];
                acStack_bc[2] = s_Fail_to_create_buffer_a05a8464[0xe];
                acStack_bc[3] = s_Fail_to_create_buffer_a05a8464[0xf];
                local_b8[0] = s_Fail_to_create_buffer_a05a8464[0x10];
                local_b8[1] = s_Fail_to_create_buffer_a05a8464[0x11];
                local_b8[2] = s_Fail_to_create_buffer_a05a8464[0x12];
                local_b8[3] = s_Fail_to_create_buffer_a05a8464[0x13];
                local_b4[0] = (short)ram0xa05a8478;
                local_29 = 0;
                FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,
                             s__AppLib___NetSharePreview__a05a8070,s__Audio__Non_Init_a055c96c + 0xc
                             ,local_c8);
                matched_analyst_pool_free(*DAT_a1443d44);
                uVar6 = 0xfffffff9;
                DAT_a1443d44 = (undefined4 *)0x0;
              }
            }
            else {
              local_c8[0] = s_Fail_to_create_buffer_a05a8464[0];
              local_c8[1] = s_Fail_to_create_buffer_a05a8464[1];
              local_c8[2] = s_Fail_to_create_buffer_a05a8464[2];
              local_c8[3] = s_Fail_to_create_buffer_a05a8464[3];
              acStack_c4[0] = s_Fail_to_create_buffer_a05a8464[4];
              acStack_c4[1] = s_Fail_to_create_buffer_a05a8464[5];
              acStack_c4[2] = s_Fail_to_create_buffer_a05a8464[6];
              acStack_c4[3] = s_Fail_to_create_buffer_a05a8464[7];
              acStack_c0[0] = s_Fail_to_create_buffer_a05a8464[8];
              acStack_c0[1] = s_Fail_to_create_buffer_a05a8464[9];
              acStack_c0[2] = s_Fail_to_create_buffer_a05a8464[10];
              acStack_c0[3] = s_Fail_to_create_buffer_a05a8464[0xb];
              acStack_bc[0] = s_Fail_to_create_buffer_a05a8464[0xc];
              acStack_bc[1] = s_Fail_to_create_buffer_a05a8464[0xd];
              acStack_bc[2] = s_Fail_to_create_buffer_a05a8464[0xe];
              acStack_bc[3] = s_Fail_to_create_buffer_a05a8464[0xf];
              local_b8[0] = s_Fail_to_create_buffer_a05a8464[0x10];
              local_b8[1] = s_Fail_to_create_buffer_a05a8464[0x11];
              local_b8[2] = s_Fail_to_create_buffer_a05a8464[0x12];
              local_b8[3] = s_Fail_to_create_buffer_a05a8464[0x13];
              local_b4[0] = (short)ram0xa05a8478;
              local_29 = cVar3;
              FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,
                           s__AppLib___NetSharePreview__a05a8070,s__Audio__Non_Init_a055c96c + 0xc,
                           local_c8);
              uVar6 = 0xfffffffa;
            }
          }
        }
      }
    }
  }
  return uVar6;
}

