//46. 全排列
//https://leetcode-cn.com/problems/permutations/

//https://leetcode-cn.com/problems/permutations/solution/swift-46-quan-pai-lie-hui-su-tong-shi-ji-lu-shi-yo/
//执行用时：28 ms, 在所有 Swift 提交中击败了74.77%的用户
//内存消耗：13.4 MB, 在所有 Swift 提交中击败了98.28%的用户
func permute(_ nums: [Int]) -> [[Int]] {
    var res = [[Int]]()
    let count = nums.count
    var used = [Int :Bool]()
    
    func backtrack(track: inout [Int]){
        if track.count == count{
            res.append(track)
        }
        for num in nums {
            if used[num] ?? false {
                continue
            }
            used[num] = true
            track.append(num)
            backtrack(track: &track)
            used[num] = false
            track.popLast()
        }
    }
    
    var items = [Int]()
    backtrack( track: &items)
    
    return res
}
