/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 eis_task_create_2(undefined4 param_1,undefined4 param_2)

{
  matched_analyst_task_create
            (&DAT_a170ba90,s_AmbaImageMainEisAlgo2Task_a06017dc,param_1,eis_algo2_task,0,
             DAT_a03976f0,0x2000,0);
  matched_thunk_FUN_a03c0bc4(&DAT_a170ba90,param_2);
  matched_analyst_task_suspend_candidate(&DAT_a170ba90);
  return 0;
}

