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
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;

import com.google.gson.Gson;
import com.measuredsoftware.passvault.listener.PasswordTextWatcher;
import com.measuredsoftware.passvault.model.PasswordGenerator;
import com.measuredsoftware.passvault.model.PasswordModel;
import com.measuredsoftware.passvault.model.RandomRandomizer;
import com.measuredsoftware.passvault.model.UserPreferences;
import com.measuredsoftware.passvault.view.GeneratorSection;
import com.measuredsoftware.passvault.view.PasswordLengthSlider;

/**
 * The base class for the New and Edit Password screens.
 */
@SuppressWarnings("ConstantConditions")
public abstract class AbsPasswordActivity extends AppCompatActivity implements SeekBar.OnSeekBarChangeListener,
    View.OnTouchListener
{
    private GeneratorSection generatorSection;
    private EditText passwordNameEditText;
    private EditText passwordEditText;
    private TextView lengthText;
    private String charsText;
    private PasswordGenerator passwordGenerator;
    private MenuItem doneButton;
    private PasswordLengthSlider lengthSlider;
    private boolean started;
    private int passwordLength;
    private Toolbar toolbar;
    private int minPwdLengthManualEntry;

    @Override
    protected void onCreate(final Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.password_activity);

        setUpActionBar();

        final PassVaultApplication application = (PassVaultApplication) getApplication();
        passwordGenerator = new PasswordGenerator(new RandomRandomizer(application.getDictionary(), application.getWordLengths()));

        passwordGenerator.setIncludeSymbol(application.getUserPrefs().isOptionChecked(UserPreferences.Options.INCLUDE_SYMBOL));
        passwordGenerator.setCapitalisation(
            application.getUserPrefs().isOptionChecked(UserPreferences.Options.CAPITALISE_EVERY_WORD) ? PasswordGenerator.Capitalisation.EVERY_WORD : PasswordGenerator.Capitalisation.RANDOM);

        charsText = getResources().getString(R.string.chars_suffix);
        minPwdLengthManualEntry = getResources().getInteger(R.integer.manual_pwd_len_min);

        generatorSection = (GeneratorSection) findViewById(R.id.generator_section);
        passwordNameEditText = (EditText) findViewById(R.id.name);
        passwordEditText = (EditText) findViewById(R.id.password);

        passwordNameEditText.addTextChangedListener(new TextWatcher()
        {
            @Override
            public void beforeTextChanged(final CharSequence s, final int start, final int count, final int after)
            {
                // do nothing
            }

            @Override
            public void onTextChanged(final CharSequence s, final int start, final int before, final int count)
            {
                // do nothing
            }

            @Override
            public void afterTextChanged(final Editable s)
            {
                updateButtonStates();
            }
        });

        passwordEditText.addTextChangedListener(new PasswordTextWatcher(new PasswordTextWatcher.Listener()
        {
            @Override
            public void onTextCleared()
            {
                generatorSection.show(true, true);
                passwordGenerator.setLength(lengthSlider.getLength());
                passwordGenerator.formPassword();
                updateButtonStates();
            }

            @Override
            public void onTextKeyboardEdited()
            {
                generatorSection.show(false, true);
                updateButtonStates();
            }

            @Override
            public void onTextAutoEdited()
            {
                generatorSection.show(true, true);
                passwordEditText.setSelection(passwordEditText.getText().length());
                updateButtonStates();
            }
        }));

        lengthText = (TextView) findViewById(R.id.password_length_text);
        lengthSlider = (PasswordLengthSlider) findViewById(R.id.password_length_slider);
        lengthSlider.setOnSeekBarChangeListener(this);

        findViewById(R.id.password_randomizer).setOnTouchListener(this);
    }

    private void setUpActionBar()
    {
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setPageTitle(getTitleResId());
        getSupportActionBar().setHomeAsUpIndicator(R.drawable.ic_action_content_clear);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public boolean onCreateOptionsMenu(final Menu menu)
    {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_password_screen, menu);

        doneButton = toolbar.getMenu().findItem(R.id.done_button);

        updateButtonStates();

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item)
    {
        boolean handled = true;

        final int id = item.getItemId();
        switch (id)
        {
            case android.R.id.home:
                close(false);
                break;
            case R.id.done_button:
                close(true);
                break;
            default:
                handled = super.onOptionsItemSelected(item);
                break;
        }

        return handled;
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        final int passwordLength = getStartingPasswordLength();
        lengthSlider.setLength(passwordLength);
        passwordGenerator.setLength(passwordLength);
        updateLengthText();
    }

    protected abstract int getStartingPasswordLength();

    public MenuItem getDoneButton()
    {
        return doneButton;
    }

    protected boolean passwordNameIsValid()
    {
        return getPasswordName().length() > 0;
    }

    protected boolean passwordIsValid()
    {
        return getPasswordValue().length() >= Math.min(lengthSlider.getPwdLenMin(), minPwdLengthManualEntry);
    }

    protected void updateButtonStates()
    {
        final MenuItem doneButton = getDoneButton();
        if (doneButton != null)
        {
            doneButton.setEnabled(passwordNameIsValid() && passwordIsValid());
        }
    }

    protected String getPasswordName()
    {
        return passwordNameEditText.getText().toString();
    }

    protected String getPasswordValue()
    {
        return passwordEditText.getText().toString();
    }

    protected void setEditTextValues(final String name, final String password)
    {
        passwordNameEditText.setText(name);
        passwordNameEditText.setSelection(name.length());
        passwordEditText.setText(password);
        passwordEditText.setSelection(password.length());
        updateLengthText();
    }

    private void updateLengthText()
    {
        lengthText.setText(lengthSlider.getLength() + " " + charsText);
    }

    private void setPageTitle(final int titleResId)
    {
        getSupportActionBar().setTitle(titleResId);
    }

    protected GeneratorSection getGeneratorSection()
    {
        return generatorSection;
    }

    protected abstract int getTitleResId();

    @Override
    public void onProgressChanged(final SeekBar seekBar, final int progress, final boolean fromUser)
    {
        passwordLength = progress + ((PasswordLengthSlider) seekBar).getPwdLenMin();

        passwordGenerator.setLength(passwordLength);

        if (started)
        {
            passwordEditText.setText(passwordGenerator.formPassword());
        }

        updateLengthText();
    }

    @Override
    protected void onResume()
    {
        super.onResume();
        started = true;
    }

    @Override
    public void onStartTrackingTouch(final SeekBar seekBar)
    {
        // do nothing
    }

    @Override
    public void onStopTrackingTouch(final SeekBar seekBar)
    {
        // do nothing
    }

    private void close(final boolean submit)
    {
        if (submit)
        {
            ((PassVaultApplication)getApplication()).getUserPrefs().setOptionInt(UserPreferences.Options.PREFS_PASSWORD_LENGTH, passwordLength);

            final Intent intent = new Intent();
            final Gson gson = new Gson();
            intent.putExtra(MainActivity.RESULT_EXTRA, gson.toJson(getPasswordModelToCommit()));
            setResult(RESULT_OK, intent);
        }
        else
        {
            setResult(RESULT_CANCELED);
        }

        finish();
    }

    protected abstract PasswordModel getPasswordModelToCommit();

    @Override
    public boolean onTouch(final View v, final MotionEvent event)
    {
        if (v.getId() == R.id.password_randomizer)
        {
            passwordGenerator.addRandom((int) event.getX(), (int) event.getY(), v.getWidth(), v.getHeight());
            passwordEditText.setText(passwordGenerator.formPassword());
            return true;
        }

        return false;
    }
}
