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

import android.os.SystemClock;

import java.util.List;
import java.util.Map;
import java.util.Random;

/**
 * Implemenation of a {@link com.measuredsoftware.passvault.model.Randomizer} that uses real pseudo-random numbers.
 */
public class RandomRandomizer implements Randomizer
{
    private final Random random = new Random(SystemClock.uptimeMillis());

    private final Map<Integer, List<String>> dictionary;
    private final int minSingleWordLength;
    private final int maxSingleWordLength;
    private long currentSeed;

    public RandomRandomizer(final Map<Integer, List<String>> dictionary, final List<Integer> wordLengths)
    {
        minSingleWordLength = wordLengths.get(0);
        maxSingleWordLength = wordLengths.get(wordLengths.size() - 1);

        this.dictionary = dictionary;
    }

    public int getMaxSingleWordLength()
    {
        return maxSingleWordLength;
    }

    public int getMinSingleWordLength()
    {
        return minSingleWordLength;
    }

    @Override
    public int getNumber(final long additionalRandom)
    {
        random.setSeed(updateSeed(additionalRandom));
        return random.nextInt(10);
    }

    private long updateSeed(final long additionalRandom)
    {
        currentSeed += additionalRandom;
        return currentSeed;
    }

    @Override
    public int getPosition(final int count)
    {
        return random.nextInt(count);
    }

    @Override
    public String getWord(final int length)
    {
        final List<String> words = dictionary.get(length);
        if (words == null)
        {
            throw new IllegalArgumentException("Failed to find list of words of length " + length);
        }
        return words.get(random.nextInt(words.size()));
    }

    @Override
    public double getRandom()
    {
        return random.nextDouble();
    }
}
