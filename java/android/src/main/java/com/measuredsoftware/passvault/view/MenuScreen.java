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
import android.view.MotionEvent;
import android.view.View;
import android.widget.CheckedTextView;
import android.widget.FrameLayout;
import com.measuredsoftware.passvault.R;

/**
 * Root layout of Menu Options Screen.
 */
public class MenuScreen extends FrameLayout implements View.OnClickListener
{
    private final CheckedTextView obscurePasswords;
    private ChangedListener listener;

    public MenuScreen(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setBackgroundColor(context.getResources().getColor(R.color.menu_screen_background));

        View.inflate(context, R.layout.menu_screen, this);

        obscurePasswords = (CheckedTextView) findViewById(R.id.obscure_passwords);
        obscurePasswords.setOnClickListener(this);
    }

    public void setListener(final ChangedListener listener)
    {
        this.listener = listener;
    }

    @Override
    public void onClick(final View v)
    {
        if (listener == null)
        {
            throw new IllegalStateException("Must set a listener for " + getClass().getSimpleName());
        }
        if (v.getId() == R.id.obscure_passwords)
        {
            obscurePasswords.setChecked(!obscurePasswords.isChecked());
            listener.optionChanged(v.getId(), obscurePasswords.isChecked());
        }
    }

    @Override
    public boolean onTouchEvent(final MotionEvent event)
    {
        super.onTouchEvent(event);
        return true;
    }

    public void setOption(final int viewId, final boolean checked)
    {
        if (viewId == R.id.obscure_passwords)
        {
            obscurePasswords.setChecked(checked);
        }
    }

    public interface ChangedListener
    {
        void optionChanged(int viewId, boolean checked);
    }
}
