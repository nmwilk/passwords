package com.measuredsoftware.passvault;

import android.support.test.espresso.intent.rule.IntentsTestRule;
import android.support.test.runner.AndroidJUnit4;
import android.test.suitebuilder.annotation.LargeTest;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
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
        injectNewPassword("Ebay", "EbayPassword");

        onView(withId(R.id.edit_button)).check(matches(isDisplayed()));
    }
}
