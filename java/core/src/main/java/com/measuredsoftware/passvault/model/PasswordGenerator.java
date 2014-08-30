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

import java.util.ArrayList;
import java.util.List;

public final class PasswordGenerator
{
    public enum Capitalisation
    {
        EVERY_WORD,
        RANDOM,
    }

    private static final String SYMBOLS = "\"!$%&'()*+,-./:;<=>?@[\\]^_`";

    private final Randomizer randomizer;
    private final List<String> passwordItems;
    private int number;
    private int maxLength;
    private long lastRandom;
    private int numberPosition;
    private Capitalisation capitalisation;
    private boolean includeSymbol;
    private char symbol;
    private int symbolPosition;
    private int reservedSpace;
    private int totalLength;

    public PasswordGenerator(final Randomizer randomizer)
    {
        this.randomizer = randomizer;
        passwordItems = new ArrayList<String>();

        capitalisation = Capitalisation.EVERY_WORD;
        reservedSpace = 1;
    }

    /**
     * @param includeSymbol Include a symbol when generating. Defaults to false.
     */
    public void setIncludeSymbol(final boolean includeSymbol)
    {
        this.includeSymbol = includeSymbol;
        reservedSpace = this.includeSymbol ? 2 : 1;
        setLength(totalLength);
    }

    /**
     * @param capitalisation The {@link com.measuredsoftware.passvault.model.PasswordGenerator.Capitalisation} method. Defaults to EVERY_WORD.
     */
    public void setCapitalisation(final Capitalisation capitalisation)
    {
        this.capitalisation = capitalisation;
    }

    public void addRandom(final int a, final int b, final int maxA, final int maxB)
    {
        final double normalA = a / (double) maxA;
        final double normalB = b / (double) maxB;

        addRandom((long) (((normalA + normalB) / 2) * Long.MAX_VALUE));
    }

    public void addRandom(final long random)
    {
        lastRandom = random;

        passwordItems.clear();

        number = randomizer.getNumber(lastRandom);

        if (includeSymbol)
        {
            symbol = SYMBOLS.charAt(randomizer.getPosition(SYMBOLS.length()));
        }

        int passwordLength = getLength();
        do
        {
            final int desiredLength = calcDesireWordLength(passwordLength, randomizer.getRandom());

            final String word = capitaliseWord(randomizer.getWord(desiredLength), randomizer.getBoolean());

            passwordItems.add(word);

            passwordLength = getLength();
        } while (passwordLength < maxLength);

        numberPosition = randomizer.getPosition(passwordItems.size() + reservedSpace);

        if (includeSymbol)
        {
            symbolPosition = randomizer.getPosition(passwordItems.size() + reservedSpace);
        }
    }

    private String capitaliseWord(final String word, final boolean capitaliseWord)
    {
        final String newFormat;
        if (capitalisation == Capitalisation.EVERY_WORD || capitaliseWord)
        {
            newFormat = word.toUpperCase().charAt(0) + word.substring(1);
        }
        else
        {
            newFormat = word.toLowerCase();
        }

        return newFormat;
    }

    public String formPassword()
    {
        final StringBuilder sb = new StringBuilder();

        if (passwordItems.size() > 0)
        {
            for (int i = 0; i < passwordItems.size() + reservedSpace; i++)
            {
                if (i == numberPosition)
                {
                    sb.append(number);
                }

                if (includeSymbol && i == symbolPosition)
                {
                    sb.append(symbol);
                }

                if (i < passwordItems.size())
                {
                    sb.append(passwordItems.get(i));
                }
            }
        }

        return sb.toString();
    }

    public void setLength(final int length)
    {
        totalLength = length;
        maxLength = length - reservedSpace;

        passwordItems.clear();

        if (lastRandom > 0)
        {
            addRandom(lastRandom);
        }
    }

    private int calcDesireWordLength(final int currentFormedLength, final double random)
    {
        final int minSingleWordLength = randomizer.getMinSingleWordLength();

        final int maxWordLength = Math.min(maxLength - currentFormedLength, randomizer.getMaxSingleWordLength());

        int desiredLength = (int) Math
            .min(minSingleWordLength + Math.round(random * ((maxWordLength - minSingleWordLength) + reservedSpace)), maxWordLength);

        final int remaining = maxLength - (desiredLength + currentFormedLength);
        if (remaining > 0 && remaining < minSingleWordLength)
        {
            final int reduced = desiredLength - (minSingleWordLength - remaining);
            if (reduced < minSingleWordLength)
            {
                desiredLength += remaining;
            }
            else
            {
                desiredLength -= (minSingleWordLength - remaining);
            }
        }

        return desiredLength;
    }

    private int getLength()
    {
        int len = 0;
        for (final String item : passwordItems)
        {
            len += item.length();
        }

        return len;
    }
}
