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
package com.measuredsoftware.passvault.model;

import android.content.ContextWrapper;
import android.content.SharedPreferences;
import com.measuredsoftware.passvault.R;

/**
 * Reads and writes user preferences.
 */
public class UserPreferences
{
    private static final String PREFS = "904hkjfnbkwef";
    private final SharedPreferences preferences;

    public void setOptionChecked(final Options option, final boolean checked)
    {
        final SharedPreferences.Editor editor = preferences.edit();
        boolean save = true;

        switch (option)
        {
            case OBSCURE_PASSWORDS:
            case INCLUDE_SYMBOL:
            case CAPITALISATION_EVERY_WORD:
                editor.putBoolean(option.getStorageKey(), checked);
                break;
            default:
                save = false;
                break;
        }

        if (save)
        {
            editor.commit();
        }
    }

    public void setOptionInt(final Options option, final int value)
    {
        final SharedPreferences.Editor editor = preferences.edit();
        boolean save = true;

        switch (option)
        {
            case PREFS_PASSWORD_LENGTH:
                editor.putInt(option.getStorageKey(), value);
                break;
            default:
                save = false;
                break;
        }

        if (save)
        {
            editor.commit();
        }
    }

    public UserPreferences(final ContextWrapper contextWrapper)
    {
        preferences = contextWrapper.getSharedPreferences(PREFS, ContextWrapper.MODE_PRIVATE);
    }

    public boolean isOptionChecked(final Options option)
    {
        boolean checked = false;

        switch (option)
        {
            case OBSCURE_PASSWORDS:
            case CAPITALISATION_EVERY_WORD:
            case INCLUDE_SYMBOL:
                checked = preferences.getBoolean(option.getStorageKey(), option.defaultSetting());
                break;
        }


        return checked;
    }

    public int getOptionInt(final Options options)
    {
        int value = 0;

        switch (options)
        {
            case PREFS_PASSWORD_LENGTH:
                value = preferences.getInt(options.getStorageKey(), 0);
                break;
        }

        return value;
    }

    public enum Options
    {
        OBSCURE_PASSWORDS(false, R.id.obscure_passwords, "4oikjkjw"),
        INCLUDE_SYMBOL(true, R.id.include_symbol, "kjnk3iubj4"),
        CAPITALISATION_EVERY_WORD(true, R.id.capitalise_every_word, "iojnkbkbl2s"),
        PREFS_PASSWORD_LENGTH(false, 0, "09kjnkjbk2");

        private final boolean defaultSetting;
        private final int viewId;
        private final String storageKey;

        Options(final boolean defaultSetting, final int viewId, final String storageKey)
        {
            this.defaultSetting = defaultSetting;
            this.viewId = viewId;
            this.storageKey = storageKey;
        }

        public static Options getOptionFromViewId(final int viewId)
        {
            for (final Options option : values())
            {
                if (viewId == option.viewId)
                {
                    return option;
                }
            }

            return null;
        }

        public int getViewId()
        {
            return viewId;
        }

        public boolean defaultSetting()
        {
            return defaultSetting;
        }

        public String getStorageKey()
        {
            return storageKey;
        }
    }
}
