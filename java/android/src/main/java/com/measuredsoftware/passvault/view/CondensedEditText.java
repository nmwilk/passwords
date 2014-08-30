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
import android.graphics.Typeface;
import android.text.Editable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.TypedValue;
import com.measuredsoftware.passvault.Typefaces;

/**
 * Sets the condensed typeface on an Android {@link android.widget.EditText}.
 *
 * Must have its text size set via XML, as this is used as it's 'normal' size, which is sized down if the text doesn't fit.
 */
public class CondensedEditText extends android.widget.EditText
{
    private final float normalTextSize;

    public CondensedEditText(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setTypeface(Typefaces.getCondensed(context), Typeface.BOLD);

        normalTextSize = getTextSize();
    }

    @Override
    public void setText(final CharSequence text, final BufferType type)
    {
        super.setText(text, type);

        updateTextSize();
    }

    @Override
    protected void onSizeChanged(final int w, final int h, final int oldw, final int oldh)
    {
        super.onSizeChanged(w, h, oldw, oldh);

        updateTextSize();
    }

    private void updateTextSize()
    {
        final Editable text = getText();
        if (text != null && getWidth() != 0)
        {
            float newTextSize = normalTextSize;
            setTextSize(TypedValue.COMPLEX_UNIT_PX, newTextSize);
            int textWidth = Math.round(getPaint().measureText(text, 0, text.length()));
            while (textDoesntFit(textWidth))
            {
                newTextSize--;
                if (newTextSize == 0)
                {
                    setEllipsize(TextUtils.TruncateAt.MIDDLE);
                    break;
                }
                setTextSize(TypedValue.COMPLEX_UNIT_PX, newTextSize);
                textWidth = Math.round(getPaint().measureText(text, 0, text.length()));
            }
        }
    }

    private boolean textDoesntFit(final int textWidth)
    {
        return textWidth > (getWidth() - (getPaddingLeft() + getPaddingRight()));
    }
}
