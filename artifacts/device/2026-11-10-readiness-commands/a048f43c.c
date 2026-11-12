/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa048f43c, name: matched_FUN_a048f43c.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4 matched_FUN_a048f43c(code *param_1)

{
  int iVar1;
  undefined4 uVar2;
  uint uVar3;
  int iVar4;
  uint uVar5;
  undefined4 local_2c [2];
  
  iVar4 = DAT_a1796304;
  if (param_1 == (code *)0x0) {
    uVar2 = 0xffffffff;
  }
  else {
    (*param_1)(s_ID_PRI_PREEMPT_SCHED_STAT_NEXT_I_a062c9c0);
    (*param_1)(s__________________________________a062ca44);
    if (DAT_a17962fc != 0) {
      uVar5 = 0;
      do {
        iVar1 = matched_FUN_a03c4500
                          (iVar4,&DAT_a1a399e8,&DAT_a1a399ec,&DAT_a1a399f0,&DAT_a1a399f8,
                           &DAT_a1a399fc,&DAT_a1a399f4,&DAT_a1a39a00,&DAT_a1a39a04);
        if ((iVar1 == 0) && (DAT_a1a399ec != 2)) {
          if (DAT_a17962fc == 0) {
LAB_a048f540:
            uVar3 = uVar5;
          }
          else if (DAT_a1a39a04 == DAT_a1796304) {
            uVar3 = 0;
          }
          else {
            uVar3 = 0;
            iVar1 = DAT_a1796304;
            do {
              uVar3 = uVar3 + 1;
              iVar1 = *(int *)(iVar1 + 0x8c);
              if (uVar3 == DAT_a17962fc) goto LAB_a048f540;
            } while (DAT_a1a39a04 != iVar1);
          }
          matched_FUN_a03bc7e0(iVar4,local_2c);
          iVar1 = *(int *)(iVar4 + 0x10);
          (*param_1)(s__3d_5d_9d_7d_16s_9d_9d_9d_9d_0x__a062cac4,uVar5,DAT_a1a399f8,DAT_a1a399fc,
                     DAT_a1a399f0,*(undefined4 *)(&DAT_a062c988 + DAT_a1a399ec * 4),uVar3,
                     *(undefined4 *)(iVar4 + 0x14),iVar1 + (1 - *(int *)(iVar4 + 0xc4)),
                     iVar1 + (1 - *(int *)(iVar4 + 8)),*(undefined4 *)(iVar4 + 0xc),iVar1,
                     *(int *)(iVar4 + 8),local_2c[0],DAT_a1a399e8);
          iVar4 = *(int *)(iVar4 + 0x8c);
        }
        uVar5 = uVar5 + 1;
      } while (uVar5 < DAT_a17962fc);
    }
    uVar2 = 0;
  }
  return uVar2;
}

