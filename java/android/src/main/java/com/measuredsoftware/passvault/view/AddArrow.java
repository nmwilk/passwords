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
import android.animation.AnimatorSet;
import android.animation.ValueAnimator;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import com.measuredsoftware.passvault.R;

/**
 * Animated arrow pointing at the bottom of the screen.
 */
public class AddArrow extends ImageView implements ValueAnimator.AnimatorUpdateListener
{
    private AnimatorSet animator;
    private int counter;
    private final float moveAmount;

    public AddArrow(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        setImageResource(R.drawable.arrow);

        moveAmount = getDrawable().getIntrinsicHeight() * 0.5f;
        animator = new AnimatorSet();
        ValueAnimator.setFrameDelay(16);
        final ValueAnimator moveDown = ValueAnimator.ofFloat(-moveAmount, 0);
        moveDown.addUpdateListener(this);
        moveDown.setDuration(250);
        final ValueAnimator moveUp = ValueAnimator.ofFloat(0, -moveAmount);
        moveUp.addUpdateListener(this);
        moveUp.setDuration(400);
        animator.playSequentially(moveDown, moveUp);
        animator.addListener(new AnimatorListenerAdapter()
        {
            @Override
            public void onAnimationEnd(final Animator animation)
            {
                animator.setStartDelay(counter++ % 2 == 0 ? 0 : 500);
                animator.start();
            }
        });
    }

    public void hide()
    {
        if (getVisibility() == View.VISIBLE)
        {
            setVisibility(View.INVISIBLE);
        }

        counter = 0;
        animator.end();
    }

    public void show()
    {
        setTranslationY(-moveAmount);
        setVisibility(VISIBLE);
        animator.start();
    }

    @Override
    public void onAnimationUpdate(final ValueAnimator animation)
    {
       setTranslationY((Float) animation.getAnimatedValue());
    }
}
