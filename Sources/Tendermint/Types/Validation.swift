import Foundation
import Crypto

struct HashValidateError: Error, CustomStringConvertible {
    var description: String
}

public func validate<D: DataProtocol>(hash: D) throws {
    guard hash.isEmpty || hash.count == SHA256.byteCount else {
        throw HashValidateError(description: "Invalid hash size \(hash.count)")
    }
}
