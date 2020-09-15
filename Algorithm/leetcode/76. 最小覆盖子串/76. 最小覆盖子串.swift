//76. 最小覆盖子串
//https://leetcode-cn.com/problems/minimum-window-substring/

//https://leetcode-cn.com/problems/minimum-window-substring/solution/swift-hua-dong-chuang-kou-you-hua-by-hu-cheng-he-d/
//执行用时：168 ms, 在所有 Swift 提交中击败了70.27%的用户
//内存消耗：15.5 MB, 在所有 Swift 提交中击败了96.67%的用户
func minWindow(_ s: String, _ t: String) -> String {
    let sArray = [Character](s)
    
    var win =  Dictionary<Character, Int>()    // 保存滑动窗口字符集
    var need = Dictionary<Character, Int>()    // 保存需要的字符集
    
    for c in t {
        need[c, default: 0] += 1
    }
    
    var left = 0 ,right = 0    // 窗口
    var match = 0    // match匹配次数
    var start = 0 , end = 0
    var minLength = Int.max
    
    while right < sArray.count {
        let rightItem = sArray[right]
        right += 1
        // 在需要的字符集里面，添加到窗口字符集里面
        if need[rightItem] != nil{
            win[rightItem,  default: 0] += 1
            // 如果当前字符的数量匹配需要的字符的数量，则match值+1
            if win[rightItem] == need[rightItem]{
                match += 1
            }
        }else{
            continue
        }
        
        // 当所有字符数量都匹配之后，开始缩紧窗口
        while match == need.count {
            if right - left < minLength {
                start = left
                end = right
                minLength = end - start
            }
            
            let leftItem = sArray[left]
            left += 1
            // 左指针指向不在需要字符集则直接跳过
            if need[leftItem] != nil{
                // 左指针指向字符数量和需要的字符相等时，右移之后match值就不匹配则减一
                // 因为win里面的字符数可能比较多，如有10个A，但需要的字符数量可能为3
                // 所以在压死骆驼的最后一根稻草时，match才减一，这时候才跳出循环
                if win[leftItem] == need[leftItem]{
                    match -= 1
                }
                win[leftItem]! -= 1
            }
        }
    }
    
    return minLength == Int.max ? "" : String(sArray[start..<end])
}
//print(minWindow("ADOBECODEBANC","ABC"))
