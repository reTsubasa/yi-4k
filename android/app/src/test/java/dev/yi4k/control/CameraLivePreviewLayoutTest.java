package dev.yi4k.control;

import androidx.media3.ui.AspectRatioFrameLayout;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public final class CameraLivePreviewLayoutTest {
    @Test public void previewUsesCenterInsideForAnySelectedOrStreamAspectRatio() {
        assertEquals(AspectRatioFrameLayout.RESIZE_MODE_FIT, CameraLivePreview.previewResizeMode());
    }

    @Test public void selectedAspectFitsCenteredWithoutCroppingAcrossOrientations() {
        String[] resolutions = {"3840x2160 30P 16:9", "1920x1080 60P 16:9", "1440x1080 30P 4:3"};
        int[][] viewports = {{2400, 1080}, {1080, 2400}, {1920, 1080}, {1080, 1920}};
        for (String resolution : resolutions) {
            float aspect = CameraPreviewLayout.aspectRatio(resolution);
            for (int[] viewport : viewports) {
                CameraPreviewLayout.Bounds fitted = CameraPreviewLayout.centeredFit(viewport[0], viewport[1], aspect);
                assertTrue(fitted.left >= 0 && fitted.top >= 0);
                assertTrue(fitted.right <= viewport[0] && fitted.bottom <= viewport[1]);
                String bounds = fitted.left + "," + fitted.top + "," + fitted.right + "," + fitted.bottom + " in " + viewport[0] + "x" + viewport[1];
                assertTrue(bounds, fitted.left <= viewport[0] - fitted.right + 2);
                assertTrue(bounds, fitted.top <= viewport[1] - fitted.bottom + 2);
                assertTrue(fitted.right > fitted.left && fitted.bottom > fitted.top);
                assertEquals(aspect, (float) (fitted.right - fitted.left) / (fitted.bottom - fitted.top), .002f);
            }
        }
        assertEquals(16f / 9f, CameraPreviewLayout.aspectRatio("unknown"), .001f);
    }
}
