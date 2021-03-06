// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//



#if DEPLOYMENT_RUNTIME_OBJC || os(Linux)
import Foundation
import XCTest
#else
import SwiftFoundation
import SwiftXCTest
#endif



class TestNSArray : XCTestCase {
    
    static var allTests: [(String, (TestNSArray) -> () throws -> Void)] {
        return [
            ("test_BasicConstruction", test_BasicConstruction),
            ("test_enumeration", test_enumeration),
            ("test_sequenceType", test_sequenceType),
            ("test_objectAtIndex", test_objectAtIndex),
            ("test_binarySearch", test_binarySearch),
            ("test_binarySearchFringeCases", test_binarySearchFringeCases),
            ("test_replaceObjectsInRange_withObjectsFromArray", test_replaceObjectsInRange_withObjectsFromArray),
            ("test_replaceObjectsInRange_withObjectsFromArray_range", test_replaceObjectsInRange_withObjectsFromArray_range),
            ("test_replaceObjectAtIndex", test_replaceObjectAtIndex),
            ("test_removeObjectsInArray", test_removeObjectsInArray),
            ("test_sortedArrayUsingComparator", test_sortedArrayUsingComparator),
            ("test_sortedArrayWithOptionsUsingComparator", test_sortedArrayWithOptionsUsingComparator),
            ("test_arrayReplacement", test_arrayReplacement),
            ("test_arrayReplaceObjectsInRangeFromRange", test_arrayReplaceObjectsInRangeFromRange),
            ("test_sortUsingFunction", test_sortUsingFunction),
            ("test_sortUsingComparator", test_sortUsingComparator),
            ("test_equality", test_equality),
            ("test_copying", test_copying),
            ("test_mutableCopying", test_mutableCopying),
        ]
    }
    
    func test_BasicConstruction() {
        let array = NSArray()
        let array2 : NSArray = ["foo", "bar"].bridge()
        XCTAssertEqual(array.count, 0)
        XCTAssertEqual(array2.count, 2)
    }
    
    func test_enumeration() {
        let array : NSArray = ["foo", "bar", "baz"].bridge()
        let e = array.objectEnumerator()
        XCTAssertEqual((e.nextObject() as! NSString).bridge(), "foo")
        XCTAssertEqual((e.nextObject() as! NSString).bridge(), "bar")
        XCTAssertEqual((e.nextObject() as! NSString).bridge(), "baz")
        XCTAssertNil(e.nextObject())
        XCTAssertNil(e.nextObject())
        
        let r = array.reverseObjectEnumerator()
        XCTAssertEqual((r.nextObject() as! NSString).bridge(), "baz")
        XCTAssertEqual((r.nextObject() as! NSString).bridge(), "bar")
        XCTAssertEqual((r.nextObject() as! NSString).bridge(), "foo")
        XCTAssertNil(r.nextObject())
        XCTAssertNil(r.nextObject())
        
        let empty = NSArray().objectEnumerator()
        XCTAssertNil(empty.nextObject())
        XCTAssertNil(empty.nextObject())
        
        let reverseEmpty = NSArray().reverseObjectEnumerator()
        XCTAssertNil(reverseEmpty.nextObject())
        XCTAssertNil(reverseEmpty.nextObject())
    }
    
    func test_sequenceType() {
        let array : NSArray = ["foo", "bar", "baz"].bridge()
        var res = [String]()
        for obj in array {
            res.append((obj as! NSString).bridge())
        }
        XCTAssertEqual(res, ["foo", "bar", "baz"])
    }

//    func test_getObjects() {
//        let array : NSArray = ["foo", "bar", "baz", "foo1", "bar2", "baz3",].bridge()
//        var objects = [AnyObject]()
//        array.getObjects(&objects, range: NSMakeRange(1, 3))
//        XCTAssertEqual(objects.count, 3)
//        let fetched = [
//            (objects[0] as! NSString).bridge(),
//            (objects[1] as! NSString).bridge(),
//            (objects[2] as! NSString).bridge(),
//        ]
//        XCTAssertEqual(fetched, ["bar", "baz", "foo1"])
//    }
    
    func test_objectAtIndex() {
        let array : NSArray = ["foo", "bar"].bridge()
        let foo = array.object(at: 0) as! NSString
        XCTAssertEqual(foo, "foo".bridge())
        
        let bar = array.object(at: 1) as! NSString
        XCTAssertEqual(bar, "bar".bridge())
    }

    func test_binarySearch() {
        let numbers: [AnyObject] = [
            NSNumber(value: 0 as Int), NSNumber(value: 1 as Int), NSNumber(value: 2 as Int), NSNumber(value: 2 as Int), NSNumber(value: 3 as Int),
            NSNumber(value: 4 as Int), NSNumber(value: 4 as Int), NSNumber(value: 6 as Int), NSNumber(value: 7 as Int), NSNumber(value: 7 as Int),
            NSNumber(value: 7 as Int), NSNumber(value: 8 as Int), NSNumber(value: 9 as Int), NSNumber(value: 9 as Int)]
        let array = NSArray(array: numbers)
        
        // Not sure how to test fatal errors.
        
//        NSArray throws NSInvalidArgument if range exceeds bounds of the array.
//        let rangeOutOfArray = NSRange(location: 5, length: 15)
//        let _ = array.indexOfObject(NSNumber(value: 9 as Int), inSortedRange: rangeOutOfArray, options: [.InsertionIndex, .FirstEqual], usingComparator: compareIntNSNumber)
        
//        NSArray throws NSInvalidArgument if both .FirstEqual and .LastEqaul are specified
//        let searchForBoth: NSBinarySearchingOptions = [.FirstEqual, .LastEqual]
//        let _ = objectIndexInArray(array, value: 9, startingFrom: 0, length: 13, options: searchForBoth)

        let notFound = objectIndexInArray(array, value: 11, startingFrom: 0, length: 13)
        XCTAssertEqual(notFound, NSNotFound, "NSArray return NSNotFound if object is not found.")
        
        let notFoundInRange = objectIndexInArray(array, value: 7, startingFrom: 0, length: 5)
        XCTAssertEqual(notFoundInRange, NSNotFound, "NSArray return NSNotFound if object is not found.")
        
        let indexOfAnySeven = objectIndexInArray(array, value: 7, startingFrom: 0, length: 13)
        XCTAssertTrue(Set([8, 9, 10]).contains(indexOfAnySeven), "If no options provided NSArray returns an arbitrary matching object's index.")
        
        let indexOfFirstNine = objectIndexInArray(array, value: 9, startingFrom: 7, length: 6, options: [.FirstEqual])
        XCTAssertTrue(indexOfFirstNine == 12, "If .FirstEqual is set NSArray returns the lowest index of equal objects.")
        
        let indexOfLastTwo = objectIndexInArray(array, value: 2, startingFrom: 1, length: 7, options: [.LastEqual])
        XCTAssertTrue(indexOfLastTwo == 3, "If .LastEqual is set NSArray returns the highest index of equal objects.")
        
        let anyIndexToInsertNine = objectIndexInArray(array, value: 9, startingFrom: 0, length: 13, options: [.InsertionIndex])
        XCTAssertTrue(Set([12, 13, 14]).contains(anyIndexToInsertNine), "If .InsertionIndex is specified and no other options provided NSArray returns any equal or one larger index than any matching object’s index.")
        
        let lowestIndexToInsertTwo = objectIndexInArray(array, value: 2, startingFrom: 0, length: 5, options: [.InsertionIndex, .FirstEqual])
        XCTAssertTrue(lowestIndexToInsertTwo == 2, "If both .InsertionIndex and .FirstEqual are specified NSArray returns the lowest index of equal objects.")
        
        let highestIndexToInsertNine = objectIndexInArray(array, value: 9, startingFrom: 7, length: 6, options: [.InsertionIndex, .LastEqual])
        XCTAssertTrue(highestIndexToInsertNine == 13, "If both .InsertionIndex and .LastEqual are specified NSArray returns the index of the least greater object...")
        
        let indexOfLeastGreaterObjectThanFive = objectIndexInArray(array, value: 5, startingFrom: 0, length: 10, options: [.InsertionIndex, .LastEqual])
        XCTAssertTrue(indexOfLeastGreaterObjectThanFive == 7, "If both .InsertionIndex and .LastEqual are specified NSArray returns the index of the least greater object...")
        
        let rangeStart = 0
        let rangeLength = 13
        let endOfArray = objectIndexInArray(array, value: 10, startingFrom: rangeStart, length: rangeLength, options: [.InsertionIndex, .LastEqual])
        XCTAssertTrue(endOfArray == (rangeStart + rangeLength), "...or the index at the end of the array if the object is larger than all other elements.")
        
        let arrayOfTwo = NSArray(array: [NSNumber(value: 0 as Int), NSNumber(value: 2 as Int)])
        let indexInMiddle = objectIndexInArray(arrayOfTwo, value: 1, startingFrom: 0, length: 2, options: [.InsertionIndex, .FirstEqual])
        XCTAssertEqual(indexInMiddle, 1, "If no match found item should be inserted before least greater object")
        let indexInMiddle2 = objectIndexInArray(arrayOfTwo, value: 1, startingFrom: 0, length: 2, options: [.InsertionIndex, .LastEqual])
        XCTAssertEqual(indexInMiddle2, 1, "If no match found item should be inserted before least greater object")
        let indexInMiddle3 = objectIndexInArray(arrayOfTwo, value: 1, startingFrom: 0, length: 2, options: [.InsertionIndex])
        XCTAssertEqual(indexInMiddle3, 1, "If no match found item should be inserted before least greater object")
    }


    func test_arrayReplacement() {
        let numbers: [AnyObject] = [
            NSNumber(value: 0 as Int), NSNumber(value: 1 as Int), NSNumber(value: 2 as Int), NSNumber(value: 3 as Int),
            NSNumber(value: 4 as Int), NSNumber(value: 5 as Int), NSNumber(value: 7 as Int)]
        let array = NSMutableArray(array: numbers)
        array.replaceObjectsInRange(NSRange(location: 0, length: 2), withObjectsFromArray: [NSNumber(value: 8 as Int), NSNumber(value: 9 as Int)])
        XCTAssertTrue((array[0] as! NSNumber).intValue == 8)
        XCTAssertTrue((array[1] as! NSNumber).intValue == 9)
        XCTAssertTrue((array[2] as! NSNumber).intValue == 2)
    }

    func test_arrayReplaceObjectsInRangeFromRange() {
        let numbers: [AnyObject] = [
            NSNumber(value: 0 as Int), NSNumber(value: 1 as Int), NSNumber(value: 2 as Int), NSNumber(value: 3 as Int),
            NSNumber(value: 4 as Int), NSNumber(value: 5 as Int), NSNumber(value: 7 as Int)]
        let array = NSMutableArray(array: numbers)
        array.replaceObjects(in: NSRange(location: 0, length: 2), withObjectsFrom: [NSNumber(value: 8 as Int), NSNumber(value: 9 as Int), NSNumber(value: 10 as Int)], range: NSRange(location: 1, length: 2))
        XCTAssertTrue((array[0] as! NSNumber).intValue == 9)
        XCTAssertTrue((array[1] as! NSNumber).intValue == 10)
        XCTAssertTrue((array[2] as! NSNumber).intValue == 2)
    }

    func test_replaceObjectAtIndex() {
        let numbers: [AnyObject] = [
            NSNumber(value: 0 as Int), NSNumber(value: 1 as Int), NSNumber(value: 2 as Int), NSNumber(value: 3 as Int),
            NSNumber(value: 4 as Int), NSNumber(value: 5 as Int), NSNumber(value: 7 as Int)]
        let array = NSMutableArray(array: numbers)

        // 1. Check replacement in the middle of the array
        array.replaceObject(at: 3, with: NSNumber(value: 8 as Int))
        XCTAssertEqual(array.count, 7)
        XCTAssertEqual((array[3] as! NSNumber).intValue, 8)

        // 2. Check replacement of the first element
        array.replaceObject(at: 0, with: NSNumber(value: 7 as Int))
        XCTAssertEqual(array.count, 7)
        XCTAssertEqual((array[0] as! NSNumber).intValue, 7)

        // 3. Check replacement of the last element
        array.replaceObject(at: 6, with: NSNumber(value: 6 as Int))
        XCTAssertEqual(array.count, 7)
        XCTAssertEqual((array[6] as! NSNumber).intValue, 6)
    }

    func test_removeObjectsInArray() {
        let numbers: [AnyObject] = [
            NSNumber(value: 0 as Int), NSNumber(value: 1 as Int), NSNumber(value: 2 as Int), NSNumber(value: 3 as Int),
            NSNumber(value: 4 as Int), NSNumber(value: 5 as Int), NSNumber(value: 7 as Int)]
        let array = NSMutableArray(array: numbers)
        let objectsToRemove: Array<AnyObject> = [
            NSNumber(value: 1 as Int), NSNumber(value: 22 as Int), NSNumber(value: 7 as Int), NSNumber(value: 5 as Int)]
        array.removeObjects(in: objectsToRemove)
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual((array[0] as! NSNumber).intValue, 0)
        XCTAssertEqual((array[1] as! NSNumber).intValue, 2)
        XCTAssertEqual((array[2] as! NSNumber).intValue, 3)
        XCTAssertEqual((array[3] as! NSNumber).intValue, 4)
    }

    func test_binarySearchFringeCases() {
        let numbers: [AnyObject] = [
            NSNumber(value: 0 as Int), NSNumber(value: 1 as Int), NSNumber(value: 2 as Int), NSNumber(value: 2 as Int), NSNumber(value: 3 as Int),
            NSNumber(value: 4 as Int), NSNumber(value: 4 as Int), NSNumber(value: 6 as Int), NSNumber(value: 7 as Int), NSNumber(value: 7 as Int),
            NSNumber(value: 7 as Int), NSNumber(value: 8 as Int), NSNumber(value: 9 as Int), NSNumber(value: 9 as Int)]
        let array = NSArray(array: numbers)
        
        let emptyArray = NSArray()
//        Same as for non empty NSArray but error message ends with 'bounds for empty array'.
//        let _ = objectIndexInArray(emptyArray, value: 0, startingFrom: 0, length: 1)
        
        let notFoundInEmptyArray = objectIndexInArray(emptyArray, value: 9, startingFrom: 0, length: 0)
        XCTAssertEqual(notFoundInEmptyArray, NSNotFound, "Empty NSArray return NSNotFound for any valid arguments.")
        
        let startIndex = objectIndexInArray(emptyArray, value: 7, startingFrom: 0, length: 0, options: [.InsertionIndex])
        XCTAssertTrue(startIndex == 0, "For Empty NSArray any objects should be inserted at start.")
        
        let rangeStart = 0
        let rangeLength = 13
        
        let leastSearch = objectIndexInArray(array, value: -1, startingFrom: rangeStart, length: rangeLength)
        XCTAssertTrue(leastSearch == NSNotFound, "If object is less than least object in the range then there is no change it could be found.")
        
        let greatestSearch = objectIndexInArray(array, value: 15, startingFrom: rangeStart, length: rangeLength)
        XCTAssertTrue(greatestSearch == NSNotFound, "If object is greater than greatest object in the range then there is no change it could be found.")
        
        let leastInsert = objectIndexInArray(array, value: -1, startingFrom: rangeStart, length: rangeLength, options: .InsertionIndex)
        XCTAssertTrue(leastInsert == rangeStart, "If object is less than least object in the range it should be inserted at range' location.")
        
        let greatestInsert = objectIndexInArray(array, value: 15, startingFrom: rangeStart, length: rangeLength, options: .InsertionIndex)
        XCTAssertTrue(greatestInsert == (rangeStart + rangeLength), "If object is greater than greatest object in the range it should be inserted at range' end.")
    }
    
    func objectIndexInArray(_ array: NSArray, value: Int, startingFrom: Int, length: Int, options: NSBinarySearchingOptions = []) -> Int {
        return array.index(of: NSNumber(value: value), inSortedRange: NSRange(location: startingFrom, length: length), options: options, usingComparator: compareIntNSNumber)
    }
    
    func compareIntNSNumber(_ lhs: AnyObject, rhs: AnyObject) -> ComparisonResult {
        let lhsInt = (lhs as! NSNumber).intValue
        let rhsInt = (rhs as! NSNumber).intValue
        if lhsInt == rhsInt {
            return .orderedSame
        }
        if lhsInt < rhsInt {
            return .orderedAscending
        }
        
        return .orderedDescending
    }
    
    func test_replaceObjectsInRange_withObjectsFromArray() {
        let array1 = NSMutableArray(array:[
            "foo1".bridge(),
            "bar1".bridge(),
            "baz1".bridge()])
        
        let array2: [AnyObject] = [
            "foo2".bridge(),
            "bar2".bridge(),
            "baz2".bridge()]
        
        array1.replaceObjectsInRange(NSMakeRange(0, 2), withObjectsFromArray: array2)
        
        XCTAssertEqual(array1[0] as? NSString, "foo2".bridge(), "Expected foo2 but was \(array1[0])")
        XCTAssertEqual(array1[1] as? NSString, "bar2".bridge(), "Expected bar2 but was \(array1[1])")
        XCTAssertEqual(array1[2] as? NSString, "baz2".bridge(), "Expected baz2 but was \(array1[2])")
        XCTAssertEqual(array1[3] as? NSString, "baz1".bridge(), "Expected baz1 but was \(array1[3])")
    }
    
    func test_replaceObjectsInRange_withObjectsFromArray_range() {
        let array1 = NSMutableArray(array:[
            "foo1".bridge(),
            "bar1".bridge(),
            "baz1".bridge()])
        
        let array2: [AnyObject] = [
            "foo2".bridge(),
            "bar2".bridge(),
            "baz2".bridge()]
        
        array1.replaceObjects(in: NSMakeRange(1, 1), withObjectsFrom: array2, range: NSMakeRange(1, 2))
        
        XCTAssertEqual(array1[0] as? NSString, "foo1".bridge(), "Expected foo1 but was \(array1[0])")
        XCTAssertEqual(array1[1] as? NSString, "bar2".bridge(), "Expected bar2 but was \(array1[1])")
        XCTAssertEqual(array1[2] as? NSString, "baz2".bridge(), "Expected baz2 but was \(array1[2])")
        XCTAssertEqual(array1[3] as? NSString, "baz1".bridge(), "Expected baz1 but was \(array1[3])")
    }

    func test_sortedArrayUsingComparator() {
        // sort with localized caseInsensitive compare
        let input = ["this", "is", "a", "test", "of", "sort", "with", "strings"]
        let expectedResult: Array<String> = input.sorted()
        let result = input.bridge().sortedArray(comparator:) { left, right -> ComparisonResult in
            let l = left as! NSString
            let r = right as! NSString
            return l.localizedCaseInsensitiveCompare(r.bridge())
        }
        XCTAssertEqual(result.map { ($0 as! NSString).bridge()} , expectedResult)

        // sort empty array
        let emptyArray = NSArray().sortedArray(comparator:) { _,_ in .orderedSame }
        XCTAssertTrue(emptyArray.isEmpty)

        // sort numbers
        let inputNumbers = [0, 10, 25, 100, 21, 22]
        let expectedNumbers = inputNumbers.sorted()
        let resultNumbers = inputNumbers.bridge().sortedArray(comparator:) { left, right -> ComparisonResult in
            let l = (left as! NSNumber).intValue
            let r = (right as! NSNumber).intValue
            return l < r ? .orderedAscending : (l > r ? .orderedSame : .orderedDescending)
        }
        XCTAssertEqual(resultNumbers.map { ($0 as! NSNumber).intValue}, expectedNumbers)
    }

    func test_sortedArrayWithOptionsUsingComparator() {
        // check that sortedArrayWithOptions:comparator: works in the way sortedArrayUsingComparator does
        let input = ["this", "is", "a", "test", "of", "sort", "with", "strings"].bridge()
        let comparator: (AnyObject, AnyObject) -> ComparisonResult = { left, right -> ComparisonResult in
            let l = left as! NSString
            let r = right as! NSString
            return l.localizedCaseInsensitiveCompare(r.bridge())
        }
        let result1 = input.sortedArray(comparator: comparator)
        let result2 = input.sortedArray([], usingComparator: comparator)

        XCTAssertTrue(result1.bridge().isEqual(to: result2))

        // sort empty array
        let emptyArray = NSArray().sortedArray([]) { _,_ in .orderedSame }
        XCTAssertTrue(emptyArray.isEmpty)
    }

    func test_sortUsingFunction() {
        let inputNumbers = [11, 120, 215, 11, 1, -22, 35, -89, 65]
        let mutableInput = inputNumbers.bridge().mutableCopy() as! NSMutableArray
        let expectedNumbers = inputNumbers.sorted()

        func compare(_ left: AnyObject, right:AnyObject,  context: UnsafeMutablePointer<Void>?) -> Int {
            let l = (left as! NSNumber).intValue
            let r = (right as! NSNumber).intValue
            return l < r ? -1 : (l > r ? 0 : 1)
        }
        mutableInput.sortUsingFunction(compare, context: UnsafeMutablePointer<Void>(bitPattern: 0))

        XCTAssertEqual(mutableInput.map { ($0 as! NSNumber).intValue}, expectedNumbers)
    }

    func test_sortUsingComparator() {
        // check behaviour with Array's sort method
        let inputNumbers = [11, 120, 215, 11, 1, -22, 35, -89, 65]
        let mutableInput = inputNumbers.bridge().mutableCopy() as! NSMutableArray
        let expectedNumbers = inputNumbers.sorted()

        mutableInput.sortUsingComparator { left, right -> ComparisonResult in
            let l = (left as! NSNumber).intValue
            let r = (right as! NSNumber).intValue
            return l < r ? .orderedAscending : (l > r ? .orderedSame : .orderedDescending)
        }

        XCTAssertEqual(mutableInput.map { ($0 as! NSNumber).intValue}, expectedNumbers)

        // check that it works in the way self.sortWithOptions([], usingComparator: cmptr) does
        let inputStrings = ["this", "is", "a", "test", "of", "sort", "with", "strings"]
        let mutableStringsInput1 = inputStrings.bridge().mutableCopy() as! NSMutableArray
        let mutableStringsInput2 = inputStrings.bridge().mutableCopy() as! NSMutableArray
        let comparator: (AnyObject, AnyObject) -> ComparisonResult = { left, right -> ComparisonResult in
            let l = left as! NSString
            let r = right as! NSString
            return l.localizedCaseInsensitiveCompare(r.bridge())
        }
        mutableStringsInput1.sortUsingComparator(comparator)
        mutableStringsInput2.sortWithOptions([], usingComparator: comparator)
        XCTAssertTrue(mutableStringsInput1.isEqual(to: mutableStringsInput2.bridge()))
    }

    func test_equality() {
        let array1 = ["this", "is", "a", "test", "of", "equal", "with", "strings"].bridge()
        let array2 = ["this", "is", "a", "test", "of", "equal", "with", "strings"].bridge()
        let array3 = ["this", "is", "a", "test", "of", "equal", "with", "objects"].bridge()

        XCTAssertTrue(array1 == array2)
        XCTAssertTrue(array1.isEqual(array2))
        XCTAssertTrue(array1.isEqual(to: array2.bridge()))
        // if 2 arrays are equal, hashes should be equal as well. But not vise versa
        XCTAssertEqual(array1.hash, array2.hash)
        XCTAssertEqual(array1.hashValue, array2.hashValue)

        XCTAssertFalse(array1 == array3)
        XCTAssertFalse(array1.isEqual(array3))
        XCTAssertFalse(array1.isEqual(to: array3.bridge()))

        XCTAssertFalse(array1.isEqual(nil))
        XCTAssertFalse(array1.isEqual(NSObject()))
    }

    func test_copying() {
        let array = ["this", "is", "a", "test", "of", "copy", "with", "strings"].bridge()

        let arrayCopy1 = array.copy() as! NSArray
        XCTAssertTrue(array === arrayCopy1)

        let arrayMutableCopy = array.mutableCopy() as! NSMutableArray
        let arrayCopy2 = arrayMutableCopy.copy() as! NSArray
        XCTAssertTrue(arrayCopy2.dynamicType === NSArray.self)
        XCTAssertFalse(arrayMutableCopy === arrayCopy2)
        for entry in arrayCopy2 {
            XCTAssertTrue(array.indexOfObjectIdentical(to: entry) != NSNotFound)
        }

    }

    func test_mutableCopying() {
        let array = ["this", "is", "a", "test", "of", "mutableCopy", "with", "strings"].bridge()

        let arrayMutableCopy1 = array.mutableCopy() as! NSMutableArray
        XCTAssertTrue(arrayMutableCopy1.dynamicType === NSMutableArray.self)
        XCTAssertFalse(array === arrayMutableCopy1)
        for entry in arrayMutableCopy1 {
            XCTAssertTrue(array.indexOfObjectIdentical(to: entry) != NSNotFound)
        }

        let arrayMutableCopy2 = arrayMutableCopy1.mutableCopy() as! NSMutableArray
        XCTAssertTrue(arrayMutableCopy2.dynamicType === NSMutableArray.self)
        XCTAssertFalse(arrayMutableCopy2 === arrayMutableCopy1)
        for entry in arrayMutableCopy2 {
            XCTAssertTrue(arrayMutableCopy1.indexOfObjectIdentical(to: entry) != NSNotFound)
        }
    }

}
