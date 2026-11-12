package dev.yi4k.control;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.Network;
import android.os.Bundle;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import android.widget.FrameLayout;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

/** Explicit real-source test. Never starts VF or changes settings itself. */
public final class CameraPreviewDeviceTest extends InstrumentationTestCase {
    public void testActualCameraFirstFrameThroughBoundNetwork() throws Exception {
        String url=((InstrumentationTestRunner)getInstrumentation()).getArguments().getString("yi4k_rtsp_url");
        assertNotNull("Run explicitly with the camera-advertised yi4k_rtsp_url",url);
        String validated=CameraPreviewAddress.validateForPlayback(url);
        Context context=getInstrumentation().getTargetContext();
        ConnectivityManager connectivity=(ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        Network network=connectivity.getActiveNetwork();
        assertNotNull("An Android Network is required",network);
        Activity activity=getInstrumentation().startActivitySync(
                new Intent(context,MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
        AtomicReference<CameraLivePreview> preview=new AtomicReference<>();
        AtomicReference<Throwable> failure=new AtomicReference<>();
        AtomicReference<String> status=new AtomicReference<>("not started");
        CountDownLatch firstFrame=new CountDownLatch(1);
        try {
            getInstrumentation().runOnMainSync(()->{
                try {
                    FrameLayout frame=new FrameLayout(activity);activity.setContentView(frame);
                    preview.set(CameraLivePreview.start(activity,frame,network,validated,status::set,firstFrame::countDown));
                }catch(Throwable error){failure.set(error);firstFrame.countDown();}
            });
            assertTrue("Actual RTSP first frame timeout; last state: "+status.get(),firstFrame.await(20,TimeUnit.SECONDS));
            if(failure.get()!=null)throw new AssertionError("Camera preview failed",failure.get());
            assertNotNull(preview.get());assertFalse("Preview closed: "+status.get(),preview.get().isClosed());
            assertEquals("实时画面已连接",status.get());
            Bundle result=new Bundle();result.putString("camera_preview_first_frame","rendered");
            result.putString("android_network",String.valueOf(connectivity.getNetworkCapabilities(network)));
            getInstrumentation().sendStatus(0,result);
        }finally{
            getInstrumentation().runOnMainSync(()->{
                if(preview.get()!=null)preview.get().close();activity.finish();
            });
        }
    }
}
