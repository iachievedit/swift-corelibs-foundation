// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


public class SortDescriptor: NSObject, NSSecureCoding, NSCopying {
    
    public required init?(coder aDecoder: NSCoder) {
        NSUnimplemented()
    }
    
    public func encode(with aCoder: NSCoder) {
        NSUnimplemented()
    }
    
    static public func supportsSecureCoding() -> Bool {
        return true
    }
    
    public override func copy() -> AnyObject {
        return copy(with: nil)
    }
    
    public func copy(with zone: NSZone? = nil) -> AnyObject {
        NSUnimplemented()
    }

    // keys may be key paths
    public init(key: String?, ascending: Bool) { NSUnimplemented() }
    
    public var key: String? { NSUnimplemented() }
    public var ascending: Bool { NSUnimplemented() }
    
    public func allowEvaluation() { NSUnimplemented() } // Force a sort descriptor which was securely decoded to allow evaluation
    
    public init(key: String?, ascending: Bool, comparator cmptr: Comparator) { NSUnimplemented() }
    
    public var comparator: Comparator { NSUnimplemented() }
    
    public func compareObject(_ object1: AnyObject, toObject object2: AnyObject) -> ComparisonResult  { NSUnimplemented() }// primitive - override this method if you want to perform comparisons differently (not key based for example)
    public var reversedSortDescriptor: AnyObject  { NSUnimplemented() } // primitive - override this method to return a sort descriptor instance with reversed sort order
}

extension NSSet {
    
    public func sortedArrayUsingDescriptors(_ sortDescriptors: [SortDescriptor]) -> [AnyObject] { NSUnimplemented() }// returns a new array by sorting the objects of the receiver
}

extension NSArray {
    
    public func sortedArrayUsingDescriptors(_ sortDescriptors: [SortDescriptor]) -> [AnyObject] { NSUnimplemented() }// returns a new array by sorting the objects of the receiver
}

extension NSMutableArray {
    
    public func sortUsingDescriptors(_ sortDescriptors: [SortDescriptor]) { NSUnimplemented() } // sorts the array itself
}


extension NSOrderedSet {
    
    // returns a new array by sorting the objects of the receiver
    public func sortedArrayUsingDescriptors(_ sortDescriptors: [SortDescriptor]) -> [AnyObject] { NSUnimplemented() }
}

extension NSMutableOrderedSet {
    
    // sorts the ordered set itself
    public func sortUsingDescriptors(_ sortDescriptors: [SortDescriptor]) { NSUnimplemented() }
}
