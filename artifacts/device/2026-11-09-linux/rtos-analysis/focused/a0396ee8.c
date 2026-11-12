/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void eis_algo2_task(void)

{
  uint local_c;
  
  do {
    do {
      matched_FUN_a03bc4ac(&DAT_a170bb88,0x10000,3,&local_c,0xffffffff);
    } while ((local_c & 0x10000) == 0);
    image_command_dispatch(0x1010,0,0,0);
  } while( true );
}

