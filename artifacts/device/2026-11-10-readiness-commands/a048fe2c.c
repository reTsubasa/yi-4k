/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa048fe2c, name: matched_FUN_a048fe2c.
 * Types and names may be inferred. Runtime validation not performed. */


int matched_FUN_a048fe2c(code *param_1)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  int iVar5;
  undefined4 *puVar6;
  int iVar7;
  char *pcVar8;
  
  iVar5 = DAT_a17962b0;
  if (param_1 == (code *)0x0) {
    iVar5 = -1;
  }
  else {
    (*param_1)(s__________________________________a062cc20);
    (*param_1)(s________Total__3d_Block_pool______a062ced4,DAT_a17962b8);
    (*param_1)(s__________________________________a062cc20);
    (*param_1)(s_ID_Available_TotalBlocks_Name_a062cefc);
    iVar1 = DAT_a048ff4c;
    if (DAT_a17962b8 != 0) {
      iVar7 = DAT_a048ff4c + 4;
      puVar6 = (undefined4 *)(DAT_a048ff4c + -0xc);
      uVar4 = 0;
      do {
        iVar2 = matched_FUN_a03c33d8
                          (iVar5,&DAT_a1a39bc8,&DAT_a1a39bcc,&DAT_a1a39bd0,iVar1,iVar7,&DAT_a1a39bdc
                          );
        if (iVar2 != 0) {
          (*param_1)(s_Error_get__d_block_pool_a062cf24);
          return iVar2;
        }
        pcVar8 = (char *)*puVar6;
        uVar3 = uVar4 + 1;
        if (pcVar8 == (char *)0x0) {
          pcVar8 = s_1_____awb_no_whites____d___6d____a05fc8e8 + 0x30;
        }
        (*param_1)(s__3d__10d__8d__s_a062cf40,uVar4,*(undefined4 *)(iVar1 + -8),
                   *(undefined4 *)(iVar1 + -4),pcVar8);
        iVar5 = *(int *)(iVar5 + 0x28);
        uVar4 = uVar3;
      } while (uVar3 < DAT_a17962b8);
    }
    iVar5 = 0;
  }
  return iVar5;
}

