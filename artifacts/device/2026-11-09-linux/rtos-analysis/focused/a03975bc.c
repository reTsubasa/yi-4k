/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 eis_task_create_1(undefined4 param_1,undefined4 param_2)

{
  matched_FUN_a03bc3dc(&DAT_a170bd04,0);
  matched_FUN_a03bc3dc(&DAT_a170bc98,0);
  matched_FUN_a03bc3dc(&DAT_a170bcdc);
  matched_FUN_a03bc3dc(&DAT_a170bb68,0);
  matched_FUN_a03bc3dc(&DAT_a170bcbc,0);
  matched_FUN_a03bc49c(&DAT_a170bb88);
  matched_analyst_task_create
            (&DAT_a170bbb0,s_AmbaImageMainEisTask_a06017c4,param_1,eis_main_task,0,0xa0ac9200,0x2000
             ,0);
  matched_thunk_FUN_a03c0bc4(&DAT_a170bbb0,param_2);
  matched_analyst_task_suspend_candidate(&DAT_a170bbb0);
  return 0;
}

