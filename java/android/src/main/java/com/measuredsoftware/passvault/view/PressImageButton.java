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

import android.content.Context;
import android.graphics.ColorFilter;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.util.AttributeSet;
import android.widget.ImageButton;
import com.measuredsoftware.passvault.R;

/**
 * Adds a press effect to the Android {@link android.widget.ImageButton}.
 */
public class PressImageButton extends ImageButton
{
    private final ColorFilter pressedFilter;

    public PressImageButton(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setScaleType(ScaleType.CENTER);
        final int pressedFilterColour = 0x7f000000 | (0x00FFFFFF & context.getResources().getColor(R.color.app_tint));
        pressedFilter = new PorterDuffColorFilter(pressedFilterColour, PorterDuff.Mode.SRC_ATOP);
    }

    @Override
    protected void onMeasure(final int widthMeasureSpec, final int heightMeasureSpec)
    {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        setMeasuredDimension(getMeasuredHeight(), getMeasuredHeight());
    }

    @Override
    public void setPressed(final boolean pressed)
    {
        super.setPressed(pressed);

        getDrawable().setColorFilter(pressed ? pressedFilter : null);
    }

    @Override
    public void setEnabled(final boolean enabled)
    {
        super.setEnabled(enabled);

        getDrawable().setColorFilter(enabled ? null : pressedFilter);
    }
}
