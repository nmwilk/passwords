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
import android.util.AttributeSet;
import android.view.animation.OvershootInterpolator;
import android.widget.TextView;
import com.measuredsoftware.passvault.R;

import java.util.Arrays;

/**
 * Popup that shows the (optionally obscured) password.
 */
public class PasswordPopup extends TextView
{
    private static final float SCALE_FACTOR = 0.6f;
    private static final int ANIMATION_DURATION = 250;

    public PasswordPopup(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setTextSize(context.getResources().getDimensionPixelSize(R.dimen.popup_password_text_size));
        setBackgroundResource(R.drawable.popup_password_background);
    }

    public void setPassword(final String password, final boolean obscure)
    {
        setText(obscure ? obscurePassword(password) : password);
    }

    private String obscurePassword(final String password)
    {
        final StringBuilder sb = new StringBuilder();

        final int length = password.length();
        final int charsShown;
        if (length < 5)
        {
            charsShown = 0;
        }
        else if (length < 7)
        {
            charsShown = 1;
        }
        else
        {
            charsShown = 2;
        }

        if (charsShown > 0)
        {
            sb.append(password.substring(0, charsShown));
        }
        final char[] chars = new char[length - (charsShown * 2)];
        Arrays.fill(chars, '●');
        sb.append(String.valueOf(chars));
        if (charsShown > 0)
        {
            sb.append(password.substring(length - charsShown, length));
        }
        return sb.toString();
    }

    public void show(final int centreX, final int centreY)
    {
        // post so it goes on the next tick and it'll have been layed out since the setText() call.
        getHandler().post(new Runnable()
        {
            @Override
            public void run()
            {
                final int left = centreX - (getWidth() / 2);
                final int top = centreY - (getHeight() / 2);

                setVisibility(VISIBLE);
                setTranslationX(left);
                setTranslationY(top);

                setAlpha(0f);
                setScaleX(SCALE_FACTOR);
                setScaleY(SCALE_FACTOR);

                animate().alpha(1f).scaleX(1f).scaleY(1f).setInterpolator(new OvershootInterpolator()).setDuration(ANIMATION_DURATION)
                         .start();
            }
        });
    }

    public void close()
    {
        setVisibility(INVISIBLE);
    }
}
