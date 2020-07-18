//https://leetcode-cn.com/problems/decode-string/

class Solution {
//https://leetcode-cn.com/problems/decode-string/solution/yi-ci-bian-li-by-hu-cheng-he-da-bai-sha/
func decodeString(_ s: String) -> String {
    var numbers = [Int]()
    var values = [String]()
    var retureValue = ""
    var tempInt = 0
    var tempStr = ""
    for item in s {
        if item.isNumber {
            tempInt = tempInt * 10 + Int(String(item))!
            if(tempStr.count > 0){
                let valuesCount = values.count
                let numbersCount = numbers.count
                if(valuesCount > 0 || numbers.count > 0){
                    if valuesCount   >= numbersCount  {
                        values[valuesCount - 1] = values[valuesCount - 1] + tempStr
                    }else{
                        values.append(tempStr)
                    }
                }else{
                    retureValue += tempStr
                }
                tempStr = ""
            }
        }else if item == "[" {
            numbers.append(tempInt)
            tempInt = 0
        }else if item == "]" {
            let multiple = numbers.popLast()!
            if tempStr.count == 0 || (values.count > 0 && values.count > numbers.count) {
                tempStr = values.popLast()! + tempStr
            }
            var multipleStr = ""
            for _ in 1...multiple {
                multipleStr += tempStr
            }
            let valuesCount = values.count
            let numbersCount = numbers.count
            
            if valuesCount > 0 ||  numbersCount > 0 {
                if valuesCount == numbersCount {
                    values[valuesCount - 1] = values[valuesCount - 1] + multipleStr
                }else{
                    values.append(multipleStr)
                }
            } else{
                retureValue += multipleStr
            }
            tempStr = ""
        }else{
            tempStr += String(item)
        }
    }
    retureValue += tempStr
    return retureValue
}

//https://leetcode-cn.com/problems/decode-string/solution/zhan-cao-zuo-by-hu-cheng-he-da-bai-sha/
func decodeString_a(_ s: String) -> String {
    var stk = [String]()
    var index = 0
    
    while index < s.count {
        let item = s[s.index(s.startIndex, offsetBy: index)]
        if item.isNumber {
            var num = Int(String(item))!
            while true{
                let nextItem = s[s.index(s.startIndex, offsetBy: index + 1)]
                if nextItem.isNumber {
                    num = num * 10 + Int(String(nextItem))!
                    index += 1
                }else{
                    break
                }
            }
            stk.append(String(num))
        }else if item == "]" {
            var repeatedStr = ""
            var lastStr = stk.popLast()!
            while lastStr != "[" {
                repeatedStr = lastStr +  repeatedStr
                lastStr = stk.popLast()!
            }
            let multipleNum = Int(stk.popLast()!)!
            var multipleStr = repeatedStr
            for _ in 1..<multipleNum {
                multipleStr += repeatedStr
            }
            stk.append(multipleStr)
        }else{
            stk.append(String(item))
        }
        index += 1
    }
    
    return stk.joined()
}

//https://leetcode-cn.com/problems/decode-string/solution/di-gui-by-hu-cheng-he-da-bai-sha/
func decodeString_b(_ s: String) -> String {
    var index = 0
    
    func dfs() -> String{
        if index >= s.count {
            return ""
        }
        
        let item = s[s.index(s.startIndex, offsetBy: index)]
        
        if item == "]" {
            return ""
        }
        
        if item.isNumber {
            var num = Int(String(item))!
            while true{
                let nextItem = s[s.index(s.startIndex, offsetBy: index + 1)]
                if nextItem.isNumber {
                    num = num * 10 + Int(String(nextItem))!
                    index += 1
                }else{
                    break
                }
            }
            index += 2 //过滤[
            let repeatedStr = dfs()
            index += 1 //过滤]
            
            var multipleStr = repeatedStr
            for _ in 1..<num {
                multipleStr += repeatedStr
            }
            return multipleStr + dfs()
            
        }
        
        index += 1
        return String(item) + dfs()
        
    }
    return dfs()
}
    
}


let solution = Solution()
print(solution.decodeString("3[a]2[bc]"))
print(solution.decodeString("3[a]2[b4[F]c]"))
print(solution.decodeString("3[z]2[2[y]pq4[2[jk]e1[f]]]ef"))
print(solution.decodeString("2[2[2[b]]]"))
print(solution.decodeString("2[l3[e4[c5[t]]]]"))

print(solution.decodeString_a("3[a]2[b4[F]c]"))
print(solution.decodeString_a("3[z]2[2[y]pq4[2[jk]e1[f]]]ef"))
print(solution.decodeString_a("2[2[2[b]]]"))
print(solution.decodeString_a("2[l3[e4[c5[t]]]]"))

print(solution.decodeString_b("3[a]2[b4[F]c]"))
print(solution.decodeString_b("3[z]2[2[y]pq4[2[jk]e1[f]]]ef"))
print(solution.decodeString_b("2[2[2[b]]]"))
print(solution.decodeString_b("2[l3[e4[c5[t]]]]"))
