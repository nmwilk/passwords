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
package com.measuredsoftware.passvault.listener;

import android.text.Editable;
import android.text.TextWatcher;
import com.measuredsoftware.passvault.tools.StringTools;

/**
 * Intermediatary for watching the state of the password edit text.
 */
public class PasswordTextWatcher implements TextWatcher
{
    private final Listener listener;
    private int textWasLength;
    private String textWas;

    public PasswordTextWatcher(final Listener listener)
    {
        this.listener = listener;
    }

    @Override
    public void beforeTextChanged(final CharSequence s, final int start, final int count, final int after)
    {
        textWas = s.toString();
        textWasLength = s.length();
    }

    @Override
    public void onTextChanged(final CharSequence s, final int start, final int before, final int count)
    {
        // ignore
    }

    @Override
    public void afterTextChanged(final Editable s)
    {
        final int characterChangedCount = s.length() - textWasLength;
        if (s.length() == 0)
        {
            listener.onTextCleared();
        }
        else if (Math.abs(characterChangedCount) == 1 && StringTools.textOneCharDifferent(textWas, s.toString()))
        {
            listener.onTextKeyboardEdited();
        }
        else
        {
            listener.onTextAutoEdited();
        }
    }


    public interface Listener
    {
        void onTextCleared();

        void onTextKeyboardEdited();

        void onTextAutoEdited();
    }
}
