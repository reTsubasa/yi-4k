/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 shell_ipc_rpc_handler(int param_1,int param_2,code *param_3)

{
  undefined2 uVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  undefined4 *puVar5;
  int iVar6;
  int local_440;
  int local_43c;
  int local_434;
  undefined4 local_430;
  undefined4 local_42c;
  undefined4 local_428;
  undefined4 *local_424;
  undefined1 local_29;
  
  if (param_1 == 1) {
    (*param_3)(s_supported_test_commands_a05a6da8);
    (*param_3)(s_rpc_list__list_registered_progra_a05a6f48);
    (*param_3)(s_rpc_svc__prog_name_____register_p_a05a6f74);
    (*param_3)(s_rpc_svc__prog_name_____unregiste_a05a6fa4);
    (*param_3)(s_supported_programs__test__test_r_a05a6fd4);
    (*param_3)(s_exec__execute_command_in_Linux__a05a7010);
    (*param_3)(s_rpc_clnt_test_1_str__echo__str__a05a7054);
    (*param_3)(s_rpc_clnt_test_2_a__calulate_a_a_a05a707c);
    (*param_3)(s_rpc_clnt_exec1__command___execut_a05a70a4);
    (*param_3)(s_rpc_clnt_exec2__command___execut_a05a70f4);
    (*param_3)(s_rpc_profile_start_a05a7130);
    (*param_3)(s_rpc_profile_stop_a05a7148);
    return 1;
  }
  uVar4 = *(undefined4 *)(param_2 + 4);
  iVar2 = matched_FUN_a04f9744(uVar4,&DAT_a05a7160);
  if (iVar2 == 0) {
    matched_FUN_a03caa4c(param_3);
    return 0;
  }
  iVar2 = matched_FUN_a04f9744(uVar4,&DAT_a05a7168);
  if (iVar2 == 0) {
    if (param_1 != 4) {
      (*param_3)(s_invalid_input_for_svc_a05a716c);
      return 0;
    }
    iVar2 = matched_FUN_a04f9744
                      (*(undefined4 *)(param_2 + 8),
                       s__I__PB_MULTI_FUNC___06d___s__Han_a05311f0 + 0x38);
    if (iVar2 != 0) {
      return 0;
    }
    if (**(char **)(param_2 + 0xc) == '+') {
      uVar4 = matched_FUN_a03cd2d8(0x1000);
      local_428 = 2;
      local_424 = (undefined4 *)matched_FUN_a03cd2d8(0x10);
      local_424[1] = 1;
      local_424[3] = 0;
      *local_424 = &LAB_a0245620;
      local_424[2] = &LAB_a024566c;
      matched_FUN_a03caab4(0x10000001,1,s_test_rpc_svc_a05a7184,0x41,uVar4,0x1000,&local_428,1);
      matched_FUN_a03cd264(local_424);
      return 0;
    }
    matched_FUN_a03cac1c(0x10000001,1);
    return 0;
  }
  iVar2 = matched_FUN_a04f9744(uVar4,&DAT_a05a7194);
  if (iVar2 != 0) {
    iVar2 = matched_FUN_a04f9744(uVar4,s_profile_a05a6d7c);
    if (iVar2 != 0) {
      (*param_3)(s_unknown_command__s_a05a7200,uVar4);
      return 0;
    }
    uVar4 = *(undefined4 *)(param_2 + 8);
    iVar2 = matched_FUN_a04f9744(uVar4,s__Applib___StillEnc__<QvFreeBuf>_s_a0590184 + 0x20);
    if (iVar2 == 0) {
      matched_FUN_a03c8988();
      return 0;
    }
    iVar2 = matched_FUN_a04f9744(uVar4,s_factory_burnin_test_stop_a056bf64 + 0x14);
    if (iVar2 == 0) {
      matched_FUN_a03c8ab0();
      return 0;
    }
    return 0;
  }
  uVar4 = *(undefined4 *)(param_2 + 8);
  iVar2 = matched_FUN_a04f9744(uVar4,s__I__PB_MULTI_FUNC___06d___s__Han_a05311f0 + 0x38);
  if (iVar2 == 0) {
    local_440 = matched_FUN_a03c4e94(0,0x20000003,1);
    iVar2 = 0;
    local_43c = 0;
  }
  else {
    iVar2 = matched_FUN_a04f9744(uVar4,s_exec1_a05a719c);
    if ((iVar2 != 0) && (iVar2 = matched_FUN_a04f9744(uVar4,s_exec2_a05a71a4), iVar2 != 0))
    goto LAB_a02460bc;
    local_440 = matched_FUN_a03c4e94(0,0x20000001,1);
    iVar2 = matched_FUN_a03cd2d8(0x65);
    local_43c = matched_FUN_a03cd2d8(0x800);
    matched_FUN_a04f8dec(local_43c,0,0x800);
    matched_FUN_a04f9900(iVar2,*(undefined4 *)(param_2 + 0xc));
    uVar1 = s_1_____awb_no_whites____d___6d____a05fc8e8._48_2_;
    if (4 < param_1) {
      puVar5 = (undefined4 *)(param_2 + 0xc);
      iVar6 = 4;
      do {
        iVar6 = iVar6 + 1;
        iVar3 = matched_FUN_a04f99f0(iVar2);
        *(undefined2 *)(iVar2 + iVar3) = uVar1;
        puVar5 = puVar5 + 1;
        matched_FUN_a04f9900(iVar2 + iVar3 + 1,*puVar5);
      } while (iVar6 != param_1);
    }
  }
  if (local_440 != 0) {
    uVar4 = *(undefined4 *)(param_2 + 8);
    iVar6 = matched_FUN_a04f9744(uVar4,s__I__PB_MULTI_FUNC___06d___s__Han_a05311f0 + 0x38);
    if (iVar6 == 0) {
      if (**(char **)(param_2 + 0xc) == '1') {
        matched_FUN_a0245cb4(*(undefined4 *)(param_2 + 0x10),0,local_440);
        uVar4 = *(undefined4 *)(param_2 + 8);
      }
      else if (**(char **)(param_2 + 0xc) == '2') {
        matched_FUN_a04f94a0
                  (*(undefined4 *)(param_2 + 0x10),s_Short_Line___d_a062fe68 + 0x10,&local_430);
        local_42c = local_430;
        matched_FUN_a03c4f40(local_440,2,&local_430,8,&local_434,4,1000);
        (*param_3)(s_return_value_is__d_a05a71c4,local_434);
        uVar4 = *(undefined4 *)(param_2 + 8);
      }
    }
    iVar6 = matched_FUN_a04f9744(uVar4,s_exec1_a05a719c);
    if (iVar6 == 0) {
      local_434 = rpc_linux_exec1(iVar2,local_43c,local_440);
      matched_FUN_a03cd264(iVar2);
      if (local_434 != 0) {
        (*param_3)(s_Execute_exec1_failed__status__d_a05a71dc,local_434);
        matched_FUN_a03cd264(local_43c);
        return 0;
      }
      iVar2 = matched_FUN_a04f99f0(local_43c);
      iVar2 = iVar2 + 1;
      if (0 < iVar2) {
        iVar6 = local_43c;
        do {
          if (iVar2 < 0x401) {
            matched_FUN_a029c680(&local_428,iVar6,iVar2);
          }
          else {
            matched_FUN_a029c680(&local_428,iVar6,0x3ff);
            local_29 = 0;
          }
          iVar2 = iVar2 + -0x400;
          (*param_3)(s_Create_SYS_ID___s_a0635564 + 0x10,&local_428);
          iVar6 = iVar6 + 0x400;
        } while (0 < iVar2);
      }
      matched_FUN_a03cd264(local_43c);
    }
    else {
      iVar6 = matched_FUN_a04f9744(uVar4,s_exec2_a05a71a4);
      if (iVar6 == 0) {
        local_434 = matched_FUN_a03c91d0(iVar2,local_43c,local_440);
        if (local_434 != 0) {
          (*param_3)(s_Execute_exec1_failed__status__d_a05a71dc,local_434);
        }
        matched_FUN_a03cd264(local_43c);
        matched_FUN_a03cd264(iVar2);
      }
    }
    matched_FUN_a03c4c1c(local_440);
    return 0;
  }
LAB_a02460bc:
  (*param_3)(s_Client_creation_failed_a05a71ac);
  return 0;
}

