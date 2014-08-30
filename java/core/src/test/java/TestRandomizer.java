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
import com.measuredsoftware.passvault.model.Randomizer;

import java.util.Arrays;
import java.util.List;

public class TestRandomizer implements Randomizer
{
    private final List<String> testWords;
    private int testPosition;

    public TestRandomizer()
    {
        testWords = Arrays.asList("ABC", "DEFG", "HIJKL", "MNOPQR", "STUVWXY");
    }

    @Override
    public int getNumber(final long random)
    {
        return (int) (random % 10);
    }

    @Override
    public int getPosition(final int count)
    {
        return testPosition++ % count;
    }

    @Override
    public String getWord(final int length)
    {
        return testWords.get(length - getMinSingleWordLength());
    }

    @Override
    public double getRandom()
    {
        return 1.0;
    }

    @Override
    public int getMaxSingleWordLength()
    {
        return testWords.get(testWords.size() - 1).length();
    }

    @Override
    public int getMinSingleWordLength()
    {
        return testWords.get(0).length();
    }
}
