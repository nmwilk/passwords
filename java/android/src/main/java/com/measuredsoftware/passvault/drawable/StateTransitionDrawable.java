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
package com.measuredsoftware.passvault.drawable;

import android.graphics.drawable.TransitionDrawable;
import android.os.Handler;
import android.os.Message;

/**
 * Wraps a standard TransitionDrawable toggling around a state flag, so that the start/reverse is only called when needed.
 *
 * Start animations are delayed in order to allow the caller to cancel them (e.g. if they're in a scroll/listview).
 */
public class StateTransitionDrawable
{
    private final TransitionDrawable transitionDrawable;
    private final Handler pressedStateHandler;

    private boolean on;
    private boolean touchDown;

    public StateTransitionDrawable(final TransitionDrawable drawable, final int inTime)
    {
        this.transitionDrawable = drawable;

        pressedStateHandler = new Handler()
        {
            @Override
            public void handleMessage(final Message msg)
            {
                if (touchDown)
                {
                    on(inTime);
                }
            }
        };
    }

    public void setTouchDown(final boolean touchDown)
    {
        this.touchDown = touchDown;
        if (this.touchDown)
        {
            pressedStateHandler.sendEmptyMessageDelayed(0, 75);
        }
    }

    public void on(final int duration)
    {
        if (!on)
        {
            on = true;
            transitionDrawable.startTransition(duration);
        }
    }

    public void off(final int duration)
    {
        if (on)
        {
            on = false;
            transitionDrawable.reverseTransition(duration);
        }
    }
}
