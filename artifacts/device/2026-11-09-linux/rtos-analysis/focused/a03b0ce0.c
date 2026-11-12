/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Removing unreachable block (ram,0xa03af230) */
/* WARNING: Removing unreachable block (ram,0xa03af238) */
/* WARNING: Removing unreachable block (ram,0xa03af23c) */
/* WARNING: Heritage AFTER dead removal. Example location: s1 : 0xa0367430 */
/* WARNING: Restarted to delay deadcode elimination for space: register */

float * image_command_dispatch(uint param_1,int *param_2,float *param_3,double *param_4)

{
  short sVar1;
  byte bVar2;
  undefined1 uVar3;
  undefined1 *puVar4;
  float *pfVar5;
  undefined *puVar6;
  ushort *puVar7;
  undefined1 *puVar8;
  undefined4 extraout_r1;
  int iVar9;
  undefined4 extraout_r1_00;
  undefined4 extraout_r1_01;
  float fVar10;
  uint uVar11;
  ushort *puVar12;
  int iVar13;
  float fVar14;
  int iVar15;
  uint uVar16;
  uint uVar17;
  ushort uVar18;
  undefined1 *puVar19;
  int iVar20;
  float fVar21;
  int iVar22;
  uint uVar23;
  ushort *puVar24;
  int *piVar25;
  uint uVar26;
  uint uVar27;
  int *piVar28;
  uint *puVar29;
  undefined2 *puVar30;
  short *psVar31;
  int *piVar32;
  uint uVar33;
  undefined2 *puVar34;
  char *pcVar35;
  double *pdVar36;
  double *pdVar37;
  int iVar38;
  undefined4 *puVar39;
  bool bVar40;
  uint in_fpscr;
  double dVar41;
  undefined4 uVar42;
  undefined4 uVar43;
  double dVar44;
  undefined8 unaff_d8;
  double dVar45;
  double dVar46;
  undefined8 uVar47;
  undefined1 auStack_110 [8];
  uint *local_108;
  uint uStack_104;
  ushort *local_100;
  int iStack_fc;
  ushort *local_f8;
  int iStack_f4;
  ushort *local_f0;
  int iStack_ec;
  uint local_e8;
  uint uStack_e4;
  uint local_e0;
  int iStack_dc;
  uint local_d8;
  int iStack_d4;
  uint local_d0;
  int iStack_cc;
  uint local_c8;
  int iStack_c4;
  ushort *local_c0;
  uint local_bc;
  uint *local_b8;
  short *local_b4;
  int *local_b0;
  uint local_ac;
  uint local_a8;
  int local_a4;
  int local_a0;
  int local_9c;
  int local_98;
  uint local_94;
  uint local_90;
  int local_8c;
  undefined4 local_88;
  undefined4 local_84;
  short local_80 [4];
  int local_78 [4];
  undefined8 local_68;
  undefined4 local_60;
  int local_5c;
  undefined4 local_58;
  uint local_54 [2];
  int *local_4c;
  uint local_48;
  int *local_44;
  uint local_40;
  float local_3c;
  ushort *local_38;
  float local_34;
  float local_30;
  float local_2c;
  float local_28;
  undefined4 in_stack_ffffffdc;
  
  iVar9 = DAT_a1739b1c;
  dVar44 = DAT_a03ad120;
  dVar41 = DAT_a03acfc8;
  dVar46 = DAT_a03ace70;
  if (param_1 == 0xa7c) {
    matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
    iVar15 = (&DAT_a1739a7c)[(int)param_2];
    iVar9 = *(int *)((int)param_4 + 4);
    iVar13 = *(int *)(param_4 + 1);
    iVar20 = *(int *)((int)param_4 + 0xc);
    if (((uint)param_3 & 0xff) == 0) {
      piVar32 = (int *)(iVar15 + 0x19c9c);
    }
    else {
      piVar32 = (int *)(iVar15 + 0x19cd8);
    }
    *piVar32 = *(int *)param_4;
    piVar32[1] = iVar9;
    piVar32[2] = iVar13;
    piVar32[3] = iVar20;
    iVar9 = *(int *)((int)param_4 + 0x14);
    iVar13 = *(int *)(param_4 + 3);
    iVar20 = *(int *)((int)param_4 + 0x1c);
    piVar32[4] = *(int *)(param_4 + 2);
    piVar32[5] = iVar9;
    piVar32[6] = iVar13;
    piVar32[7] = iVar20;
    iVar9 = *(int *)((int)param_4 + 0x24);
    iVar13 = *(int *)(param_4 + 5);
    iVar20 = *(int *)((int)param_4 + 0x2c);
    piVar32[8] = *(int *)(param_4 + 4);
    piVar32[9] = iVar9;
    piVar32[10] = iVar13;
    piVar32[0xb] = iVar20;
    iVar9 = *(int *)((int)param_4 + 0x34);
    iVar13 = *(int *)(param_4 + 7);
    piVar32[0xc] = *(int *)(param_4 + 6);
    piVar32[0xd] = iVar9;
    piVar32[0xe] = iVar13;
    matched_thunk_FUN_a03c3c5c(iVar15);
    return (float *)0x0;
  }
  uVar3 = SUB41(param_3,0);
  local_30 = (float)unaff_d8;
  local_2c = (float)((ulonglong)unaff_d8 >> 0x20);
  if (param_1 < 0xa7d) {
    if (param_1 == 0xa27) {
      FUN_a0375cac(param_2,param_3);
      return (float *)0x0;
    }
    if (param_1 < 0xa28) {
      if (param_1 == 0xa08) {
        fVar10 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4954);
        param_3[4] = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4d0c);
        param_3[3] = fVar10;
        iVar9 = (&DAT_a1739a7c)[(int)param_2];
        fVar10 = param_3[1];
        fVar14 = param_3[2];
        fVar21 = param_3[3];
        *(float *)(iVar9 + 0x4958) = *param_3;
        *(float *)(iVar9 + 0x495c) = fVar10;
        *(float *)(iVar9 + 0x4960) = fVar14;
        *(float *)(iVar9 + 0x4964) = fVar21;
        *(float *)(iVar9 + 0x4968) = param_3[4];
        return (float *)0x0;
      }
      if (param_1 < 0xa09) {
        if (param_1 == 0xe6) {
          matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
          *(short *)((&DAT_a1739a7c)[(int)param_2] + 0x18b54) = (short)param_3;
          matched_thunk_FUN_a03c3c5c();
          return (float *)0x0;
        }
        if (param_1 < 0xe7) {
          if (param_1 == 5) {
            pfVar5 = (float *)matched_FUN_a03aaa74(param_2,param_3,param_3,param_4);
            return pfVar5;
          }
          if (param_1 < 6) {
            if (param_1 == 2) {
              matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
              matched_FUN_a029c680(param_3,(&DAT_a1739a7c)[(int)param_2] + 0x34,0x3a90);
              matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
              return (float *)0x0;
            }
            if (param_1 < 3) {
              if (param_1 == 1) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                matched_FUN_a029c680(iVar9 + 0x34,param_3,0x3a90);
                matched_thunk_FUN_a03c3c5c(iVar9);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 3) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                matched_FUN_a029c680(iVar9 + 0x3ac4,param_3,0xe90);
                matched_thunk_FUN_a03c3c5c(iVar9);
                return (float *)0x0;
              }
              if (param_1 == 4) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                matched_FUN_a029c680(param_3,(&DAT_a1739a7c)[(int)param_2] + 0x3ac4,0xe90);
                matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
                return (float *)0x0;
              }
            }
          }
          else {
            if (param_1 == 0xe3) {
              uVar3 = matched_FUN_a03b0cd0();
              *(undefined1 *)param_2 = uVar3;
              return (float *)0x0;
            }
            if (param_1 < 0xe4) {
              if (param_1 == 6) {
                pfVar5 = (float *)matched_FUN_a03aaab0(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
              if (param_1 == 0xe2) {
                matched_FUN_a03b0cc0((char)*param_2);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xe4) {
                matched_FUN_a0367a24(param_2);
                matched_FUN_a0374ef0(param_3);
                matched_FUN_a03658d8(param_4);
                return (float *)0x0;
              }
              if (param_1 == 0xe5) {
                *param_2 = 0x13f5;
                return (float *)0x0;
              }
            }
          }
        }
        else {
          if (param_1 == 0xa02) {
            if (*(code **)(DAT_a1a30f20 + 0x18) != (code *)0x0) {
              (**(code **)(DAT_a1a30f20 + 0x18))(0,param_3);
            }
            return (float *)0x0;
          }
          if (param_1 < 0xa03) {
            if (param_1 == 0xe9) {
              pfVar5 = (float *)matched_FUN_a03ae0c0(param_2,param_3,param_3,param_4);
              return pfVar5;
            }
            if (param_1 < 0xea) {
              if (param_1 == 0xe7) {
                pfVar5 = (float *)matched_FUN_a03ae040(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
              if (param_1 == 0xe8) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                fVar10 = param_3[1];
                fVar14 = param_3[2];
                fVar21 = param_3[3];
                *(float *)(iVar9 + 0x18b58) = *param_3;
                *(float *)(iVar9 + 0x18b5c) = fVar10;
                *(float *)(iVar9 + 0x18b60) = fVar14;
                *(float *)(iVar9 + 0x18b64) = fVar21;
                matched_thunk_FUN_a03c3c5c(iVar9);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa00) {
                pfVar5 = (float *)matched_FUN_a03ab424(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
              if (param_1 == 0xa01) {
                pfVar5 = (float *)matched_FUN_a03aaaf0(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
            }
          }
          else {
            if (param_1 == 0xa05) {
              matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
              *param_3 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4954);
              matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
              return (float *)0x0;
            }
            if (param_1 < 0xa06) {
              if (param_1 == 0xa03) {
                if (*(int *)((&DAT_a1739a7c)[(int)param_2] + 0x19d18) == 0xea25) {
                  image_command_dispatch(0xa02,param_2,auStack_110,0);
                  fVar10 = (float)matched_FUN_a0506418(local_ac + (local_a8 >> 1),local_a8);
                  *param_3 = fVar10;
                  iVar9 = matched_FUN_a0506418(local_ac * 1000,local_a8);
                  if (param_4 != (double *)0x0) {
                    *(int *)param_4 = iVar9;
                    return (float *)0x0;
                  }
                }
                else {
                  *param_3 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x19d14);
                  if (param_4 != (double *)0x0) {
                    *(int *)param_4 = *(int *)((&DAT_a1739a7c)[(int)param_2] + 0x19d18);
                  }
                }
                return (float *)0x0;
              }
              if (param_1 == 0xa04) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(float **)((&DAT_a1739a7c)[(int)param_2] + 0x4954) = param_3;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa06) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(float **)((&DAT_a1739a7c)[(int)param_2] + 0x4d0c) = param_3;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
              if (param_1 == 0xa07) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *param_3 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4d0c);
                matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
                return (float *)0x0;
              }
            }
          }
        }
      }
      else {
        if (param_1 == 0xa13) {
          pfVar5 = (float *)matched_FUN_a03ab594
                                      (param_2,(uint)param_3 & 0xff,(uint)param_4 & 0xff,param_4);
          return pfVar5;
        }
        if (param_1 < 0xa14) {
          if (param_1 == 0xa0d) {
            local_48 = (uint)*(ushort *)((int)param_3 + 6);
            local_44 = (int *)param_3[2];
            local_40 = (uint)param_3[3];
            local_3c = param_3[4];
            local_38 = (ushort *)param_3[5];
            local_30 = (float)(uint)*(ushort *)(param_3 + 7);
            local_34 = param_3[6];
            local_2c = (float)(uint)*(byte *)((int)param_3 + 0x1e);
            local_28 = (float)(uint)*(byte *)((int)param_3 + 0x1f);
            pfVar5 = (float *)matched_FUN_a035b4c0
                                        (param_2,*(undefined1 *)param_3,
                                         *(ushort *)((int)param_3 + 2),*(ushort *)(param_3 + 1));
            return pfVar5;
          }
          if (param_1 < 0xa0e) {
            if (param_1 == 0xa0a) {
              pfVar5 = (float *)matched_FUN_a03aaf94(param_2,(uint)param_3 & 0xff,param_4,param_4);
              return pfVar5;
            }
            if (param_1 < 0xa0a) {
              matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
              iVar9 = (&DAT_a1739a7c)[(int)param_2];
              fVar10 = *(float *)(iVar9 + 0x495c);
              fVar14 = *(float *)(iVar9 + 0x4960);
              fVar21 = *(float *)(iVar9 + 0x4964);
              *param_3 = *(float *)(iVar9 + 0x4958);
              param_3[1] = fVar10;
              param_3[2] = fVar14;
              param_3[3] = fVar21;
              param_3[4] = *(float *)(iVar9 + 0x4968);
              matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
              return (float *)0x0;
            }
            if (param_1 == 0xa0b) {
              matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
              switch((uint)param_3 & 0xff) {
              case 1:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0x0;
                *(double **)(iVar9 + 0x10638) = param_4;
                break;
              default:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0xffffffff;
                break;
              case 3:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0x0;
                *(double **)(iVar9 + 0x10634) = param_4;
                break;
              case 5:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0x0;
                *(double **)(iVar9 + 0x1063c) = param_4;
                break;
              case 6:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0x0;
                *(double **)(iVar9 + 0x10640) = param_4;
                break;
              case 7:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0x0;
                *(double **)(iVar9 + 0x10644) = param_4;
                break;
              case 9:
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                pfVar5 = (float *)0x0;
                *(double **)(iVar9 + 0x10648) = param_4;
              }
              matched_thunk_FUN_a03c3c5c(iVar9);
              return pfVar5;
            }
            if (param_1 == 0xa0c) {
              if (((uint)param_4 & 0xff) == 1) {
                matched_FUN_a03b29a8(param_2,*(undefined1 *)((int)param_3[0x14] + 0x904));
              }
              local_38 = (ushort *)(uint)*(ushort *)((int)param_3 + 6);
              local_34 = param_3[0xc];
              local_30 = param_3[0xd];
              local_2c = param_3[0xe];
              local_28 = param_3[0xf];
              pfVar5 = (float *)matched_FUN_a035603c
                                          (param_2,1,*(ushort *)(param_3 + 2),
                                           *(ushort *)(param_3 + 1));
              return pfVar5;
            }
          }
          else {
            if (param_1 == 0xa10) {
              pfVar5 = (float *)matched_FUN_a03ab3c0(param_2,param_3,param_4,param_4);
              return pfVar5;
            }
            if (param_1 < 0xa11) {
              if (param_1 == 0xa0e) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                DAT_a1739b3c = param_3;
                *(float **)((&DAT_a1739a7c)[(int)param_2] + 0x18b2c) = param_3;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
              if (param_1 == 0xa0f) {
                pfVar5 = (float *)matched_FUN_a03ab174(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
            }
            else {
              if (param_1 == 0xa11) {
                pfVar5 = (float *)matched_FUN_a03ab4e8(param_2,param_3,param_4,param_4);
                return pfVar5;
              }
              if (param_1 == 0xa12) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                *(undefined1 *)(iVar9 + 0x4980) = uVar3;
                *(char *)(iVar9 + 0x4983) = (char)param_4;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
            }
          }
        }
        else {
          if (param_1 == 0xa21) {
            matched_FUN_a029c680(param_3,&DAT_a0775178,0xbae0);
            return (float *)0x0;
          }
          if (param_1 < 0xa22) {
            if (param_1 == 0xa16) {
              uVar18 = matched_FUN_a0375bb4(param_2,param_3,param_3,param_4);
              *(ushort *)param_3 = uVar18;
              return (float *)0x0;
            }
            if (param_1 < 0xa17) {
              if (param_1 == 0xa14) {
                pfVar5 = (float *)matched_FUN_a03ab594
                                            (param_2,(uint)param_3 & 0xff,(uint)param_4 & 0xff,
                                             param_4);
                return pfVar5;
              }
              if (param_1 == 0xa15) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                uVar18 = matched_FUN_a036f930((uint)param_2 & 0xff);
                *(ushort *)param_3 = uVar18;
                matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa17) {
                pfVar5 = (float *)matched_FUN_a03ab610(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
              if (param_1 == 0xa20) {
                if (*param_3 == 2.6473383e-26) {
                  matched_FUN_a029c680(&DAT_a0775178,param_3,0xbae0);
                  matched_FUN_a029c680((&DAT_a1739a7c)[(int)param_2] + 0x4b54,param_3,0xbae0);
                  return (float *)0x0;
                }
                FUN_a02a70ec(s_____Aaa_Params_StructVersionNum_i_a060ad20,*param_3);
                return (float *)0xffffffff;
              }
            }
          }
          else {
            if (param_1 == 0xa24) {
              matched_FUN_a0374a18(param_2,param_3,param_4);
              return (float *)0x0;
            }
            if (param_1 < 0xa25) {
              if (param_1 == 0xa22) {
                pfVar5 = (float *)matched_FUN_a03aa574(param_2,(uint)param_3 & 0xff,param_4,param_4)
                ;
                return pfVar5;
              }
              if (param_1 == 0xa23) {
                matched_FUN_a0370e24(param_2,param_3,param_4);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa25) {
                matched_FUN_a0374de8(param_2);
                return (float *)0x0;
              }
              if (param_1 == 0xa26) {
                FUN_a03714a4(param_2,param_3);
                return (float *)0x0;
              }
            }
          }
        }
      }
    }
    else {
      if (param_1 == 0xa59) {
        puVar4 = (undefined1 *)((int)param_2 + -1);
        puVar19 = DAT_a03ab394;
        do {
          puVar4 = puVar4 + 1;
          puVar19 = puVar19 + 1;
          *puVar19 = *puVar4;
        } while (puVar4 != (undefined1 *)((int)param_2 + 0xf));
        return (float *)0x0;
      }
      if (param_1 < 0xa5a) {
        if (param_1 == 0xa41) {
          iVar9 = (&DAT_a1739a7c)[(int)param_2];
          *(undefined4 *)(iVar9 + 0x4988) = 0;
          *(undefined4 *)(iVar9 + 0x498c) = 0;
          *(undefined4 *)(iVar9 + 0x4990) = 0;
          *(undefined4 *)(iVar9 + 0x4994) = 0;
          *(undefined4 *)(iVar9 + 0x4998) = 0;
          return (float *)0x0;
        }
        if (param_1 < 0xa42) {
          if (param_1 == 0xa30) {
            pfVar5 = (float *)matched_FUN_a03ac784(param_2,(uint)param_3 & 0xff,param_4,param_4);
            return pfVar5;
          }
          if (param_1 < 0xa31) {
            if (param_1 == 0xa29) {
              matched_FUN_a0356fa8(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 < 0xa29) {
              FUN_a0365978(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 == 0xa2a) {
              matched_FUN_a03571e8(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 == 0xa2b) {
              matched_FUN_a037115c();
              matched_FUN_a0374bdc(param_2,param_3);
              return (float *)0x0;
            }
          }
          else {
            if (param_1 == 0xa33) {
              pfVar5 = (float *)matched_FUN_a03aa4b8(param_2,param_3,param_3,param_4);
              return pfVar5;
            }
            if (param_1 < 0xa34) {
              if (param_1 == 0xa31) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
                pfVar5 = (float *)matched_FUN_a03ac41c(param_2,(uint)param_3 & 0xff);
                if (pfVar5 != (float *)0xffffffff) {
                  *(undefined2 *)param_4 = *(undefined2 *)((&DAT_a1739a7c)[(int)param_2] + 0x18b28);
                  *(undefined2 *)((int)param_4 + 2) =
                       *(undefined2 *)((&DAT_a1739a7c)[(int)param_2] + 0x18b2a);
                  *(int *)((int)param_4 + 4) = (&DAT_a1739a7c)[(int)param_2] + 0x10b28;
                }
                matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
                return pfVar5;
              }
              if (param_1 == 0xa32) {
                if (*param_3 == 6.513427e-27) {
                  matched_FUN_a029c680((&DAT_a1739a7c)[(int)param_2] + 0x1064c,param_3,0x218);
                  return (float *)0x0;
                }
                FUN_a02a70ec(s_____Adj_Table_Params_VersionNum_i_a060acec,*param_3);
                return (float *)0xffffffff;
              }
            }
            else {
              if (param_1 == 0xa34) {
                if (param_3 == (float *)0x0) {
                  if (*(int *)param_4 == 0x14020700) {
                    FUN_a02a70ec(s__________ImgParam___VersionNumbe_a060ae10,0x14020700);
                    return (float *)0x0;
                  }
                  pfVar5 = (float *)0xffffffff;
                  FUN_a02a70ec(s__________ImgParam_Struct_Version_a060ae4c);
                  FUN_a02a70ec(s__________ImgParam___VersionNumbe_a060ae90,*(int *)param_4);
                }
                else if (param_3 == (float *)&SupervisorCall) {
                  if (*(int *)param_4 != 0x15031700) {
                    FUN_a02a70ec(s__________AaaParam_Struct_Version_a060af10);
                    FUN_a02a70ec(s__________AaaParam___VersionNumbe_a060af54,*(int *)param_4,
                                 *(int *)((int)param_4 + 4));
                    return (float *)0xffffffff;
                  }
                  FUN_a02a70ec(s__________AaaParam___VersionNumbe_a060aec8,0x15031700,
                               *(int *)((int)param_4 + 4));
                  pfVar5 = (float *)0x0;
                }
                else if (param_3 == (float *)&DAT_00000009) {
                  if (*(int *)param_4 != 0x14051500) {
                    FUN_a02a70ec(s__________StillParam_Struct_Versi_a060afe0);
                    FUN_a02a70ec(s__________StillParam___VersionNum_a060af98,*(int *)param_4,
                                 *(int *)((int)param_4 + 4));
                    return (float *)0xffffffff;
                  }
                  FUN_a02a70ec(s__________StillParam___VersionNum_a060af98,0x14051500,
                               *(int *)((int)param_4 + 4));
                  pfVar5 = (float *)0x0;
                }
                else if (param_3 == (float *)0x1) {
                  if (*(int *)param_4 != 0x15032300) {
                    FUN_a02a70ec(s__________VIDEO_Struct_VersionNum_a060b070);
                    FUN_a02a70ec(s__________VIDEO___VersionNumber__S_a060b0b4,*(int *)param_4,
                                 *(int *)((int)param_4 + 4));
                    return (float *)0xffffffff;
                  }
                  FUN_a02a70ec(s__________VIDEO___VersionNumber__S_a060b028,0x15032300,
                               *(int *)((int)param_4 + 4));
                  pfVar5 = (float *)0x0;
                }
                else {
                  pfVar5 = (float *)0x0;
                  if (param_3 == (float *)0x3) {
                    if (*(int *)param_4 != 0x15032300) {
                      FUN_a02a70ec(s__________Photo_Struct_VersionNum_a060b140);
                      FUN_a02a70ec(s__________Photo___VersionNumber__S_a060b184,*(int *)param_4,
                                   *(int *)((int)param_4 + 4));
                      return (float *)0xffffffff;
                    }
                    FUN_a02a70ec(s__________Photo___VersionNumber__S_a060b0f8,0x15032300,
                                 *(int *)((int)param_4 + 4));
                  }
                  else if (param_3 == (float *)&DAT_00000005) {
                    if (*(int *)param_4 != 0x15032300) {
                      FUN_a02a70ec(s__________Still_LISO_Struct_Versi_a060b210);
                      FUN_a02a70ec(s__________Still_LISO___VersionNum_a060b1c8,*(int *)param_4,
                                   *(int *)((int)param_4 + 4));
                      return (float *)0xffffffff;
                    }
                    FUN_a02a70ec(s__________Still_LISO___VersionNum_a060b1c8,0x15032300,
                                 *(int *)((int)param_4 + 4));
                  }
                  else if (param_3 == (float *)0x6) {
                    if (*(int *)param_4 == 0x15032300) {
                      FUN_a02a70ec(s__________Still_HISO___VersionNum_a060b258,0x15032300,
                                   *(int *)((int)param_4 + 4));
                    }
                    else {
                      pfVar5 = (float *)0xffffffff;
                      FUN_a02a70ec(s__________Still_HISO_Struct_Versi_a060b2a0);
                      FUN_a02a70ec(s__________Still_HISO___VersionNum_a060b258,*(int *)param_4,
                                   *(int *)((int)param_4 + 4));
                    }
                  }
                  else if (param_3 == (float *)&DAT_00000007) {
                    if (*(int *)param_4 == 0x15032300) {
                      FUN_a02a70ec(s__________Still_MfHISO___VersionN_a060b2e8,0x15032300,
                                   *(int *)((int)param_4 + 4));
                    }
                    else {
                      pfVar5 = (float *)0xffffffff;
                      FUN_a02a70ec(s__________Still_MfHISO_Struct_Ver_a060b330,0x15032300);
                      FUN_a02a70ec(s__________Still_MfHISO___VersionN_a060b2e8,*(int *)param_4,
                                   *(int *)((int)param_4 + 4));
                    }
                  }
                }
                return pfVar5;
              }
              if (param_1 == 0xa40) {
                if (*param_3 != 0.0) {
                  *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4988) = *param_3;
                }
                if (param_3[1] != 0.0) {
                  *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x498c) = param_3[1];
                }
                if (param_3[2] != 0.0) {
                  *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4990) = param_3[2];
                }
                if (param_3[3] != 0.0) {
                  *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4994) = param_3[3];
                }
                if (param_3[4] != 0.0) {
                  *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x4998) = param_3[4];
                }
                return (float *)0x0;
              }
            }
          }
        }
        else {
          if (param_1 == 0xa53) {
            pfVar5 = (float *)matched_FUN_a03aa024(param_2,0xa53,param_3,param_4);
            return pfVar5;
          }
          if (param_1 < 0xa54) {
            if (param_1 == 0xa50) {
              pfVar5 = (float *)matched_FUN_a03aca7c(param_2,(uint)param_3 & 0xff,param_4,param_4);
              return pfVar5;
            }
            if (param_1 < 0xa51) {
              if (param_1 == 0xa42) {
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                fVar10 = *(float *)(iVar9 + 0x498c);
                fVar14 = *(float *)(iVar9 + 0x4990);
                fVar21 = *(float *)(iVar9 + 0x4994);
                *param_3 = *(float *)(iVar9 + 0x4988);
                param_3[1] = fVar10;
                param_3[2] = fVar14;
                param_3[3] = fVar21;
                param_3[4] = *(float *)(iVar9 + 0x4998);
                return (float *)0x0;
              }
              if (param_1 == 0xa43) {
                local_3c = (float)DAT_a060ab6c;
                local_38 = (ushort *)DAT_a060ab70;
                local_34 = (float)DAT_a060ab74;
                local_30 = (float)DAT_a060ab78;
                local_2c = (float)DAT_a060ab7c;
                if (DAT_a1763e50 == '\0') {
                  FUN_a02a70ec(s_____AmbaImgProc_Module__Revision_a060aca0,0x13f5);
                  DAT_a1763e50 = '\x01';
                }
                if (param_2 == (int *)0x0) {
                  param_2 = (int *)0x1;
                }
                if (DAT_a1739a77 == '\0') {
                  image_command_dispatch(0xd06,param_2,0,0);
                  FUN_a02a70ec(s_<_s>_channelCount____d_a05f02c4,
                               s_AmbaImg_CtrlFunc_Param_Init_a060aba0,param_2);
                  DAT_a1739a77 = '\x01';
                }
                local_44 = &DAT_a1739a7c;
                piVar32 = (int *)0x0;
                pcVar35 = &DAT_a1739aac;
                local_4c = param_2;
                do {
                  while (*pcVar35 == '\0') {
                    iVar9 = local_44[(int)piVar32];
                    piVar32 = (int *)((int)piVar32 + 1);
                    matched_FUN_a04f8dec(iVar9 + 0x34,0,0x3a90);
                    matched_FUN_a04f8dec(iVar9 + 0x3ac4,0,0xe90);
                    matched_FUN_a04f8dec(iVar9 + 0x499c,0,0x2c);
                    matched_FUN_a04f8dec(iVar9 + 0x49c8,0,0x18c);
                    matched_FUN_a04f8dec(iVar9 + 0x18b30,0,0x20);
                    matched_FUN_a04f8dec(iVar9 + 0x18b58,0,0x10);
                    *(undefined4 *)(iVar9 + 0x4954) = 0x1000;
                    *(float *)(iVar9 + 0x4958) = local_3c;
                    *(ushort **)(iVar9 + 0x495c) = local_38;
                    *(float *)(iVar9 + 0x4960) = local_34;
                    *(float *)(iVar9 + 0x4964) = local_30;
                    local_48 = (uint)local_2c;
                    *(float *)(iVar9 + 0x4968) = local_2c;
                    *(float *)(iVar9 + 0x496c) = local_3c;
                    *(ushort **)(iVar9 + 0x4970) = local_38;
                    *(float *)(iVar9 + 0x4974) = local_34;
                    *(float *)(iVar9 + 0x4978) = local_30;
                    *(float *)(iVar9 + 0x497c) = local_2c;
                    *(undefined1 *)(iVar9 + 0x4980) = 0;
                    *(undefined1 *)(iVar9 + 0x4981) = 0;
                    *(undefined1 *)(iVar9 + 0x4982) = 0;
                    *(undefined1 *)(iVar9 + 0x4983) = 0;
                    *(undefined1 *)(iVar9 + 0x4984) = 0;
                    *(undefined1 *)(iVar9 + 0x4985) = 0;
                    *(undefined1 *)(iVar9 + 0x18b50) = 0;
                    *(undefined1 *)(iVar9 + 0x18b51) = 0;
                    *(undefined1 *)(iVar9 + 0x18b52) = 0;
                    *(undefined4 *)(iVar9 + 0x4988) = 0;
                    *(undefined4 *)(iVar9 + 0x498c) = 0;
                    *(undefined4 *)(iVar9 + 0x4990) = 0;
                    *(undefined4 *)(iVar9 + 0x4994) = 0;
                    *(undefined4 *)(iVar9 + 0x4998) = 0;
                    *(undefined2 *)(iVar9 + 0x18b54) = 0;
                    *(undefined4 *)(iVar9 + 0x19c48) = 0;
                    *(undefined2 *)(iVar9 + 0x19c58) = 0;
                    *(undefined2 *)(iVar9 + 0x19c5a) = 0;
                    *(undefined4 *)(iVar9 + 0x19d18) = 0xea25;
                    *(undefined4 *)(iVar9 + 0x19d20) = 0xea25;
                    *(undefined1 *)(iVar9 + 0x19c98) = 0;
                    *(undefined1 *)(iVar9 + 0x19c99) = 0;
                    *(undefined4 *)(iVar9 + 0x19d14) = 0x3c;
                    *(undefined4 *)(iVar9 + 0x19d1c) = 0x3c;
                    matched_FUN_a029c680(iVar9 + 0x4b54,&DAT_a0775178,0xbae0);
                    *pcVar35 = '\x01';
                    FUN_a02a70ec(s_<_s>_ICF_PARAM_s___size____d_a060accc,
                                 s_AmbaImg_CtrlFunc_Param_Init_a060aba0,0x19d24);
                    pcVar35 = pcVar35 + 1;
                    if (local_4c <= piVar32) {
                      return (float *)0x0;
                    }
                  }
                  piVar32 = (int *)((int)piVar32 + 1);
                  pcVar35 = pcVar35 + 1;
                } while (piVar32 < local_4c);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa51) {
                pfVar5 = (float *)matched_FUN_a03acb70(param_2,(uint)param_3 & 0xff,param_4,param_4)
                ;
                return pfVar5;
              }
              if (param_1 == 0xa52) {
                DAT_a1763e4c = param_2;
                DAT_a172e020 = param_2;
                return (float *)0x0;
              }
            }
          }
          else {
            if (param_1 == 0xa56) {
              if ((*param_2 == 0) || (param_2[1] == 0)) {
                return (float *)0xffffffff;
              }
              DAT_a1739b18 = *param_2;
              DAT_a1739b1c = param_2[1];
              pfVar5 = (float *)matched_FUN_a03bc6b0(&DAT_a1763e54,*param_2);
              if (pfVar5 == (float *)0x0) {
                DAT_a1763e4c = (int *)&DAT_a1763e54;
                DAT_a172e020 = (int *)&DAT_a1763e54;
                return (float *)0x0;
              }
              return pfVar5;
            }
            if (param_1 < 0xa57) {
              if (param_1 == 0xa54) {
                DAT_a0774eec = param_2;
                return (float *)0x0;
              }
              if (param_1 == 0xa55) {
                pfVar5 = (float *)matched_FUN_a03aa050(param_2,0xa56,param_3,param_4);
                return pfVar5;
              }
            }
            else {
              if (param_1 == 0xa57) {
                if ((DAT_a1739b18 == 0) || (DAT_a1739b1c == 0)) {
                  pfVar5 = (float *)0xffffffff;
                }
                else {
                  pfVar5 = (float *)0x0;
                  *param_2 = DAT_a1739b18;
                  param_2[1] = iVar9;
                }
                return pfVar5;
              }
              if (param_1 == 0xa58) {
                fVar10 = param_3[2];
                dVar46 = (double)VectorSignedToFloat(1 << ((uint)param_3[1] & 0xff),
                                                     (byte)(in_fpscr >> 0x16) & 3);
                uVar43 = (undefined4)((ulonglong)dVar46 >> 0x20);
                uVar42 = SUB84((double)(1.0 / *param_3),0);
                matched_FUN_a0504220(SUB84(dVar46,0),uVar43,uVar42);
                dVar44 = (double)VectorSignedToFloat(1 << ((uint)fVar10 & 0xff),
                                                     (byte)(in_fpscr >> 0x16) & 3);
                matched_FUN_a0504220(SUB84(dVar44,0),uVar43,uVar42);
                dVar41 = (double)CONCAT44(uVar43,SUB84(dVar44,0));
                uVar43 = matched_FUN_a03673a4(param_2);
                dVar45 = (double)VectorSignedToFloat(uVar43,(byte)(in_fpscr >> 0x16) & 3);
                DAT_a0700ac0 = dVar45 + DAT_a0700ac0;
                if (dVar46 < DAT_a0700ac0) {
                  DAT_a0700ac0 = dVar46;
                }
                else if (DAT_a0700ac0 < dVar41) {
                  DAT_a0700ac0 = dVar41;
                }
                else {
                }
                *param_4 = dVar44 / DAT_a0700ac0;
                return (float *)0x0;
              }
            }
          }
        }
      }
      else {
        if (param_1 == 0xa70) {
          pfVar5 = (float *)matched_FUN_a03ae784(param_2,param_3,param_3,param_4);
          return pfVar5;
        }
        if (param_1 < 0xa71) {
          if (param_1 == 0xa64) {
            matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
            *param_3 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x19d1c);
            *(int *)param_4 = *(int *)((&DAT_a1739a7c)[(int)param_2] + 0x19d20);
            matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
            return (float *)0x0;
          }
          if (param_1 < 0xa65) {
            if (param_1 == 0xa61) {
              pfVar5 = (float *)matched_FUN_a03aaf58(param_2,(uint)param_3 & 0xff,param_4,param_4);
              return pfVar5;
            }
            if (param_1 < 0xa62) {
              if (param_1 == 0xa5a) {
                puVar4 = (undefined1 *)((int)param_2 + -1);
                puVar8 = DAT_a03ab3bc + 0x10;
                puVar19 = DAT_a03ab3bc;
                do {
                  puVar19 = puVar19 + 1;
                  puVar4 = puVar4 + 1;
                  *puVar4 = *puVar19;
                } while (puVar19 != puVar8);
                return (float *)0x0;
              }
              if (param_1 == 0xa60) {
                iVar9 = *(int *)((&DAT_a1739a7c)[(int)param_2] + 0x4954);
                *(int *)(param_4 + 2) = *(int *)((&DAT_a1739a7c)[(int)param_2] + 0x4d0c);
                *(int *)((int)param_4 + 0xc) = iVar9;
                if (((uint)param_3 & 0xff) == 0) {
                  iVar15 = (&DAT_a1739a7c)[(int)param_2];
                  iVar9 = *(int *)((int)param_4 + 4);
                  iVar13 = *(int *)(param_4 + 1);
                  iVar20 = *(int *)((int)param_4 + 0xc);
                  *(int *)(iVar15 + 0x4958) = *(int *)param_4;
                  *(int *)(iVar15 + 0x495c) = iVar9;
                  *(int *)(iVar15 + 0x4960) = iVar13;
                  *(int *)(iVar15 + 0x4964) = iVar20;
                  *(int *)(iVar15 + 0x4968) = *(int *)(param_4 + 2);
                  return (float *)0x0;
                }
                iVar15 = (&DAT_a1739a7c)[(int)param_2];
                iVar9 = *(int *)((int)param_4 + 4);
                iVar13 = *(int *)(param_4 + 1);
                iVar20 = *(int *)((int)param_4 + 0xc);
                *(int *)(iVar15 + 0x496c) = *(int *)param_4;
                *(int *)(iVar15 + 0x4970) = iVar9;
                *(int *)(iVar15 + 0x4974) = iVar13;
                *(int *)(iVar15 + 0x4978) = iVar20;
                *(int *)(iVar15 + 0x497c) = *(int *)(param_4 + 2);
                matched_FUN_a03b39c0(param_2,&DAT_a1739b10);
                iVar9 = DAT_a1739b10;
                iVar13 = *(int *)((int)param_4 + 4);
                iVar20 = *(int *)(param_4 + 1);
                iVar15 = *(int *)((int)param_4 + 0xc);
                *(int *)(DAT_a1739b10 + 4) = *(int *)param_4;
                *(int *)(iVar9 + 8) = iVar13;
                *(int *)(iVar9 + 0xc) = iVar20;
                *(int *)(iVar9 + 0x10) = iVar15;
                *(int *)(iVar9 + 0x14) = *(int *)(param_4 + 2);
                *(undefined1 *)(iVar9 + 2) = 1;
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa62) {
                local_30 = param_3[0xd];
                local_2c = param_3[0xe];
                local_28 = param_3[0xf];
                pfVar5 = (float *)matched_FUN_a0356980
                                            (param_2,*(undefined1 *)param_3,*(ushort *)(param_3 + 1)
                                             ,param_3[0xc]);
                return pfVar5;
              }
              if (param_1 == 0xa63) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                *(float **)(iVar9 + 0x19d14) = param_3;
                *(double **)(iVar9 + 0x19d18) = param_4;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
            }
          }
          else {
            if (param_1 == 0xa69) {
              fVar10 = *(float *)(&DAT_a0774e4c + (int)param_2 * 8);
              *param_3 = *(float *)(&DAT_a0774e48 + (int)param_2 * 8);
              param_3[1] = fVar10;
              return (float *)0x0;
            }
            if (param_1 < 0xa6a) {
              if (param_1 == 0xa65) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff);
                iVar9 = (&DAT_a1739a7c)[(int)param_2];
                *(float **)(iVar9 + 0x19d1c) = param_3;
                *(double **)(iVar9 + 0x19d20) = param_4;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
              if (param_1 == 0xa68) {
                fVar10 = param_3[1];
                *(float *)(&DAT_a0774e48 + (int)param_2 * 8) = *param_3;
                *(float *)(&DAT_a0774e4c + (int)param_2 * 8) = fVar10;
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa6a) {
                *(undefined1 *)(param_2 + -0x17a31935) = uVar3;
                return (float *)0x0;
              }
              if (param_1 == 0xa6b) {
                *param_3 = (float)(uint)*(byte *)(param_2 + -0x17a31935);
                return (float *)0x0;
              }
            }
          }
        }
        else {
          if (param_1 == 0xa76) {
            matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
            *param_3 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x19cbc);
            matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
            return (float *)0x0;
          }
          if (param_1 < 0xa77) {
            if (param_1 == 0xa73) {
              matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
              *(undefined1 *)((&DAT_a1739a7c)[(int)param_2] + 0x19c99) = uVar3;
              matched_thunk_FUN_a03c3c5c();
              return (float *)0x0;
            }
            if (param_1 < 0xa74) {
              if (param_1 == 0xa71) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(undefined1 *)((&DAT_a1739a7c)[(int)param_2] + 0x19c98) = uVar3;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
              if (param_1 == 0xa72) {
                pfVar5 = (float *)matched_FUN_a03ae7fc(param_2,param_3,param_3,param_4);
                return pfVar5;
              }
            }
            else {
              if (param_1 == 0xa74) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(undefined1 *)param_3 = *(undefined1 *)((&DAT_a1739a7c)[(int)param_2] + 0x19cc0);
                matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
                return (float *)0x0;
              }
              if (param_1 == 0xa75) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(undefined1 *)((&DAT_a1739a7c)[(int)param_2] + 0x19cc0) = uVar3;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
            }
          }
          else {
            if (param_1 == 0xa79) {
              matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
              *(undefined1 *)((&DAT_a1739a7c)[(int)param_2] + 0x19cc1) = uVar3;
              matched_thunk_FUN_a03c3c5c();
              return (float *)0x0;
            }
            if (param_1 < 0xa7a) {
              if (param_1 == 0xa77) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(float **)((&DAT_a1739a7c)[(int)param_2] + 0x19cbc) = param_3;
                matched_thunk_FUN_a03c3c5c();
                return (float *)0x0;
              }
              if (param_1 == 0xa78) {
                matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
                *(undefined1 *)param_3 = *(undefined1 *)((&DAT_a1739a7c)[(int)param_2] + 0x19cc1);
                matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
                return (float *)0x0;
              }
            }
            else {
              if (param_1 == 0xa7a) {
                local_a0 = param_2[1];
                local_90 = (uint)*(ushort *)(param_2 + 5);
                local_88 = 0;
                local_84 = 0;
                local_48 = 0;
                local_44 = (int *)0x0;
                local_40 = 0;
                local_3c = 0.0;
                local_38 = (ushort *)0x0;
                local_34 = 0.0;
                local_30 = 0.0;
                local_2c = 0.0;
                local_80[0] = 0;
                local_80[1] = 0;
                local_80[2] = 0;
                local_80[3] = 0;
                local_78[0] = 0;
                local_78[1] = 0;
                local_78[2] = 0;
                local_78[3] = 0;
                local_68 = 0.0;
                local_60 = 0;
                local_5c = 0;
                local_58 = 0;
                local_54[0] = 0;
                local_54[1] = 0;
                local_4c = (int *)0x0;
                local_b0 = param_2;
                if (local_a0 == 0) {
                  FUN_a02a70ec(s_<_s>__Raw_data_address_is_NULL_a060b3a0,
                               s___CalculateBlackLevel_a060abbc,0,param_4);
                  pfVar5 = (float *)0xffffffff;
                }
                else {
                  local_ac = (uint)*(ushort *)((int)param_2 + 0x1e);
                  if (local_ac == 0) {
                    uVar23 = 0;
                    uVar11 = 0;
                    local_bc = (uint)*(ushort *)(param_2 + 7);
                  }
                  else {
                    local_bc = (uint)*(ushort *)(param_2 + 7);
                    local_f8 = (ushort *)(local_90 * 2);
                    local_38 = (ushort *)0x0;
                    local_34 = 0.0;
                    iVar9 = 0;
                    uVar23 = 0;
                    local_f0 = local_f8 + 1;
                    local_48 = 0;
                    local_44 = (int *)0x0;
                    uVar11 = 0;
                    local_30 = 0.0;
                    local_2c = 0.0;
                    local_c0 = (ushort *)0x0;
                    local_100 = (ushort *)0x0;
                    iStack_fc = 0;
                    do {
                      if (local_bc != 0) {
                        iVar13 = 0;
                        uVar18 = *(ushort *)(param_2 + 6);
                        puVar24 = (ushort *)((int)local_c0 + local_a0 + (uint)uVar18);
                        puVar7 = (ushort *)((int)local_f8 + (int)local_c0 + local_a0 + (uint)uVar18)
                        ;
                        puVar12 = (ushort *)
                                  ((int)local_f0 + (int)local_c0 + local_a0 + (uint)uVar18);
                        local_108 = (uint *)local_30;
                        uStack_104 = (uint)local_2c;
                        do {
                          iVar13 = iVar13 + 2;
                          bVar40 = CARRY4(uVar23,(uint)*puVar24);
                          uVar23 = uVar23 + *puVar24;
                          puVar24 = puVar24 + 1;
                          uVar11 = uVar11 + bVar40;
                          bVar40 = CARRY4((uint)local_100,(uint)*puVar24);
                          local_100 = (ushort *)((int)local_100 + (uint)*puVar24);
                          iStack_fc = iStack_fc + (uint)bVar40;
                          bVar40 = CARRY4((uint)local_38,(uint)*puVar7);
                          local_38 = (ushort *)((int)local_38 + (uint)*puVar7);
                          local_34 = (float)((int)local_34 + (uint)bVar40);
                          local_30 = (float)((int)local_108 + (uint)*puVar12);
                          local_2c = (float)(uStack_104 + CARRY4((uint)local_108,(uint)*puVar12));
                          puVar7 = puVar7 + 1;
                          puVar12 = puVar12 + 1;
                          local_108 = (uint *)local_30;
                          uStack_104 = (uint)local_2c;
                        } while (iVar13 < (int)local_bc);
                        local_48 = uVar23;
                        local_44 = (int *)uVar11;
                      }
                      iVar9 = iVar9 + 2;
                      local_c0 = local_c0 + local_90;
                    } while (iVar9 < (int)local_ac);
                    local_40 = (uint)local_100;
                    local_3c = (float)iStack_fc;
                  }
                  iVar13 = 0;
                  local_b4 = local_80;
                  local_8c = local_bc * local_ac;
                  local_b8 = &local_48;
                  iVar9 = local_8c + 3;
                  if (-1 < local_8c) {
                    iVar9 = local_8c;
                  }
                  puVar29 = local_b8;
                  psVar31 = local_b4;
                  while( true ) {
                    uVar23 = matched_FUN_a0506f00(uVar23,uVar11,iVar9 >> 2,iVar9 >> 0x1f);
                    *puVar29 = 0;
                    puVar29[1] = 0;
                    local_54[iVar13 + -1] = uVar23;
                    iVar13 = iVar13 + 1;
                    *psVar31 = 0;
                    if (iVar13 == 4) break;
                    uVar23 = puVar29[2];
                    uVar11 = puVar29[3];
                    puVar29 = puVar29 + 2;
                    psVar31 = psVar31 + 1;
                  }
                  piVar32 = local_44;
                  uVar23 = local_48;
                  if (local_ac != 0) {
                    local_9c = local_90 * 2;
                    local_98 = local_9c + 2;
                    iStack_c4 = (int)local_58 >> 0x1f;
                    local_a8 = 0;
                    local_c8 = local_58;
                    local_108 = (uint *)local_48;
                    uStack_104 = (uint)local_44;
                    iStack_dc = (int)local_54[0] >> 0x1f;
                    iStack_cc = (int)local_4c >> 0x1f;
                    local_e0 = local_54[0];
                    iStack_d4 = (int)local_54[1] >> 0x1f;
                    local_d0 = (uint)local_4c;
                    local_d8 = local_54[1];
                    local_a4 = 0;
                    local_f8 = (ushort *)local_40;
                    iStack_f4 = (int)local_3c;
                    local_f0 = local_38;
                    iStack_ec = (int)local_34;
                    local_e8 = (uint)local_30;
                    uStack_e4 = (uint)local_2c;
                    do {
                      if (local_bc != 0) {
                        iVar13 = 0;
                        iVar9 = local_a8 + *(ushort *)(local_b0 + 6);
                        puVar7 = (ushort *)(local_a0 + iVar9);
                        local_100 = (ushort *)(local_a0 + iVar9 + local_98);
                        local_c0 = (ushort *)(local_a0 + iVar9 + local_9c);
                        do {
                          uVar23 = (uint)*puVar7;
                          if (iStack_c4 < (int)(uint)(local_58 < uVar23)) {
                            uVar11 = uVar23 - local_58;
                            iVar9 = -(iStack_c4 + (uint)(uVar23 < local_58));
                          }
                          else {
                            uVar11 = local_58 - uVar23;
                            iVar9 = iStack_c4 - (uint)(local_58 < uVar23);
                          }
                          uVar23 = (uint)puVar7[1];
                          if (iStack_dc < (int)(uint)(local_54[0] < uVar23)) {
                            uVar16 = uVar23 - local_54[0];
                            iVar20 = -(iStack_dc + (uint)(uVar23 < local_54[0]));
                          }
                          else {
                            uVar16 = local_54[0] - uVar23;
                            iVar20 = iStack_dc - (uint)(local_54[0] < uVar23);
                          }
                          puVar12 = local_c0 + 1;
                          uVar23 = (uint)*local_c0;
                          if (iStack_d4 < (int)(uint)(local_54[1] < uVar23)) {
                            uVar17 = uVar23 - local_54[1];
                            iVar15 = -(iStack_d4 + (uint)(uVar23 < local_54[1]));
                          }
                          else {
                            uVar17 = local_54[1] - uVar23;
                            iVar15 = iStack_d4 - (uint)(local_54[1] < uVar23);
                          }
                          puVar24 = local_100 + 1;
                          uVar23 = (uint)*local_100;
                          if (iStack_cc < (int)(uint)(local_4c < uVar23)) {
                            uVar26 = uVar23 - (int)local_4c;
                            iVar22 = -(iStack_cc + (uint)(uVar23 < local_4c));
                          }
                          else {
                            uVar26 = (int)local_4c - uVar23;
                            iVar22 = iStack_cc - (uint)(local_4c < uVar23);
                          }
                          uVar27 = (uint)((ulonglong)uVar11 * (ulonglong)uVar11);
                          iVar13 = iVar13 + 2;
                          uVar33 = (uint)((ulonglong)uVar16 * (ulonglong)uVar16);
                          uVar23 = (int)local_108 + uVar27;
                          piVar32 = (int *)(uStack_104 +
                                            (int)((ulonglong)uVar11 * (ulonglong)uVar11 >> 0x20) +
                                            uVar11 * iVar9 * 2 +
                                           (uint)CARRY4((uint)local_108,uVar27));
                          uVar11 = (uint)((ulonglong)uVar26 * (ulonglong)uVar26);
                          uVar27 = (uint)((ulonglong)uVar17 * (ulonglong)uVar17);
                          bVar40 = CARRY4((uint)local_f8,uVar33);
                          local_f8 = (ushort *)((int)local_f8 + uVar33);
                          iStack_f4 = iStack_f4 +
                                      (int)((ulonglong)uVar16 * (ulonglong)uVar16 >> 0x20) +
                                      uVar16 * iVar20 * 2 + (uint)bVar40;
                          bVar40 = CARRY4((uint)local_f0,uVar27);
                          local_f0 = (ushort *)((int)local_f0 + uVar27);
                          iStack_ec = iStack_ec +
                                      (int)((ulonglong)uVar17 * (ulonglong)uVar17 >> 0x20) +
                                      uVar17 * iVar15 * 2 + (uint)bVar40;
                          bVar40 = CARRY4(local_e8,uVar11);
                          local_e8 = local_e8 + uVar11;
                          uStack_e4 = uStack_e4 +
                                      (int)((ulonglong)uVar26 * (ulonglong)uVar26 >> 0x20) +
                                      uVar26 * iVar22 * 2 + (uint)bVar40;
                          puVar7 = puVar7 + 1;
                          local_108 = (uint *)uVar23;
                          uStack_104 = (uint)piVar32;
                          local_100 = puVar24;
                          local_c0 = puVar12;
                        } while (iVar13 < (int)local_bc);
                      }
                      local_a8 = local_a8 + local_9c;
                      local_a4 = local_a4 + 2;
                    } while (local_a4 < (int)local_ac);
                    local_48 = (uint)local_108;
                    local_44 = (int *)uStack_104;
                    local_40 = (uint)local_f8;
                    local_3c = (float)iStack_f4;
                    local_38 = local_f0;
                    local_34 = (float)iStack_ec;
                    local_30 = (float)local_e8;
                    local_2c = (float)uStack_e4;
                  }
                  local_94 = local_58;
                  local_108 = &local_58;
                  iVar13 = 0;
                  puVar29 = local_b8;
                  iVar9 = local_8c;
                  while( true ) {
                    iVar20 = iVar9 + 3;
                    if (-1 < iVar9) {
                      iVar20 = iVar9;
                    }
                    matched_FUN_a0506f00(uVar23,piVar32,iVar20 >> 2,iVar20 >> 0x1f);
                    dVar46 = (double)matched_FUN_a0506c88();
                    iVar20 = VectorFloatToSigned(SQRT(dVar46),3);
                    *puVar29 = 0;
                    puVar29[1] = 0;
                    iVar9 = local_94 + iVar20 * -2;
                    local_78[iVar13 + 4] = iVar9;
                    local_78[iVar13] = iVar9 + iVar20 * 4;
                    iVar13 = iVar13 + 1;
                    if (iVar13 == 4) break;
                    uVar23 = puVar29[2];
                    piVar32 = (int *)puVar29[3];
                    local_108 = local_108 + 1;
                    local_94 = *local_108;
                    iVar9 = *(ushort *)(local_b0 + 7) * local_ac;
                    puVar29 = puVar29 + 2;
                  }
                  if (local_ac != 0) {
                    local_100 = (ushort *)0x0;
                    local_c0 = (ushort *)0x0;
                    local_f8 = (ushort *)(local_90 * 2);
                    local_108 = (uint *)(uint)*(ushort *)(local_b0 + 7);
                    local_f0 = local_f8 + 1;
                    do {
                      if (local_108 != (uint *)0x0) {
                        iVar13 = 0;
                        iVar9 = local_b0[1];
                        uVar18 = *(ushort *)(local_b0 + 6);
                        puVar7 = (ushort *)((int)local_100 + iVar9 + (uint)uVar18);
                        puVar30 = (undefined2 *)
                                  ((int)local_f0 + (int)local_100 + iVar9 + (uint)uVar18);
                        puVar34 = (undefined2 *)
                                  ((int)local_f8 + (int)local_100 + iVar9 + (uint)uVar18);
LAB_a03af014:
                        iVar20 = 0;
                        uVar23 = (uint)*puVar7;
                        puVar12 = (ushort *)&local_88;
                        local_88 = *(undefined4 *)puVar7;
                        local_84 = CONCAT22(*puVar30,*puVar34);
                        iVar9 = iVar20;
                        puVar29 = local_b8;
                        psVar31 = local_b4;
                        if ((int)uVar23 < (int)local_68) goto LAB_a03af078;
                        do {
                          iVar9 = iVar20;
                          if ((int)uVar23 <= local_78[iVar20]) {
                            uVar11 = *puVar29;
                            sVar1 = *psVar31;
                            *puVar29 = uVar11 + uVar23;
                            puVar29[1] = puVar29[1] + (uint)CARRY4(uVar11,uVar23);
                            *psVar31 = sVar1 + 1;
                          }
LAB_a03af078:
                          do {
                            iVar20 = iVar9 + 1;
                            puVar29 = puVar29 + 2;
                            psVar31 = psVar31 + 1;
                            if (iVar20 == 4) {
                              iVar13 = iVar13 + 2;
                              puVar7 = puVar7 + 1;
                              puVar30 = puVar30 + 1;
                              puVar34 = puVar34 + 1;
                              if ((int)local_108 <= iVar13) goto LAB_a03af0b0;
                              goto LAB_a03af014;
                            }
                            puVar12 = puVar12 + 1;
                            uVar23 = (uint)*puVar12;
                            iVar15 = iVar9 + 5;
                            iVar9 = iVar20;
                          } while ((int)uVar23 < local_78[iVar15]);
                        } while( true );
                      }
LAB_a03af0b0:
                      local_100 = local_100 + local_90;
                      local_c0 = local_c0 + 1;
                    } while ((int)local_c0 < (int)local_ac);
                  }
                  iVar9 = 4;
                  puVar30 = (undefined2 *)((int)local_b0 + 0x26);
                  puVar29 = local_b8;
                  psVar31 = local_b4;
                  do {
                    uVar47 = matched_FUN_a0506f00(*puVar29,puVar29[1],*psVar31,0);
                    uVar23 = -(int)uVar47;
                    iVar9 = iVar9 + -1;
                    *puVar29 = uVar23;
                    puVar29[1] = -((int)((ulonglong)uVar47 >> 0x20) + (uint)((int)uVar47 != 0));
                    puVar30 = puVar30 + 1;
                    *puVar30 = (short)uVar23;
                    puVar29 = puVar29 + 2;
                    psVar31 = psVar31 + 1;
                  } while (iVar9 != 0);
                  pfVar5 = (float *)0x0;
                }
                switch(*(undefined1 *)((int)local_b0 + 10)) {
                case 0:
                  *(short *)((int)local_b0 + 0x32) = (short)local_b0[10];
                  *(undefined2 *)(local_b0 + 0xd) = *(undefined2 *)((int)local_b0 + 0x2a);
                  *(short *)((int)local_b0 + 0x36) = (short)local_b0[0xb];
                  *(undefined2 *)(local_b0 + 0xe) = *(undefined2 *)((int)local_b0 + 0x2e);
                  return pfVar5;
                case 1:
                  *(undefined2 *)((int)local_b0 + 0x32) = *(undefined2 *)((int)local_b0 + 0x2e);
                  *(short *)(local_b0 + 0xd) = (short)local_b0[0xb];
                  *(undefined2 *)((int)local_b0 + 0x36) = *(undefined2 *)((int)local_b0 + 0x2a);
                  *(short *)(local_b0 + 0xe) = (short)local_b0[10];
                  break;
                case 2:
                  *(undefined2 *)((int)local_b0 + 0x32) = *(undefined2 *)((int)local_b0 + 0x2a);
                  *(short *)(local_b0 + 0xd) = (short)local_b0[10];
                  *(undefined2 *)((int)local_b0 + 0x36) = *(undefined2 *)((int)local_b0 + 0x2e);
                  *(short *)(local_b0 + 0xe) = (short)local_b0[0xb];
                  return pfVar5;
                case 3:
                  *(short *)((int)local_b0 + 0x32) = (short)local_b0[0xb];
                  *(undefined2 *)(local_b0 + 0xd) = *(undefined2 *)((int)local_b0 + 0x2e);
                  *(short *)((int)local_b0 + 0x36) = (short)local_b0[10];
                  *(undefined2 *)(local_b0 + 0xe) = *(undefined2 *)((int)local_b0 + 0x2a);
                  return pfVar5;
                }
                return pfVar5;
              }
              if (param_1 == 0xa7b) {
                pfVar5 = (float *)matched_FUN_a03ae6f4(param_2,(uint)param_3 & 0xff,param_4,param_4)
                ;
                return pfVar5;
              }
            }
          }
        }
      }
    }
    goto LAB_a03b1b40;
  }
  if (param_1 == 0xb63) {
    *(ushort *)param_3 = DAT_a077516c >> 6;
    return (float *)0x0;
  }
  if (0xb63 < param_1) {
    if (param_1 == 0xd0b) {
      return DAT_a172e01c;
    }
    if (0xd0b < param_1) {
      uVar3 = SUB41(param_2,0);
      if (param_1 == 0x1008) {
        DAT_a17045d8 = uVar3;
        return (float *)0x0;
      }
      if (param_1 < 0x1009) {
        if (param_1 == 0x1002) {
          eis_controller_init(param_2,param_3);
          return (float *)0x0;
        }
        if (param_1 < 0x1003) {
          if (param_1 == 0xe01) {
            iVar9 = matched_analyst_fs_fopen(param_3,&DAT_a055e450,param_4,param_4);
            if (iVar9 == 0) {
              FUN_a02a70ec(s_Open_Load_File_Fail_a060b378);
              return (float *)0x0;
            }
            matched_thunk_FUN_a033a2cc(iVar9,0,0,0);
            matched_analyst_fs_fread(param_2,param_4,1,iVar9);
            matched_analyst_fs_fclose(iVar9);
            return (float *)0x0;
          }
          if (param_1 < 0xe02) {
            if (param_1 == 0xd0c) {
              matched_FUN_a03b3b24(param_2);
              return (float *)0x0;
            }
            if (param_1 == 0xe00) {
              iVar9 = matched_analyst_fs_fopen
                                (param_3,s_t_cal_wb_init___re_init_wb_a057bbf8 + 0x18,param_4,
                                 param_4);
              if (iVar9 == 0) {
                FUN_a02a70ec(s_Open_Save_File_Fail_a060b38c);
                return (float *)0x0;
              }
              matched_thunk_FUN_a033a2cc(iVar9,0,0,0);
              matched_analyst_fs_fwrite(param_2,param_4,1,iVar9);
              matched_analyst_fs_fclose(iVar9);
              return (float *)0x0;
            }
          }
          else {
            if (param_1 == 0x1000) {
              pfVar5 = (float *)matched_FUN_a0382f88(param_2,param_3,param_3,param_4);
              return pfVar5;
            }
            if (param_1 == 0x1001) {
              pfVar5 = (float *)matched_FUN_a0382ba0(param_2,param_3,param_3,param_4);
              return pfVar5;
            }
          }
        }
        else {
          if (param_1 == 0x1005) {
            DAT_a17045dc = uVar3;
            return (float *)0x0;
          }
          if (param_1 < 0x1006) {
            if (param_1 == 0x1003) {
              pfVar5 = (float *)eis_mode_rowtime_init(param_2,param_3,param_3,param_4);
              return pfVar5;
            }
            if (param_1 == 0x1004) {
              matched_FUN_a037bba8(param_2,param_3);
              return (float *)0x0;
            }
          }
          else {
            if (param_1 == 0x1006) {
              DAT_a17045dd = uVar3;
              return (float *)0x0;
            }
            if (param_1 == 0x1007) {
              DAT_a17045d7 = uVar3;
              DAT_a17045cc = (uint)param_3 & 0xff;
              DAT_a170af80 = (char)((int)((uint)param_2 & 2) >> 1);
              return (float *)0x0;
            }
          }
        }
      }
      else {
        if (param_1 == 0x100e) {
          image_sof(param_2,param_3);
          return (float *)0x0;
        }
        if (param_1 < 0x100f) {
          if (param_1 == 0x100b) {
            matched_FUN_a03833b0(param_2,param_3);
            return (float *)0x0;
          }
          if (param_1 < 0x100c) {
            if (param_1 == 0x1009) {
              matched_FUN_a037bc34(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 == 0x100a) {
              matched_FUN_a037bc80(param_2,param_2);
              return (float *)0x0;
            }
          }
          else {
            if (param_1 == 0x100c) {
              matched_FUN_a0383568(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 == 0x100d) {
              image_eof(param_2,param_3);
              return (float *)0x0;
            }
          }
        }
        else {
          if (param_1 == 0x1011) {
            matched_FUN_a037b7dc(param_2,param_3);
            return (float *)0x0;
          }
          if (param_1 < 0x1012) {
            if (param_1 == 0x100f) {
              eis_gyro_sample_processing(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 == 0x1010) {
              eis_per_frame(0,param_3);
              return (float *)0x0;
            }
          }
          else {
            if (param_1 == 0x1012) {
              matched_FUN_a03835c4(param_2,param_3);
              return (float *)0x0;
            }
            if (param_1 == 0x10ff) {
              eis_debug_dispatch(param_2,param_3,param_4);
              return (float *)0x0;
            }
          }
        }
      }
LAB_a03b1b40:
      FUN_a02a70ec(s_IMG_PROC_cannot_handle_cmd____d_a060b6e8,param_1);
      return (float *)0x0;
    }
    if (param_1 == 0xc06) {
      matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
      *(float **)((&DAT_a1739a7c)[(int)param_2] + 0x19c48) = param_3;
      matched_thunk_FUN_a03c3c5c();
      return (float *)0x0;
    }
    if (param_1 < 0xc07) {
      if (param_1 == 0xc00) {
        DAT_a1739a76 = (char)*param_2;
        DAT_a1739a75 = *(undefined1 *)param_3;
        return (float *)0x0;
      }
      if (param_1 < 0xc01) {
        if (param_1 == 0xb65) {
          iVar9 = ((uint)param_2 & 0xff) * 0x28;
          fVar10 = param_3[1];
          fVar14 = param_3[2];
          fVar21 = param_3[3];
          *(float *)(&DAT_a0774c38 + iVar9) = *param_3;
          *(float *)(&DAT_a0774c3c + iVar9) = fVar10;
          *(float *)(&DAT_a0774c40 + iVar9) = fVar14;
          *(float *)(&DAT_a0774c44 + iVar9) = fVar21;
          iVar13 = *(int *)param_4;
          iVar20 = *(int *)((int)param_4 + 4);
          iVar15 = *(int *)(param_4 + 1);
          iVar22 = *(int *)((int)param_4 + 0xc);
          *(float *)(&DAT_a0774c48 + iVar9) = param_3[4];
          iVar38 = *(int *)(param_4 + 2);
          *(int *)(&DAT_a0774c4c + iVar9) = iVar13;
          *(int *)(&DAT_a0774c50 + iVar9) = iVar20;
          *(int *)(&DAT_a0774c54 + iVar9) = iVar15;
          *(int *)(&DAT_a0774c58 + iVar9) = iVar22;
          *(int *)(&DAT_a0774c5c + iVar9) = iVar38;
          return (float *)0x0;
        }
        if (param_1 < 0xb65) {
          pfVar5 = (float *)matched_FUN_a03ada64((uint)param_2 & 0xff,param_3,param_4,param_4);
          return pfVar5;
        }
        if (param_1 == 0xb66) {
          pfVar5 = (float *)matched_FUN_a03adafc((uint)param_2 & 0xff,param_3,param_4,param_4);
          return pfVar5;
        }
        if (param_1 == 0xb67) {
          iVar9 = ((uint)param_2 & 0xff) * 0x28;
          fVar10 = param_3[1];
          fVar14 = param_3[2];
          fVar21 = param_3[3];
          *(float *)(&DAT_a0774f04 + iVar9) = *param_3;
          *(float *)(&DAT_a0774f08 + iVar9) = fVar10;
          *(float *)(&DAT_a0774f0c + iVar9) = fVar14;
          *(float *)(&DAT_a0774f10 + iVar9) = fVar21;
          iVar13 = *(int *)param_4;
          iVar20 = *(int *)((int)param_4 + 4);
          iVar15 = *(int *)(param_4 + 1);
          iVar22 = *(int *)((int)param_4 + 0xc);
          *(float *)(&DAT_a0774f14 + iVar9) = param_3[4];
          iVar38 = *(int *)(param_4 + 2);
          *(int *)(&DAT_a0774f18 + iVar9) = iVar13;
          *(int *)(&DAT_a0774f1c + iVar9) = iVar20;
          *(int *)(&DAT_a0774f20 + iVar9) = iVar15;
          *(int *)(&DAT_a0774f24 + iVar9) = iVar22;
          *(int *)(&DAT_a0774f28 + iVar9) = iVar38;
          return (float *)0x0;
        }
      }
      else {
        if (param_1 == 0xc03) {
          pfVar5 = (float *)matched_FUN_a03adbe4(param_2,0xc06,param_3,param_4);
          return pfVar5;
        }
        if (param_1 < 0xc04) {
          if (param_1 == 0xc01) {
            pfVar5 = (float *)matched_FUN_a03adb94(param_2,param_3,param_3,param_4);
            return pfVar5;
          }
          if (param_1 == 0xc02) {
            DAT_a1739a74 = (char)*param_2;
            return (float *)0x0;
          }
        }
        else {
          if (param_1 == 0xc04) {
            matched_FUN_a03b3570(local_54 + 0xc,param_3,param_3,param_4);
            matched_FUN_a03aa4b8(0,&DAT_a17951a8);
            if (((uint)param_2 & 0xff) == 1) {
              uVar43 = DAT_a03b3834;
            }
            else {
              uVar43 = DAT_a03b3838;
            }
            DAT_a1794ba5 = matched_FUN_a03b365c(local_54 + 0xc,uVar43);
            *(undefined1 *)param_3 = DAT_a1794ba5;
            DAT_a1788bc0 = in_stack_ffffffdc;
            return (float *)0x0;
          }
          if (param_1 == 0xc05) {
            matched_FUN_a03bc46c((&DAT_a1739a7c)[(int)param_2],0xffffffff,param_3,param_4);
            *param_3 = *(float *)((&DAT_a1739a7c)[(int)param_2] + 0x19c48);
            matched_thunk_FUN_a03c3c5c((&DAT_a1739a7c)[(int)param_2]);
            return (float *)0x0;
          }
        }
      }
      goto LAB_a03b1b40;
    }
    if (param_1 == 0xd05) {
      matched_FUN_a03b3bb8(param_2);
      return (float *)0x0;
    }
    if (0xd05 < param_1) {
      if (param_1 == 0xd08) {
        matched_FUN_a03b448c(param_2,param_3);
        return (float *)0x0;
      }
      if (param_1 < 0xd09) {
        if (param_1 == 0xd06) {
          if (DAT_a0774ea8 == param_2) {
            return (float *)0x0;
          }
          if (DAT_a1763e4c == (int *)0x0) {
            return (float *)0xffffffff;
          }
          DAT_a172e020 = DAT_a1763e4c;
          if (param_2 == (int *)0x0) {
            pfVar5 = (float *)0x0;
          }
          else {
            piVar28 = &DAT_a1739a7c;
            piVar32 = (int *)0x0;
            do {
              pfVar5 = (float *)matched_analyst_pool_alloc(DAT_a172e020,piVar28,0x19d24,100);
              if (pfVar5 == (float *)0x0) {
                pfVar5 = (float *)matched_FUN_a03bc458(*piVar28);
                FUN_a02a70ec(s_<_s>__d__rval___0x_x___MutexCrea_a060ac64,
                             s_AmbaImg_CtrlFunc_MemMgr_Init_a060ab80,piVar32,pfVar5);
              }
              piVar25 = (int *)((int)piVar32 + 1);
              piVar28 = piVar28 + 1;
              FUN_a02a70ec(s_<_s>__d__rval___0x_x_a060ac88,s_AmbaImg_CtrlFunc_MemMgr_Init_a060ab80,
                           piVar32,pfVar5);
              piVar32 = piVar25;
            } while (piVar25 != param_2);
          }
          DAT_a0774ea8 = param_2;
          return pfVar5;
        }
        if (param_1 == 0xd07) {
          matched_FUN_a03b3dd4(param_2,param_3);
          return (float *)0x0;
        }
      }
      else {
        if (param_1 == 0xd09) {
          matched_FUN_a03b3988(param_2,param_3);
          return (float *)0x0;
        }
        if (param_1 == 0xd0a) {
          DAT_a172e01c = param_3;
          return (float *)0x0;
        }
      }
      goto LAB_a03b1b40;
    }
    if (param_1 == 0xd02) {
      switch((uint)param_2 & 0xff) {
      case 0:
        matched_FUN_a03a9a5c(param_3,0x14);
        matched_FUN_a03a9d18(param_3,0x28);
        matched_FUN_a03a978c(param_3,0x32);
        return (float *)0x0;
      case 1:
        matched_FUN_a03a9a5c(param_3,0x14);
        break;
      case 2:
        matched_FUN_a03a9d18(param_3,0x28);
        return (float *)0x0;
      case 3:
        matched_FUN_a03a978c(param_3,0x32,param_3,param_4);
        return (float *)0x0;
      }
      return (float *)0x0;
    }
    if (0xd02 < param_1) {
      if (param_1 == 0xd03) {
        pfVar5 = (float *)matched_FUN_a03b383c(param_2,0xc06,param_3,param_4);
        return pfVar5;
      }
      if (param_1 == 0xd04) {
        matched_FUN_a03b39e0(param_2);
        return (float *)0x0;
      }
      goto LAB_a03b1b40;
    }
    if (param_1 != 0xd00) {
      if (param_1 == 0xd01) {
        uVar23 = (uint)param_2 & 0xff;
        if (uVar23 == 0 && DAT_a1763e40 == '\0') {
          matched_FUN_a04f8dec(&DAT_a17399ec,0,0x44,param_4);
          param_4 = (double *)0x1;
          DAT_a1763e40 = '\x01';
        }
        if (DAT_a1763ea0 == '\0') {
          if (uVar23 != 0) {
            matched_FUN_a04f8dec(&DAT_a1739a30,0,0x44,param_4);
            DAT_a1763ea0 = '\x01';
            goto LAB_a03ad938;
          }
        }
        else if (uVar23 != 0) {
LAB_a03ad938:
          matched_FUN_a029c680(param_3,&DAT_a1739a30,0x44);
          return (float *)0x0;
        }
        matched_FUN_a029c680(param_3,&DAT_a17399ec,0x44);
        return (float *)0x0;
      }
      goto LAB_a03b1b40;
    }
    uVar23 = (uint)param_2 & 0xff;
    if (uVar23 == 0) {
      matched_FUN_a029c680(&DAT_a17399ec,param_3,0x44,param_4);
      if (DAT_a1763e40 != '\0') {
        return (float *)0x0;
      }
    }
    else {
      matched_FUN_a029c680(&DAT_a1739a30,param_3,0x44,param_4);
      if (uVar23 != 0 || DAT_a1763e40 != '\0') goto LAB_a03ad880;
    }
    DAT_a1763e40 = '\x01';
LAB_a03ad880:
    if (DAT_a1763ea0 == '\0' && uVar23 != 0) {
      DAT_a1763ea0 = '\x01';
    }
    return (float *)0x0;
  }
  if (param_1 == 0xb16) {
    pfVar5 = (float *)matched_FUN_a03ad3f4(param_2,0xb16,param_3,param_4);
    return pfVar5;
  }
  local_28 = local_2c;
  if (0xb16 < param_1) {
    if (param_1 == 0xb57) {
      if ((((uint)param_2 & 0xff) == 0) || (((uint)param_2 & 0xff) != 1)) {
        matched_FUN_a029c680(param_3,&DAT_a172e024,0x5ce4);
        return (float *)0x0;
      }
      matched_FUN_a029c680(param_3,&DAT_a1733d08,0x5ce4);
      return (float *)0x0;
    }
    if (0xb57 < param_1) {
      sVar1 = (short)param_4;
      if (param_1 == 0xb5d) {
        iVar9 = ((uint)param_2 & 0xff) * 8;
        *(short *)(&DAT_a07814ba + iVar9) = sVar1;
        matched_FUN_a03b2818((uint)param_2 & 0xff,param_3,&DAT_a07814b4 + iVar9);
        return (float *)0x0;
      }
      if (param_1 < 0xb5e) {
        if (param_1 == 0xb5a) {
          iVar9 = ((uint)param_2 & 0xff) * 8;
          *(short *)(&DAT_a07814b4 + iVar9) = sVar1;
          matched_FUN_a03b2818((uint)param_2 & 0xff,param_3,&DAT_a07814b4 + iVar9);
          return (float *)0x0;
        }
        if (param_1 < 0xb5b) {
          if (param_1 == 0xb58) {
            (&DAT_a178eeac)[(uint)param_2 & 0xff] = uVar3;
            if ((&DAT_a07814f4)[(uint)param_2 & 0xff] == -1) {
              matched_FUN_a03b2d0c();
              return (float *)0x0;
            }
            return (float *)0x0;
          }
          if (param_1 == 0xb59) {
            *(undefined *)param_3 = (&DAT_a178eeac)[(uint)param_2 & 0xff];
            return (float *)0x0;
          }
        }
        else {
          if (param_1 == 0xb5b) {
            iVar9 = ((uint)param_2 & 0xff) * 8;
            *(short *)(&DAT_a07814b6 + iVar9) = sVar1;
            matched_FUN_a03b2818((uint)param_2 & 0xff,param_3,&DAT_a07814b4 + iVar9);
            return (float *)0x0;
          }
          if (param_1 == 0xb5c) {
            iVar9 = ((uint)param_2 & 0xff) * 8;
            *(short *)(&DAT_a07814b8 + iVar9) = sVar1;
            matched_FUN_a03b2818((uint)param_2 & 0xff,param_3,&DAT_a07814b4 + iVar9);
            return (float *)0x0;
          }
        }
      }
      else {
        if (param_1 == 0xb60) {
          *(ushort *)param_3 = *(ushort *)(&DAT_a07814b6 + ((uint)param_2 & 0xff) * 8);
          return (float *)0x0;
        }
        if (param_1 < 0xb61) {
          if (param_1 == 0xb5e) {
            DAT_a077514a = (6 - sVar1) * 0x40;
            DAT_a077516c = (ushort)(((uint)param_4 & 0xffff) << 6);
            DAT_a0775172 = DAT_a077514a;
            DAT_a0775174 = DAT_a077516c;
            matched_FUN_a03af744(param_2,param_3,&DAT_a1763efc);
            matched_FUN_a03af8ec(param_2,param_3,&DAT_a176593c);
            matched_FUN_a03afa0c(param_2,param_3,&DAT_a17640ac);
            matched_FUN_a03afaa4(param_2,param_3,&DAT_a1765a8c);
            matched_FUN_a03af988(param_2,param_3,&DAT_a17672a4);
            return (float *)0x0;
          }
          if (param_1 == 0xb5f) {
            *(ushort *)param_3 = *(ushort *)(&DAT_a07814b4 + ((uint)param_2 & 0xff) * 8);
            return (float *)0x0;
          }
        }
        else {
          if (param_1 == 0xb61) {
            *(ushort *)param_3 = *(ushort *)(&DAT_a07814b8 + ((uint)param_2 & 0xff) * 8);
            return (float *)0x0;
          }
          if (param_1 == 0xb62) {
            *(ushort *)param_3 = *(ushort *)(&DAT_a07814ba + ((uint)param_2 & 0xff) * 8);
            return (float *)0x0;
          }
        }
      }
      goto LAB_a03b1b40;
    }
    if (param_1 == 0xb51) {
      pfVar5 = (float *)matched_FUN_a03ad624((char)*param_2,param_2[1],param_2[2],param_4);
      return pfVar5;
    }
    if (param_1 < 0xb52) {
      if (param_1 == 0xb19) {
        pfVar5 = (float *)matched_FUN_a03ad40c((uint)param_2 & 0xff,0xb19,param_3,param_4);
        return pfVar5;
      }
      if (param_1 < 0xb1a) {
        if (param_1 == 0xb17) {
          piVar32 = &local_5c;
          pdVar36 = param_4;
          local_2c = local_30;
          do {
            pdVar37 = pdVar36;
            piVar28 = piVar32;
            pdVar36 = pdVar37 + 2;
            iVar9 = *(int *)((int)pdVar37 + 4);
            iVar13 = *(int *)(pdVar37 + 1);
            iVar20 = *(int *)((int)pdVar37 + 0xc);
            *piVar28 = *(int *)pdVar37;
            piVar28[1] = iVar9;
            piVar28[2] = iVar13;
            piVar28[3] = iVar20;
            piVar32 = piVar28 + 4;
          } while (pdVar36 != param_4 + 4);
          iVar9 = *(int *)((int)pdVar37 + 0x14);
          iVar13 = *(int *)(pdVar37 + 3);
          piVar28[4] = *(int *)pdVar36;
          piVar28[5] = iVar9;
          piVar28[6] = iVar13;
          if (((float)local_40 == 0.0) || ((float)local_44 == 0.0)) {
            FUN_a02a70ec(s_Warning__ShutterTime_or_AgcGain_v_a060ad54);
            local_68 = (double)(float)local_40;
            FUN_a02a70ec(s_Warning__ShutterTime__f__AgcGain_a060ad84,extraout_r1_01,
                         SUB84((double)(float)local_44,0),
                         (int)((ulonglong)(double)(float)local_44 >> 0x20));
            return (float *)0x0;
          }
          matched_FUN_a0504018(SUB84((double)(float)local_40,0));
          dVar46 = DAT_a03ad128;
          uVar43 = VectorFloatToUnsigned
                             ((DAT_a03ad130 - ((double)(float)local_40 / dVar44) * DAT_a03ad128) +
                              0.5,3);
          local_58._2_2_ = (undefined2)uVar43;
          matched_FUN_a0504018(SUB84((double)(float)local_44 * 30.0,0));
          uVar43 = VectorFloatToUnsigned
                             ((DAT_a03ad138 - (((double)(float)local_44 * 30.0) / dVar44) * dVar46)
                              + 0.5,3);
          local_58 = CONCAT22(local_58._2_2_,(short)uVar43);
          pfVar5 = (float *)matched_FUN_a036fa04
                                      ((uint)param_2 & 0xff,(uint)param_3 & 0xff,&local_5c);
          return pfVar5;
        }
      }
      else {
        if (param_1 == 0xb1a) {
          *(undefined1 *)param_2 = DAT_a0774edc;
          return (float *)0x0;
        }
        if (param_1 == 0xb50) {
          pfVar5 = (float *)matched_FUN_a03ad648((char)*param_2,param_2[1],param_2[2],param_4);
          return pfVar5;
        }
      }
      goto LAB_a03b1b40;
    }
    if (param_1 == 0xb54) {
      matched_FUN_a03ad734(0,param_2);
      return (float *)0x0;
    }
    if (0xb54 < param_1) {
      if (param_1 == 0xb55) {
        if (param_2 == (int *)0x0) {
          pfVar5 = (float *)&DAT_a0774eac;
        }
        else {
          pfVar5 = (float *)&DAT_a0774e18;
        }
        *param_3 = *pfVar5;
        return (float *)0x0;
      }
      if (param_1 == 0xb56) {
        if ((((uint)param_2 & 0xff) == 0) || (((uint)param_2 & 0xff) != 1)) {
          matched_FUN_a029c680(&DAT_a172e024,param_3,0x5ce4);
          return (float *)0x0;
        }
        matched_FUN_a029c680(&DAT_a1733d08,param_3,0x5ce4);
        return (float *)0x0;
      }
      goto LAB_a03b1b40;
    }
    if (param_1 != 0xb52) {
      if (param_1 == 0xb53) {
        pfVar5 = (float *)matched_FUN_a03ad52c(param_2,param_3,param_3,param_4);
        return pfVar5;
      }
      goto LAB_a03b1b40;
    }
    if (param_2 == (int *)0xfe) {
      uVar23 = 0;
    }
    else {
      if (-1 < (int)param_2) {
        if ((int)param_2 < 0x28) {
          if ((int)(uint)*(ushort *)(DAT_a1739a7c + 0xfc98) <= (int)param_2) {
            param_2 = (int *)(uint)*(ushort *)(DAT_a1739a7c + 0xfc98);
          }
          uVar23 = (uint)param_2 & 7;
          switch((int)param_2 >> 3) {
          case 1:
            iVar9 = uVar23 << 8;
            iVar13 = -0x5e8bddc0;
            break;
          case 2:
            iVar9 = uVar23 << 8;
            iVar13 = -0x5e8b56c0;
            break;
          case 3:
            iVar9 = uVar23 << 8;
            iVar13 = -0x5e8acfc0;
            break;
          case 4:
            goto switchD_a03ad4e4_caseD_4;
          default:
            goto switchD_a03ad4e4_default;
          }
        }
        else {
          uVar23 = 7;
switchD_a03ad4e4_caseD_4:
          iVar9 = uVar23 << 8;
          iVar13 = -0x5e8a48c0;
        }
        goto LAB_a03ad464;
      }
      uVar23 = 0;
    }
switchD_a03ad4e4_default:
    iVar9 = uVar23 << 8;
    iVar13 = -0x5e8c64c0;
LAB_a03ad464:
    matched_FUN_a029c680(iVar13 + (iVar9 + uVar23 * 0x20) * 0xf,param_3,0x10e0);
    return (float *)0x0;
  }
  if (param_1 == 0xb0a) {
    pfVar5 = (float *)matched_FUN_a03ad2bc((uint)param_2 & 0xff,param_3,param_3,param_4);
    return pfVar5;
  }
  if (param_1 < 0xb0b) {
    if (param_1 == 0xb04) {
      matched_FUN_a029c680((&DAT_a1739a7c)[(uint)param_2 & 0xff] + 0x4d0c,param_3,0xbc);
      return (float *)0x0;
    }
    if (param_1 < 0xb05) {
      if (param_1 == 0xb01) {
        matched_FUN_a029c680((&DAT_a1739a7c)[(uint)param_2 & 0xff] + 0x4c84,param_3,0x508);
        return (float *)0x0;
      }
      if (param_1 < 0xb02) {
        if (param_1 == 0xb00) {
          matched_FUN_a029c680(param_3,(&DAT_a1739a7c)[(uint)param_2 & 0xff] + 0x4c84,0x508);
          return (float *)0x0;
        }
      }
      else {
        if (param_1 == 0xb02) {
          iVar9 = (&DAT_a1739a7c)[(uint)param_2 & 0xff];
          fVar10 = param_3[1];
          fVar14 = param_3[2];
          fVar21 = param_3[3];
          *(float *)(iVar9 + 0x4b64) = *param_3;
          *(float *)(iVar9 + 0x4b68) = fVar10;
          *(float *)(iVar9 + 0x4b6c) = fVar14;
          *(float *)(iVar9 + 0x4b70) = fVar21;
          fVar10 = param_3[5];
          fVar14 = param_3[6];
          fVar21 = param_3[7];
          *(float *)(iVar9 + 0x4b74) = param_3[4];
          *(float *)(iVar9 + 0x4b78) = fVar10;
          *(float *)(iVar9 + 0x4b7c) = fVar14;
          *(float *)(iVar9 + 0x4b80) = fVar21;
          fVar10 = param_3[9];
          fVar14 = param_3[10];
          fVar21 = param_3[0xb];
          *(float *)(iVar9 + 0x4b84) = param_3[8];
          *(float *)(iVar9 + 0x4b88) = fVar10;
          *(float *)(iVar9 + 0x4b8c) = fVar14;
          *(float *)(iVar9 + 0x4b90) = fVar21;
          *(float *)(iVar9 + 0x4b94) = param_3[0xc];
          return (float *)0x0;
        }
        if (param_1 == 0xb03) {
          pfVar5 = (float *)matched_FUN_a03ad140((uint)param_2 & 0xff,param_3,param_3,param_4);
          return pfVar5;
        }
      }
    }
    else {
      if (param_1 == 0xb07) {
        pfVar5 = (float *)matched_FUN_a03acccc((uint)param_2 & 0xff,param_3,param_3,param_4);
        return pfVar5;
      }
      if (param_1 < 0xb08) {
        if (param_1 == 0xb05) {
          matched_FUN_a029c680(param_3,(&DAT_a1739a7c)[(uint)param_2 & 0xff] + 0x4d0c,0xbc);
          return (float *)0x0;
        }
        if (param_1 == 0xb06) {
          matched_FUN_a029c680((&DAT_a1739a7c)[(uint)param_2 & 0xff] + 0x4b98,param_3,0xec);
          matched_FUN_a03aa574((uint)param_2 & 0xff,1,0);
          return (float *)0x0;
        }
      }
      else {
        if (param_1 == 0xb08) {
          piVar32 = &local_5c;
          pdVar36 = param_4;
          local_2c = local_30;
          do {
            pdVar37 = pdVar36;
            piVar28 = piVar32;
            pdVar36 = pdVar37 + 2;
            iVar9 = *(int *)((int)pdVar37 + 4);
            iVar13 = *(int *)(pdVar37 + 1);
            iVar20 = *(int *)((int)pdVar37 + 0xc);
            *piVar28 = *(int *)pdVar37;
            piVar28[1] = iVar9;
            piVar28[2] = iVar13;
            piVar28[3] = iVar20;
            piVar32 = piVar28 + 4;
          } while (pdVar36 != param_4 + 4);
          iVar9 = *(int *)((int)pdVar37 + 0x14);
          iVar13 = *(int *)(pdVar37 + 3);
          piVar28[4] = *(int *)pdVar36;
          piVar28[5] = iVar9;
          piVar28[6] = iVar13;
          if (((float)local_40 == 0.0) || ((float)local_44 == 0.0)) {
            FUN_a02a70ec(s_Warning__ShutterTime_or_AgcGain_v_a060ad54);
            local_68 = (double)(float)local_40;
            FUN_a02a70ec(s_Warning__ShutterTime__f__AgcGain_a060ad84,extraout_r1,
                         SUB84((double)(float)local_44,0),
                         (int)((ulonglong)(double)(float)local_44 >> 0x20));
            return (float *)0x0;
          }
          matched_FUN_a0504018(SUB84((double)(float)local_40,0));
          dVar41 = DAT_a03ace78;
          uVar43 = VectorFloatToUnsigned
                             ((DAT_a03ace80 - ((double)(float)local_40 / dVar46) * DAT_a03ace78) +
                              0.5,3);
          local_58._2_2_ = (undefined2)uVar43;
          matched_FUN_a0504018(SUB84((double)(float)local_44 * 30.0,0));
          uVar43 = VectorFloatToUnsigned
                             ((DAT_a03ace88 - (((double)(float)local_44 * 30.0) / dVar46) * dVar41)
                              + 0.5,3);
          local_58 = CONCAT22(local_58._2_2_,(short)uVar43);
          pfVar5 = (float *)matched_FUN_a036fb04
                                      ((uint)param_2 & 0xff,(uint)param_3 & 0xff,&local_5c);
          return pfVar5;
        }
        if (param_1 == 0xb09) {
          piVar32 = &local_5c;
          pdVar36 = param_4;
          local_2c = local_30;
          do {
            pdVar37 = pdVar36;
            piVar28 = piVar32;
            pdVar36 = pdVar37 + 2;
            iVar9 = *(int *)((int)pdVar37 + 4);
            iVar13 = *(int *)(pdVar37 + 1);
            iVar20 = *(int *)((int)pdVar37 + 0xc);
            *piVar28 = *(int *)pdVar37;
            piVar28[1] = iVar9;
            piVar28[2] = iVar13;
            piVar28[3] = iVar20;
            piVar32 = piVar28 + 4;
          } while (pdVar36 != param_4 + 4);
          iVar9 = *(int *)((int)pdVar37 + 0x14);
          iVar13 = *(int *)(pdVar37 + 3);
          piVar28[4] = *(int *)pdVar36;
          piVar28[5] = iVar9;
          piVar28[6] = iVar13;
          if (((float)local_40 == 0.0) || ((float)local_44 == 0.0)) {
            FUN_a02a70ec(s_Warning__ShutterTime_or_AgcGain_v_a060ad54);
            local_68 = (double)(float)local_40;
            FUN_a02a70ec(s_Warning__ShutterTime__f__AgcGain_a060ad84,extraout_r1_00,
                         SUB84((double)(float)local_44,0),
                         (int)((ulonglong)(double)(float)local_44 >> 0x20));
            return (float *)0x0;
          }
          matched_FUN_a0504018(SUB84((double)(float)local_40,0));
          dVar46 = DAT_a03acfd0;
          uVar43 = VectorFloatToUnsigned
                             ((DAT_a03acfd8 - ((double)(float)local_40 / dVar41) * DAT_a03acfd0) +
                              0.5,3);
          local_58._2_2_ = (undefined2)uVar43;
          matched_FUN_a0504018(SUB84((double)(float)local_44 * 30.0,0));
          uVar43 = VectorFloatToUnsigned
                             ((DAT_a03acfe0 - (((double)(float)local_44 * 30.0) / dVar41) * dVar46)
                              + 0.5,3);
          local_58 = CONCAT22(local_58._2_2_,(short)uVar43);
          pfVar5 = (float *)matched_FUN_a036fa2c
                                      ((uint)param_2 & 0xff,(uint)param_3 & 0xff,&local_5c);
          return pfVar5;
        }
      }
    }
    goto LAB_a03b1b40;
  }
  if (param_1 == 0xb10) {
    if (((uint)param_3 & 0xff) == 0) {
      puVar6 = (undefined *)0xa1763ea4;
    }
    else {
      puVar6 = &DAT_a1739ab8;
    }
    matched_FUN_a029c680(puVar6,param_4,0x58);
    return (float *)0x0;
  }
  if (param_1 < 0xb11) {
    if (param_1 == 0xb0d) {
      pfVar5 = (float *)matched_FUN_a03ad310((uint)param_2 & 0xff,param_3,param_3,param_4);
      return pfVar5;
    }
    if (param_1 < 0xb0e) {
      if (param_1 == 0xb0b) {
        matched_FUN_a029c680((&DAT_a1739a7c)[(uint)param_2 & 0xff] + 0x51dc,param_3,0xa6b0);
        return (float *)0x0;
      }
      if (param_1 == 0xb0c) {
        iVar13 = (&DAT_a1739a7c)[(uint)param_2 & 0xff];
        iVar9 = matched_FUN_a04f8cc4(iVar13 + 0x518c,param_3,0x50);
        if (iVar9 != 0) {
          matched_FUN_a029c680(iVar13 + 0x518c,param_3,0x50);
          matched_FUN_a03aa574((uint)param_2 & 0xff,2,0);
        }
        return (float *)0x0;
      }
    }
    else {
      if (param_1 == 0xb0e) {
        DAT_a0774ee0 = *param_2;
        DAT_a0774ee4 = param_2[1];
        DAT_a0774ee8 = (short)param_2[2];
        if (DAT_a1763e48 == '\0') {
          DAT_a1763e48 = '\x01';
        }
        return (float *)0x0;
      }
      if (param_1 == 0xb0f) {
        pfVar5 = (float *)matched_FUN_a03adc88(param_2,0xb0a,param_3,param_4);
        return pfVar5;
      }
    }
    goto LAB_a03b1b40;
  }
  if (param_1 == 0xb13) {
    pfVar5 = (float *)matched_FUN_a03adf28(param_2,param_3,param_3,param_4);
    return pfVar5;
  }
  if (0xb13 < param_1) {
    if (param_1 == 0xb14) {
      pfVar5 = (float *)matched_FUN_a03adf9c(param_2,param_3,param_3,param_4);
      return pfVar5;
    }
    if (param_1 == 0xb15) {
      pfVar5 = (float *)matched_FUN_a03ad3e0((uint)param_2 & 0xff,0xb13,param_3,param_4);
      return pfVar5;
    }
    goto LAB_a03b1b40;
  }
  if (param_1 == 0xb11) {
    pfVar5 = (float *)matched_FUN_a03add14(param_2,(uint)param_3 & 0xff,param_4,param_4);
    return pfVar5;
  }
  if (param_1 != 0xb12) goto LAB_a03b1b40;
  puVar39 = *(undefined4 **)((&DAT_a1739a7c)[(int)param_2] + 0x10648);
  DAT_a0775114 = 3;
  local_38 = (ushort *)*puVar39;
  local_34 = (float)puVar39[1];
  DAT_a1739b20 = puVar39[2];
  DAT_a1739b24 = puVar39[3];
  DAT_a1739b28 = puVar39[4];
  iVar9 = puVar39[6];
  uVar23 = puVar39[5] & 0xffff;
  local_30 = (float)DAT_a1739b20;
  local_2c = (float)DAT_a1739b24;
  local_28 = (float)DAT_a1739b28;
  if (uVar23 == 0) {
    if (iVar9 <= (int)(uint)*(ushort *)(param_3 + 4)) goto LAB_a03addd0;
LAB_a03ade30:
    DAT_a0775114 = 2;
    FUN_a02a70ec(s______IP_MODE_LISO_STILL_a060ada8);
    uVar23 = DAT_a1739b20 & 0xffff;
    if (uVar23 == 0) goto LAB_a03ade5c;
LAB_a03addf0:
    if (uVar23 == 1) {
      FUN_a02a70ec(s______AGC_IDX_TYPE_a060adf8);
      goto LAB_a03ade68;
    }
  }
  else {
    if ((uVar23 == 1) && ((int)(uint)*(ushort *)((int)param_3 + 2) < iVar9)) goto LAB_a03ade30;
LAB_a03addd0:
    DAT_a1739b20 = puVar39[5];
    DAT_a1739b24 = iVar9;
    DAT_a1739b28 = puVar39[7];
    FUN_a02a70ec(s______IP_MODE_HISO_STILL_a060adc4);
    uVar23 = DAT_a1739b20 & 0xffff;
    if (uVar23 != 0) goto LAB_a03addf0;
LAB_a03ade5c:
    FUN_a02a70ec(s______ISO_IDX_TYPE_a060ade0);
LAB_a03ade68:
    if ((DAT_a1739b20 & 0xffff) == 0) {
      uVar18 = matched_FUN_a036f958((uint)param_2 & 0xff,1,*(ushort *)(param_3 + 4),DAT_a1739b24);
      goto LAB_a03addfc;
    }
    if ((DAT_a1739b20 & 0xffff) == 1) {
      uVar23 = matched_FUN_a036f958((uint)param_2 & 0xff,1,*(ushort *)(param_3 + 4),0xfffe);
      iVar9 = (uVar23 & 0xffff) - DAT_a1739b24;
      uVar18 = (ushort)iVar9 & ~(ushort)(iVar9 >> 0x1f);
      goto LAB_a03addfc;
    }
  }
  uVar18 = *(ushort *)((int)param_3 + 2);
LAB_a03addfc:
  bVar2 = DAT_a0775114;
  *(ushort *)((int)param_3 + 2) = uVar18 + (short)DAT_a1739b28;
  *(ushort *)(param_3 + 5) = (ushort)bVar2;
  return (float *)0x0;
}

