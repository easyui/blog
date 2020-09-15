//35. 搜索插入位置
//https://leetcode-cn.com/problems/search-insert-position/

//https://leetcode-cn.com/problems/search-insert-position/solution/swift-er-fen-cha-zhao-by-hu-cheng-he-da-bai-sha-2/
//二分查找，思路：找到第一个 >= target 的元素位置
//执行用时：40 ms, 在所有 Swift 提交中击败了77.60%的用户
//内存消耗：20.9 MB, 在所有 Swift 提交中击败了80.65%的用户
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var start = 0
    var end = nums.count - 1
    
    while start + 1 < end {
        let mid = (end + start)/2
        if nums[mid] == target {
            end = mid//向右搜索
        }else if nums[mid] > target {
            end = mid
        }else if nums[mid] < target {
            start = mid
        }
    }
    
    if nums[start] >= target {
        return start
    }else if nums[end] >= target {
        return end
    }else{//nums[end] > target// 目标值比所有值都大
        return end + 1
    }
}
