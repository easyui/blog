//190. 颠倒二进制位
//https://leetcode-cn.com/problems/reverse-bits/

//https://leetcode-cn.com/problems/reverse-bits/solution/swift-yi-ci-dian-dao-er-jin-zhi-wei-by-hu-cheng-he/
//依次颠倒二进制位
//执行用时：16 ms, 在所有 Swift 提交中击败了64.29%的用户
//内存消耗：20.7 MB, 在所有 Swift 提交中击败了100.00%的用户
func reverseBits(_ n: Int) -> Int {
    var num = n
    var res = 0
    var pow = 31
    while num != 0 {
        let bit = num&1
        res += bit << pow
        
        num = num >> 1
        pow -= 1
    }
    return res
}
