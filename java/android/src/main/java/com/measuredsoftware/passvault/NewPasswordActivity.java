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
package com.measuredsoftware.passvault;

import android.animation.Animator;
import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.ViewAnimationUtils;
import android.view.ViewTreeObserver;

import com.measuredsoftware.passvault.model.PasswordModel;
import com.measuredsoftware.passvault.model.UserPreferences;

public class NewPasswordActivity extends AbsPasswordActivity
{
    private static final String PARAM_REVEAL_X = "grknlwefwefew";
    private static final String PARAM_REVEAL_Y = "894uibjkvl";

    private View rootLayout;
    private Point revealStartLocation;

    @Override
    protected void onCreate(final Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        if (savedInstanceState == null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
        {
            overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
            revealStartLocation = new Point(getIntent().getIntExtra(PARAM_REVEAL_X, 0), getIntent().getIntExtra(PARAM_REVEAL_Y, 0));
            rootLayout = findViewById(R.id.container);
            rootLayout.setVisibility(View.INVISIBLE);

            final ViewTreeObserver viewTreeObserver = rootLayout.getViewTreeObserver();
            if (viewTreeObserver.isAlive())
            {
                viewTreeObserver.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener()
                {
                    @Override
                    public void onGlobalLayout()
                    {
                        circularRevealActivity();
                        rootLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                });
            }
        }
    }

    public static Intent createLaunchIntent(final Context caller, final int revealX, final int revealY)
    {
        final Intent intent = new Intent(caller, NewPasswordActivity.class);
        intent.putExtra(PARAM_REVEAL_X, revealX);
        intent.putExtra(PARAM_REVEAL_Y, revealY);
        return intent;
    }

    private void circularRevealActivity()
    {
        final float finalRadius = Math.max(rootLayout.getWidth(), rootLayout.getHeight());

        // create the animator for this view (the start radius is zero)
        final Animator circularReveal = ViewAnimationUtils.createCircularReveal(rootLayout, revealStartLocation.x, revealStartLocation.y, 0, finalRadius);
        circularReveal.setDuration(getResources().getInteger(android.R.integer.config_mediumAnimTime));

        // make the view visible and start the animation
        rootLayout.setVisibility(View.VISIBLE);
        circularReveal.start();
    }

    @Override
    protected int getTitleResId()
    {
        return R.string.new_password;
    }

    @Override
    protected PasswordModel getPasswordModelToCommit()
    {
        final PasswordModel model = new PasswordModel();
        model.setName(getPasswordName());
        model.setPassword(getPasswordValue());
        return model;
    }

    @Override
    protected int getStartingPasswordLength()
    {
        final int length = ((PassVaultApplication) getApplication()).getUserPrefs()
                .getOptionInt(UserPreferences.Options.PREFS_PASSWORD_LENGTH);
        return length == 0 ? getResources().getInteger(R.integer.pwd_len_default) : length;
    }
}
