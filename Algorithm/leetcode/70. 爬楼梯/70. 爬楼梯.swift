//70. 爬楼梯
//https://leetcode-cn.com/problems/climbing-stairs/

//https://leetcode-cn.com/problems/climbing-stairs/solution/swift-dong-tai-gui-hua-fxfx-1fx-2-by-hu-cheng-he-d/
//动态规划：f(x)=f(x−1)+f(x−2)
//执行用时：4 ms, 在所有 Swift 提交中击败了84.08%的用户
//内存消耗：20.7 MB, 在所有 Swift 提交中击败了64.71%的用户
func climbStairs(_ n: Int) -> Int {//n是正整数
    var x1 = 0,x2 = 1 ,x3 = 0
    for _ in 1...n {
        x3 = x1 + x2
        x1 = x2
        x2 = x3
    }
    return x3
}

//https://leetcode-cn.com/problems/climbing-stairs/solution/swift-di-gui-fxfx-1fx-2-by-hu-cheng-he-da-bai-sha/
//递归：f(x)=f(x−1)+f(x−2)
//执行用时：4 ms, 在所有 Swift 提交中击败了84.17%的用户
//内存消耗：20.7 MB, 在所有 Swift 提交中击败了64.91%的用户
func climbStairs_a(_ n: Int) -> Int {//n是正整数
    var cache = [Int](repeating: 0, count: n+1)
    func dfs(_ n: Int) -> Int{
        if cache[n] != 0 {
            return cache[n]
        }
        if n <= 2 {
            return n
        }
//        cache[n - 1] = dfs(n - 1)
//        cache[n - 2] = dfs(n - 2)
//        return cache[n - 1] +  cache[n - 2]
        cache[n] = dfs(n - 1) +  dfs(n - 2)
        return cache[n]
    }
    return dfs(n)
}
