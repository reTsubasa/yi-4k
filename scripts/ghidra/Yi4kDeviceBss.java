// Reconstruct BSS only from this imported image's own reset clear-loop literals.
//@category Yi4k
import ghidra.app.script.GhidraScript;

public class Yi4kDeviceBss extends GhidraScript {
    public void run() throws Exception {
        long start = Integer.toUnsignedLong(getInt(toAddr(0xa010022cL)));
        long end = (Integer.toUnsignedLong(getInt(toAddr(0xa0100230L))) & ~3L) + 4;
        if (start < 0xa0800000L || end <= start || end > 0xa3000000L)
            throw new IllegalArgumentException("Unexpected startup clear range");
        if (currentProgram.getMemory().getBlock(toAddr(start)) == null) {
            var block = currentProgram.getMemory().createUninitializedBlock(
                "startup_bss_candidate", toAddr(start), end-start, false);
            block.setRead(true); block.setWrite(true); block.setExecute(false);
            block.setComment("Device image reset clear-loop literals; static candidate, not live capture.");
        }
        println("DEVICE_BSS " + Long.toHexString(start) + ".." + Long.toHexString(end));
    }
}
