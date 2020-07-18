//https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/

class Solution {
//https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/solution/ni-bo-lan-biao-da-shi-hou-zhui-biao-da-shi-de-zhan/
func evalRPN(_ tokens: [String]) -> Int {
    var values = [Int]()
    for item in tokens {
        switch item {
        case "+":
            if let x = values.popLast(),let y = values.popLast(){
                values.append(y + x)
            }
        case "-":
            if let x = values.popLast(),let y = values.popLast(){
                values.append(y - x)
            }
        case "*":
            if let x = values.popLast(),let y = values.popLast(){
                values.append(y * x)
            }
        case "/":
            if let x = values.popLast(),let y = values.popLast(){
                values.append(y / x)
            }
            
        default:
            values.append(Int(item)!)
        }
    }
    return values.popLast()!
}
    
}
