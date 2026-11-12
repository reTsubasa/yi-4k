/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa018756c, name: matched_FUN_a018756c.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Restarted to delay deadcode elimination for space: ram */

void matched_FUN_a018756c(void)

{
  undefined4 *puVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  undefined *puVar5;
  undefined4 local_68;
  undefined4 local_64;
  undefined4 local_60;
  undefined *local_5c;
  code *local_58;
  undefined4 local_54;
  undefined4 local_50;
  undefined4 local_4c;
  undefined4 local_48;
  undefined4 local_44;
  undefined4 local_40;
  undefined4 local_3c;
  undefined4 local_38;
  undefined4 local_34;
  undefined4 local_30;
  undefined4 local_2c;
  
  DAT_a0fd70dc = DAT_a0187de8 & 0xffffffc0;
  DAT_a0fd70d4 = DAT_a0fd70dc + 0x1dffffff;
  DAT_a0fd7114 = 0;
  DAT_a0fd7118 = 0;
  DAT_a0fd711c = 0;
  DAT_a0fe7220 = 0;
  DAT_a0fe7224 = 0;
  DAT_a0fe7228 = 0;
  DAT_a0fd7120 = 0;
  DAT_a0fe722c = 0;
  DAT_a0fd7124 = 0;
  DAT_a0fe7230 = 0;
  DAT_a0fd7128 = 0;
  DAT_a0fe7234 = 0;
  DAT_a0fd712c = 0;
  DAT_a0fe7238 = 0;
  DAT_a0fd7130 = 0;
  DAT_a0fe723c = 0;
  DAT_a0fd7134 = 0;
  DAT_a0fe7240 = 0;
  DAT_a0fd7138 = 0;
  DAT_a0fe7244 = 0;
  DAT_a0fd713c = 0;
  DAT_a0fe7248 = 0;
  DAT_a0fd7140 = 0;
  DAT_a0fe724c = 0;
  DAT_a0fd7144 = 0;
  DAT_a0fe7250 = 0;
  DAT_a0fd70d8 = 0x1e000000;
  matched_FUN_a03bc6b0(&DAT_a0fd7114,DAT_a0fd70dc + 0x1e000000,DAT_a0187dec - DAT_a0fd70d4);
  matched_FUN_a03bc6b0(&DAT_a0fe7220,0xa2100000,0x1000000);
  puVar1 = DAT_a0187df0;
  matched_FUN_a02a80f4(&DAT_a0fd7114);
  matched_FUN_a0482668();
  matched_FUN_a0296674();
  matched_thunk_FUN_a04902bc();
  matched_FUN_a0481cf8();
  matched_FUN_a0488ec0();
  matched_FUN_a01e66f4(&DAT_a0fd7114,&DAT_a0fe7220);
  matched_FUN_a01e6714(DAT_a0fd70dc,DAT_a0fd70d4,DAT_a0fd70d8);
  matched_FUN_a0187414();
  matched_FUN_a0186500(0);
  DAT_a1a355a4 = &PTR_gyro_get_info_a078b0bc;
  DAT_a1a3105c = &PTR_matched_FUN_a047aa74_a078af98;
  matched_FUN_a0296030();
  local_58 = (code *)0x1c200;
  local_54 = 3;
  local_48 = 0;
  local_4c = 0xa0828000;
  local_50 = 0x400;
  matched_FUN_a048e7bc(0,&local_58);
  local_50 = 0x400;
  local_48 = 0;
  local_4c = 0xa0828400;
  matched_FUN_a048e7bc(2,&local_58);
  local_58 = (code *)*puVar1;
  local_54 = puVar1[1];
  local_50 = puVar1[2];
  local_4c = puVar1[3];
  local_5c = &DAT_a0fe7254;
  local_60 = 0x40000;
  local_68 = 0xca;
  local_64 = 2;
  FUN_a02a6e3c(&local_68);
  matched_FUN_a02a702c(&local_58);
  matched_FUN_a02a6fb0(&LAB_a0296600);
  FUN_a02a70ec(s__________________________________a055bbb0);
  FUN_a02a70ec(s_CACHE____0x_08x___0x_08x____3d_M_a055bbdc,DAT_a0fd712c,
               DAT_a0fd712c + (DAT_a0fd7130 - 1),DAT_a0fd7130 >> 0x14);
  FUN_a02a70ec(s_DSP____0x_08x___0x_08x____3d_MB_a055bc04,DAT_a0fd70dc,DAT_a0fd70d4,
               DAT_a0fd70d8 >> 0x14);
  FUN_a02a70ec(s_NON_CACHE____0x_08x___0x_08x_____a055bc2c,DAT_a0fe7238,
               DAT_a0fe7238 + (DAT_a0fe723c - 1),DAT_a0fe723c >> 0x14);
  FUN_a02a70ec(s_LINUX____0x_08x___0x_08x____3d_M_a055bc54,0xdc000000,0xdfffffff,0x40);
  FUN_a02a70ec(s__________________________________a055bbb0);
  matched_FUN_a04891fc();
  matched_FUN_a04822c8();
  matched_FUN_a029e06c();
  matched_FUN_a032dfe0();
  matched_FUN_a029bcec();
  local_58 = (code *)puVar1[4];
  local_54 = puVar1[5];
  local_50 = puVar1[6];
  FUN_a02a70ec(s___d__EXTENC___d__s___s_a0621830 + 0x10,s_Main_NANDInit_a055b738,DAT_a0628938);
  iVar2 = matched_FUN_a0483140();
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_Init___fail__a055bc7c);
  }
  iVar2 = matched_FUN_a048331c(&local_58);
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_Config___faile__a055bc94);
  }
  iVar2 = matched_FUN_a04a0874(7);
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055bcb0);
  }
  iVar2 = matched_FUN_a04a0874(8);
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055bcf0);
  }
  iVar2 = matched_FUN_a04a0874(9);
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055bd30);
  }
  iVar2 = matched_FUN_a04a0874(10);
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055baf4);
  }
  iVar2 = matched_FUN_a04a0874(0xb);
  if (iVar2 != 0) {
    FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055bd6c);
  }
  iVar2 = matched_thunk_FUN_a0339e28(&DAT_a055bda8);
  if (iVar2 == 0) {
    iVar2 = matched_FUN_a048744c();
  }
  else {
    FUN_a02a70ec(s_AmbaFS_ChangeDir_____DRI_B_need_f_a055bdac);
    iVar2 = matched_FUN_a0483c78(0,1,0xb,5000);
    if (iVar2 != 0) {
      FUN_a02a70ec(s_AmbaNVM_ErasePartition_____AMBA__a055bdd4);
    }
    FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055be18);
    iVar2 = matched_FUN_a04a0874(0xb);
    if (iVar2 != 0) {
      FUN_a02a70ec(s_AmbaNAND_FtlInit_____AMBA_USER_P_a055bd6c);
    }
    FUN_a02a70ec(s_AmbaFS_Format_DrvB____start__a055be54);
    matched_thunk_FUN_a033a298(0x42,&DAT_a05a6c90);
    iVar2 = matched_FUN_a048744c();
  }
  if (iVar2 == 0) {
    iVar3 = matched_FUN_a02980c4();
  }
  else {
    FUN_a02a70ec(s__sAmbaNand_InitMiscBoardConfig___a055be74,DAT_a06f3080,iVar2);
    iVar3 = matched_FUN_a02980c4();
  }
  if (iVar3 < 1) {
    iVar2 = matched_FUN_a0487c20();
    if (iVar2 != 0) {
      FUN_a02a70ec(s__sAmbaNand_InitHWBoardConfig_____a055bea4,DAT_a06f3080);
    }
    iVar2 = 0;
    matched_FUN_a0197424(*(char *)(DAT_a078b608 + 5) != '\0');
  }
  local_4c = 300;
  local_38 = 2;
  local_34 = 0x20;
  local_48 = 0;
  local_44 = 0;
  local_30 = 0;
  local_2c = 0;
  local_58 = matched_FUN_a0296044;
  local_40 = 300000;
  local_3c = 150000000;
  local_50 = 1;
  local_54 = 0x1010101;
  matched_FUN_a0489bec(0,&local_58);
  local_4c = 300;
  local_38 = 2;
  local_34 = 0x20;
  local_58 = matched_FUN_a0296044;
  local_40 = 300000;
  local_3c = 150000000;
  local_48 = 0;
  local_44 = 0;
  local_30 = 0;
  local_2c = 0;
  local_50 = 1;
  local_54 = 0x1010101;
  matched_FUN_a0489bec(1,&local_58);
  matched_FUN_a0186f3c();
  if (iVar3 < 1) {
    matched_FUN_a047f944();
    matched_FUN_a04805e8();
    matched_FUN_a0483984(0);
  }
  else {
    matched_FUN_a0483984(0);
  }
  if (iVar2 < 0) {
    FUN_a02a70ec(s__s_AppMainTask__AmbaROM_Init_fai_a055bed0,DAT_a06f3080,iVar2);
  }
  matched_FUN_a0450338(&local_58);
  iVar2 = matched_FUN_a029a7d8(&DAT_a0fd7114,&DAT_a104e588,&DAT_a0fd70d0,0x500000,0x20);
  if (iVar2 == 0) {
    local_58 = DAT_a104e588;
    local_54 = 0x500000;
    local_44 = 0x8000;
    local_48 = 0x19;
    local_40 = 2;
    local_4c = 0xe;
    local_50 = 0x16;
    iVar2 = matched_FUN_a045037c(&local_58);
    if (iVar2 != 0) {
      FUN_a02a70ec(s__s_appmaintask__Main_FifoInit_fa_a055bf2c,DAT_a06f3080);
    }
  }
  else {
    FUN_a02a70ec(s__s_appmaintask__Main_FifoInit_ge_a055befc,DAT_a06f3080);
  }
  matched_FUN_a0187310();
  FUN_a02a70ec(s_AmbaUserAudioCodec_Init_a055bf54);
  matched_FUN_a02968f4();
  matched_FUN_a0204818();
  FUN_a029b1f8();
  FUN_a02a70ec(s__________________________________a055bf70);
  FUN_a02a70ec(s_BSP___s_a055bfa0,s_XiaoYi_Z16_a055bfa8);
  FUN_a02a70ec(s__________________________________a055bf70);
  uVar4 = matched_FUN_a0499f3c();
  FUN_a02a70ec(s_Cortex_freq___d_a055bfb4,uVar4);
  uVar4 = matched_FUN_a0499f80();
  FUN_a02a70ec(s_DDR_freq___d_a055bfc8,uVar4);
  uVar4 = matched_FUN_a0499fc0();
  FUN_a02a70ec(s_IDSP_freq___d_a055bfd8,uVar4);
  uVar4 = matched_FUN_a0499ef8();
  FUN_a02a70ec(s_Core_freq___d_a055bfe8,uVar4);
  uVar4 = matched_FUN_a049a110();
  FUN_a02a70ec(s_AXI_freq___d_a055bff8,uVar4);
  uVar4 = matched_FUN_a049a150();
  FUN_a02a70ec(s_AHB_freq___d_a055c008,uVar4);
  uVar4 = matched_FUN_a049a190();
  FUN_a02a70ec(s_APB_freq___d_a055c018,uVar4);
  FUN_a02a70ec(s__________________________________a055bf70);
  FUN_a02a70ec(s_______Version_info_______________a055c028);
  matched_FUN_a029b72c();
  FUN_a029b76c();
  FUN_a02a70ec(s_Create_SYS_ID___s_a0635564 + 0x10,s_Z16V13L_1_10_7_build_20180202122_a05361d0);
  FUN_a02a70ec(s__________________________________a055bf70);
  FUN_a029a824();
  matched_FUN_a02978b0();
  matched_FUN_a0296b7c(&LAB_a019d10c);
  matched_FUN_a0296b8c(&LAB_a019cf48);
  matched_FUN_a0296b9c();
  matched_FUN_a0187484();
  matched_FUN_a01e6258();
  if (iVar3 < 1) {
    puVar5 = (undefined *)0xa06cd13c;
  }
  else {
    puVar5 = &DAT_a06d1810;
  }
  matched_FUN_a01e5ce8(puVar5);
  matched_FUN_a01e627c();
  if (DAT_a104e58c == '\0') {
    matched_FUN_a0186e3c();
    matched_FUN_a0186ee8();
    DAT_a104e58c = '\x01';
  }
  return;
}

