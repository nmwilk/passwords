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

import com.measuredsoftware.passvault.model.PasswordModel;

public class NewPasswordActivity extends AbsPasswordActivity
{
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
        return getResources().getInteger(R.integer.pwd_len_default);
    }
}
