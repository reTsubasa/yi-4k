/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa048fca0, name: matched_FUN_a048fca0.
 * Types and names may be inferred. Runtime validation not performed. */


int matched_FUN_a048fca0(code *param_1)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  int *piVar6;
  int iVar7;
  int *piVar8;
  
  iVar7 = DAT_a17962d4;
  if (param_1 == (code *)0x0) {
    iVar7 = -1;
  }
  else {
    (*param_1)(s__________________________________a062cd88);
    (*param_1)(s_______Total__3d_Byte_pool_______a062cdb0,DAT_a17962b4);
    (*param_1)(s__________________________________a062cd88);
    (*param_1)(s_ID_Available_Fragement_Size_Star_a062ce30);
    iVar1 = DAT_a048fe28;
    if (DAT_a17962b4 != 0) {
      uVar5 = 0;
      do {
        iVar2 = matched_FUN_a03c36c4
                          (iVar7,&DAT_a1a39be0,&DAT_a1a39be4,&DAT_a1a39be8,DAT_a048fe28,
                           DAT_a048fe28 + 4,DAT_a048fe28 + 8);
        if (iVar2 != 0) {
          (*param_1)(s_Error_get__d_byte_pool_a062cdfc,uVar5);
          return iVar2;
        }
        (*param_1)(s__3d__10d__8d__10d__p_a062ce60,uVar5,*(undefined4 *)(iVar1 + -8),
                   *(undefined4 *)(iVar1 + -4),*(undefined4 *)(iVar7 + 0x1c),
                   *(undefined4 *)(iVar7 + 0x18));
        (*param_1)(s_ID_Start_End_Size_Free_a062ce7c);
        uVar3 = 0;
        piVar8 = *(int **)(iVar7 + 0x10);
        if (*(int *)(iVar7 + 0xc) != 0) {
          do {
            piVar6 = (int *)*piVar8;
            uVar4 = uVar3 + 1;
            (*param_1)(s__3d__p__p__10d__01d_a062ceb4,uVar3,piVar8,piVar6,(int)piVar6 - (int)piVar8,
                       piVar8[1] == -0x1112);
            uVar3 = uVar4;
            piVar8 = piVar6;
          } while (uVar4 < *(uint *)(iVar7 + 0xc));
        }
        uVar5 = uVar5 + 1;
        iVar7 = *(int *)(iVar7 + 0x2c);
      } while (uVar5 < DAT_a17962b4);
    }
    iVar7 = 0;
  }
  return iVar7;
}

