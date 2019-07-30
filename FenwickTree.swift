import Foundation

class FenwickTree<T>: CustomDebugStringConvertible {
    
    private let count   : Int
    private let neutral : T
    private let forward : (T,T) -> T
    private let reverse : (T,T) -> T
    
    private var data    : [T]
    private var tree    : [T]
    
    init(
        count: Int,
        neutralElement: T,
        forward: @escaping (T,T) -> T,
        reverse: @escaping (T,T) -> T
        ) {
        self.count = count
        self.neutral = neutralElement
        self.forward = forward
        self.reverse = reverse
        self.data = Array(repeating: neutralElement, count: count)
        self.tree = Array(repeating: neutralElement, count: count + 1)
    }
    
    func update(index: Int, with newValue: T) {
        let oldValue = data[index];
        let delta = reverse(newValue, oldValue)
        data[index] = newValue
        var treeIndex = index + 1
        while treeIndex <= count {
            tree[treeIndex] = forward(tree[treeIndex], delta)
            treeIndex += treeIndex & -treeIndex
        }
    }
    
    func accumulated(at index: Int) -> T {
        var sum = neutral
        var treeIndex = index + 1
        while 0 < treeIndex {
            sum = forward(tree[treeIndex], sum)
            treeIndex -= treeIndex & -treeIndex
        }
        return sum
    }
    
    func accumulated(in range: Range<Int>) -> T {
        let low = range.lowerBound, high = range.upperBound - 1
        let cumulatedLow = low == 0 ? neutral : accumulated(at: low - 1)
        let cumulatedHigh = accumulated(at: high)
        return low == high ? data[low] : reverse(cumulatedHigh,cumulatedLow)
    }
    
    var debugDescription: String {
        let dataDescription = data.map { "\($0),\t"  }.joined().dropLast(2)
        let treeDescription = tree.dropFirst().map { "\($0),\t" }.joined().dropLast(2)
        
        return  "data :\t" + dataDescription
            + "\n" +
            "tree :\t" + treeDescription
    }
}
