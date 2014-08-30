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
package com.measuredsoftware.passvault.tools;

public class StringTools
{
    public static boolean textOneCharDifferent(final String prev, final String current)
    {
        int charsDifferent = 0;

        final String longer;
        final String shorter;

        if (prev.length() > current.length())
        {
            longer = prev;
            shorter = current;
        }
        else
        {
            shorter = prev;
            longer = current;
        }

        int indexInShorter = 0;

        for (int i = 0; i < longer.length(); i++)
        {
            if (indexInShorter >= shorter.length())
            {
                charsDifferent += longer.length() - shorter.length();
            }
            else if (longer.charAt(i) != shorter.charAt(indexInShorter))
            {
                ++charsDifferent;
            }
            else
            {
                ++indexInShorter;
            }


            if (charsDifferent > 1)
            {
                break;
            }
        }

        return charsDifferent == 1;
    }

}
