package com.measuredsoftware.passvault;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Instrumentation;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.test.InstrumentationRegistry;

import com.google.gson.Gson;
import com.measuredsoftware.passvault.model.PasswordListAdapter;
import com.measuredsoftware.passvault.model.PasswordModel;

import org.junit.Before;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.intent.Intents.intended;
import static android.support.test.espresso.intent.Intents.intending;
import static android.support.test.espresso.intent.matcher.IntentMatchers.toPackage;
import static android.support.test.espresso.matcher.ViewMatchers.withId;

/**
 * Created by neil on 09/03/2016.
 */
public class UITest
{
    protected static void injectNewPassword(final String name, final String password)
    {
        final Intent resultData = new Intent();
        final Gson gson = new Gson();
        final PasswordModel passwordModel = new PasswordModel();
        passwordModel.setName(name);
        passwordModel.setPassword(password);
        passwordModel.setId(1);
        resultData.putExtra(MainActivity.RESULT_EXTRA, gson.toJson(passwordModel));

        final Instrumentation.ActivityResult result = new Instrumentation.ActivityResult(Activity.RESULT_OK, resultData);

        intending(toPackage("com.measuredsoftware.passvault")).respondWith(result);

        onView(withId(R.id.add_button)).perform(click());

        intended(toPackage("com.measuredsoftware.passvault"));
    }

    @SuppressLint("CommitPrefEdits")
    @Before
    public void clearData()
    {
        final Context targetContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        final SharedPreferences preferences = targetContext.getSharedPreferences(PasswordListAdapter.PASSWORD_STORE, Context.MODE_PRIVATE);
        preferences.edit().clear().commit();
    }
}
