package com.measuredsoftware.passvault;

import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;
import android.test.suitebuilder.annotation.LargeTest;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.isDisplayed;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static org.hamcrest.Matchers.not;

/**
 * Created by neil on 09/03/2016.
 */
@RunWith(AndroidJUnit4.class)
@LargeTest
public class MainScreenTests
{
    @Rule
    public ActivityTestRule<MainActivity> mainActivityActivityTestRule = new ActivityTestRule<>(MainActivity.class);

    @Test
    public void startupOkay()
    {
        onView(withId(R.id.add_button)).check(matches(isDisplayed()));
        onView(withId(R.id.password_list)).check(matches(isDisplayed()));
        onView(withId(R.id.password_popup)).check(matches(not(isDisplayed())));
        onView(withId(R.id.toolbar)).check(matches(isDisplayed()));
        onView(withId(R.id.sliding_drawer)).check(matches(isDisplayed()));
    }

    @Test
    public void addButton()
    {
        onView(withId(R.id.add_button)).perform(click());

        onView(withId(R.id.done)).check(matches(isDisplayed()));
        onView(withId(R.id.cancel)).check(matches(isDisplayed()));
        onView(withId(R.id.name)).check(matches(isDisplayed()));
        onView(withId(R.id.password)).check(matches(isDisplayed()));
        onView(withId(R.id.generator_section)).check(matches(isDisplayed()));
    }
}
