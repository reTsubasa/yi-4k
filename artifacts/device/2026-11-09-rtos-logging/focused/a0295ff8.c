/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


bool rtos_cached_pool_contains(uint param_1,int param_2)

{
  if (param_1 < DAT_a1445410) {
    return false;
  }
  return param_1 + param_2 <= DAT_a1445410 + DAT_a1445418;
}

