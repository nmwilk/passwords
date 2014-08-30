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
    private static final String PREFS_OBSCURE_PASSWORDS = "4oikjkjw";
    private final SharedPreferences preferences;

    public void setOptionChecked(final Options option, final boolean checked)
    {
        final SharedPreferences.Editor editor = preferences.edit();
        boolean save = true;

        switch (option)
        {
            case OBSCURE_PASSWORDS:
                editor.putBoolean(PREFS_OBSCURE_PASSWORDS, checked);
                break;
            default:
                save = false;
                break;
        }

        //noinspection ConstantConditions
        if (save)
        {
            editor.commit();
        }
    }

    public enum Options
    {
        OBSCURE_PASSWORDS(false, R.id.obscure_passwords);

        private final boolean defaultSetting;
        private final int viewId;

        Options(final boolean defaultSetting, final int viewId)
        {
            this.defaultSetting = defaultSetting;
            this.viewId = viewId;
        }

        public static Options getOptionFromViewId(final int viewId)
        {
            for(final Options option : values())
            {
                if (viewId == option.viewId)
                {
                    return option;
                }
            }

            return null;
        }

        public boolean defaultSetting()
        {
            return defaultSetting;
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
                checked = preferences.getBoolean(PREFS_OBSCURE_PASSWORDS, option.defaultSetting());
                break;
        }


        return checked;
    }
}
