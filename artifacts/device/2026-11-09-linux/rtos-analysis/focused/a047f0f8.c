/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 gyro_open(void)

{
  undefined4 uVar1;
  undefined1 local_15;
  undefined1 local_14;
  undefined1 local_13;
  undefined2 local_12;
  
  local_15 = 0x80;
  local_12 = 0;
  matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_15,&local_12,800);
  if (local_12._1_1_ == -0x2f) {
    local_13 = 0x11;
    local_14 = 0x7e;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_14,0,1000);
    matched_analyst_task_sleep(5);
    local_13 = 0x15;
    local_14 = 0x7e;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_14,0,1000);
    matched_analyst_task_sleep(5);
    local_14 = 0x40;
    local_13 = 0x2c;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_14,0,1000);
    local_14 = 0x41;
    local_13 = 8;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_14,0,1000);
    local_14 = 0x42;
    local_13 = 0xd;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_14,0,1000);
    local_14 = 0x43;
    local_13 = 3;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,2,&local_14,0,1000);
    uVar1 = 0;
  }
  else {
    FUN_a02a70ec(s_ERROR__Bosch_gyro_ID__0x_x___rea_a06288b0,0xd1);
    FUN_a02a70ec(s_ERROR__Cannot_open_gyro_with_SPI_a06288e4);
    uVar1 = 0xffffffff;
    DAT_a1a3560c = 0xffff;
  }
  return uVar1;
}

