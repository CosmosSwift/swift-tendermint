import Foundation
import ABCIMessages

struct Part: Codable {
    public let index: UInt32
    public let bytes: Data // tmbytes.HexBytes
    public let proof: Never // crypto.MerkleProof
}

public struct PartSetHeader: Codable {
    public let total: UInt32
    public let hash: Data // tmbytes.HexBytes
}

struct PartSet {
    public let total: UInt32
    public let hash: Data
    public let mtx: Never
    public let parts: [Part]
    public let partsBitArray: Never // *bits.BitArray
    public let count: UInt32
    @StringBackedInt public var byteSize: Int64
}
