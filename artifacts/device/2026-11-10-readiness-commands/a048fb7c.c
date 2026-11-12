/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa048fb7c, name: matched_FUN_a048fb7c.
 * Types and names may be inferred. Runtime validation not performed. */


int matched_FUN_a048fb7c(code *param_1)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  int iVar5;
  undefined4 *puVar6;
  int iVar7;
  char *pcVar8;
  
  iVar5 = DAT_a17962d4;
  if (param_1 == (code *)0x0) {
    iVar5 = -1;
  }
  else {
    (*param_1)(s__________________________________a062cd88);
    (*param_1)(s_______Total__3d_Byte_pool_______a062cdb0,DAT_a17962b4);
    (*param_1)(s__________________________________a062cd88);
    (*param_1)(s_ID_Available_Fragement_Name_a062cdd8);
    iVar1 = DAT_a048fc9c;
    if (DAT_a17962b4 != 0) {
      iVar7 = DAT_a048fc9c + 4;
      puVar6 = (undefined4 *)(DAT_a048fc9c + -0xc);
      uVar4 = 0;
      do {
        iVar2 = matched_FUN_a03c36c4
                          (iVar5,&DAT_a1a39be0,&DAT_a1a39be4,&DAT_a1a39be8,iVar1,iVar7,&DAT_a1a39bf4
                          );
        if (iVar2 != 0) {
          (*param_1)(s_Error_get__d_byte_pool_a062cdfc);
          return iVar2;
        }
        pcVar8 = (char *)*puVar6;
        uVar3 = uVar4 + 1;
        if (pcVar8 == (char *)0x0) {
          pcVar8 = s_1_____awb_no_whites____d___6d____a05fc8e8 + 0x30;
        }
        (*param_1)(s__3d__10d__8d__s_a062ce18,uVar4,*(undefined4 *)(iVar1 + -8),
                   *(undefined4 *)(iVar1 + -4),pcVar8);
        iVar5 = *(int *)(iVar5 + 0x2c);
        uVar4 = uVar3;
      } while (uVar3 < DAT_a17962b4);
    }
    iVar5 = 0;
  }
  return iVar5;
}

