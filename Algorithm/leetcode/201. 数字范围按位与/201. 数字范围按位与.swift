//201. 数字范围按位与
//https://leetcode-cn.com/problems/bitwise-and-of-numbers-range/

//https://leetcode-cn.com/problems/bitwise-and-of-numbers-range/solution/swift-zui-zhong-jie-guo-you-zuo-bian-gong-gong-zhi/
//最终结果由左边公共值决定
//执行用时：24 ms, 在所有 Swift 提交中击败了100.00%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了100.00%的用户

func rangeBitwiseAnd(_ m: Int, _ n: Int) -> Int {
    // m 5 1 0 1
    //   6 1 1 0
    // n 7 1 1 1
    // 把n右边依次去掉1，直到<=m
    // m 5 1 0 1
    //   6 1 1 0
    // n 7 1 0 0
    // n&m
    var num = n
    while m < num {
        num = num&(num-1)
    }
    return m&num
}
