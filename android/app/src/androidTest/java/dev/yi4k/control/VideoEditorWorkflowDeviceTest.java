package dev.yi4k.control;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.Button;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;

/** Drives the real DocumentsUI picker, editor controls, codecs, and MediaStore. */
public final class VideoEditorWorkflowDeviceTest extends InstrumentationTestCase {
    public void testSystemPickerEditAndSavePlayableClip() throws Exception {
        ContentResolver resolver=getInstrumentation().getTargetContext().getContentResolver();
        Set<Long> before=editedRows(resolver);
        Uri source=null;Activity activity=null;
        String name="YI4K_WORKFLOW_"+System.currentTimeMillis()+".mp4";
        try {
            ContentValues values=new ContentValues();
            values.put(MediaStore.MediaColumns.DISPLAY_NAME,name);
            values.put(MediaStore.MediaColumns.MIME_TYPE,"video/mp4");
            values.put(MediaStore.MediaColumns.RELATIVE_PATH,"Movies/YI4K/Acceptance");
            values.put(MediaStore.MediaColumns.IS_PENDING,1);
            source=resolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,values);
            assertNotNull(source);
            try(InputStream input=getInstrumentation().getContext().getAssets().open("editor-av-fixture.mp4");
                OutputStream output=resolver.openOutputStream(source)) {
                assertNotNull(output);byte[] buffer=new byte[8192];int n;
                while((n=input.read(buffer))!=-1)output.write(buffer,0,n);
            }
            values.clear();values.put(MediaStore.MediaColumns.IS_PENDING,0);
            assertEquals(1,resolver.update(source,values,null,null));
            activity=getInstrumentation().startActivitySync(new Intent(getInstrumentation().getTargetContext(),
                    VideoEditorActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            final Activity editor=activity;
            clickEditor(editor,"从手机选择视频");
            clickAccessible(name,30000);
            waitEditorText(editor,"调整片段范围，然后点击右上角导出",15000);
            saveScreen("editor-imported.png");
            clickEditor(editor,"精确调整");
            setAccessibleProgress("片段起点",1667);
            setAccessibleProgress("片段终点",8333);
            waitEditorText(editor,"起点 00:00.5  ·  终点 00:02.5  ·  保留 00:02.0",3000);
            clickEditor(editor,"播放片段");
            waitEditorText(editor,"暂停预览",10000);
            waitFirstFrame(editor,10000);
            clickEditor(editor,"暂停预览");waitEditorText(editor,"播放片段",3000);
            clickEditor(editor,"保留原声");clickEditor(editor,"原色");clickEditor(editor,"旋转 0°");
            saveScreen("editor-adjusted.png");
            clickEditor(editor,"导出");
            waitEditorText(editor,"已保存到相册 Movies/YI4K/Edited",60000);
            waitEditorText(editor,"剪辑已保存",3000);waitEditorText(editor,"查看视频",3000);
            saveScreen("editor-exported.png");
            Set<Long> added=editedRows(resolver);added.removeAll(before);
            assertEquals("The UI export must publish exactly one result",1,added.size());
            Uri saved=ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,added.iterator().next());
            try(Cursor row=resolver.query(saved,new String[]{MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE},null,null,null)) {
                assertNotNull(row);assertTrue(row.moveToFirst());assertEquals(0,row.getInt(0));assertTrue(row.getLong(1)>0);
            }
            try(MediaMetadataRetriever reader=new MediaMetadataRetriever()) {
                reader.setDataSource(getInstrumentation().getTargetContext(),saved);
                long duration=Long.parseLong(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
                assertTrue("UI range must reach exported clip: "+duration,duration>=1850&&duration<=2150);
                assertNull("UI mute must remove audio",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
                Bitmap frame=reader.getFrameAtTime(0);assertNotNull("Saved result must actually decode",frame);
                try {
                    assertTrue("UI rotation must produce portrait output",frame.getHeight()>frame.getWidth());
                    for(int y=1;y<10;y++)for(int x=1;x<10;x++) {
                        int pixel=frame.getPixel(frame.getWidth()*x/10,frame.getHeight()*y/10);
                        int r=android.graphics.Color.red(pixel),g=android.graphics.Color.green(pixel),b=android.graphics.Color.blue(pixel);
                        assertTrue("UI black/white control must affect saved pixels",Math.max(r,Math.max(g,b))-Math.min(r,Math.min(g,b))<=8);
                    }
                }finally{frame.recycle();}
            }
            try(InputStream input=resolver.openInputStream(source)){assertNotNull(input);assertTrue("Original must survive editing",input.read()!=-1);}
            Bundle evidence=new Bundle();evidence.putString("editor_workflow","actual system picker -> UI range -> play/pause selected clip and rendered first frame -> UI effects -> Transformer -> inline completion and published decodable MediaStore clip");
            getInstrumentation().sendStatus(0,evidence);
        }finally{
            if(activity!=null){Activity close=activity;getInstrumentation().runOnMainSync(close::finish);getInstrumentation().waitForIdleSync();}
            Set<Long> added=editedRows(resolver);added.removeAll(before);
            for(long id:added)resolver.delete(ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,id),null,null);
            if(source!=null)resolver.delete(source,null,null);
        }
    }
    private void waitFirstFrame(Activity activity,long timeout) throws Exception {
        long deadline=android.os.SystemClock.uptimeMillis()+timeout;
        do {
            AtomicBoolean ready=new AtomicBoolean();
            getInstrumentation().runOnMainSync(()->ready.set(hasDescription(activity.getWindow().getDecorView(),"视频预览，首帧已显示")));
            if(ready.get())return;Thread.sleep(50);
        }while(android.os.SystemClock.uptimeMillis()<deadline);
        fail("Selected clip must render a real first frame before export");
    }
    private static boolean hasDescription(View view,String text) {
        if(view.getContentDescription()!=null&&text.contentEquals(view.getContentDescription()))return true;
        if(view instanceof ViewGroup)for(int i=0;i<((ViewGroup)view).getChildCount();i++)
            if(hasDescription(((ViewGroup)view).getChildAt(i),text))return true;
        return false;
    }

    private void clickEditor(Activity activity,String text) {
        getInstrumentation().runOnMainSync(()->{
            View target=findText(activity.getWindow().getDecorView(),text);
            assertTrue("Missing enabled editor button: "+text,target instanceof Button&&target.isEnabled());
            assertTrue(target.performClick());
        });getInstrumentation().waitForIdleSync();
    }
    private void waitEditorText(Activity activity,String text,long timeout) throws Exception {
        long deadline=android.os.SystemClock.uptimeMillis()+timeout;
        do {
            AtomicBoolean found=new AtomicBoolean();
            getInstrumentation().runOnMainSync(()->found.set(findText(activity.getWindow().getDecorView(),text)!=null));
            if(found.get())return;Thread.sleep(200);
        }while(android.os.SystemClock.uptimeMillis()<deadline);
        saveScreen("workflow-timeout.png");
        fail("Editor text not reached: "+text+"; visible text: "+visibleTexts(activity));
    }
    private static View findText(View root,String text) {
        if(root instanceof TextView&&text.contentEquals(((TextView)root).getText()))return root;
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){
            View found=findText(((ViewGroup)root).getChildAt(i),text);if(found!=null)return found;
        }return null;
    }
    private String visibleTexts(Activity activity) {
        AtomicReference<String> result=new AtomicReference<>();
        getInstrumentation().runOnMainSync(()->{StringBuilder text=new StringBuilder();collectTexts(activity.getWindow().getDecorView(),text);result.set(text.toString());});
        return result.get();
    }
    private static void collectTexts(View root,StringBuilder result) {
        if(root instanceof TextView)result.append(((TextView)root).getText()).append(" | ");
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++)collectTexts(((ViewGroup)root).getChildAt(i),result);
    }
    private void clickAccessible(String text,long timeout) throws Exception {
        long started=android.os.SystemClock.uptimeMillis(), deadline=started+timeout;
        int sourceRoute=0;
        do {
            AccessibilityNodeInfo root=getInstrumentation().getUiAutomation().getRootInActiveWindow();
            if(root!=null)for(AccessibilityNodeInfo node:root.findAccessibilityNodeInfosByText(text)) {
                // The thumbnail preview icon includes the filename in its
                // description but opens an external player. Select the file label.
                if(node.getText()==null || !text.contentEquals(node.getText()))continue;
                saveScreen("system-picker-before.png");
                File directory=new File(getInstrumentation().getTargetContext().getExternalFilesDir(null),"acceptance-screens");
                try(OutputStream output=new FileOutputStream(new File(directory,"picker-tree.txt"))){
                    StringBuilder tree=new StringBuilder();describeTree(root,tree,0);output.write(tree.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8));
                }
                AccessibilityNodeInfo clickable=null;
                for(AccessibilityNodeInfo target=node;target!=null;target=target.getParent())if(target.isClickable()){clickable=target;break;}
                if(clickable!=null&&clickable.performAction(AccessibilityNodeInfo.ACTION_CLICK)){getInstrumentation().waitForIdleSync();return;}
            }
            // On a fresh AVD the Media Documents Videos root can appear after
            // the Recent loader has already completed. Navigate through the
            // real picker instead of relying on its stale Recent snapshot.
            if(root!=null && android.os.SystemClock.uptimeMillis()-started>3000) {
                AccessibilityNodeInfo destination=sourceRoute==0?findDescription(root,"Show roots"):null;
                if(sourceRoute==1)destination=exactText(root,"Videos");
                if(sourceRoute==2)destination=exactText(root,"Acceptance");
                if(destination!=null && clickNearest(destination)) { sourceRoute++; getInstrumentation().waitForIdleSync(); }
            }
            Thread.sleep(200);
        }while(android.os.SystemClock.uptimeMillis()<deadline);
        saveScreen("system-picker-timeout.png");
        AccessibilityNodeInfo lastRoot=getInstrumentation().getUiAutomation().getRootInActiveWindow();
        File lastDirectory=new File(getInstrumentation().getTargetContext().getExternalFilesDir(null),"acceptance-screens");
        if(lastRoot!=null)try(OutputStream output=new FileOutputStream(new File(lastDirectory,"picker-timeout-tree.txt"))){
            StringBuilder tree=new StringBuilder();describeTree(lastRoot,tree,0);output.write(tree.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8));
        }
        fail("System picker did not expose/select actual fixture: "+text);
    }
    private static AccessibilityNodeInfo exactText(AccessibilityNodeInfo root,String text) {
        for(AccessibilityNodeInfo node:root.findAccessibilityNodeInfosByText(text))
            if(text.contentEquals(node.getText()==null?"":node.getText())&&node.isVisibleToUser())return node;
        return null;
    }
    private static boolean clickNearest(AccessibilityNodeInfo node) {
        for(AccessibilityNodeInfo target=node;target!=null;target=target.getParent())
            if(target.isClickable()&&target.isEnabled())return target.performAction(AccessibilityNodeInfo.ACTION_CLICK);
        return false;
    }
    private static void describeTree(AccessibilityNodeInfo node,StringBuilder out,int depth) {
        if(node==null)return;for(int i=0;i<depth;i++)out.append(" ");out.append(node).append("\n");
        for(int i=0;i<node.getChildCount();i++)describeTree(node.getChild(i),out,depth+1);
    }
    private void setAccessibleProgress(String description,float value) throws Exception {
        AccessibilityNodeInfo root=getInstrumentation().getUiAutomation().getRootInActiveWindow();
        AccessibilityNodeInfo slider=findDescription(root,description);assertNotNull("Missing slider: "+description,slider);
        Bundle args=new Bundle();args.putFloat(AccessibilityNodeInfo.ACTION_ARGUMENT_PROGRESS_VALUE,value);
        assertTrue("Slider accessibility action failed",slider.performAction(AccessibilityNodeInfo.AccessibilityAction.ACTION_SET_PROGRESS.getId(),args));
        getInstrumentation().waitForIdleSync();
    }
    private static AccessibilityNodeInfo findDescription(AccessibilityNodeInfo root,String description) {
        if(root==null)return null;if(description.equals(String.valueOf(root.getContentDescription())))return root;
        for(int i=0;i<root.getChildCount();i++){AccessibilityNodeInfo match=findDescription(root.getChild(i),description);if(match!=null)return match;}return null;
    }
    private void saveScreen(String name) throws Exception {
        getInstrumentation().waitForIdleSync();
        getInstrumentation().getUiAutomation().waitForIdle(500,5000);
        Bitmap screenshot=getInstrumentation().getUiAutomation().takeScreenshot();assertNotNull(screenshot);
        File directory=new File(getInstrumentation().getTargetContext().getExternalFilesDir(null),"acceptance-screens");
        assertTrue(directory.isDirectory()||directory.mkdirs());
        try(OutputStream output=new FileOutputStream(new File(directory,name))){assertTrue(screenshot.compress(Bitmap.CompressFormat.PNG,100,output));}
        finally{screenshot.recycle();}
    }
    private Set<Long> editedRows(ContentResolver resolver) {
        Bundle query=new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{getInstrumentation().getTargetContext().getPackageName(),"Movies/YI4K/Edited/"});
        Set<Long> result=new HashSet<>();
        try(Cursor rows=resolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,new String[]{MediaStore.MediaColumns._ID},query,null)){
            assertNotNull(rows);while(rows.moveToNext())result.add(rows.getLong(0));
        }return result;
    }
}
