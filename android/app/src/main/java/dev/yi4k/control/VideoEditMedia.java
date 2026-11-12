package dev.yi4k.control;

import android.net.Uri;
import androidx.annotation.OptIn;
import androidx.media3.common.Effect;
import androidx.media3.common.MediaItem;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.effect.RgbFilter;
import androidx.media3.effect.ScaleAndRotateTransformation;
import androidx.media3.transformer.EditedMediaItem;
import androidx.media3.transformer.Effects;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@OptIn(markerClass = UnstableApi.class)
final class VideoEditMedia {
    static MediaItem source(Uri uri, VideoEditPlan plan) {
        return new MediaItem.Builder().setUri(uri).setClippingConfiguration(
                new MediaItem.ClippingConfiguration.Builder().setStartPositionMs(plan.startMs)
                        .setEndPositionMs(plan.endMs).build()).build();
    }
    static List<Effect> effects(VideoEditPlan plan) {
        List<Effect> effects = new ArrayList<>();
        if (plan.rotation != 0) effects.add(new ScaleAndRotateTransformation.Builder()
                .setRotationDegrees(plan.rotation).build());
        if (plan.grayscale) effects.add(RgbFilter.createGrayscaleFilter());
        return effects;
    }
    static EditedMediaItem edited(Uri uri, VideoEditPlan plan) {
        return new EditedMediaItem.Builder(source(uri, plan)).setRemoveAudio(plan.muted)
                .setEffects(new Effects(Collections.emptyList(), effects(plan))).build();
    }
}
