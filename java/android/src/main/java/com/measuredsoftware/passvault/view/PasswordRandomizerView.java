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
import android.graphics.Paint;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.view.View;
import com.measuredsoftware.passvault.R;
import com.measuredsoftware.passvault.Typefaces;

/**
 * The touchpad randomizer, used to generate entropy for the generation of passwords.
 */
public class PasswordRandomizerView extends View
{
    private final TextPaint textPaint;
    private final String[] text;

    public PasswordRandomizerView(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setBackgroundResource(R.color.touch_zone_background);

        text = context.getResources().getString(R.string.touch_randomizer).split("\n");
        textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
        textPaint.setTypeface(Typefaces.getCondensed(context));
        textPaint.setTextAlign(Paint.Align.CENTER);
        textPaint.setTextSize(context.getResources().getDimension(R.dimen.touchzone_text_size));
        textPaint.setColor(context.getResources().getColor(R.color.touch_zone_text));
    }

    @Override
    protected void onMeasure(final int widthMeasureSpec, final int heightMeasureSpec)
    {
        final int width = MeasureSpec.getSize(widthMeasureSpec);

        //noinspection SuspiciousNameCombination
        setMeasuredDimension(width, Math.min(width, MeasureSpec.getSize(heightMeasureSpec)));
    }

    @Override
    protected void onDraw(final Canvas canvas)
    {
        super.onDraw(canvas);

        final int x = getWidth() / 2;
        final int y = getHeight() / 2;
        int offsetY = 0;
        for (final String line : text)
        {
            canvas.drawText(line, x, y + offsetY, textPaint);
            offsetY += textPaint.getTextSize();
        }
    }
}
