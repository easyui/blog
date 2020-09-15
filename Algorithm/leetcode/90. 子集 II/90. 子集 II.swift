//90. 子集 II
//https://leetcode-cn.com/problems/subsets-ii/

//https://leetcode-cn.com/problems/subsets-ii/solution/swift-90-zi-ji-iihui-su-by-hu-cheng-he-da-bai-sha/
//执行用时：12 ms, 在所有 Swift 提交中击败了100.00%的用户
//内存消耗：14 MB, 在所有 Swift 提交中击败了87.50%的用户
func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
    var res = [[Int]]()
    let sortedNums = nums.sorted()
    
    func backtrack(start :Int, track: inout [Int]){
        res.append(track)
        for index in start..<sortedNums.count {
            if index > start && sortedNums[index] == sortedNums[index - 1]{
                continue
            }
            track.append(sortedNums[index])
            backtrack(start: index+1, track: &track)
            track.popLast()
        }
    }
    
    var items = [Int]()
    backtrack(start: 0, track: &items)
    
    return res
}
