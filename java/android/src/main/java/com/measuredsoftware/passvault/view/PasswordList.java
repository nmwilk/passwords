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
import com.measuredsoftware.passvault.model.PasswordListAdapter;
import com.measuredsoftware.passvault.model.PasswordModel;

/**
 * App's main list view that displays the stored passwords.
 */
public class PasswordList extends AnimatedListView<PasswordModel>
{
    private PasswordPopup passwordPopup;
    private boolean popupOpen;

    public PasswordList(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setSelector(android.R.color.transparent);
        setOverScrollMode(OVER_SCROLL_NEVER);
        setVerticalFadingEdgeEnabled(true);
        setDivider(null);
        setDividerHeight(0);
    }

    public void setPasswordPopup(final PasswordPopup passwordPopup)
    {
        this.passwordPopup = passwordPopup;
    }

    public PasswordListAdapter getPasswordListAdapter()
    {
        return (PasswordListAdapter) getAdapter();
    }

    @Override
    public boolean onInterceptTouchEvent(final MotionEvent ev)
    {
        return popupOpen || super.onInterceptTouchEvent(ev);
    }

    @Override
    public boolean dispatchTouchEvent(final MotionEvent ev)
    {
        final int action = ev.getAction();
        if (popupOpen && action == MotionEvent.ACTION_UP)
        {
            closePopup();
        }
        return super.dispatchTouchEvent(ev);
    }

    @Override
    public boolean onTouchEvent(final MotionEvent ev)
    {
        return popupOpen || super.onTouchEvent(ev);
    }

    public void setMode(final PasswordListAdapter.Mode mode)
    {
        for (int i = 0; i < getChildCount(); i++)
        {
            final PasswordListItem childAt = (PasswordListItem) getChildAt(i);
            if (childAt == null)
            {
                continue;
            }
            childAt.setTransitionEnabled(true);
            childAt.setMode(mode);
        }
    }

    public void openPopup(final int x, final int y, final String password, final boolean obscure)
    {
        passwordPopup.setPassword(password, obscure);
        passwordPopup.show(x, y);
        popupOpen = true;
    }

    public void closePopup()
    {
        passwordPopup.close();
        popupOpen = false;
    }
}
