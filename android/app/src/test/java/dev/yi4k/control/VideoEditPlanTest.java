package dev.yi4k.control;

import org.junit.Test;
import static org.junit.Assert.*;

public class VideoEditPlanTest {
    @Test public void preservesSourceTimeSelectionAndRejectsInvalidOrOverflowingRanges() {
        VideoEditPlan plan = new VideoEditPlan(42000, 7000, 31000, true, true, 270);
        assertEquals(24000, plan.selectedDurationMs());
        assertEquals(7000, plan.startMs); assertEquals(31000, plan.endMs);
        for (long[] range : new long[][]{{0, 0, 0}, {42000, -1, 500}, {42000, 41000, 42001},
                {42000, 9000, 8000}, {42000, 1000, 1099}, {Long.MAX_VALUE, Long.MAX_VALUE - 1, Long.MIN_VALUE}}) {
            try { new VideoEditPlan(range[0], range[1], range[2], false, false, 0); fail("Invalid range accepted"); }
            catch (IllegalArgumentException expected) { }
        }
    }
    @Test public void endpointsAndLongSliderMappingRemainExactWithoutOverflow() {
        assertEquals(0, VideoEditPlan.timeAt(0, 42000));
        assertEquals(21000, VideoEditPlan.timeAt(5000, 42000));
        assertEquals(42001, VideoEditPlan.timeAt(10000, 42001));
        assertEquals(Long.MAX_VALUE, VideoEditPlan.timeAt(10000, Long.MAX_VALUE));
        assertEquals(Long.MAX_VALUE / 2, VideoEditPlan.timeAt(5000, Long.MAX_VALUE));
    }
    @Test public void rotationIsLimitedToSupportedQuarterTurns() {
        for (int angle : new int[]{0, 90, 180, 270}) assertEquals(angle, new VideoEditPlan(100, 0, 100, false, false, angle).rotation);
        for (int angle : new int[]{-90, 1, 45, 360}) {
            try { new VideoEditPlan(1000, 0, 1000, false, false, angle); fail("Invalid rotation accepted"); }
            catch (IllegalArgumentException expected) { }
        }
    }
    @Test public void timelineHandlesClampToSourceAndCannotCross() {
        assertEquals(0, VideoEditPlan.boundary(true, -500, 42000, 7000, 31000));
        assertEquals(30900, VideoEditPlan.boundary(true, 42000, 42000, 7000, 31000));
        assertEquals(7100, VideoEditPlan.boundary(false, 0, 42000, 7000, 31000));
        assertEquals(42000, VideoEditPlan.boundary(false, Long.MAX_VALUE, 42000, 7000, 31000));
        assertEquals(7000, VideoEditPlan.boundary(true, 7000, 42000, 7000, 31000));
    }
}
