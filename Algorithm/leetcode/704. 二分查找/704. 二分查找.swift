//704. 二分查找
//https://leetcode-cn.com/problems/binary-search/

// 无重复元素搜索时，更方便
//https://leetcode-cn.com/problems/binary-search/solution/swift-er-fen-cha-zhao-by-hu-cheng-he-da-bai-sha/
//二分查找
//执行用时：396 ms, 在所有 Swift 提交中击败了39.04%的用户
//内存消耗：20.8 MB, 在所有 Swift 提交中击败了25.00%的用户
func search(_ nums: [Int], _ target: Int) -> Int {
    var start = 0
    var end = nums.count - 1
    
    while start <= end {
        let mid = (end + start)/2
        if nums[mid] == target {
            return mid
        }else if nums[mid] > target {
            end = mid - 1
        }else {
            start = mid + 1
        }
    }
    // 如果找不到，start 是第一个大于target的索引
    // 如果在B+树结构里面二分搜索，可以return start
    // 这样可以继续向子节点搜索，如：node:=node.Children[start]
    return  -1
}

func search_a(_ nums: [Int], _ target: Int) -> Int {
    var start = 0
    var end = nums.count - 1
    
    while start + 1 < end {
        let mid = (end + start)/2
        if nums[mid] == target {
            end = mid
        }else if nums[mid] > target {
            end = mid
        }else if nums[mid] < target {
            start = mid
        }
    }
    //最后剩下两个元素，手动判断
    if nums[start] == target {
        return start
    }
    
    if nums[end] == target {
        return end
    }
    
    return  -1
}
