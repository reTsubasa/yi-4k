/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void eis_process_deferred_enable(void)

{
  if (((DAT_a170404c != '\0') || (DAT_a170404b != '\0')) && (DAT_a17045a4 == '\0')) {
    if (DAT_a170404b == '\0') {
      if ((DAT_a170404c != '\0') && (DAT_a1702cac != 0)) {
        if (DAT_a170423c < DAT_a1702cac) {
          DAT_a170423c = DAT_a170423c + 1;
        }
        else if (DAT_a170404a == '\0') {
          DAT_a1702cac = 0;
          DAT_a170423c = 0;
          DAT_a170404c = '\0';
          if (DAT_a170404e != '\0') {
            DAT_a17042f2 = 1;
            DAT_a1704045 = 1;
            DAT_a170404e = '\0';
          }
          if (DAT_a170404f != '\0') {
            DAT_a17042f3 = 1;
            DAT_a1704046 = 1;
            DAT_a170404f = '\0';
          }
        }
      }
    }
    else if (DAT_a1702cac != 0) {
      if (DAT_a170423c < DAT_a1702cac) {
        DAT_a170423c = DAT_a170423c + 1;
      }
      else if (DAT_a170404a == '\0') {
        DAT_a1702cac = 0;
        DAT_a170423c = 0;
        eis_enable();
        FUN_a02a70ec(s_EisObj_EnablePref__d_a05ffb84,DAT_a170404e);
        FUN_a02a70ec(s_EisObj_RscEnablePref__d_a05ffb9c,DAT_a170404f);
        if (DAT_a170404e == '\0') {
          matched_FUN_a0383788(0);
        }
        if (DAT_a170404f == '\0') {
          matched_FUN_a038391c(0);
        }
        eis_set_pending_enable_preferences(0,0);
        FUN_a02a70ec(s_EisObj_EnablePref__d_a05ffb84,DAT_a170404e);
        FUN_a02a70ec(s_EisObj_RscEnablePref__d_a05ffb9c,DAT_a170404f);
      }
    }
  }
  return;
}

