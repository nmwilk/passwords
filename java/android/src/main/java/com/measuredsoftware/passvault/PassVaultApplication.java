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

import android.app.Application;
import com.measuredsoftware.passvault.model.UserPreferences;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;

/**
 * Adds loading of the dictionary to the main application, so that is doesn't need to be loaded each time the New/Edit Password dialogs opens.
 */
public class PassVaultApplication extends Application
{
    private Map<Integer, List<String>> dictionary;
    private final List<Integer> wordLengths = Arrays.asList(3, 4, 5, 6, 7);
    private UserPreferences userPrefs;

    @Override
    public void onCreate()
    {
        super.onCreate();

        dictionary = new HashMap<Integer, List<String>>();

        userPrefs = new UserPreferences(this);

        for (final Integer wordLength : wordLengths)
        {
            final InputStream in;
            try
            {
                in = getAssets().open(constructFilename(wordLength));

                final BufferedReader reader = new BufferedReader(new InputStreamReader(in));

                final List<String> words = new ArrayList<String>();
                String word = reader.readLine();
                while (word != null)
                {
                    words.add(word);
                    word = reader.readLine();
                }

                dictionary.put(wordLength, words);

                in.close();
            }
            catch (IOException e)
            {
                throw new IllegalStateException("Failure reading password files: " + e.getMessage());
            }
        }
    }

    public UserPreferences getUserPrefs()
    {
        return userPrefs;
    }

    public Map<Integer, List<String>> getDictionary()
    {
        return dictionary;
    }

    public List<Integer> getWordLengths()
    {
        return wordLengths;
    }

    private String constructFilename(final Integer wordLength)
    {
        return String.format("enable1_%d.txt", wordLength);
    }
}
