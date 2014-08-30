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

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;

public class GeneratorSection extends LinearLayout
{
    private boolean visible;

    public GeneratorSection(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setOrientation(VERTICAL);
    }

    @Override
    protected void onFinishInflate()
    {
        super.onFinishInflate();

        visible = getVisibility() == VISIBLE;
    }

    public void show(final boolean show, final boolean animate)
    {
        if (show != visible)
        {
            visible = show;
            final int visibility = show ? View.VISIBLE : View.INVISIBLE;

            if (animate)
            {
                final float alpha = show ? 1.0f : 0.0f;
                animate().alpha(alpha).setListener(new AnimatorListenerAdapter()
                {
                    @Override
                    public void onAnimationStart(final Animator animation)
                    {
                        if (show)
                        {
                            setVisibility(visibility);
                        }
                    }

                    @Override
                    public void onAnimationEnd(final Animator animation)
                    {
                        if (!show)
                        {
                            setVisibility(visibility);
                        }
                    }
                });
            }
            else
            {
                setVisibility(visibility);
            }
        }
    }
}
