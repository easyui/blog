//139. 单词拆分
//https://leetcode-cn.com/problems/word-break/

//https://leetcode-cn.com/problems/word-break/solution/swift-dong-tai-gui-hua-you-hua-bian-li-chang-du-by/
//执行用时：16 ms, 在所有 Swift 提交中击败了94.96%的用户
//内存消耗：14.3 MB, 在所有 Swift 提交中击败了100.00%的用户
func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    var wordSet = Set<String>()
    var maxCount = 0
    var minCount = Int.max
    for item in wordDict {
        wordSet.insert(item)
        maxCount = max(item.count ,maxCount)
        minCount = min(item.count ,minCount)
    }
    
    
    let dpCount = s.count + 1
    var dp = Array(repeating: false, count: dpCount)
    dp[0] = true
    
    for i in 1..<dpCount {
        let left = max( i - maxCount ,0)
        let right = (i - minCount)
        if left > right{
            continue
        }
        for j in left...right {
            //        for j in 0..<i {
            //            if i - j < minCount {
            //                break;
            //            }
            //            if i - j > maxCount {
            //                continue;
            //            }
            let start = s.index(s.startIndex, offsetBy: j)
            let end = s.index(s.startIndex, offsetBy: i)
            let subStr = s[start..<end]
            if wordSet.contains(String(subStr)) && dp[j]{
                dp[i] = true
                break
            }
        }
    }
    
    return dp[dpCount-1]
}
//print(wordBreak("applepenapple",["apple","pen"]))

//https://leetcode-cn.com/problems/word-break/solution/swift-ji-yi-hua-hui-su-by-hu-cheng-he-da-bai-sha/
//执行用时：16 ms, 在所有 Swift 提交中击败了94.96%的用户
//内存消耗：14.1 MB, 在所有 Swift 提交中击败了100.00%的用户
func wordBreak_a(_ s: String, _ wordDict: [String]) -> Bool {
    var cache = [String:Bool]()
    func check(_ str: String) -> Bool{
        guard str.count > 0 else{
            return true
        }
        if let temp = cache[str]{
            return temp
        }
        var flag = false
        for word in wordDict {
            if(str.hasPrefix(word)){
                if check(String(str.suffix(str.count - word.count))) {
                    flag = true
                    break
                }
            }
        }
        cache[str] = flag
        return flag
        
    }
    return check(s)
}

//print(wordBreak_a("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab",["a","aa","aaa","aaaa","aaaaa","aaaaaa","aaaaaaa","aaaaaaaa","aaaaaaaaa","aaaaaaaaaa"]))
