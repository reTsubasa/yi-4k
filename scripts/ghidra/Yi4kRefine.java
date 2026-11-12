// Add the startup-observed BSS range; apply a few analyst ABI reconstructions.
// Retry failed decompilations with a larger per-function timeout.
//@category Yi4k
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.app.cmd.function.ApplyFunctionSignatureCmd;
import ghidra.app.util.cparser.C.CParser;
import ghidra.program.model.data.FunctionDefinition;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.SourceType;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.nio.file.*;
import java.io.*;
import java.util.*;

public class Yi4kRefine extends GhidraScript {
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    public void run() throws Exception {
        Path out = Path.of(getScriptArgs()[0]);
        var mem = currentProgram.getMemory();
        if (mem.getBlock(toAddr(0xa0fb3000L)) == null) {
            var b = mem.createUninitializedBlock("startup_bss_candidate",toAddr(0xa0fb3000L),0xa9e17cL,false);
            b.setRead(true); b.setWrite(true); b.setExecute(false);
            b.setComment("Bounds read from reset clear loop literals at file offsets 0x22c/0x230. Static BSS candidate, no runtime ownership claim.");
        }
        String[][] prototypes = {
            {"a029e098","int analyst_t_command_register(const char *name, void *handler)"},
            {"a032e0c8","void *analyst_fs_fopen(const char *path, const char *mode)"},
            {"a032e0d0","int analyst_fs_fclose(void *file)"},
            {"a032e0d4","unsigned int analyst_fs_fread(void *buffer, unsigned int size, unsigned int count, void *file)"},
            {"a032e0d8","unsigned int analyst_fs_fwrite(const void *buffer, unsigned int size, unsigned int count, void *file)"},
            {"a03bc320","unsigned int analyst_task_sleep(unsigned int raw_ticks)"},
            {"a03bc6dc","unsigned int analyst_pool_allocate(void *pool, void **output, unsigned int bytes, unsigned int timeout)"},
            {"a03bc714","unsigned int analyst_pool_release(void *allocation)"},
            {"a03bc2bc","unsigned int analyst_task_create(void *task, const char *name, unsigned int priority, void *entry, unsigned int arg, void *stack, unsigned int stack_bytes, unsigned int auto_start)"},
            {"a0498728","void analyst_dcache_clean(void *address, unsigned int bytes)"},
            {"a049878c","void analyst_dcache_invalidate(void *address, unsigned int bytes)"},
            {"a04987f0","void analyst_dcache_flush(void *address, unsigned int bytes)"}
        };
        Set<String> retry = new HashSet<>();
        var parser = new CParser(currentProgram.getDataTypeManager());
        for (var p : prototypes) {
            var at = toAddr(Long.parseUnsignedLong(p[0],16));
            var signature = (FunctionDefinition)parser.parse(p[1]+";");
            var cmd = new ApplyFunctionSignatureCmd(at,signature,SourceType.USER_DEFINED);
            if (!cmd.applyTo(currentProgram,monitor)) println("PROTOTYPE_FAILED " + p[0] + " " + cmd.getStatusMsg());
            retry.add("0x"+p[0]);
        }
        List<Map<String,Object>> all;
        try (Reader r = Files.newBufferedReader(out.resolve("functions.json"))) {
            all = gson.fromJson(r,new TypeToken<List<Map<String,Object>>>(){}.getType());
        }
        for (var row : all)
            if (!"completed".equals(row.get("decompile_status"))) retry.add((String)row.get("entry"));
        // Refine all named functions as well, after core signatures are applied.
        for (var row : all)
            if (!((String)row.get("name")).startsWith("FUN_")) retry.add((String)row.get("entry"));
        var dec = new DecompInterface();
        dec.setOptions(new DecompileOptions());
        dec.openProgram(currentProgram);
        int success=0,failed=0;
        for (var row : all) {
            String entry = (String)row.get("entry");
            if (!retry.contains(entry)) continue;
            Function f = getFunctionAt(toAddr(Long.parseUnsignedLong(entry.substring(2),16)));
            if (f == null) continue;
            row.put("name",f.getName());
            row.put("signature",f.getSignature().toString());
            row.put("signature_source",f.getSignatureSource().toString());
            DecompileResults result = dec.decompileFunction(f,40,monitor);
            if (result.decompileCompleted() && result.getDecompiledFunction()!=null) {
                String relative="decompiled/"+entry.substring(2)+".c";
                Files.writeString(out.resolve(relative),"/* Analyst-refined Ghidra pseudocode; not original source.\n * ABI candidates are static reconstructions and have no runtime validation. */\n\n"+result.getDecompiledFunction().getC());
                row.put("decompiled_file",relative); row.put("decompile_status","completed");
                row.remove("decompile_error"); success++;
            } else {
                row.put("decompile_status","failed"); row.put("decompile_error",result.getErrorMessage());failed++;
            }
            println("YI4K_REFINE " + entry + " " + row.get("decompile_status"));
        }
        dec.dispose();
        List<Map<String,Object>> failures=new ArrayList<>();
        int completed=0;
        for(var row:all) { if("completed".equals(row.get("decompile_status")))completed++;else failures.add(row); }
        try(Writer w=Files.newBufferedWriter(out.resolve("functions.json"))){gson.toJson(all,w);}
        try(Writer w=Files.newBufferedWriter(out.resolve("decompile-failures.json"))){gson.toJson(failures,w);}
        Map<String,Object> coverage;
        try(Reader r=Files.newBufferedReader(out.resolve("coverage.json"))){coverage=gson.fromJson(r,new TypeToken<Map<String,Object>>(){}.getType());}
        coverage.put("decompilations_completed",completed);
        coverage.put("decompilations_failed",failures.size());
        List<Map<String,Object>> blocks = new ArrayList<>();
        for (var block : currentProgram.getMemory().getBlocks())
            blocks.add(Map.of("name",block.getName(),"start","0x"+block.getStart(),"end","0x"+block.getEnd(),"bytes",block.getSize(),"initialized",block.isInitialized()));
        coverage.put("memory_blocks",blocks);
        coverage.put("refinement",Map.of("retried",retry.size(),"completed",success,"failed",failed,"timeout_seconds",40,"bss_candidate_start","0xa0fb3000","bss_candidate_end_exclusive","0xa1a5117c"));
        try(Writer w=Files.newBufferedWriter(out.resolve("coverage.json"))){gson.toJson(coverage,w);}
        println("YI4K_REFINE_COMPLETE completed="+completed+" failed="+failures.size());
    }
}
