import Foundation
import ABCIMessages

// An address is a []byte, but hex-encoded even in JSON.
// []byte leaves us the option to change the address length.
// Use an alias so Unmarshal methods (with ptr receivers) are available too.
public typealias Address = HexadecimalData

public enum Crypto {
    public static func addressHash(data: Data) -> Address {
        Address(Hash.sumTruncated(data: data))
    }
}

public protocol PublicKeyProtocol: ProtocolCodable {
    var address: Address { get }
    var data: Data { get }
    func verify(message: Data, signature: Data) -> Bool
    func equals(publicKey: PublicKeyProtocol) -> Bool
}

public extension PublicKeyProtocol {
    func equals(publicKey: PublicKeyProtocol) -> Bool {
        self.data == publicKey.data
    }
}

public protocol PrivateKey: ProtocolCodable {
    var data: Data { get }
    var publicKey: PublicKeyProtocol { get}
    func sign(message: Data) throws -> Data
    func equals(privateKey: PrivateKey) -> Bool
}
    
public extension PrivateKey {
    func equals(privateKey: PrivateKey) -> Bool {
        self.data == privateKey.data
    }
}
