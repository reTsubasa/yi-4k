package dev.yi4k.control;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import java.util.List;
import java.util.function.Consumer;

/** One selection surface for all camera parameters; wire values stay with the caller. */
final class CameraOptionSheet {
    static final class Row {
        final String label, subtitle;
        final List<String> tags;
        final boolean selected;
        Row(String label, String subtitle, List<String> tags, boolean selected) {
            this.label = label; this.subtitle = subtitle; this.tags = tags; this.selected = selected;
        }
    }
    static AlertDialog show(Activity activity, String title, List<Row> rows, Consumer<Integer> select) {
        AlertDialog[] surface = new AlertDialog[1];
        Consumer<Integer> choose = position -> {
            surface[0].dismiss();
            if (!rows.get(position).selected) select.accept(position);
        };
        BaseAdapter adapter = new BaseAdapter() {
            @Override public int getCount() { return rows.size(); }
            @Override public Object getItem(int position) { return rows.get(position).label; }
            @Override public long getItemId(int position) { return position; }
            @Override public View getView(int position, View recycled, ViewGroup parent) {
                View row = optionRow(activity, rows.get(position));
                row.setOnClickListener(ignored -> choose.accept(position));
                return row;
            }
        };
        AlertDialog dialog = new AlertDialog.Builder(activity).setTitle(title)
                .setAdapter(adapter, (ignored, position) -> choose.accept(position)).create();
        surface[0] = dialog;
        dialog.setCustomTitle(header(activity, title, dialog));
        dialog.show();
        // Apply the surface synchronously after show creates the native list.
        // Posting through OnShow briefly exposes the platform's centered dialog.
        style(dialog);
        ListView list = dialog.getListView();
        list.setBackgroundColor(AppPalette.SURFACE);
        list.setPadding(dp(activity, 12), 0, dp(activity, 12), dp(activity, 16));
        list.setClipToPadding(false);
        list.setSelector(new ColorDrawable(Color.TRANSPARENT));
        list.setDivider(new ColorDrawable(Color.TRANSPARENT)); list.setDividerHeight(0);
        list.setVerticalScrollBarEnabled(false);
        ViewGroup.LayoutParams params = list.getLayoutParams();
        int maxHeight = (int) (activity.getResources().getDisplayMetrics().heightPixels * .62f);
        params.height = Math.min(maxHeight, dp(activity, rows.size() * 70 + 16));
        list.setLayoutParams(params);
        for (int i = 0; i < rows.size(); i++) if (rows.get(i).selected) { list.setSelection(i); break; }
        return dialog;
    }
    static AlertDialog info(Activity activity, String title, String message) {
        TextView body = text(activity, message, 15, AppPalette.MUTED);
        body.setPadding(dp(activity, 24), 0, dp(activity, 24), dp(activity, 28));
        body.setLineSpacing(dp(activity, 4), 1f);
        AlertDialog dialog = new AlertDialog.Builder(activity).setTitle(title).setView(body).create();
        dialog.setCustomTitle(header(activity, title, dialog));
        dialog.show(); style(dialog); return dialog;
    }
    static void style(AlertDialog dialog) {
        Window window = dialog.getWindow(); if (window == null) return;
        android.content.Context context = dialog.getContext();
        window.setBackgroundDrawable(shape(context, AppPalette.SURFACE, 24, 0));
        window.setGravity(Gravity.BOTTOM);
        int width = Math.min(context.getResources().getDisplayMetrics().widthPixels - dp(context, 24), dp(context, 600));
        window.setLayout(width, WindowManager.LayoutParams.WRAP_CONTENT);
        WindowManager.LayoutParams layout = window.getAttributes();
        layout.y = dp(context, 12); layout.dimAmount = .32f; window.setAttributes(layout);
        window.addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        for (int which : new int[]{AlertDialog.BUTTON_POSITIVE, AlertDialog.BUTTON_NEGATIVE, AlertDialog.BUTTON_NEUTRAL})
            if (dialog.getButton(which) != null) dialog.getButton(which).setTextColor(AppPalette.ACCENT);
    }
    private static View header(Activity activity, String title, AlertDialog dialog) {
        LinearLayout body = new LinearLayout(activity); body.setOrientation(LinearLayout.VERTICAL);
        body.setPadding(dp(activity, 20), dp(activity, 10), dp(activity, 14), dp(activity, 12));
        View handle = new View(activity); handle.setBackground(shape(activity, AppPalette.LINE, 2, 0));
        LinearLayout.LayoutParams handleParams = new LinearLayout.LayoutParams(dp(activity, 32), dp(activity, 4));
        handleParams.gravity = Gravity.CENTER_HORIZONTAL; handleParams.bottomMargin = dp(activity, 14); body.addView(handle, handleParams);
        LinearLayout line = new LinearLayout(activity); line.setGravity(Gravity.CENTER_VERTICAL);
        TextView name = text(activity, title, 20, AppPalette.INK);
        name.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        line.addView(name, new LinearLayout.LayoutParams(0, -2, 1));
        TextView close = text(activity, "×", 26, AppPalette.MUTED); close.setGravity(Gravity.CENTER);
        close.setContentDescription("关闭" + title);
        close.setOnClickListener(ignored -> dialog.dismiss()); line.addView(close, new LinearLayout.LayoutParams(dp(activity, 40), dp(activity, 40)));
        body.addView(line); return body;
    }
    static View optionRow(Activity activity, Row value) {
        LinearLayout row = new LinearLayout(activity); row.setGravity(Gravity.CENTER_VERTICAL);
        // A focusable HorizontalScrollView otherwise makes ListView treat the
        // entire item as containing independent controls and swallow its tap.
        row.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
        row.setPadding(dp(activity, 14), dp(activity, 12), dp(activity, 12), dp(activity, 12));
        row.setMinimumHeight(dp(activity, 70));
        if (value.selected) row.setBackground(shape(activity, AppPalette.SELECTED, 12, AppPalette.ACCENT));
        else {
            LayerDrawable paper = new LayerDrawable(new android.graphics.drawable.Drawable[]{
                    shape(activity, AppPalette.SURFACE, 0, 0), shape(activity, AppPalette.LINE, 0, 0)});
            paper.setLayerGravity(1, Gravity.BOTTOM); paper.setLayerHeight(1, dp(activity, 1));
            row.setBackground(paper);
        }
        row.setSelected(value.selected);
        row.setContentDescription(value.label + (value.subtitle.isEmpty() ? "" : "，" + value.subtitle)
                + (value.tags.isEmpty() ? "" : "，" + String.join("，", value.tags)) + (value.selected ? "，当前已选" : ""));
        LinearLayout descriptions = new LinearLayout(activity); descriptions.setOrientation(LinearLayout.VERTICAL);
        TextView title = text(activity, value.label, 15, AppPalette.INK); title.setMaxLines(2);
        if (value.selected) title.setTypeface(null, Typeface.BOLD); descriptions.addView(title);
        if (!value.subtitle.isEmpty()) {
            TextView subtitle = text(activity, value.subtitle, 11, AppPalette.MUTED); subtitle.setPadding(0, dp(activity, 5), 0, 0);
            subtitle.setMaxLines(2); descriptions.addView(subtitle);
        }
        row.addView(descriptions, new LinearLayout.LayoutParams(0, -2, 1));
        if (!value.tags.isEmpty()) {
            HorizontalScrollView scroller = new TagScrollView(activity, row); scroller.setHorizontalScrollBarEnabled(false);
            scroller.setFocusable(false);
            scroller.setOverScrollMode(View.OVER_SCROLL_NEVER); scroller.setFillViewport(true);
            scroller.setTag("option-tags");
            LinearLayout tags = new LinearLayout(activity); tags.setGravity(Gravity.END | Gravity.CENTER_VERTICAL);
            for (String label : value.tags) {
                TextView tag = text(activity, label, 10, AppPalette.tagText(label)); tag.setSingleLine(true);
                tag.setGravity(Gravity.CENTER); tag.setPadding(dp(activity, 6), dp(activity, 4), dp(activity, 6), dp(activity, 4));
                tag.setBackground(shape(activity, AppPalette.tagBackground(label), 5, 0));
                // CJK and Latin fallback fonts have different natural heights.
                // A common tag height keeps the whole metadata line aligned.
                int height = Math.max(24, Math.round(18 * activity.getResources().getConfiguration().fontScale) + 8);
                LinearLayout.LayoutParams spacing = new LinearLayout.LayoutParams(-2, dp(activity, height));
                spacing.setMarginStart(dp(activity, 4)); tags.addView(tag, spacing);
            }
            scroller.addView(tags, new HorizontalScrollView.LayoutParams(-2, -2));
            int availableDp = (int) (activity.getResources().getDisplayMetrics().widthPixels / activity.getResources().getDisplayMetrics().density);
            LinearLayout.LayoutParams trailing = new LinearLayout.LayoutParams(dp(activity, Math.min(168, Math.max(116, (availableDp - 104) / 2))), -2);
            trailing.setMarginStart(dp(activity, 8)); row.addView(scroller, trailing);
        }
        TextView check = text(activity, value.selected ? "✓" : "", 17, AppPalette.ACCENT);
        check.setGravity(Gravity.END | Gravity.CENTER_VERTICAL); check.setContentDescription(value.selected ? "当前已选" : "");
        row.addView(check, new LinearLayout.LayoutParams(dp(activity, 24), -2));
        return row;
    }
    /** Metadata still scrolls horizontally, but a stationary tap selects its
     * owning option just like a tap on the title. Vertical movement remains
     * available to the enclosing ListView; a drag never selects a row. */
    private static final class TagScrollView extends HorizontalScrollView {
        private final View option;
        private final int slop;
        private float downX, downY;
        private boolean tap;
        TagScrollView(Activity activity, View option) {
            super(activity); this.option = option;
            slop = ViewConfiguration.get(activity).getScaledTouchSlop();
        }
        @Override public boolean onTouchEvent(MotionEvent event) {
            if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
                downX = event.getX(); downY = event.getY(); tap = true;
            } else if (event.getActionMasked() == MotionEvent.ACTION_MOVE) {
                if (Math.abs(event.getX() - downX) > slop || Math.abs(event.getY() - downY) > slop) tap = false;
            } else if (event.getActionMasked() == MotionEvent.ACTION_CANCEL
                    || event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN) tap = false;
            boolean handled = super.onTouchEvent(event);
            if (event.getActionMasked() == MotionEvent.ACTION_UP) {
                boolean select = tap;
                tap = false;
                if (select) return option.performClick();
            }
            return handled;
        }
    }
    private static TextView text(android.content.Context context, String value, int size, int color) {
        TextView view = new TextView(context); view.setText(value); view.setTextSize(size); view.setTextColor(color);
        view.setIncludeFontPadding(false); return view;
    }
    private static GradientDrawable shape(android.content.Context context, int color, int radius, int stroke) {
        GradientDrawable drawable = new GradientDrawable(); drawable.setColor(color); drawable.setCornerRadius(dp(context, radius));
        if (stroke != 0) drawable.setStroke(dp(context, 1), stroke); return drawable;
    }
    private static int dp(android.content.Context context, int value) { return Math.round(value * context.getResources().getDisplayMetrics().density); }
    private CameraOptionSheet() { }
}
