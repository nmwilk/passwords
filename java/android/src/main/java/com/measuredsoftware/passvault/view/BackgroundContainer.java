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
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import com.measuredsoftware.passvault.R;

public class BackgroundContainer extends FrameLayout
{
    private final Drawable rowBackground;

    private int rowTop;
    private int rowHeight;
    private boolean dirtyBounds;
    private boolean show;

    public BackgroundContainer(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);
        rowBackground = context.getResources().getDrawable(R.drawable.deleted_row_background);
    }

    /**
     * @param top    top of item being removed.
     * @param height height of item being removed.
     */
    public void showBackground(final int top, final int height)
    {
        show = true;
        setWillNotDraw(false);
        rowTop = top;
        rowHeight = height;
        dirtyBounds = true;
    }

    public void hideBackground()
    {
        show = false;
        setWillNotDraw(true);
    }

    @Override
    protected void onDraw(Canvas canvas)
    {
        if (show)
        {
            if (dirtyBounds)
            {
                rowBackground.setBounds(0, 0, getWidth(), rowHeight);
            }
            canvas.save();
            canvas.translate(0, rowTop);
            rowBackground.draw(canvas);
            canvas.restore();
        }
    }

}
