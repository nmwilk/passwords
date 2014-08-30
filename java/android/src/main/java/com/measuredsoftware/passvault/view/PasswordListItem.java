// Copyright 2014 Neil Wilkinson
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package com.measuredsoftware.passvault.view;

import android.animation.LayoutTransition;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.drawable.TransitionDrawable;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.measuredsoftware.passvault.R;
import com.measuredsoftware.passvault.drawable.StateTransitionDrawable;
import com.measuredsoftware.passvault.model.PasswordListAdapter;
import com.measuredsoftware.passvault.model.PasswordModel;

/**
 * Row in the {@link com.measuredsoftware.passvault.view.PasswordList}.
 */
public class PasswordListItem extends RelativeLayout implements View.OnClickListener, View.OnLongClickListener
{
    private static final float COPIED_SCALE_FACTOR = 1.2f;
    private static final long COPIED_ANIMATION_DURATION = 500;
    private static final int BACKGROUND_TRANSITION_DURATION_IN = 50;
    private static final int BACKGROUND_TRANSITION_DURATION_OUT = 250;

    private final TextView passwordName;
    private final View copiedNotification;
    private final View editIcon;
    private final View deleteButton;
    private final LayoutTransition transition;
    private final StateTransitionDrawable background;
    private final int paddingLeft;
    private final Paint linePaint;
    private final Point touchPosition = new Point();

    private PasswordModel item;
    private DeleteItemListener deleteItemListener;
    private EditItemListener editItemListener;
    private PasswordListAdapter.Mode mode;
    private boolean copiedAnimating;

    public PasswordListItem(final Context context)
    {
        super(context);

        setWillNotDraw(false);

        final Resources resources = context.getResources();

        final TransitionDrawable drawable = (TransitionDrawable) resources.getDrawable(R.drawable.row_background_transition);
        background = new StateTransitionDrawable(drawable, BACKGROUND_TRANSITION_DURATION_IN);
        setBackground(drawable);

        paddingLeft = resources.getDimensionPixelSize(R.dimen.password_list_item_margin_left);
        setPadding(paddingLeft, 0, 0, 0);

        linePaint = new Paint();
        linePaint.setColor(resources.getColor(R.color.divider_colour));

        inflate(context, R.layout.password_list_item_content, this);

        transition = new LayoutTransition();

        passwordName = (TextView) findViewById(R.id.password_name);
        copiedNotification = findViewById(R.id.copied_notification);
        editIcon = findViewById(R.id.edit_pointer);
        deleteButton = findViewById(R.id.delete_button);

        setOnClickListener(this);
        setOnLongClickListener(this);

        deleteButton.setOnClickListener(new OnClickListener()
        {
            @Override
            public void onClick(final View v)
            {
                if (deleteItemListener != null)
                {
                    deleteItemListener.onItemDeleted(item);
                }
            }
        });
    }

    @Override
    protected void onDraw(final Canvas canvas)
    {
        super.onDraw(canvas);

        final int bottom = getHeight() - 1;
        canvas.drawLine(paddingLeft, bottom, getWidth(), bottom, linePaint);
    }

    private void copyToClipboard()
    {
        if (!copiedAnimating)
        {
            copiedAnimating = true;
            setTransitionEnabled(false);

            final ClipboardManager clipboard = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
            ClipData clip = ClipData.newPlainText("label", item.getPassword());
            clipboard.setPrimaryClip(clip);

            copiedNotification.setVisibility(VISIBLE);
            copiedNotification.setAlpha(1f);
            copiedNotification.animate().alpha(0).setDuration(COPIED_ANIMATION_DURATION)
                              .scaleX(COPIED_SCALE_FACTOR).scaleY(COPIED_SCALE_FACTOR).withEndAction(new Runnable()
            {
                @Override
                public void run()
                {
                    copiedNotification.setVisibility(INVISIBLE);
                    copiedNotification.setAlpha(1f);
                    copiedNotification.setScaleX(1f);
                    copiedNotification.setScaleY(1f);
                    copiedAnimating = false;
                    setTransitionEnabled(true);
                }
            }).start();
        }
    }

    @Override
    public boolean onTouchEvent(final MotionEvent event)
    {
        final int action = event.getAction();
        if (action == MotionEvent.ACTION_CANCEL
            || action == MotionEvent.ACTION_UP)
        {
            background.off(BACKGROUND_TRANSITION_DURATION_OUT);
            background.setTouchDown(false);
        }
        else if (action == MotionEvent.ACTION_DOWN)
        {
            touchPosition.set((int) event.getX() + getLeft(), (int) event.getY() + getTop());
            background.setTouchDown(true);
        }
        return super.onTouchEvent(event);
    }

    public void setTransitionEnabled(final boolean enabled)
    {
        setLayoutTransition(enabled ? transition : null);
    }

    public void configure(final PasswordModel item, final PasswordListAdapter.Mode mode)
    {
        this.item = item;

        passwordName.setText(item.getName());

        setMode(mode);
    }

    public void setMode(final PasswordListAdapter.Mode mode)
    {
        this.mode = mode;
        editIcon.setVisibility(mode == PasswordListAdapter.Mode.EDIT ? VISIBLE : INVISIBLE);
        deleteButton.setVisibility(mode == PasswordListAdapter.Mode.EDIT ? VISIBLE : GONE);
    }

    public PasswordModel getItem()
    {
        return item;
    }

    public void setDeleteItemListener(final DeleteItemListener deleteItemListener)
    {
        this.deleteItemListener = deleteItemListener;
    }

    public void setEditItemListener(final EditItemListener editItemListener)
    {
        this.editItemListener = editItemListener;
    }

    @Override
    public void onClick(final View v)
    {
        if (mode == PasswordListAdapter.Mode.EDIT && editItemListener != null)
        {
            editItemListener.onItemChosenForEdit(item);
        }
        else
        {
            copyToClipboard();
        }
    }

    @Override
    public boolean onLongClick(final View v)
    {
        if (editItemListener != null && mode != PasswordListAdapter.Mode.EDIT)
        {
            background.off(BACKGROUND_TRANSITION_DURATION_OUT);
            setPressed(false);
            editItemListener.onOpenPopup(((PasswordListItem) v).getItem(), touchPosition.x, touchPosition.y);
        }

        return false;
    }

    @Override
    public String toString()
    {
        return item.toString();
    }

    public interface DeleteItemListener
    {
        void onItemDeleted(final PasswordModel item);
    }

    public interface EditItemListener
    {
        void onItemChosenForEdit(PasswordModel item);

        void onOpenPopup(PasswordModel item, final int x, final int y);
    }
}
