// Seed known RTOS entry points before whole-image analysis.
//@category Yi4k
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.SourceType;
import java.nio.file.*;
import java.math.BigInteger;
import java.util.*;

public class Yi4kPrepare extends GhidraScript {
    public void run() throws Exception {
        int good = 0, bad = 0;
        for (String filename : getScriptArgs()) {
            if (!Files.exists(Path.of(filename))) continue;
            for (String line : Files.readAllLines(Path.of(filename))) {
                if (line.isBlank() || line.startsWith("#")) continue;
                String[] parts = line.split("\t");
                long raw = Long.parseUnsignedLong(parts[0].replace("0x", ""), 16);
                Address at = toAddr(raw & ~1L);
                String name = parts[1].replaceAll("[^A-Za-z0-9_]", "_");
                try {
                    var tmode = currentProgram.getRegister("TMode");
                    if (getInstructionAt(at) == null)
                        currentProgram.getProgramContext().setValue(tmode, at, at,
                            (raw & 1) != 0 ? BigInteger.ONE : BigInteger.ZERO);
                    disassemble(at);
                    Function f = getFunctionAt(at);
                    if (f == null) f = createFunction(at, name);
                    if (f != null) {
                        f.setName(name, SourceType.USER_DEFINED);
                        f.setRepeatableComment("Static analysis seed; provenance: " + filename + ": " + line);
                        good++;
                    } else bad++;
                } catch (Exception e) {
                    println("SEED_FAILED " + line + " " + e);
                    bad++;
                }
            }
        }
        println("YI4K_SEEDS good=" + good + " failed=" + bad);
    }
}
