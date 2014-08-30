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
import com.measuredsoftware.passvault.model.PasswordGenerator;
import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

public class RandomizerTest
{
    @Test
    public void testModel()
    {
        final PasswordGenerator generator = new PasswordGenerator(new TestRandomizer());

        final List<String> expected = Arrays.asList(
            "1STUVWXY",
            "HIJKLABC2",
            "MNOPQR3ABC",
            "4STUVWXYABC",
            "STUVWXYDEFG5",
            "STUVWXY6HIJKL",
            "7STUVWXYMNOPQR",
            "STUVWXYSTUVWXY8",
            "9STUVWXYHIJKLABC",
            "STUVWXYMNOPQR0ABC",
            "1STUVWXYSTUVWXYABC",
            "STUVWXYSTUVWXY2DEFG",
            "3STUVWXYSTUVWXYHIJKL",
            "STUVWXYSTUVWXY4MNOPQR",
            "5STUVWXYSTUVWXYSTUVWXY",
            "6STUVWXYSTUVWXYHIJKLABC",
            "STUVWXYSTUVWXY7MNOPQRABC",
            "STUVWXYSTUVWXYSTUVWXYABC8",
            "STUVWXY9STUVWXYSTUVWXYDEFG",
            "STUVWXYSTUVWXYSTUVWXY0HIJKL",
            "1STUVWXYSTUVWXYSTUVWXYMNOPQR",
            "STUVWXYSTUVWXY2STUVWXYSTUVWXY",
            "STUVWXYSTUVWXY3STUVWXYHIJKLABC",
            "STUVWXYSTUVWXYSTUVWXYMNOPQR4ABC"
        );

        for (int i = 8; i < 32; i++)
        {
            try
            {
                generator.setLength(i);
                generator.addRandom(i - 7);
            }
            catch (Exception e)
            {
                System.out.println("error");
            }

            final String result = generator.formPassword();

            Assert.assertEquals(expected.get(i - 8), result);
        }
    }
}
