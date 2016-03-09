package com.measuredsoftware.passvault;

import android.app.Activity;
import android.app.Instrumentation;
import android.content.Intent;
import android.support.test.espresso.intent.rule.IntentsTestRule;
import android.support.test.runner.AndroidJUnit4;
import android.test.suitebuilder.annotation.LargeTest;

import com.google.gson.Gson;
import com.measuredsoftware.passvault.model.PasswordModel;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.intent.Intents.intended;
import static android.support.test.espresso.intent.Intents.intending;
import static android.support.test.espresso.intent.matcher.IntentMatchers.toPackage;
import static android.support.test.espresso.matcher.ViewMatchers.isDisplayed;
import static android.support.test.espresso.matcher.ViewMatchers.withId;

/**
 * Created by neil on 09/03/2016.
 */
@RunWith(AndroidJUnit4.class)
@LargeTest
public class MainScreenUsageTests extends UITest
{
    @Rule
    public IntentsTestRule<MainActivity> mainActivityIntentTestRule = new IntentsTestRule<>(MainActivity.class);

    @Test
    public void passwordCreated()
    {
        // Build a result to return from the Camera app
        final Intent resultData = new Intent();
        final Gson gson = new Gson();
        final PasswordModel passwordModel = new PasswordModel();
        passwordModel.setName("Ebay");
        passwordModel.setPassword("EbayPassword");
        passwordModel.setId(1);
        resultData.putExtra(MainActivity.RESULT_EXTRA, gson.toJson(passwordModel));

        final Instrumentation.ActivityResult result = new Instrumentation.ActivityResult(Activity.RESULT_OK, resultData);

        intending(toPackage("com.measuredsoftware.passvault")).respondWith(result);

        onView(withId(R.id.add_button)).perform(click());

        intended(toPackage("com.measuredsoftware.passvault"));

        onView(withId(R.id.edit_button)).check(matches(isDisplayed()));
    }
}
