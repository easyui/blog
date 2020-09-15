//338. 比特位计数
//https://leetcode-cn.com/problems/counting-bits/


//https://leetcode-cn.com/problems/counting-bits/solution/swift-bian-li-mei-ge-shu-an-191-wei-1de-ge-shu-qiu/
//遍历每个数，按《191. 位1的个数》求出每个数的1的个数（在二进制表示中，数字 n 中最低位的 1总是对应 n - 1中的 0 。因此，将 n 和 n - 1与运算总是能把 n中最低位的 1 变成 0 ，并保持其他位不变。）
//执行用时：80 ms, 在所有 Swift 提交中击败了92.31%的用户
//内存消耗：24.6 MB, 在所有 Swift 提交中击败了100.00%的用户
func countBits(_ num: Int) -> [Int] {
    func hammingWeight(_ n: Int) -> Int {
        var res = 0
        var i = n
        while i != 0 {
            i &= (i - 1)
            res += 1
        }
        return res
    }
    var res = [Int]()
    for i in 0...num {
        res.append(hammingWeight(i))
    }
    return res
}

//https://leetcode-cn.com/problems/counting-bits/solution/swift-dong-tai-gui-hua-ibi-ii-1duo-yi-ge-1zai-zui-/
/*
依据：
在二进制表示中，数字 n 中最低位的 1总是对应 n - 1中的 0 。因此，将 n 和 n - 1与运算总是能把 n中最低位的 1 变成 0 ，并保持其他位不变。
所以：
用i比i&(i-1)多一个1（在最低有效位）来动态规划
 */
// ms, 在所有 Swift 提交中击败了96.15%的用户
//内存消耗：24.6 MB, 在所有 Swift 提交中击败了100.00%的用户
func countBits_a(_ num: Int) -> [Int] {
    if num == 0{
        return [0]
    }
    var res = Array(repeating: 0, count: num+1)
    for i in 1...num {
        res[i] = res[i&(i-1)] + 1
    }
    return res
}

//https://leetcode-cn.com/problems/counting-bits/solution/swift-dong-tai-gui-hua-qi-ou-shu-by-hu-cheng-he-da/
/*
对于所有的数字，只有两类：
奇数：二进制表示中，奇数一定比前面那个偶数多一个 1，因为多的就是最低位的 1。
偶数：二进制表示中，偶数中 1 的个数一定和除以 2 之后的那个数一样多。因为最低位是 0，除以 2 就是右移一位，也就是把那个 0 抹掉而已，所以 1 的个数是不变的。
 */
//执行用时：80 ms, 在所有 Swift 提交中击败了92.31%的用户
//内存消耗：24.6 MB, 在所有 Swift 提交中击败了100.00%的用s户
func countBits_b(_ num: Int) -> [Int] {
    if num == 0{
        return [0]
    }
    var res = Array(repeating: 0, count: num+1)
    for i in 1...num {
        if i&1 == 0 {// x / 2 is x >> 1 and x % 2 is x & 1
            //偶数
            res[i] = res[i>>1]
        }else{
            //奇数
            res[i] = res[i-1] + 1
        }
    }
    return res
}

//https://leetcode-cn.com/problems/counting-bits/solution/swift-dong-tai-gui-hua-zui-di-you-xiao-wei-by-hu-c/
//动态规划+最低有效位
//执行用时：84 ms, 在所有 Swift 提交中击败了80.77%的用户
//内存消耗：24.6 MB, 在所有 Swift 提交中击败了100.00%的用户
func countBits_c(_ num: Int) -> [Int] {
    if num == 0{
        return [0]
    }
    var res = Array(repeating: 0, count: num+1)
    for i in 1...num {
        /*
        if i&1 == 0 {// x / 2 is x >> 1 and x % 2 is x & 1
            //偶数
            res[i] = res[i>>1]
        }else{
            //奇数
            res[i] = res[i-1] + 1
        }
        */
        res[i] = res[i>>1] + i&1//P(x)=P(x/2)+(xmod2) //用奇偶数也可以推导出
    }
    return res
}

