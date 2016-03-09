package com.measuredsoftware.passvault;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.support.test.InstrumentationRegistry;

import com.measuredsoftware.passvault.model.PasswordListAdapter;

import org.junit.Before;

/**
 * Created by neil on 09/03/2016.
 */
public class UITest
{
    @SuppressLint("CommitPrefEdits")
    @Before
    public void clearData()
    {
        final Context targetContext = InstrumentationRegistry.getInstrumentation().getTargetContext();
        final SharedPreferences preferences = targetContext.getSharedPreferences(PasswordListAdapter.PASSWORD_STORE, Context.MODE_PRIVATE);
        preferences.edit().clear().commit();
    }
}
