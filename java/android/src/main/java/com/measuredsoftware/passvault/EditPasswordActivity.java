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

import android.content.Intent;
import android.os.Bundle;
import com.google.gson.Gson;
import com.measuredsoftware.passvault.model.PasswordModel;

/**
 * Activity used to edit an existing password.
 */
public class EditPasswordActivity extends AbsPasswordActivity
{
    public static final String CONFIG_EXTRA = "password_activity_config";

    private PasswordModel editedModel;

    @Override
    protected void onCreate(final Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        final Intent intent = getIntent();
        if (intent == null || !intent.hasExtra(CONFIG_EXTRA))
        {
            throw new IllegalArgumentException("Must call " + getClass().getSimpleName() + " with config data");
        }

        final Gson gson = new Gson();
        editedModel = gson.fromJson(intent.getStringExtra(CONFIG_EXTRA), PasswordModel.class);

        setEditTextValues(editedModel.getName(), editedModel.getPassword());

        getGeneratorSection().show(false, false);
    }

    @Override
    protected int getStartingPasswordLength()
    {
        return editedModel.getPassword().length();
    }

    @Override
    protected int getTitleResId()
    {
        return R.string.edit_password;
    }

    @Override
    protected PasswordModel getPasswordModelToCommit()
    {
        editedModel.setName(getPasswordName());
        editedModel.setPassword(getPasswordValue());
        return editedModel;
    }
}
