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

import android.app.Activity;
import android.content.Intent;
import android.database.DataSetObserver;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.view.Gravity;
import android.view.View;
import com.google.gson.Gson;
import com.measuredsoftware.passvault.model.PasswordListAdapter;
import com.measuredsoftware.passvault.model.PasswordModel;
import com.measuredsoftware.passvault.model.UserPreferences;
import com.measuredsoftware.passvault.view.*;

public class MainActivity extends Activity implements View.OnClickListener, MenuScreen.ChangedListener, PasswordListItem.EditItemListener
{
    public static final String RESULT_EXTRA = "krkesjfkejfe";

    public static final int REQUEST_CODE_ADD = 0;
    public static final int REQUEST_CODE_EDIT = 1;

    private PasswordList passwordList;
    private View addButton;
    private PasswordListAdapter dataModel;
    private View editButton;
    private View menuButton;
    private DrawerLayout slidingDrawer;
    private AddArrow addArrow;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        passwordList = (PasswordList) findViewById(R.id.password_list);
        final PasswordListAdapter adapter = new PasswordListAdapter(this, passwordList);
        passwordList.setAdapter(adapter);
        passwordList.getAdapter().registerDataSetObserver(new DataSetObserver()
        {
            @Override
            public void onChanged()
            {
                if (dataModel.isEmpty())
                {
                    if (dataModel.getMode() == PasswordListAdapter.Mode.EDIT)
                    {
                        toggleEditMode();
                    }
                    showEmptyArrowIfNeeded();
                }

                dataModel.storePasswords();

                updateEditButtonState();
            }
        });
        adapter.setEditItemListener(this);

        dataModel = passwordList.getPasswordListAdapter();

        addButton = findViewById(R.id.add_button);
        addButton.setOnClickListener(this);

        editButton = findViewById(R.id.edit_button);
        editButton.setOnClickListener(this);

        menuButton = findViewById(R.id.menu_button);
        menuButton.setOnClickListener(this);

        passwordList.setPasswordPopup((PasswordPopup) findViewById(R.id.password_popup));

        addArrow = (AddArrow) findViewById(R.id.add_arrow);

        slidingDrawer = (DrawerLayout) findViewById(R.id.sliding_drawer);

        final MenuScreen menuScreen = (MenuScreen) findViewById(R.id.menu_screen);
        menuScreen.setListener(this);
        for (UserPreferences.Options option : UserPreferences.Options.values())
        {
            menuScreen.setOption(option.getViewId(), getUserPrefs().isOptionChecked(option));
        }

        updateEditButtonState();
    }

    private UserPreferences getUserPrefs()
    {
        return ((PassVaultApplication) getApplication()).getUserPrefs();
    }

    @Override
    public void onClick(final View v)
    {
        switch (v.getId())
        {
            case R.id.add_button:
                goToPasswordEditor(NewPasswordActivity.class, REQUEST_CODE_ADD, null);
                break;
            case R.id.edit_button:
                toggleEditMode();
                break;
            case R.id.menu_button:
                if (slidingDrawer.isDrawerOpen(Gravity.LEFT))
                {
                    slidingDrawer.closeDrawer(Gravity.LEFT);
                }
                else
                {
                    slidingDrawer.openDrawer(Gravity.LEFT);
                }
                break;
        }
    }

    private void toggleEditMode()
    {
        final PasswordListAdapter.Mode newMode = dataModel.getMode() == PasswordListAdapter.Mode.EDIT
                                                 ? PasswordListAdapter.Mode.NORMAL
                                                 : PasswordListAdapter.Mode.EDIT;
        dataModel.setMode(newMode);
        passwordList.setMode(newMode);
        addButton.setEnabled(newMode == PasswordListAdapter.Mode.NORMAL);
        menuButton.setEnabled(newMode == PasswordListAdapter.Mode.NORMAL);
    }

    private void updateEditButtonState()
    {
        editButton.setEnabled(passwordList.getCount() > 0);
    }

    private void goToPasswordEditor(final Class clazz, final int requestCode, final PasswordModel model)
    {
        final Intent intent = new Intent(this, clazz);
        if (model != null)
        {
            final Gson gson = new Gson();
            intent.putExtra(EditPasswordActivity.CONFIG_EXTRA, gson.toJson(model));
        }
        startActivityForResult(intent, requestCode);
        overridePendingTransition(R.anim.password_in, R.anim.no_change);
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK)
        {
            final Gson gson = new Gson();
            final PasswordModel model = gson.fromJson(data.getStringExtra(RESULT_EXTRA), PasswordModel.class);

            if (requestCode == REQUEST_CODE_ADD)
            {
                dataModel.addPassword(model);
                addArrow.hide();
            }
            else if (requestCode == REQUEST_CODE_EDIT)
            {
                dataModel.editPassword(model);
            }
        }
    }

    @Override
    protected void onPause()
    {
        super.onPause();
        addArrow.hide();
        passwordList.closePopup();
    }

    @Override
    protected void onResume()
    {
        super.onResume();

        showEmptyArrowIfNeeded();
    }

    private void showEmptyArrowIfNeeded()
    {
        if (dataModel.isEmpty())
        {
            addArrow.show();
        }
        else
        {
            addArrow.hide();
        }
    }

    @Override
    public void optionChanged(final int viewId, final boolean checked)
    {
        final UserPreferences.Options option = UserPreferences.Options.getOptionFromViewId(viewId);

        if (option != null)
        {
            getUserPrefs().setOptionChecked(option, checked);
        }
    }

    @Override
    public void onItemChosenForEdit(final PasswordModel item)
    {
        goToPasswordEditor(EditPasswordActivity.class, REQUEST_CODE_EDIT, item);
    }

    @Override
    public void onOpenPopup(final PasswordModel item, final int x, final int y)
    {
        passwordList.openPopup(x, y, item.getPassword(), getUserPrefs().isOptionChecked(UserPreferences.Options.OBSCURE_PASSWORDS));
    }
}
