/* always_fail.cpp - a placeholder to check if gtest works
 *
 * Copyright (c) 2020 Oleg Iarygin <oleg@arhadthedev.net>
 *
 * Distributed under the MIT software license; see the accompanying
 * file LICENSE.txt or <https://www.opensource.org/licenses/mit-license.php>.
 */

#include <gtest/gtest.h>

TEST(always_pass, sample_test)
{
    EXPECT_EQ(1, 1);
}
