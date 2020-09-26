import Foundation

//ed:不改变原来的，返回排序后的
var array = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
var copy = array
print("before:",array)

// 冒泡排序
public func bubbleSorted<T> (_ elements: [T], _ comparison: (T,T) -> Bool) -> [T]  {
    var array = elements
    
    for i in 0..<array.count {
        for j in 1..<array.count-i {
            if comparison(array[j], array[j-1]) {
                let tmp = array[j-1]
                array[j-1] = array[j]
                array[j] = tmp
            }
        }
    }
    
    return array
}


public func bubbleSorted<T> (_ elements: [T]) -> [T] where T: Comparable {
    return bubbleSorted(elements, <)
}

print("冒泡排序:")
print("after:", bubbleSorted(array))
print("after:", bubbleSorted(array, <))
print("after:", bubbleSorted(array, >))

// 快速排序

//swift api
func quickSorted<T: Comparable>(_ elements: [T]) -> [T] {
    guard elements.count > 1 else { return elements }
    
    let pivot = elements[elements.count/2]
    let less = elements.filter { $0 < pivot }
    let equal = elements.filter { $0 == pivot }
    let greater = elements.filter { $0 > pivot }
    
    return quickSorted(less) + equal + quickSorted(greater)
}

//通用
func quickSorted_a<T: Comparable>(_ elements:[T])->[T]{
    if elements.count<=1 {
        return elements
    }
    
    var left:[T] = []
    var right:[T] = []
    let pivot = elements[elements.count-1]
    for index in 0..<elements.count-1 {
        let item = elements[index]
        if item < pivot {
            left.append(item)
        }else{
            right.append(item)
        }
    }
    
    var result = quickSorted_a(left)
    result.append(pivot)
    let rightResult = quickSorted_a(right)
    result.append(contentsOf: rightResult)
    return result
}


//通用
func quickSort<T: Comparable>(_ elements:inout [T]) -> [T] {
    func swap(_ elements:inout [T], _ i: Int,_ j: Int) {
        let t = elements[i]
        elements[i] = elements[j]
        elements[j] = t
    }
    // 分区
    func partition(_ elements:inout [T],_ start: Int,_ end: Int) -> Int {
        let p = elements[end]//参考点。排序：比p小的在左边，比p大的在右边
        var i = start
        
        for j in start..<end {
            if elements[j] < p {
                swap(&elements, i, j)
                i += 1
            }
        }
        
        // 把中间的值换为用于比较的基准值
        swap(&elements, i, end)
        return i
    }
    // 原地交换，所以传入交换索引
    func sort(_ elements:inout [T],_ start: Int,_ end: Int) {
        if start < end {
            // 分治法：divide
            let pivot = partition(&elements, start, end)
            sort(&elements, 0, pivot-1)
            sort(&elements, pivot+1, end)
        }
    }
    // 思路：把一个数组分为左右两段，左段小于右段，类似分治法没有合并过程
    sort(&elements, 0, elements.count - 1)
    return elements
}


print("快速排序:")
print("after:", quickSorted(array))
print("after:", quickSorted_a(array))
print("after:", quickSort(&copy))
copy = array

// 插入排序
func insertionSorted<T>(_ array: [T], _ comparison: (T, T) -> Bool ) -> [T] {
    guard array.count > 1 else { return array }
    var sortedArray = array
    for index in 1..<sortedArray.count {
        var currentIndex = index
        let currentItem = sortedArray[currentIndex]
        while currentIndex > 0 && comparison(currentItem, sortedArray[currentIndex - 1]) {
            sortedArray[currentIndex] = sortedArray[currentIndex - 1]
            currentIndex -= 1
        }
        sortedArray[currentIndex] = currentItem
    }
    return sortedArray
}

func insertionSorted<T: Comparable>(_ array: [T]) -> [T] {
    //    return insertionSorted(array,<)
    var sortedArray = array
    for index in 1..<sortedArray.count {
        var currentIndex = index
        let currentItem = sortedArray[currentIndex]
        while currentIndex > 0 && currentItem < sortedArray[currentIndex - 1] {
            sortedArray[currentIndex] = sortedArray[currentIndex - 1]
            currentIndex -= 1
        }
        sortedArray[currentIndex] = currentItem
    }
    return sortedArray
}

print("插入排序:")
print("after:", insertionSorted(array))
print("after:", insertionSorted(array,<))
print("after:", insertionSorted(array,>))

// 希尔排序
public func shellSort<T: Comparable>(_ list: inout [T]) -> [T] {
    func insertionSort(_ list: inout [T], start: Int, gap: Int) {
        for i in stride(from: (start + gap), to: list.count, by: gap) {
            let currentItem = list[i]
            var currentIndex = i
            while currentIndex >= gap && list[currentIndex - gap] > currentItem {
                list[currentIndex] = list[currentIndex - gap]
                currentIndex -= gap
            }
            list[currentIndex] = currentItem
        }
    }
    
    var sublistCount = list.count / 2
    while sublistCount > 0 {
        for pos in 0..<sublistCount {
            insertionSort(&list, start: pos, gap: sublistCount)
        }
        sublistCount = sublistCount / 2
    }
    return list
}
print("希尔排序:")
print("after:", shellSort(&copy))
copy = array
// 选择排序
public func selectionSorted<T: Comparable>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool = {$0 < $1}) -> [T] {
    guard array.count > 1 else { return array }
    
    var a = array
    for x in 0 ..< a.count - 1 {
        
        // Find the lowest value in the rest of the array.
        var lowest = x
        for y in x + 1 ..< a.count {
            if isOrderedBefore(a[y], a[lowest]) {
                lowest = y
            }
        }
        
        // Swap the lowest value with the current array index.
        if x != lowest {
            a.swapAt(x, lowest)
        }
    }
    return a
}

print("选择排序:")
print("after:", selectionSorted(array))
// 堆排序
func heapSorted<T: Comparable>(_ array: inout [T]) -> [T] {
    func sink(_ array:inout [T], _ i: Int, _ length: Int) {
        var index = i
        while true {
            // 左节点索引(从0开始，所以左节点为i*2+1)
            let l = index*2 + 1
            // 有节点索引
            let r = index*2 + 2
            // idx保存根、左、右三者之间较大值的索引
            var idx = index
            // 存在左节点，左节点值较大，则取左节点
            if l < length && array[l] > array[idx] {
                idx = l
            }
            // 存在有节点，且值较大，取右节点
            if r < length && array[r] > array[idx] {
                idx = r
            }
            // 如果根节点较大，则不用下沉
            if idx == index {
                break
            }
            // 如果根节点较小，则交换值，并继续下沉
            exchange(&array, index, idx)
            // 继续下沉idx节点
            index = idx
        }
    }
    func exchange(_ array: inout [T], _ i: Int, _ j: Int) {
        let temp = array[i]
        array[i] = array[j]
        array[j] = temp
    }
    // 1、无序数组a
    // 2、将无序数组a构建为一个大根堆
    for i in (0...(array.count/2 - 1)).reversed() {
        sink(&array, i, array.count)
    }
    // 3、交换a[0]和a[len(a)-1]
    // 4、然后把前面这段数组继续下沉保持堆结构，如此循环即可
    for i in (1...(array.count - 1)).reversed() {
        // 从后往前填充值
        exchange(&array, 0, i)
        // 前面的长度也减一
        sink(&array, 0, i)
    }
    return array
}
print("堆排序:")
print("after:", heapSorted(&copy))
copy = array
// 归并排序
func mergeSort<T: Comparable>(_ nums: [T]) -> [T] {
    guard nums.count > 1 else { return nums }
    
    // 分治法：divide 分为两段
    let mid = nums.count / 2
    let left = mergeSort(Array(nums[0..<mid]))
    let right = mergeSort(Array(nums[mid..<nums.count]))
    // 合并两段数据
    let result = merge(left, right)
    return result
}
func merge<T: Comparable>(_ left: [T],_ right: [T]) -> [T] {
    var result = [T]()
    // 两边数组合并游标
    var l = 0,r = 0
    let lCount = left.count,rCount = right.count
    // 注意不能越界
    while l < lCount && r < rCount {
        // 谁小合并谁
        if left[l] > right[r] {
            result.append(right[r])
            r += 1
        } else {
            result.append(left[l])
            l += 1
        }
    }
    // 剩余部分合并
    if l < lCount {
        result.append(contentsOf: left[l..<lCount])
    }else{
        result.append(contentsOf: right[r..<rCount])
    }
    return result
}
print("归并排序:")
print("after:", mergeSort(array))

// 计数排序
//适用范围：整数>=0
func countingSort(_ array: [Int])-> [Int] {
    guard array.count > 0 else {return array}
    
    let maxElement = array.max() ?? 0
    
    var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
    for element in array {
        countArray[element] += 1
    }
    
    var sortedArray = [Int](repeating: 0, count: array.count)
    var sortedIndex = 0
    for (index,element) in countArray.enumerated() {
        for _ in 0..<element {
            sortedArray[sortedIndex] = index
            sortedIndex += 1
        }
    }
    return sortedArray
}
print("计数排序:")
array = [ 10, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
print("after:", countingSort(array))
array = [ 10,-1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]

//MARK:桶排序
func bucketSorted(_ arr:[Int],_ gap:Int = 5) -> [Int]
{
    //1.得到数列的最大值和最小值
    let maxNum:Int = arr.max()!
    let minNum:Int = arr.min()!
    //2.初始化桶数量
    let bucketCount:Int = (maxNum - minNum) / gap + 1
    //建桶
    var bucketlist:[[Int]] = [[Int]](repeating:[Int](),count:bucketCount)
    //3.遍历原始数组，将每个元素放入桶中
    for i in 0..<arr.count
    {
        let index:Int = (arr[i] - minNum) / gap
        bucketlist[index].append(arr[i])
    }
    //4.对每个通内部进行排序
    for i in 0..<bucketCount {
        //判断桶是否为空
        if bucketlist[i].count > 0 {
            quickSort(&bucketlist[i])//桶內元素快速排序，可用其他任意排序
        }
    }
    //5.连接全部桶内元素
    var arr = [Int]()
    for i in 0..<bucketCount {
        let bucket:[Int] = bucketlist[i]
        //判断桶是否为空
        if bucket.count > 0 {
            //数组添加
            arr += bucket
        }
    }
    return arr
}
print("桶排序:")
print("after:", bucketSorted(array,5))

// 基数排序
//适用范围：整数>=0
func radixSort(_ array: inout [Int] ) {
    //计算最大位数
    var maxNum = array.max()!
    var maxDigit = 0
    while maxNum > 0 {
        maxNum = maxNum / 10
        maxDigit += 1
    }
    
    let radix = 10
    var digit = 1
    
    for _ in 0..<maxDigit {
        var buckets: [[Int]] = [[Int]](repeating:[],count:10)
        
        for number in array {
            let index = number / digit
            buckets[index % radix].append(number)
        }
        
        var i = 0
        for j in 0..<radix {
            let bucket = buckets[j]
            for number in bucket {
                array[i] = number
                i += 1
            }
        }
        
        digit *= radix
    }
}

print("基数排序:")
copy = [ 10, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
radixSort(&copy)
print("after:", copy)
copy = array

