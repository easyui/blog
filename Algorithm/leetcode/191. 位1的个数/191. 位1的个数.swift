//https://leetcode-cn.com/problems/number-of-1-bits/

//https://leetcode-cn.com/problems/number-of-1-bits/solution/swift-zai-er-jin-zhi-biao-shi-zhong-shu-zi-n-zhong/
//在二进制表示中，数字 n 中最低位的 1总是对应 n - 1中的 0 。因此，将 n 和 n - 1与运算总是能把 n中最低位的 1 变成 0 ，并保持其他位不变。
//执行用时：8 ms, 在所有 Swift 提交中击败了75.00%的用户
//内存消耗：20 MB, 在所有 Swift 提交中击败了100.00%的用户
func hammingWeight(_ n: Int) -> Int {
    var res = 0
    var i = n
    while i != 0 {
        i &= (i - 1)
        res += 1
    }
    return res
}
