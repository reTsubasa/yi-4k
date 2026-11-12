// Export selected device functions after discovery/renaming, including data refs.
//@category Yi4k
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import com.google.gson.*;
import java.nio.file.*;
import java.util.*;

public class Yi4kFocusedExport extends GhidraScript {
    public void run() throws Exception {
        Path out = Path.of(getScriptArgs()[0]);
        Files.createDirectories(out);
        List<Map<String,Object>> rows = new ArrayList<>();
        var dec = new DecompInterface();
        dec.setOptions(new DecompileOptions());
        dec.openProgram(currentProgram);
        try {
            for (String line : Files.readAllLines(Path.of(getScriptArgs()[1]))) {
                if (line.isBlank() || line.startsWith("#")) continue;
                String[] parts = line.split("\t");
                var at = toAddr(Long.parseUnsignedLong(parts[0],16) & ~1L);
                var f = getFunctionAt(at);
                if (f == null) { println("FOCUSED_MISSING " + at); continue; }
                Map<String,Object> row = new LinkedHashMap<>();
                row.put("entry","0x"+at); row.put("name", f.getName());
                row.put("body_bytes",f.getBody().getNumAddresses());
                List<Map<String,Object>> refs = new ArrayList<>();
                StringBuilder asm = new StringBuilder();
                var it = currentProgram.getListing().getInstructions(f.getBody(),true);
                while (it.hasNext()) {
                    var i = it.next();
                    asm.append("0x").append(i.getAddress()).append("  ").append(i).append("\n");
                    for (var r : i.getReferencesFrom()) {
                        var target = r.getToAddress();
                        Map<String,Object> ref = new LinkedHashMap<>();
                        ref.put("from","0x"+i.getAddress()); ref.put("to","0x"+target);
                        ref.put("type",r.getReferenceType().toString());
                        var block = currentProgram.getMemory().getBlock(target);
                        if (block != null) {
                            ref.put("block",block.getName()); ref.put("initialized",block.isInitialized());
                        }
                        refs.add(ref);
                    }
                }
                Files.writeString(out.resolve(at+".asm"),asm.toString());
                row.put("references",refs);
                var result = dec.decompileFunction(f,60,monitor);
                boolean ok = result.decompileCompleted() && result.getDecompiledFunction()!=null;
                row.put("decompile_completed",ok);
                if (ok) Files.writeString(out.resolve(at+".c"),
                    "/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */\n\n"+
                    result.getDecompiledFunction().getC());
                else row.put("error",result.getErrorMessage());
                rows.add(row);
                println("DEVICE_FOCUSED " + at + " " + ok);
            }
        } finally { dec.dispose(); }
        Files.writeString(out.resolve("functions.json"),new GsonBuilder().setPrettyPrinting().create().toJson(rows)+"\n");
    }
}
