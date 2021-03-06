// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

extension Stream {
    public struct PropertyKey : RawRepresentable, Equatable, Hashable, Comparable {
        public private(set) var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var hashValue: Int {
            return rawValue.hashValue
        }
    }
    
    public enum Status : UInt {
        
        case notOpen
        case opening
        case open
        case reading
        case writing
        case atEnd
        case closed
        case error
    }

    public struct Event : OptionSet {
        public let rawValue : UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }

        public static let openCompleted = Event(rawValue: 1 << 0)
        public static let hasBytesAvailable = Event(rawValue: 1 << 1)
        public static let hasSpaceAvailable = Event(rawValue: 1 << 2)
        public static let errorOccurred = Event(rawValue: 1 << 3)
        public static let endEncountered = Event(rawValue: 1 << 4)
    }
}

public func ==(lhs: Stream.PropertyKey, rhs: Stream.PropertyKey) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public func <(lhs: Stream.PropertyKey, rhs: Stream.PropertyKey) -> Bool {
    return lhs.rawValue < rhs.rawValue
}


// NSStream is an abstract class encapsulating the common API to NSInputStream and NSOutputStream.
// Subclassers of NSInputStream and NSOutputStream must also implement these methods.
public class Stream: NSObject {
    
    public override init() {
        
    }
    
    public func open() {
        NSUnimplemented()
    }
    
    public func close() {
        NSUnimplemented()
    }
    
    public weak var delegate: StreamDelegate?
    // By default, a stream is its own delegate, and subclassers of NSInputStream and NSOutputStream must maintain this contract. [someStream setDelegate:nil] must restore this behavior. As usual, delegates are not retained.
    
    public func propertyForKey(_ key: String) -> AnyObject? {
        NSUnimplemented()
    }
    
    public func setProperty(_ property: AnyObject?, forKey key: String) -> Bool {
        NSUnimplemented()
    }

// Re-enable once run loop is compiled on all platforms

    public func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        NSUnimplemented()
    }
    
    public func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        NSUnimplemented()
    }
    
    public var streamStatus: Status {
        NSUnimplemented()
    }
    
    /*@NSCopying */public var streamError: NSError? {
        NSUnimplemented()
    }
}

// NSInputStream is an abstract class representing the base functionality of a read stream.
// Subclassers are required to implement these methods.
public class InputStream: Stream {
    // reads up to length bytes into the supplied buffer, which must be at least of size len. Returns the actual number of bytes read.
    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        NSUnimplemented()
    }
    
    // returns in O(1) a pointer to the buffer in 'buffer' and by reference in 'len' how many bytes are available. This buffer is only valid until the next stream operation. Subclassers may return NO for this if it is not appropriate for the stream type. This may return NO if the buffer is not available.
    public func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        NSUnimplemented()
    }
    
    // returns YES if the stream has bytes available or if it impossible to tell without actually doing the read.
    public var hasBytesAvailable: Bool {
        NSUnimplemented()
    }
    
    public init(data: Data) {
        NSUnimplemented()
    }
    
    public init?(url: URL) {
        NSUnimplemented()
    }

    public convenience init?(fileAtPath path: String) {
        NSUnimplemented()
    }
}

// NSOutputStream is an abstract class representing the base functionality of a write stream.
// Subclassers are required to implement these methods.
// Currently this is left as named NSOutputStream due to conflicts with the standard library's text streaming target protocol named OutputStream (which ideally should be renamed)
public class NSOutputStream : Stream {
    // writes the bytes from the specified buffer to the stream up to len bytes. Returns the number of bytes actually written.
    public func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        NSUnimplemented()
    }
    
    // returns YES if the stream can be written to or if it is impossible to tell without actually doing the write.
    public var hasSpaceAvailable: Bool {
        NSUnimplemented()
    }
    
    public init(toMemory: ()) {
        NSUnimplemented()
    }

    public init(toBuffer buffer: UnsafeMutablePointer<UInt8>, capacity: Int) {
        NSUnimplemented()
    }

    public init?(url: URL, append shouldAppend: Bool) {
        NSUnimplemented()
    }
    
    public convenience init?(toFileAtPath path: String, append shouldAppend: Bool) {
        NSUnimplemented()
    }
    
    public class func outputStreamToMemory() -> Self {
        NSUnimplemented()
    }
}

// Discussion of this API is ongoing for its usage of AutoreleasingUnsafeMutablePointer
#if false
extension Stream {
    public class func getStreamsToHost(withName hostname: String, port: Int, inputStream: AutoreleasingUnsafeMutablePointer<InputStream?>?, outputStream: AutoreleasingUnsafeMutablePointer<NSOutputStream?>?) {
        NSUnimplemented()
    }
}

extension Stream {
    public class func getBoundStreams(withBufferSize bufferSize: Int, inputStream: AutoreleasingUnsafeMutablePointer<InputStream?>?, outputStream: AutoreleasingUnsafeMutablePointer<NSOutputStream?>?) {
        NSUnimplemented()
    }
}
#endif

extension StreamDelegate {
    func stream(_ aStream: Stream, handleEvent eventCode: Stream.Event) { }
}

public protocol StreamDelegate : class {
    func stream(_ aStream: Stream, handleEvent eventCode: Stream.Event)
}

// NSString constants for the propertyForKey/setProperty:forKey: API
// String constants for the setting of the socket security level.
// use this as the key for setting one of the following values for the security level of the target stream.
public let NSStreamSocketSecurityLevelKey: String = "kCFStreamPropertySocketSecurityLevel"

public let NSStreamSocketSecurityLevelNone: String = "kCFStreamSocketSecurityLevelNone"
public let NSStreamSocketSecurityLevelSSLv2: String = "NSStreamSocketSecurityLevelSSLv2"
public let NSStreamSocketSecurityLevelSSLv3: String = "NSStreamSocketSecurityLevelSSLv3"
public let NSStreamSocketSecurityLevelTLSv1: String = "kCFStreamSocketSecurityLevelTLSv1"
public let NSStreamSocketSecurityLevelNegotiatedSSL: String = "kCFStreamSocketSecurityLevelNegotiatedSSL"

public let NSStreamSOCKSProxyConfigurationKey: String  = "kCFStreamPropertySOCKSProxy"
// Value is an NSDictionary containing the key/value pairs below. The dictionary returned from SystemConfiguration for SOCKS proxies will work without alteration.

public let NSStreamSOCKSProxyHostKey: String = "NSStreamSOCKSProxyKey"
// Value is an NSString
public let NSStreamSOCKSProxyPortKey: String = "NSStreamSOCKSPortKey"
// Value is an NSNumber
public let NSStreamSOCKSProxyVersionKey: String = "kCFStreamPropertySOCKSVersion"
// Value is one of NSStreamSOCKSProxyVersion4 or NSStreamSOCKSProxyVersion5
public let NSStreamSOCKSProxyUserKey: String = "kCFStreamPropertySOCKSUser"
// Value is an NSString
public let NSStreamSOCKSProxyPasswordKey: String = "kCFStreamPropertySOCKSPassword"
// Value is an NSString

public let NSStreamSOCKSProxyVersion4: String = "kCFStreamSocketSOCKSVersion4"
// Value for NSStreamSOCKProxyVersionKey
public let NSStreamSOCKSProxyVersion5: String = "kCFStreamSocketSOCKSVersion5"
// Value for NSStreamSOCKProxyVersionKey

public let NSStreamDataWrittenToMemoryStreamKey: String = "kCFStreamPropertyDataWritten"
// Key for obtaining the data written to a memory stream.

public let NSStreamFileCurrentOffsetKey: String = "kCFStreamPropertyFileCurrentOffset"
// Value is an NSNumber representing the current absolute offset of the stream.

// NSString constants for error domains.
public let NSStreamSocketSSLErrorDomain: String = "NSStreamSocketSSLErrorDomain"
// SSL errors are to be interpreted via <Security/SecureTransport.h>
public let NSStreamSOCKSErrorDomain: String = "NSStreamSOCKSErrorDomain"

// Property key to specify the type of service for the stream.  This
// allows the system to properly handle the request with respect to
// routing, suspension behavior and other networking related attributes
// appropriate for the given service type.  The service types supported
// are documented below.
public let NSStreamNetworkServiceType: String = "kCFStreamNetworkServiceType"
// Supported network service types:
public let NSStreamNetworkServiceTypeVoIP: String = "kCFStreamNetworkServiceTypeVoIP"
public let NSStreamNetworkServiceTypeVideo: String = "kCFStreamNetworkServiceTypeVideo"
public let NSStreamNetworkServiceTypeBackground: String = "kCFStreamNetworkServiceTypeBackground"
public let NSStreamNetworkServiceTypeVoice: String = "kCFStreamNetworkServiceTypeVoice"

