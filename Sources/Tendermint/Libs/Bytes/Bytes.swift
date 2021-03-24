import Foundation

// The main purpose of HexBytes is to enable HEX-encoding for json/encoding.
public struct HexadecimalData: DataProtocol, RawRepresentable, Codable, CustomStringConvertible {
    public typealias Regions = Data.Regions
    public typealias Element = Data.Element
    public typealias Index = Data.Index
    public typealias SubSequence = Data.SubSequence
    public typealias Indices = Data.Indices
    
    public var regions: Data.Regions {
        rawValue.regions
    }
    
    public var startIndex: Data.Index {
        rawValue.startIndex
    }
    
    public var endIndex: Data.Index {
        rawValue.endIndex
    }
    
    public subscript(position: Data.Index) -> Data.Element {
        rawValue[position]
    }

    public var rawValue: Data
    
    public init?(rawValue: Data) {
        self.rawValue = rawValue
    }
    
    public init<D: DataProtocol>(_ data: D) {
        self.rawValue = Data(data)
    }
    
    public init<S: Sequence>(_ sequence: S) where S.Element == UInt8 {
        self.rawValue = Data(sequence)
    }
    
    public init?<S: StringProtocol>(_ string: S) {
        guard let data = Data(hexEncoded: string) else {
            return nil
        }
        
        self.init(data)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexEncoded = try container.decode(String.self)
        
        guard let data = Data(hexEncoded: hexEncoded) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Could not decoded hex encoded string \(hexEncoded)"
            )
        }
        
        self.rawValue = data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue.hexEncodedString(options: .upperCase))
    }
    
    public var isEmpty: Bool {
        rawValue.isEmpty
    }
    
    public var description: String {
        rawValue.hexEncodedString(options: .upperCase)
    }
}
