// Export the complete discovered function inventory, assembly, references and decompiler attempts.
//@category Yi4k
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import com.google.gson.*;
import java.nio.file.*;
import java.io.*;
import java.util.*;

public class Yi4kExport extends GhidraScript {
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private void json(Path p, Object value) throws Exception {
        try (Writer w = Files.newBufferedWriter(p)) { gson.toJson(value, w); }
    }
    public void run() throws Exception {
        Path out = Path.of(getScriptArgs()[0]);
        Files.createDirectories(out);
        Files.createDirectories(out.resolve("decompiled"));
        List<Map<String,Object>> functions = new ArrayList<>();
        List<Map<String,Object>> failures = new ArrayList<>();
        AddressSet bodies = new AddressSet();
        int success = 0, count = 0;
        DecompInterface decompiler = new DecompInterface();
        decompiler.setOptions(new DecompileOptions());
        decompiler.openProgram(currentProgram);
        long start = System.currentTimeMillis();
        try (BufferedWriter calls = Files.newBufferedWriter(out.resolve("calls.tsv"));
             BufferedWriter symbols = Files.newBufferedWriter(out.resolve("symbols.tsv"))) {
            calls.write("caller\tsite\ttarget\ttype\n");
            symbols.write("address\tname\tsource\n");
            FunctionIterator it = currentProgram.getFunctionManager().getFunctions(true);
            while (it.hasNext() && !monitor.isCancelled()) {
                Function f = it.next();
                String entry = f.getEntryPoint().toString();
                Map<String,Object> row = new LinkedHashMap<>();
                row.put("entry", "0x" + entry);
                row.put("name", f.getName());
                row.put("signature", f.getSignature().toString());
                row.put("signature_source", f.getSignatureSource().toString());
                row.put("body_bytes", f.getBody().getNumAddresses());
                row.put("is_thunk", f.isThunk());
                row.put("thumb_context", String.valueOf(currentProgram.getProgramContext().getValue(currentProgram.getRegister("TMode"), f.getEntryPoint(), false)));
                List<String> ranges = new ArrayList<>();
                for (AddressRange r : f.getBody().getAddressRanges())
                    ranges.add(r.getMinAddress() + "-" + r.getMaxAddress());
                row.put("body_ranges", ranges);
                bodies.add(f.getBody());
                symbols.write("0x" + entry + "\t" + f.getName() + "\t" + f.getSymbol().getSource() + "\n");
                InstructionIterator inst = currentProgram.getListing().getInstructions(f.getBody(), true);
                int ninst = 0;
                while (inst.hasNext()) {
                    Instruction i = inst.next(); ninst++;
                    for (Reference r : i.getReferencesFrom()) {
                        if (r.getReferenceType().isCall() || r.getReferenceType().isJump())
                            calls.write("0x" + entry + "\t0x" + i.getAddress() + "\t0x" + r.getToAddress() + "\t" + r.getReferenceType() + "\n");
                    }
                }
                row.put("instruction_count", ninst);
                try {
                    DecompileResults result = decompiler.decompileFunction(f, 8, monitor);
                    if (result.decompileCompleted() && result.getDecompiledFunction() != null) {
                        String relative = "decompiled/" + entry + ".c";
                        Files.writeString(out.resolve(relative),
                            "/* Ghidra-generated pseudocode, not original source.\n" +
                            " * Entry: 0x" + entry + ", name: " + f.getName() + ".\n" +
                            " * Types and names may be inferred. Runtime validation not performed. */\n\n" +
                            result.getDecompiledFunction().getC());
                        row.put("decompiled_file", relative);
                        row.put("decompile_status", "completed");
                        success++;
                    } else {
                        row.put("decompile_status", "failed");
                        row.put("decompile_error", result.getErrorMessage());
                        failures.add(row);
                    }
                } catch (Exception e) {
                    row.put("decompile_status", "exception");
                    row.put("decompile_error", e.toString());
                    failures.add(row);
                }
                functions.add(row); count++;
                if (count % 100 == 0) {
                    println("YI4K_EXPORT functions=" + count + " decompiled=" + success +
                        " elapsed_s=" + (System.currentTimeMillis()-start)/1000);
                    calls.flush(); symbols.flush();
                    json(out.resolve("progress.json"), Map.of("functions",count,"decompiled",success,"elapsed_seconds",(System.currentTimeMillis()-start)/1000));
                }
            }
        } finally { decompiler.dispose(); }
        json(out.resolve("functions.json"), functions);
        json(out.resolve("decompile-failures.json"), failures);
        long ninstr = 0;
        try (BufferedWriter asm = Files.newBufferedWriter(out.resolve("listing.asm"));
             BufferedWriter refs = Files.newBufferedWriter(out.resolve("references.tsv"))) {
            refs.write("from\tto\ttype\n");
            var listing = currentProgram.getListing();
            var it = listing.getInstructions(true);
            while (it.hasNext()) {
                Instruction i = it.next(); ninstr++;
                asm.write("0x" + i.getAddress() + "  " + i.toString() + "\n");
                for (Reference r : i.getReferencesFrom())
                    refs.write("0x" + i.getAddress() + "\t0x" + r.getToAddress() + "\t" + r.getReferenceType() + "\n");
            }
        }
        Map<String,Object> coverage = new LinkedHashMap<>();
        coverage.put("program", currentProgram.getName());
        coverage.put("language", currentProgram.getLanguageID().toString());
        coverage.put("image_base", "0x" + currentProgram.getImageBase());
        List<Map<String,Object>> blocks = new ArrayList<>();
        for (var block : currentProgram.getMemory().getBlocks())
            blocks.add(Map.of("name",block.getName(),"start","0x"+block.getStart(),"end","0x"+block.getEnd(),"bytes",block.getSize(),"initialized",block.isInitialized()));
        coverage.put("memory_blocks", blocks);
        coverage.put("executable_sha256", currentProgram.getExecutableSHA256());
        coverage.put("discovered_functions",count);
        coverage.put("decompilations_completed",success);
        coverage.put("decompilations_failed",failures.size());
        coverage.put("function_body_union_bytes",bodies.getNumAddresses());
        coverage.put("recognized_instruction_count",ninstr);
        coverage.put("elapsed_export_seconds",(System.currentTimeMillis()-start)/1000);
        coverage.put("limitations",List.of("Automatic static analysis; not a proof of complete function discovery.","Raw binary contains code and data; inferred boundaries and types may be wrong.","No on-device execution or ABI validation performed.","Indirect calls may remain unresolved."));
        json(out.resolve("coverage.json"),coverage);
        println("YI4K_EXPORT_COMPLETE " + gson.toJson(coverage));
    }
}
