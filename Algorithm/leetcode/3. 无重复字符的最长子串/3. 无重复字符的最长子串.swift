//3. 无重复字符的最长子串
//https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/

//https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/solution/swift-hua-dong-chuang-kou-by-hu-cheng-he-da-bai--2/
//执行用时：76 ms, 在所有 Swift 提交中击败了59.25%的用户
//内存消耗：14.4 MB, 在所有 Swift 提交中击败了89.78%的用户
func lengthOfLongestSubstring(_ s: String) -> Int {
    let sArray = [Character](s)
    
    var win =  Dictionary<Character, Int>()
    
    var left = 0 ,right = 0    // 窗口
    var maxLength = 0
    
    while right < sArray.count {
        let rightItem = sArray[right]
        right += 1
        win[rightItem,  default: 0] += 1
        while win[rightItem]! > 1 {
            let leftItem = sArray[left]
            left += 1
            win[leftItem]! -= 1
        }
        maxLength = max(maxLength,right - left)
    }
    
    return maxLength
}
