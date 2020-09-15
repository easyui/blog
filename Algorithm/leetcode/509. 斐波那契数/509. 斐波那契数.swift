//509. 斐波那契数
//https://leetcode-cn.com/problems/fibonacci-number/

//https://leetcode-cn.com/problems/fibonacci-number/solution/swift-di-gui-huan-cun-by-hu-cheng-he-da-bai-sha/
//执行用时：0 ms, 在所有 Swift 提交中击败了100.00%的用户
//内存消耗：13.6 MB, 在所有 Swift 提交中击败了96.30%的用户
func fib(_ N: Int) -> Int {
    var cache =  Dictionary<Int, Int>()
    func helper(_ n: Int) -> Int {
        if(n < 2){
             return n
         }
        if let item = cache[n] {
            print(n)
            return item
        }
         let res = helper(n-1)+helper(n-2)
         cache[n] = res
         return res
    }
 
    return helper(N)
}
//fib(100)
