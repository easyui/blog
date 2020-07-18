//https://leetcode-cn.com/problems/implement-strstr/
class Solution {
    //用的系统api，但是超时了
    func strStr(_ haystack: String, _ needle: String) -> Int {
        guard !needle.isEmpty else{
            return 0
        }
        
        if let range: Range<String.Index> = haystack.range(of: needle) {
            let index: Int = haystack.distance(from: haystack.startIndex, to: range.lowerBound)
            return index
        }else{
            return -1
        }
    }
    
    //用的官方的解法二，但是超时了
    func strStr_a(_ haystack: String, _ needle: String) -> Int {
        guard !needle.isEmpty else{
            return 0
        }
        let needleCount = needle.count
        let haystackCount = haystack.count
        
        guard needleCount <= haystackCount else{
            return -1
        }
        let iRange = 0...(haystackCount - needleCount)
        let jRange = 0..<needleCount
        for i in iRange {
            var tempI = i
            for j in jRange {
                let haystackElement = haystack[haystack.index(haystack.startIndex, offsetBy: tempI)]
                let needleElement = needle[needle.index(needle.startIndex, offsetBy: j)]
                if haystackElement == needleElement {
                    tempI += 1
                    if j == needle.count - 1 {
                        return i
                    }
                }else{
                    break
                }
            }
        }
        return -1
    }
    
    //通过:12ms,20.8MB
    //https://leetcode-cn.com/problems/implement-strstr/solution/bian-li-haystackxian-pan-duan-shou-zi-mu-xiang-den/
    func strStr_b(_ haystack: String, _ needle: String) -> Int {
        guard !needle.isEmpty else{
            return 0
        }
        
        let needleCount = needle.count
        let haystackCount = haystack.count
        
        guard needleCount <= haystackCount else{
            return -1
        }
        
        let iRange = 0...(haystackCount - needleCount)
        let needleStart = needle.first
        
        for i in iRange {
            let startIndex = haystack.index(haystack.startIndex, offsetBy: i)
            let haystackElement = haystack[startIndex]
            
            if haystackElement == needleStart {
                let endIndex = haystack.index(startIndex, offsetBy: needleCount)
                let haystackRange = haystack[startIndex..<endIndex]
                if haystackRange == needle {
                    return i
                }
            }else{
                continue
            }
            
        }
        return -1
    }
    
    //通过:8ms,20.9MB
    //https://leetcode-cn.com/problems/implement-strstr/solution/yi-ci-bian-li-haystackhaystackcount-needlecountcha/
    func strStr_c(_ haystack: String, _ needle: String) -> Int {
        guard !needle.isEmpty else{
            return 0
        }
        
        let needleCount = needle.count
        let haystackCount = haystack.count
        
        guard needleCount <= haystackCount else{
            return -1
        }
        
        let iRange = 0...(haystackCount - needleCount)
        
        for i in iRange {
            let startIndex = haystack.index(haystack.startIndex, offsetBy: i)
            let endIndex = haystack.index(startIndex, offsetBy: needleCount)
            let haystackRange = haystack[startIndex..<endIndex]
            
            
            if haystackRange == needle {
                return i
            }else{
                continue
            }
        }
        return -1
    }
}

let solution = Solution()
print(solution.strStr("1234567890", "56"))
print(solution.strStr_a("1234567890", "56"))
print(solution.strStr_b("1234567890", "56"))
print(solution.strStr_c("1234567890", "56"))
