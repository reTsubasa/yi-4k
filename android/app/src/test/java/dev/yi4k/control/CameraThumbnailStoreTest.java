package dev.yi4k.control;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Looper;
import java.io.File;
import java.lang.reflect.Field;
import java.net.HttpURLConnection;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.RuntimeEnvironment;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.GraphicsMode;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

@RunWith(RobolectricTestRunner.class)
@Config(sdk=35)
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
public class CameraThumbnailStoreTest {
    @Test public void retainsOnlyASmallRealCopyAndNeverRecyclesTheViewersOriginal() throws Exception {
        try(CameraThumbnailStore store=new CameraThumbnailStore(context())) {
            Bitmap source=Bitmap.createBitmap(1600,900,Bitmap.Config.ARGB_8888);source.eraseColor(Color.RED);
            store.remember(entry("ONE.MP4",100,"today"),source);
            Result result=new Result();store.load(entry("ONE.MP4",100,"today"),result);await(store);
            assertNotNull(result.image.get());Bitmap thumb=result.image.get();
            assertEquals(384,thumb.getWidth());assertEquals(216,thumb.getHeight());
            assertTrue(Color.red(thumb.getPixel(10,10))>240);assertFalse(source.isRecycled());
            thumb.recycle();source.recycle();
        }
    }
    @Test public void metadataChangesAndANewCameraSessionCannotReuseStaleCovers() throws Exception {
        try(CameraThumbnailStore first=new CameraThumbnailStore(context());CameraThumbnailStore second=new CameraThumbnailStore(context())) {
            Bitmap source=Bitmap.createBitmap(64,64,Bitmap.Config.ARGB_8888);source.eraseColor(Color.BLUE);
            first.remember(entry("ONE.JPG",111,"old"),source);source.recycle();
            Result old=new Result(),changed=new Result(),otherCamera=new Result();
            first.load(entry("ONE.JPG",111,"old"),old);first.load(entry("ONE.JPG",112,"new"),changed);
            second.load(entry("ONE.JPG",111,"old"),otherCamera);await(first);await(second);
            assertNotNull(old.image.get());assertNull(changed.image.get());assertNull(otherCamera.image.get());
            assertNotNull(changed.reason.get());assertNotNull(otherCamera.reason.get());old.image.get().recycle();
        }
    }
    @Test public void videosUnknownSizesAndLargePhotosNeverOpenANetworkConnection() throws Exception {
        try(CameraThumbnailStore store=new CameraThumbnailStore(context())) {
            AtomicInteger requests=new AtomicInteger();
            CameraMediaCache.ConnectionFactory route=url->{requests.incrementAndGet();throw new java.io.IOException("unexpected request");};
            Result video=new Result(),unknown=new Result(),large=new Result();
            store.requestPhotoThrough(route,"127.0.0.1",80,entry("ONE.MP4",20,"today"),video);
            store.requestPhotoThrough(route,"127.0.0.1",80,entry("ONE.JPG",-1,"today"),unknown);
            store.requestPhotoThrough(route,"127.0.0.1",80,entry("ONE.JPG",CameraThumbnailStore.MAX_PHOTO_BYTES+1,"today"),large);await(store);
            assertEquals(0,requests.get());assertNotNull(video.reason.get());assertNotNull(unknown.reason.get());assertNotNull(large.reason.get());
        }
    }
    @Test public void explicitPhotoRequestUsesSuppliedRouteThenServesTheRealCachedImage() throws Exception {
        try(SimulatedCamera camera=new SimulatedCamera();CameraThumbnailStore store=new CameraThumbnailStore(context())) {
            AtomicInteger requests=new AtomicInteger();Result first=new Result(),cached=new Result();
            MediaEntry entry=entry(camera.imageName,camera.image.length,"today");
            CameraMediaCache.ConnectionFactory route=url->{requests.incrementAndGet();return (HttpURLConnection)url.openConnection();};
            store.requestPhotoThrough(route,"127.0.0.1",camera.httpPort(),entry,first);await(store);
            assertNotNull(first.reason.get(),first.image.get());assertEquals(1,requests.get());
            store.requestPhotoThrough(route,"127.0.0.1",camera.httpPort(),entry,cached);await(store);
            assertNotNull(cached.image.get());assertEquals(1,requests.get());
            assertTrue(first.image.get().getWidth()<=384);assertEquals(0,new File(directory(store),"source").list().length);
            first.image.get().recycle();cached.image.get().recycle();
        }
    }
    @Test public void missingBoundRouteAndNavigationCancellationDoNotDeliverStaleImages() throws Exception {
        try(CameraThumbnailStore store=new CameraThumbnailStore(context())) {
            Result noRoute=new Result();store.requestPhoto(null,"192.168.42.1",80,entry("ONE.JPG",3,"today"),noRoute);
            shadowOf(Looper.getMainLooper()).idle();assertTrue(noRoute.reason.get().contains("Wi-Fi"));
            Bitmap source=Bitmap.createBitmap(64,64,Bitmap.Config.ARGB_8888);store.remember(entry("ONE.JPG",3,"today"),source);source.recycle();
            Result cancelled=new Result();store.load(entry("ONE.JPG",3,"today"),cancelled);
            ((ThreadPoolExecutor)field(store,"worker")).submit(()->{}).get(5,TimeUnit.SECONDS);
            store.cancelRequests();shadowOf(Looper.getMainLooper()).idle();
            assertNull(cancelled.image.get());assertNull(cancelled.reason.get());
        }
    }
    @Test public void boundedCacheEvictsOldEntriesAndCloseRemovesOnlyItsSessionDirectory() throws Exception {
        CameraThumbnailStore store=new CameraThumbnailStore(context());File owned=directory(store);
        File unrelated=new File(owned.getParentFile(),"keep-other-owner.txt");assertTrue(unrelated.createNewFile());
        Bitmap source=Bitmap.createBitmap(8,8,Bitmap.Config.ARGB_8888);
        for(int i=0;i<CameraThumbnailStore.MAX_ITEMS+3;i++)store.remember(entry("ITEM"+i+".JPG",100,"today"),source);
        assertEquals(CameraThumbnailStore.MAX_ITEMS,owned.listFiles((dir,name)->name.endsWith(".jpg")).length);
        source.recycle();store.close();assertFalse(owned.exists());assertTrue(unrelated.exists());unrelated.delete();
    }
    private static Context context(){return RuntimeEnvironment.getApplication();}
    private static MediaEntry entry(String name,long bytes,String date){return new MediaEntry(MediaEntry.DCIM_ROOT+"100MEDIA/",name,bytes<0?"unknown":bytes+" bytes|"+date);}
    private static Object field(Object object,String key)throws Exception{Field field=object.getClass().getDeclaredField(key);field.setAccessible(true);return field.get(object);}
    private static File directory(CameraThumbnailStore store)throws Exception{return (File)field(store,"directory");}
    private static void await(CameraThumbnailStore store)throws Exception{((ThreadPoolExecutor)field(store,"worker")).submit(()->{}).get(8,TimeUnit.SECONDS);shadowOf(Looper.getMainLooper()).idle();}
    private static final class Result implements CameraThumbnailStore.Callback {
        final AtomicReference<Bitmap> image=new AtomicReference<>();final AtomicReference<String> reason=new AtomicReference<>();
        @Override public void loaded(Bitmap bitmap){image.set(bitmap);}
        @Override public void unavailable(String explanation){reason.set(explanation);}
    }
}
