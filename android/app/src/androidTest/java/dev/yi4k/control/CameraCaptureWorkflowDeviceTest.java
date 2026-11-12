package dev.yi4k.control;

import android.app.Activity;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.media.MediaMetadataRetriever;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.Uri;
import android.os.Bundle;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.accessibility.AccessibilityWindowInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayDeque;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Explicit ordinary-camera-write acceptance, run alone with yi4k_camera_control=true,
 * yi4k_camera_host and a runner-generated yi4k_control_run_id UUID. No mocked network,
 * injected CameraClient or private reflection. New camera files intentionally remain on SD.
 */
public final class CameraCaptureWorkflowDeviceTest extends InstrumentationTestCase {
    private static final String QUALITY="video_quality";
    private static final String RESOLUTION="video_resolution";
    private static final String CAPTURE_MODE="capture_mode", SINGLE_PHOTO="precise quality";
    private Context context;
    private ContentResolver resolver;
    private Network network;
    private Activity activity;
    private String host,runId;
    private Object originalQuality,requestedQuality,originalCaptureMode;
    private String requestedResolution,originalResolution,originalFov,resolutionFov,dialogTitle="视频质量";
    private int recordSeconds;
    private JSONObject beforeSettings;
    private boolean qualityRequested,resolutionRequested,modeRequested,capturePreferenceRequested,recordOwned,recordStopRequested,recordStopped,finished;
    private int originalAccessibilityFlags=-1,qualityDialogNumber;
    private final JSONObject evidence=new JSONObject();
    private final JSONArray events=new JSONArray();

    public void testRealUiConfigurationShortVideoPhotoRestoreAndDecode() throws Exception {
        Bundle args=((InstrumentationTestRunner)getInstrumentation()).getArguments();
        assertEquals("Explicit ordinary camera capture opt-in required","true",args.getString("yi4k_camera_control"));
        host=args.getString("yi4k_camera_host");assertNotNull("Explicit camera host required",host);
        runId=args.getString("yi4k_control_run_id");assertNotNull("Runner UUID required",runId);
        assertEquals(runId,UUID.fromString(runId).toString());
        recordSeconds=Integer.parseInt(args.getString("yi4k_record_seconds","3"));
        assertTrue("Explicit bounded capture duration required",recordSeconds>=3&&recordSeconds<=65);
        requestedResolution=args.getString("yi4k_capture_resolution");
        boolean expectUnsupportedEis="true".equals(args.getString("yi4k_expect_unsupported_eis"));
        context=getInstrumentation().getTargetContext();resolver=context.getContentResolver();network=awaitWifi();
        evidence.put("run_id",runId);evidence.put("events",events);evidence.put("new_media",new JSONArray());
        evidence.put("requested_record_seconds",recordSeconds);
        Set<Long> videoRowsBefore=ownedRows(true),photoRowsBefore=ownedRows(false);
        try {
            AccessibilityServiceInfo service=getInstrumentation().getUiAutomation().getServiceInfo();
            assertNotNull("UI automation accessibility service required",service);
            originalAccessibilityFlags=service.flags;
            service.flags|=AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS
                    |AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS
                    |AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS;
            getInstrumentation().getUiAutomation().setServiceInfo(service);
            Map<String,MediaEntry> before;
            CameraClient check=openCamera();
            try {
                assertEquals("Capture acceptance requires an initially idle camera","idle",status(check));
                beforeSettings=CameraClient.flattenSettings(check.call(3));
                assertTrue(beforeSettings.getString("sw_version").startsWith("Z16V13L_1.10.7_"));
                assertEquals("record",beforeSettings.getString("system_mode"));
                assertEquals("record",beforeSettings.getString("rec_mode"));
                assertEquals("insert",beforeSettings.getString("sd_card_status"));
                JSONObject battery=check.call(13);assertTrue("Battery/adapter must be >=20%",battery.getInt("param")>=20);
                assertTrue("Unexpected power response", "battery".equals(battery.optString("type"))||"adapter".equals(battery.optString("type")));
                // msg3 can omit the inactive photo preference. Save it with a
                // read-only getter before any product UI mode/capture action.
                originalCaptureMode=beforeSettings.has(CAPTURE_MODE) ? beforeSettings.get(CAPTURE_MODE)
                        : check.call(1,CameraClient.args("type",CAPTURE_MODE)).get("param");
                beforeSettings.put(CAPTURE_MODE,originalCaptureMode);
                List<Object> photoModes=CameraSettings.writableOptions(CAPTURE_MODE,
                        check.call(9,CameraClient.args("param",CAPTURE_MODE)));
                assertTrue("Original photo submode must be restorable",photoModes.contains(originalCaptureMode));
                assertTrue("Single-photo capture must be advertised",photoModes.contains(SINGLE_PHOTO));
                evidence.put("capture_mode_before",originalCaptureMode);
                originalQuality=beforeSettings.get(QUALITY);
                originalResolution=beforeSettings.getString(RESOLUTION);
                originalFov=beforeSettings.optString("fov","");
                if(requestedResolution!=null){
                    List<Object> resolutions=CameraSettings.writableOptions(RESOLUTION,check.call(9,CameraClient.args("param",RESOLUTION)));
                    assertTrue("Requested resolution must be advertised, never fabricated",resolutions.contains(requestedResolution));
                    assertTrue("Original resolution must remain restorable",resolutions.contains(originalResolution));
                    assertFalse("Resolution acceptance must exercise a real change",requestedResolution.equals(originalResolution));
                    evidence.put("resolution_before",originalResolution);evidence.put("resolution_requested",requestedResolution);
                }
                List<Object> options=CameraSettings.writableOptions(QUALITY,check.call(9,CameraClient.args("param",QUALITY)));
                assertTrue("Original quality must be a real advertised scalar option",options.contains(originalQuality));
                for(Object option:options)if(!Objects.equals(option,originalQuality)){requestedQuality=option;break;}
                assertNotNull("Camera must advertise a different settable scalar video_quality; do not fabricate an option",requestedQuality);
                String selectedLabel=CameraSettings.displayValue(QUALITY,requestedQuality);
                assertEquals("Quality labels must select one unambiguous real wire value",1,options.stream().filter(value->selectedLabel.equals(CameraSettings.displayValue(QUALITY,value))).count());
                before=snapshot(check);evidence.put("settings_before",beforeSettings);evidence.put("before_media_count",before.size());
                evidence.put("quality_before",originalQuality);evidence.put("quality_requested",requestedQuality);
            } finally {check.disconnect();}
            event("preflight_session_closed");
            activity=getInstrumentation().startActivitySync(new Intent(context,MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            getInstrumentation().waitForIdleSync();connectExplicitTestEndpoint();
            click("设置");openQualityOptions();
            qualityRequested=true;
            clickDialogOption(CameraSettings.displayValue(QUALITY,requestedQuality));
            waitText("配置已更新",15000);saveScreen("capture-quality-changed.png");
            if(requestedResolution!=null){
                openSettingOptions("视频分辨率"); resolutionRequested=true;
                clickDialogOption(CameraSettings.displayValue(RESOLUTION,requestedResolution));
                waitText("配置已更新",15000);saveScreen("capture-resolution-changed.png");
            }
            disconnectUi();
            check=openCamera();
            try {
                requireReady(check);
                Object actual=check.call(1,CameraClient.args("type",QUALITY)).get("param");
                assertEquals("Actual fresh-session quality readback",requestedQuality,actual);
                evidence.put("quality_changed_readback",actual);event("quality_write_readback_confirmed");
                if(resolutionRequested){
                    String actualResolution=check.call(1,CameraClient.args("type",RESOLUTION)).getString("param");
                    assertEquals(requestedResolution,actualResolution);evidence.put("resolution_changed_readback",actualResolution);
                    resolutionFov=check.call(1,CameraClient.args("type","fov")).getString("param");
                    evidence.put("resolution_fov_readback",resolutionFov);
                }
                if(expectUnsupportedEis){
                    String support=check.call(1,CameraClient.args("type","eis_support_status")).getString("param");
                    String preference=check.call(1,CameraClient.args("type","iq_eis_enable")).getString("param");
                    assertEquals("off",support);evidence.put("eis_support_readback",support);evidence.put("eis_preference_readback",preference);
                }
            } finally {check.disconnect();}
            // Use the real settings connection button for the new session; no parallel token owner.
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host));waitText("连接成功",20000);click("拍摄");
            click("录像");waitDescription("开始录像",15000);
            if(expectUnsupportedEis){waitText("防抖\n规格不支持",10000);saveScreen("capture-unsupported-eis.png");event("real_camera_unsupported_eis_shown");}
            event("ui_record_start_requested_once");clickDescription("开始录像");
            // The product confirms with the shutter shape/state and haptics,
            // not a success message. This dedicated session started from
            // ready and sent one UI action; final new-file checks remain required.
            waitDescription("停止录像",15000);
            recordOwned=true;captureMarker("capture_record_started");event("ui_record_active_confirmed");
            saveScreen("capture-recording.png");Thread.sleep(recordSeconds*1000L);
            clickDescription("停止录像");waitDescription("开始录像",15000);
            recordStopped=true;captureMarker("capture_record_stopped");event("ui_record_stop_confirmed");
            modeRequested=true;click("照片");waitDescription("拍照",15000);
            // The photo tab preserves the inactive preference. Explicitly
            // choose single photo through the product UI, rather than relying
            // on the compound capture request to overwrite burst/self-timer.
            if(!Objects.equals(originalCaptureMode,SINGLE_PHOTO)){
                click("设置");openSettingOptions("拍照模式");
                capturePreferenceRequested=true;
                clickDialogOption(CameraSettings.displayValue(CAPTURE_MODE,SINGLE_PHOTO));
                waitText("配置已更新",15000);click("拍摄");waitDescription("拍照",15000);
            }
            event("ui_photo_requested_once");clickDescription("拍照");
            waitDescription("拍照",20000);
            saveScreen("capture-photo-accepted.png");
            // Restore the inactive photo preference first. Its setter also
            // activates the photo parent, so the original record parent must
            // be activated last through its original child preference.
            click("设置");
            if(capturePreferenceRequested){
                openSettingOptions("拍照模式");
                clickDialogOption(CameraSettings.displayValue(CAPTURE_MODE,originalCaptureMode));
                waitText("配置已更新",15000);event("ui_restored_original_capture_submode");
            }
            click("拍摄");click("录像");waitDescription("开始录像",15000);
            click("设置");
            if(resolutionRequested){
                openSettingOptions("视频分辨率");clickDialogOption(CameraSettings.displayValue(RESOLUTION,originalResolution));
                waitText("配置已更新",15000);
                if(resolutionFov!=null&&!originalFov.equals(resolutionFov)){
                    openSettingOptions("视野范围");clickDialogOption(CameraSettings.displayValue("fov",originalFov));
                    waitText("配置已更新",15000);
                }
            }
            openQualityOptions();clickDialogOption(CameraSettings.displayValue(QUALITY,originalQuality));
            waitText("配置已更新",15000);saveScreen("capture-restored.png");disconnectUi();
            check=openCamera();
            try {
                awaitReady(check,15000);
                JSONObject afterSettings=settingsWithPhotoPreference(check);
                assertRestored(afterSettings);evidence.put("settings_after",afterSettings);
                evidence.put("quality_after_readback",afterSettings.get(QUALITY));
                Map<String,MediaEntry> after=awaitNewMedia(check,before,15000);
                for(Map.Entry<String,MediaEntry> previous:before.entrySet()){
                    assertTrue("Existing camera file must remain: "+previous.getKey(),after.containsKey(previous.getKey()));
                    assertEquals("Existing camera entry metadata must remain",previous.getValue().info,after.get(previous.getKey()).info);
                }
                int videos=0,photos=0;
                JSONArray newMedia=new JSONArray();
                for(MediaEntry entry:after.values())if(!before.containsKey(entry.path)&&entry.isMedia()){
                    boolean video=entry.name.toUpperCase(Locale.ROOT).endsWith(".MP4");
                    if(video)videos++;else photos++;
                    JSONObject media=exportAndDecode(entry,video);newMedia.put(media);evidence.put("new_media",newMedia);
                    Bundle report=new Bundle();report.putString("capture_new_media",media.toString());getInstrumentation().sendStatus(0,report);
                }
                assertEquals("Exactly this test's one short recording must be created",1,videos);
                assertEquals("Exactly this test's one photograph must be created",1,photos);
                evidence.put("after_media_count",after.size());evidence.put("final_status",status(check));
                requireReady(check);assertRestored(settingsWithPhotoPreference(check));
            } finally {check.disconnect();}
            evidence.put("complete",true);finished=true;
            evidence.put("scope","explicit test endpoint (nearby-hotspot selection bypassed), real MainActivity Wi-Fi route/API, advertised quality"+(resolutionRequested?" and resolution":"")+" write/readback, UI "+recordSeconds+"-second record/stop and photograph, UI restore/disconnect, fresh-session list/download/hash/Android decode");
            evidence.put("limitations","Android runtime under test; host runner must independently hash new camera files and compare complete before/after directory, boot and settings. New camera files retained. Not a physical-phone hotspot acceptance.");
        } catch(Throwable failure) {
            evidence.put("failure",failure.toString());
            if(failure instanceof Error)throw (Error)failure;
            if(failure instanceof Exception)throw (Exception)failure;
            throw new AssertionError(failure);
        } finally {
            try {
                if(activity!=null){runUi(activity::finish);getInstrumentation().waitForIdleSync();}
            } finally {
                try {
                    if(!finished)try {recoverOnlyKnownChanges();}
                    catch(Throwable recoveryFailure){
                        evidence.put("recovery_failure",recoveryFailure.toString());
                        // Keep the original capture/transport failure primary.
                        if(!evidence.has("failure")){
                            if(recoveryFailure instanceof Error)throw (Error)recoveryFailure;
                            if(recoveryFailure instanceof Exception)throw (Exception)recoveryFailure;
                            throw new AssertionError(recoveryFailure);
                        }
                    }
                }
                finally {
                    try {try {cleanAdded(true,videoRowsBefore);}finally{cleanAdded(false,photoRowsBefore);}}
                    finally {
                        try {writeEvidence();}
                        finally {
                            if(originalAccessibilityFlags>=0){
                                AccessibilityServiceInfo service=getInstrumentation().getUiAutomation().getServiceInfo();
                                if(service!=null){service.flags=originalAccessibilityFlags;getInstrumentation().getUiAutomation().setServiceInfo(service);}
                            }
                        }
                    }
                }
            }
        }
    }

    private void recoverOnlyKnownChanges() throws Exception {
        if(beforeSettings==null||(!qualityRequested&&!resolutionRequested&&!modeRequested&&!recordOwned))return;
        CameraClient camera=openCamera();
        try {
            String state=status(camera);evidence.put("recovery_status_before",state);
            evidence.put("recovery_record_owned",recordOwned).put("recovery_stop_already_requested",recordStopRequested);
            if("record".equals(state)){
                if(!recordOwned||recordStopRequested||recordStopped){
                    evidence.put("recovery_skipped","active recording ownership or prior STOP outcome unknown; no stop retry or configuration writes");return;
                }
                recordStopRequested=true;
                captureMarker("capture_record_stop_requested");
                camera.call(514,new JSONObject());awaitReady(camera,15000);
                recordStopped=true;captureMarker("capture_record_stopped");event("finally_stopped_owned_recording");
            } else if(!CameraState.isReady(state)){
                evidence.put("recovery_skipped","camera busy/unknown; no capture retries or configuration writes");return;
            }
            JSONObject actual=CameraClient.flattenSettings(camera.call(3));
            Object photoMode=actual.has(CAPTURE_MODE) ? actual.get(CAPTURE_MODE)
                    : camera.call(1,CameraClient.args("type",CAPTURE_MODE)).get("param");
            String parent=actual.optString("system_mode");
            // Validate the whole owned write set before changing any child.
            // A fresh read can resolve a lost reply, but does not authorize
            // overwriting an unexpected external mode/preference change.
            if(!("record".equals(parent)||(modeRequested&&"capture".equals(parent)))
                    ||!Objects.equals(actual.opt("rec_mode"),beforeSettings.get("rec_mode"))){
                evidence.put("recovery_skipped","unexpected parent or record submode; no configuration writes");return;
            }
            if(!Objects.equals(photoMode,originalCaptureMode)
                    &&!(capturePreferenceRequested&&Objects.equals(photoMode,SINGLE_PHOTO))){
                evidence.put("recovery_skipped","unexpected photo submode; no configuration writes");return;
            }
            Object qualityBeforeRecovery=actual.get(QUALITY);
            if(!Objects.equals(qualityBeforeRecovery,originalQuality)
                    &&!(qualityRequested&&Objects.equals(qualityBeforeRecovery,requestedQuality))){
                evidence.put("recovery_skipped","unexpected quality; no configuration writes");return;
            }
            if(resolutionRequested){
                Object resolution=actual.get(RESOLUTION);
                if(!Objects.equals(resolution,originalResolution)&&!Objects.equals(resolution,requestedResolution)){
                    evidence.put("recovery_skipped","unexpected resolution; no configuration writes");return;
                }
                String fov=actual.optString("fov","");
                if(!originalFov.equals(fov)&&(resolutionFov==null||!resolutionFov.equals(fov))){
                    evidence.put("recovery_skipped","unattributed FOV change; no configuration writes");return;
                }
            }
            if(!Objects.equals(photoMode,originalCaptureMode)){
                CameraConfiguration.set(camera,CAPTURE_MODE,originalCaptureMode);
                event("finally_restored_original_capture_submode");
            }
            // The capture child restoration above changes the parent. Activate
            // the original record child without selectMode(record), which
            // would overwrite a nonordinary record preference in future cases.
            CameraConfiguration.set(camera,"system_mode",beforeSettings.get("system_mode"));
            event("finally_restored_original_parent_via_original_child");
            if(resolutionRequested){
                String resolution=camera.call(1,CameraClient.args("type",RESOLUTION)).getString("param");
                if(Objects.equals(resolution,requestedResolution)){
                    CameraConfiguration.set(camera,RESOLUTION,originalResolution);event("finally_restored_own_resolution_change");
                }else if(!Objects.equals(resolution,originalResolution)){
                    evidence.put("recovery_skipped","unexpected resolution; no overwrite of possible external change");return;
                }
                String fov=camera.call(1,CameraClient.args("type","fov")).getString("param");
                if(resolutionFov!=null&&!originalFov.equals(resolutionFov)&&resolutionFov.equals(fov)){
                    CameraConfiguration.set(camera,"fov",originalFov);event("finally_restored_own_resolution_fov_side_effect");
                }else if(!originalFov.equals(fov)){
                    evidence.put("recovery_skipped","unexpected FOV; no overwrite of possible external change");return;
                }
            }
            Object quality=camera.call(1,CameraClient.args("type",QUALITY)).get("param");
            if(qualityRequested&&Objects.equals(quality,requestedQuality)){
                CameraConfiguration.set(camera,QUALITY,originalQuality);event("finally_restored_own_quality_change");
            } else if(!Objects.equals(quality,originalQuality)){
                evidence.put("recovery_skipped","unexpected quality; no overwrite of possible external change");return;
            }
            JSONObject restored=settingsWithPhotoPreference(camera);assertRestored(restored);
            evidence.put("recovery_settings_after",restored);
        } catch(Exception failure){evidence.put("recovery_failure",failure.toString());throw failure;}
        finally {camera.disconnect();}
    }
    private JSONObject settingsWithPhotoPreference(CameraClient camera) throws Exception {
        JSONObject snapshot=CameraClient.flattenSettings(camera.call(3));
        if(!snapshot.has(CAPTURE_MODE)) snapshot.put(CAPTURE_MODE,
                camera.call(1,CameraClient.args("type",CAPTURE_MODE)).get("param"));
        return snapshot;
    }
    private void assertRestored(JSONObject actual) throws Exception {
        assertEquals(originalQuality,actual.get(QUALITY));
        assertEquals(beforeSettings.getString("system_mode"),actual.getString("system_mode"));
        assertEquals(beforeSettings.getString("rec_mode"),actual.getString("rec_mode"));
        assertEquals("Exact inactive photo preference must be restored",originalCaptureMode,actual.get(CAPTURE_MODE));
        assertEquals(originalResolution,actual.getString(RESOLUTION));
        assertEquals(originalFov,actual.optString("fov",""));
    }
    private JSONObject exportAndDecode(MediaEntry entry,boolean video) throws Exception {
        assertTrue("New camera original needs a confirmed size",entry.bytes>0);
        Set<Long> before=ownedRows(video);AtomicLong progress=new AtomicLong();
        String transfer=new MediaExporter().export(resolver,network,host,entry,()->false,progress::set);
        assertEquals(entry.bytes,progress.get());Set<Long> added=ownedRows(video);added.removeAll(before);
        assertEquals(1,added.size());Uri saved=ContentUris.withAppendedId(collection(video),added.iterator().next());
        try(Cursor row=resolver.query(saved,new String[]{MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE},null,null,null)){
            assertNotNull(row);assertTrue(row.moveToFirst());assertEquals(0,row.getInt(0));assertEquals(entry.bytes,row.getLong(1));
        }
        String sha;try(InputStream input=resolver.openInputStream(saved)){sha=digest(input);}
        assertTrue("Transfer and independent published-file SHA must agree",transfer.contains(sha));
        JSONObject result=new JSONObject();result.put("path",entry.path);result.put("name",entry.name);result.put("bytes",entry.bytes);result.put("sha256",sha);result.put("type",video?"video":"photo");
        if(video)try(MediaMetadataRetriever reader=new MediaMetadataRetriever()){
            reader.setDataSource(context,saved);assertEquals("yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO));
            Bitmap frame=reader.getFrameAtTime(0,MediaMetadataRetriever.OPTION_CLOSEST);assertNotNull("New camera recording must decode on Android",frame);
            try{result.put("decoded_width",frame.getWidth());result.put("decoded_height",frame.getHeight());}finally{frame.recycle();}
            long duration=Long.parseLong(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
            assertTrue("Actual recording duration must match requested bounded capture: "+duration,
                    duration>=recordSeconds*1000L-500&&duration<=recordSeconds*1000L+12000);
            if(requestedResolution!=null){
                java.util.regex.Matcher dimensions=java.util.regex.Pattern.compile("^(\\d+)x(\\d+)").matcher(requestedResolution);
                assertTrue(dimensions.find());
                assertEquals("Actual video width must match changed resolution",Integer.parseInt(dimensions.group(1)),result.getInt("decoded_width"));
                assertEquals("Actual video height must match changed resolution",Integer.parseInt(dimensions.group(2)),result.getInt("decoded_height"));
            }
            result.put("duration_ms",duration);result.put("has_audio",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
        }else try(InputStream input=resolver.openInputStream(saved)){
            BitmapFactory.Options options=new BitmapFactory.Options();options.inSampleSize=4;
            Bitmap image=BitmapFactory.decodeStream(input,null,options);assertNotNull("New camera photograph must decode on Android",image);
            try{result.put("decoded_width",image.getWidth());result.put("decoded_height",image.getHeight());result.put("source_width",options.outWidth);result.put("source_height",options.outHeight);}finally{image.recycle();}
        }
        assertTrue(result.getInt("decoded_width")>0&&result.getInt("decoded_height")>0);return result;
    }
    private CameraClient openCamera() throws Exception {
        CameraClient camera=new CameraClient(event->{});
        try{camera.connect(network.getSocketFactory(),host,7878);return camera;}
        catch(Exception error){camera.disconnect();throw error;}
    }
    private static String status(CameraClient camera) throws Exception{return camera.call(1,CameraClient.args("type","app_status")).getString("param");}
    private static void requireReady(CameraClient camera) throws Exception{assertTrue("Camera must be ready",CameraState.isReady(status(camera)));}
    private static void awaitReady(CameraClient camera,long timeout) throws Exception{
        long deadline=SystemClock.uptimeMillis()+timeout;do{if(CameraState.isReady(status(camera)))return;Thread.sleep(200);}while(SystemClock.uptimeMillis()<deadline);fail("Camera did not return to idle/VF");
    }
    private static Map<String,MediaEntry> snapshot(CameraClient camera) throws Exception {
        Map<String,MediaEntry> result=new LinkedHashMap<>();Set<String> seen=new HashSet<>();ArrayDeque<String> todo=new ArrayDeque<>();todo.add(MediaEntry.DCIM_ROOT);
        while(!todo.isEmpty()){
            String folder=todo.remove();assertTrue("No repeated DCIM directory",seen.add(folder));assertTrue("Bounded media tree required",seen.size()<=100);
            JSONObject response=camera.call(1282,CameraClient.args("param",folder));JSONArray rows=response.getJSONArray("listing");
            assertTrue("Complete directory listing required",response.optInt("total",rows.length())<=rows.length());
            for(int i=0;i<rows.length();i++){
                JSONObject row=rows.getJSONObject(i);Iterator<String> keys=row.keys();while(keys.hasNext()){
                    String name=keys.next();MediaEntry entry=new MediaEntry(folder,name,row.getString(name));
                    if(entry.directory)todo.add(entry.path);else result.put(entry.path,entry);
                }
            }
        }return result;
    }
    private static Map<String,MediaEntry> awaitNewMedia(CameraClient camera,Map<String,MediaEntry> before,long timeout) throws Exception {
        long deadline=SystemClock.uptimeMillis()+timeout;
        do {
            Map<String,MediaEntry> after=snapshot(camera);boolean video=false,photo=false;
            for(MediaEntry entry:after.values())if(!before.containsKey(entry.path)){
                String name=entry.name.toUpperCase(Locale.ROOT);video|=name.endsWith(".MP4");photo|=name.endsWith(".JPG")||name.endsWith(".JPEG");
            }
            if(video&&photo)return after;Thread.sleep(300);
        }while(SystemClock.uptimeMillis()<deadline);throw new AssertionError("Both newly captured MP4 and JPEG must appear in actual DCIM listing");
    }
    private Network awaitWifi() throws Exception {
        ConnectivityManager manager=(ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);long deadline=SystemClock.uptimeMillis()+20000;
        do{for(Network candidate:manager.getAllNetworks()){
            NetworkCapabilities caps=manager.getNetworkCapabilities(candidate);if(caps!=null&&caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI))return candidate;
        }Thread.sleep(200);}while(SystemClock.uptimeMillis()<deadline);throw new AssertionError("Real Android Wi-Fi Network required; no injection permitted");
    }
    private void connectExplicitTestEndpoint() throws Exception {
        runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host));
        waitText("连接成功",20000); event("explicit_test_endpoint_connected_via_product_wifi_route");
    }
    private void disconnectUi() throws Exception {
        runUi(() -> MainActivityTestDriver.disconnect(activity)); waitText("已断开",15000); event("ui_disconnected");
    }
    private void openQualityOptions() throws Exception {
        openSettingOptions("视频质量");
    }
    private void openSettingOptions(String title) throws Exception {
        runUi(() -> MainActivityTestDriver.openSettingTitle(activity, title));
        dialogTitle=title;
        qualityDialogNumber++;
        waitText(title,15000);

        runUi(()->{
            View label=findText(activity.getWindow().getDecorView(),title);assertNotNull(label);
            View row=label;while(!row.isClickable()&&row.getParent() instanceof View)row=(View)row.getParent();
            row.requestRectangleOnScreen(new Rect(0,0,row.getWidth(),row.getHeight()),true);
        });getInstrumentation().waitForIdleSync();
        saveScreen("capture-quality-"+qualityDialogNumber+"-row.png");
        dumpAccessibility("capture-quality-"+qualityDialogNumber+"-before-click.txt");
        runUi(()->{
            View label=findText(activity.getWindow().getDecorView(),title);assertNotNull(label);
            View row=label;while(!row.isClickable()&&row.getParent() instanceof View)row=(View)row.getParent();
            assertTrue("Real setting row must be enabled and clickable",row.isClickable()&&row.isEnabled());assertTrue(row.performClick());
        });getInstrumentation().waitForIdleSync();
    }
    private void clickDialogOption(String label) throws Exception {
        long deadline=SystemClock.uptimeMillis()+15000;
        do {
            // The settings page can leave cached/disconnected accessibility nodes after
            // its asynchronous dialog becomes a separate window. Inspect fresh windows,
            // not findAccessibilityNodeInfosByText against the previous active root.
            if(android.os.Build.VERSION.SDK_INT>=33)getInstrumentation().getUiAutomation().clearCache();
            List<AccessibilityWindowInfo> windows=getInstrumentation().getUiAutomation().getWindows();
            for(AccessibilityWindowInfo window:windows){
                if(window.getType()!=AccessibilityWindowInfo.TYPE_APPLICATION)continue;
                AccessibilityNodeInfo root=window.getRoot();
                if(root==null||!context.getPackageName().equals(String.valueOf(root.getPackageName())))continue;
                boolean resolution = CameraSettings.displayName(RESOLUTION).equals(dialogTitle);
                AccessibilityNodeInfo title=findVisibleNode(root,resolution ? dialogTitle : dialogTitle+" · ",!resolution,0);
                if(title==null)continue; // A real options dialog must be visible before choosing.
                AccessibilityNodeInfo node=resolution ? findResolutionRow(root, CameraOptionPresentation.present(RESOLUTION,label,null),0)
                        : findVisibleNode(root,label,false,0);
                if(node==null){
                    AccessibilityNodeInfo list=findScrollable(root,0);
                    if(list!=null&&list.performAction(AccessibilityNodeInfo.ACTION_SCROLL_FORWARD)){
                        event("options_dialog_scrolled_"+dialogTitle);Thread.sleep(200);
                    }
                    continue;
                }
                for(AccessibilityNodeInfo target=node;target!=null;target=target.getParent()){
                    if(!target.isClickable()||!target.isEnabled()||!target.isVisibleToUser())continue;
                    saveScreen("capture-quality-"+qualityDialogNumber+"-dialog.png");
                    dumpAccessibility("capture-quality-"+qualityDialogNumber+"-dialog.txt");
                    // Submit once only. An ambiguous/failed action is a test failure,
                    // never grounds to retry a real camera configuration write.
                    assertTrue("Actual visible scalar option row must accept click",target.performAction(AccessibilityNodeInfo.ACTION_CLICK));
                    getInstrumentation().waitForIdleSync();return;
                }
            }
            Thread.sleep(100);
        }while(SystemClock.uptimeMillis()<deadline);
        saveScreen("capture-quality-"+qualityDialogNumber+"-timeout.png");
        dumpAccessibility("capture-quality-"+qualityDialogNumber+"-timeout.txt");
        throw new AssertionError("Real visible configuration dialog did not expose scalar option: "+label+"; activity text: "+visibleText());
    }
    private static AccessibilityNodeInfo findResolutionRow(AccessibilityNodeInfo root, CameraOptionPresentation.Option option, int depth) {
        if (root == null || depth > 80) return null;
        for (int i = 0; i < root.getChildCount(); i++) {
            AccessibilityNodeInfo child = findResolutionRow(root.getChild(i), option, depth + 1); if (child != null) return child;
        }
        if (!root.isVisibleToUser() || findVisibleNode(root, option.title, false, 0) == null) return null;
        if (!option.subtitle.isEmpty() && findVisibleNode(root, option.subtitle, false, 0) == null) return null;
        for (String tag : option.tags) if (findVisibleNode(root, tag, false, 0) == null) return null;
        return root;
    }
    private static AccessibilityNodeInfo findVisibleNode(AccessibilityNodeInfo root,String text,boolean prefix,int depth){
        if(root==null||depth>80)return null;
        String value=String.valueOf(root.getText());
        if(root.isVisibleToUser()&&(prefix?value.startsWith(text):text.equals(value)))return root;
        for(int i=0;i<root.getChildCount();i++){
            AccessibilityNodeInfo found=findVisibleNode(root.getChild(i),text,prefix,depth+1);if(found!=null)return found;
        }return null;
    }
    private static AccessibilityNodeInfo findScrollable(AccessibilityNodeInfo root,int depth){
        if(root==null||depth>80)return null;
        if(root.isScrollable()&&root.isVisibleToUser()&&root.isEnabled()
                &&root.getActionList().contains(AccessibilityNodeInfo.AccessibilityAction.ACTION_SCROLL_FORWARD))return root;
        for(int i=0;i<root.getChildCount();i++){
            AccessibilityNodeInfo result=findScrollable(root.getChild(i),depth+1);if(result!=null)return result;
        }return null;
    }
    private void dumpAccessibility(String name) throws Exception {
        StringBuilder out=new StringBuilder("Active root:\n");int[] count={0};
        describeAccessibility(getInstrumentation().getUiAutomation().getRootInActiveWindow(),out,0,count);
        for(AccessibilityWindowInfo window:getInstrumentation().getUiAutomation().getWindows()){
            out.append("\nWINDOW ").append(window).append('\n');
            describeAccessibility(window.getRoot(),out,0,count);
        }
        try(OutputStream output=new FileOutputStream(new File(directory(),name))){output.write(out.toString().getBytes(StandardCharsets.UTF_8));}
    }
    private static void describeAccessibility(AccessibilityNodeInfo node,StringBuilder out,int depth,int[] count){
        if(node==null||depth>80||count[0]++>5000)return;
        for(int i=0;i<depth;i++)out.append(' ');
        out.append(node).append('\n');
        for(int i=0;i<node.getChildCount();i++)describeAccessibility(node.getChild(i),out,depth+1,count);
    }
    private void click(String text) throws Exception {
        waitEnabled(text,false,15000);event("ui_click_"+text);
        runUi(()->{View view=findButton(activity.getWindow().getDecorView(),text);assertTrue("Missing enabled button: "+text,view instanceof Button&&view.isEnabled());assertTrue(view.performClick());});getInstrumentation().waitForIdleSync();
    }
    private void clickDescription(String description) throws Exception {
        waitDescription(description,15000);runUi(()->{
            View view=findDescription(activity.getWindow().getDecorView(),description);
            assertTrue(view instanceof Button&&view.isEnabled());
            // Track at the actual dispatch point, not before waiting for the
            // button: failure to find STOP must still allow known-owner cleanup.
            if("停止录像".equals(description)) {
                recordStopRequested=true;
                captureMarker("capture_record_stop_requested");
            }
            assertTrue(view.performClick());
        });getInstrumentation().waitForIdleSync();
    }
    private void waitDescription(String description,long timeout) throws Exception {waitEnabled(description,true,timeout);}
    private void waitEnabled(String value,boolean description,long timeout) throws Exception {
        long deadline=SystemClock.uptimeMillis()+timeout;do{
            AtomicBoolean found=new AtomicBoolean();runUi(()->{View view=description?findDescription(activity.getWindow().getDecorView(),value):findButton(activity.getWindow().getDecorView(),value);found.set(view!=null&&view.isEnabled());});
            if(found.get())return;Thread.sleep(150);
        }while(SystemClock.uptimeMillis()<deadline);saveScreen("capture-timeout.png");throw new AssertionError("Enabled UI control not reached: "+value+"; "+visibleText());
    }
    private boolean hasText(String text){AtomicBoolean found=new AtomicBoolean();runUi(()->found.set(findText(activity.getWindow().getDecorView(),text)!=null));return found.get();}
    private void waitText(String text,long timeout) throws Exception {
        long deadline=SystemClock.uptimeMillis()+timeout;do{if(hasText(text))return;Thread.sleep(150);}while(SystemClock.uptimeMillis()<deadline);saveScreen("capture-timeout.png");throw new AssertionError("UI did not reach "+text+"; "+visibleText());
    }
    private String visibleText(){AtomicReference<String> text=new AtomicReference<>();runUi(()->{StringBuilder value=new StringBuilder();collectText(activity.getWindow().getDecorView(),value);text.set(value.toString());});return text.get();}
    private static void collectText(View root,StringBuilder value){if(root instanceof TextView)value.append(((TextView)root).getText()).append(" | ");if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++)collectText(((ViewGroup)root).getChildAt(i),value);}
    private static View findText(View root,String text){if(root instanceof TextView&&text.contentEquals(((TextView)root).getText()))return root;if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){View result=findText(((ViewGroup)root).getChildAt(i),text);if(result!=null)return result;}return null;}
    private static View findButton(View root,String text){if(root instanceof Button&&text.contentEquals(((Button)root).getText()))return root;if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){View result=findButton(((ViewGroup)root).getChildAt(i),text);if(result!=null)return result;}return null;}
    private static View findDescription(View root,String text){if(text.equals(String.valueOf(root.getContentDescription())))return root;if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){View result=findDescription(((ViewGroup)root).getChildAt(i),text);if(result!=null)return result;}return null;}
    private static View findType(View root,Class<?> type){if(type.isInstance(root))return root;if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){View result=findType(((ViewGroup)root).getChildAt(i),type);if(result!=null)return result;}return null;}
    private void runUi(Runnable action){
        AtomicReference<Throwable> failure=new AtomicReference<>();getInstrumentation().runOnMainSync(()->{try{action.run();}catch(Throwable error){failure.set(error);}});
        Throwable error=failure.get();if(error instanceof Error)throw (Error)error;if(error instanceof RuntimeException)throw (RuntimeException)error;if(error!=null)throw new AssertionError(error);
    }
    private void captureMarker(String key){Bundle marker=new Bundle();marker.putString(key,runId);getInstrumentation().sendStatus(0,marker);}
    private void event(String name) throws Exception {events.put(new JSONObject().put("event",name).put("elapsed_realtime_ms",SystemClock.elapsedRealtime()));}
    private static Uri collection(boolean video){return video?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI;}
    private Set<Long> ownedRows(boolean video){
        Bundle query=new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{context.getPackageName(),video?"Movies/YI4K/":"Pictures/YI4K/"});
        Set<Long> result=new HashSet<>();try(Cursor rows=resolver.query(collection(video),new String[]{MediaStore.MediaColumns._ID},query,null)){assertNotNull(rows);while(rows.moveToNext())result.add(rows.getLong(0));}return result;
    }
    private void cleanAdded(boolean video,Set<Long> before){Set<Long> added=ownedRows(video);added.removeAll(before);for(long id:added)resolver.delete(ContentUris.withAppendedId(collection(video),id),null,null);assertEquals(before,ownedRows(video));}
    private static String digest(InputStream input) throws Exception {assertNotNull(input);MessageDigest hash=MessageDigest.getInstance("SHA-256");byte[] bytes=new byte[65536];int n;while((n=input.read(bytes))!=-1)hash.update(bytes,0,n);StringBuilder result=new StringBuilder();for(byte b:hash.digest())result.append(String.format(Locale.ROOT,"%02x",b&255));return result.toString();}
    private File directory(){File dir=new File(context.getExternalFilesDir(null),"acceptance-screens/camera-capture");assertTrue(dir.isDirectory()||dir.mkdirs());return dir;}
    private void saveScreen(String name) throws Exception {getInstrumentation().waitForIdleSync();Bitmap screen=getInstrumentation().getUiAutomation().takeScreenshot();assertNotNull(screen);try(OutputStream output=new FileOutputStream(new File(directory(),name))){assertTrue(screen.compress(Bitmap.CompressFormat.PNG,100,output));}finally{screen.recycle();}}
    private void writeEvidence() throws Exception {evidence.put("record_owned_confirmed",recordOwned);evidence.put("record_stopped_confirmed",recordStopped);try(OutputStream output=new FileOutputStream(new File(directory(),"camera-capture.json"))){output.write(evidence.toString(2).getBytes(StandardCharsets.UTF_8));}}
}
