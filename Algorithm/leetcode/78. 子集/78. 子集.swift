//78. 子集
//https://leetcode-cn.com/problems/subsets/

//回溯
//https://leetcode-cn.com/problems/subsets/solution/swift-zi-ji-hui-su-by-hu-cheng-he-da-bai-sha/
//执行用时：8 ms, 在所有 Swift 提交中击败了97.96%的用户
//内存消耗：13.5 MB, 在所有 Swift 提交中击败了93.90%的用户
func subsets(_ nums: [Int]) -> [[Int]] {
    var res = [[Int]]()
    
    func backtrack(start :Int, track: inout [Int]){
        res.append(track)
        for index in start..<nums.count {
            track.append(nums[index])
            backtrack(start: index+1, track: &track)
            track.popLast()
        }
    }
    
    var items = [Int]()
    backtrack(start: 0, track: &items)
    
    return res
}

//迭代
//https://leetcode-cn.com/problems/subsets/solution/swift-zi-ji-die-dai-by-hu-cheng-he-da-bai-sha/
//执行用时：12 ms, 在所有 Swift 提交中击败了76.35%的用户
//内存消耗：13.5 MB, 在所有 Swift 提交中击败了93.90%的用户
func subsets_a(_ nums: [Int]) -> [[Int]] {
    var res = [[Int]]()
    res.append([Int]())
    
    for num in nums {
        var list = [[Int]]()
        for item in res {
            list.append(item + [num])
        }
        res.append(contentsOf: list)
    }
    
    return res
}
