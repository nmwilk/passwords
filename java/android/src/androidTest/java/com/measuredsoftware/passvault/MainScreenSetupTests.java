package com.measuredsoftware.passvault;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.support.test.InstrumentationRegistry;
import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;
import android.test.suitebuilder.annotation.LargeTest;

import com.measuredsoftware.passvault.model.PasswordListAdapter;

import org.junit.Before;
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
public class MainScreenSetupTests extends UITest
{
    @SuppressLint("CommitPrefEdits")
    @Before
    public void clearData()
    {
        final Context targetContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        final SharedPreferences preferences = targetContext.getSharedPreferences(PasswordListAdapter.PASSWORD_STORE, Context.MODE_PRIVATE);
        preferences.edit().clear().commit();
    }

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
