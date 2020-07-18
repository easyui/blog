//https://leetcode-cn.com/problems/largest-rectangle-in-histogram/

class Solution{
//固定高度的暴力求解
 func largestRectangleArea(_ heights: [Int]) -> Int {
     let count = heights.count
     var largest = 0
     for i in 0..<count {
         let currntHeight = heights[i]
         var left = i ,right = i
         while left - 1 >= 0 && heights[left - 1] >= currntHeight {
             left -= 1
         }
         while right + 1 < count  && heights[right + 1] >= currntHeight  {
             right += 1
         }
         largest = max(largest,(right-left+1)*currntHeight)
     }
     return largest
 }
 
 //遍历宽度的暴力求解
 func largestRectangleArea_a(_ heights: [Int]) -> Int {
     let nums = heights.count
     if nums == 0 {
         return 0
     }
     var maxArea = 0
     for i in 0..<nums {
         var minHeight = heights[i]
         for j in i..<nums {
             minHeight = min(minHeight, heights[j])
             maxArea = max(maxArea, (j - i + 1) * minHeight)
         }
     }
     return maxArea
 }
 
 //单调栈
 //https://leetcode-cn.com/problems/largest-rectangle-in-histogram/solution/swift-dan-diao-zhan-bian-li-by-hu-cheng-he-da-bai-/
 func largestRectangleArea_b(_ heights: [Int]) -> Int {
     let nums = heights.count
     if nums == 0 {
         return 0
     }
     var maxArea = 0
     var stack = [Int]()
     for i in 0..<nums {
         while !stack.isEmpty && heights[stack.last!] > heights[i] {
             let highest = heights[stack.popLast()!]
             //下面这个while处理相等的，其实也可以不处理
             while !stack.isEmpty && heights[stack.last!] == highest {
                 stack.popLast()!
             }
             let width = stack.isEmpty ? i : (i - stack.last! - 1)//栈为空的特殊情况处理
             maxArea = max(maxArea,highest * width)
         }
         stack.append(i)
     }
     
     //遍历完后需要处理栈中剩余元素
     while !stack.isEmpty {
         let highest = heights[stack.popLast()!]
         //下面这个while处理相等的，其实也可以不处理
         while !stack.isEmpty && heights[stack.last!] == highest {
             stack.popLast()!
         }
         let width = stack.isEmpty ? nums : (nums -  stack.last! - 1)//栈为空的特殊情况处理
         maxArea = max(maxArea,highest * width)
     }
     
     return maxArea
 }
 
 //单调栈+哨兵
 //https://leetcode-cn.com/problems/largest-rectangle-in-histogram/solution/swift-dan-diao-zhan-shao-bing-bian-li-by-hu-cheng-/
 func largestRectangleArea_c(_ heights: [Int]) -> Int {
     if heights.count == 0 {
         return 0
     }
     
     let heights = [0] + heights + [0]
     let nums = heights.count
     
     var stack = [Int]()
     stack.append(heights[0])
     
     var maxArea = 0
     
     for i in 1..<nums {
         while heights[stack.last!] > heights[i] {
             let highest = heights[stack.popLast()!]
             let width = i - stack.last! - 1
             maxArea = max(maxArea,highest * width)
         }
         stack.append(i)
     }
     return maxArea
 }
}
let solution = Solution()

print(solution.largestRectangleArea([2,1,5,6,2,3]))
print(solution.largestRectangleArea_a([2,1,5,6,2,3]))
print(solution.largestRectangleArea_b([2,1,5,6,2,3]))
print(solution.largestRectangleArea_c([2,1,5,6,2,3]))

print(solution.largestRectangleArea([0,2,0]))
print(solution.largestRectangleArea_a([0,2,0]))
print(solution.largestRectangleArea_c([0,2,0]))

print(solution.largestRectangleArea([2,1,2]))
print(solution.largestRectangleArea_a([2,1,2]))
print(solution.largestRectangleArea_b([2,1,2]))
print(solution.largestRectangleArea_c([2,1,2]))

print(solution.largestRectangleArea([4,2,0,3,2,5]))
print(solution.largestRectangleArea_a([4,2,0,3,2,5]))
print(solution.largestRectangleArea_b([4,2,0,3,2,5]))
print(solution.largestRectangleArea_c([4,2,0,3,2,5]))

