//https://leetcode-cn.com/problems/single-number/

import Foundation

//https://leetcode-cn.com/problems/single-number/solution/swift-wei-yun-suan-by-hu-cheng-he-da-bai-sha/
//执行用时：88 ms, 在所有 Swift 提交中击败了99.50%的用户
//内存消耗：20.7 MB, 在所有 Swift 提交中击败了100.00%的用户
/*
 异或运算有以下三个性质:
 任何数和 0 做异或运算，结果仍然是原来的数，即 a^0=a。
 任何数和其自身做异或运算，结果是 0，即 a^a=0。
 异或运算满足交换律和结合律，即 a^b^a=b^a^a=b^(a^a)=b^0=b。
 */
func singleNumber(_ nums: [Int]) -> Int {
    var res = 0
    for i in nums {
        res ^= i
    }
    return res
}
