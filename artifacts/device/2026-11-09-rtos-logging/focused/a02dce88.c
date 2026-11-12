/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void shell_dsp_syslog_register(void)

{
  undefined4 extraout_r2;
  undefined4 in_r3;
  
  matched_analyst_t_register(&DAT_a056a8f4,&LAB_a02dad40);
  matched_analyst_t_register(s_syslog_a05cee78,shell_syslog_handler,extraout_r2,in_r3);
  return;
}

