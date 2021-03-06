import Foundation
import ABCIMessages

public struct FilePrivateValidatorKey: Codable {
    public let address: Address
    // TODO: The key below should be an abstract PrivateKey
    // Using PrivateKey as an "abstract" class did not work
    // We should think about what to do later (see P2P/P2P+Key.swift)
    public let publicKey: PublicKeyProtocol
    public let privateKey: PrivateKey
    
    private enum CodingKeys: String, CodingKey {
        case address
        case publicKey = "pub_key"
        case privateKey = "priv_key"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(Address.self, forKey: .address)
        let publicKeyCodable = try container.decode(AnyProtocolCodable.self, forKey: .publicKey)

        guard let publicKey = publicKeyCodable.value as? PublicKeyProtocol else {
            throw DecodingError.dataCorruptedError(
                forKey: .publicKey,
                in: container,
                debugDescription: "Invalid type for public key"
            )
        }

        self.publicKey = publicKey
        
        let privateKeyCodable = try container.decode(AnyProtocolCodable.self, forKey: .privateKey)
        
        guard let privateKey = privateKeyCodable.value as? PrivateKey else {
            throw DecodingError.dataCorruptedError(
                forKey: .privateKey,
                in: container,
                debugDescription: "Invalid type for private key"
            )
        }
        
        self.privateKey = privateKey
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(AnyProtocolCodable(publicKey), forKey: .publicKey)
        try container.encode(AnyProtocolCodable(privateKey), forKey: .privateKey)
    }
}

extension FilePrivateValidatorKey {
    public init(privateKey: Ed25519PrivateKey) {
        self.privateKey = privateKey
        // TODO: this should not fail, but we should describe the public key as associated type to the private key to avoid this.
        self.publicKey = privateKey.publicKey as! Ed25519PublicKey
        self.address = self.publicKey.address
    }
}

public struct FilePrivateValidatorState: Codable {
    @StringBackedInt public var height: Int64
    public let round: UInt
    public let step: Int
}

public enum FilePrivateValidator {
    /// LoadOrGenFilePrivateValidatorKey attempts to load the FilePrivateValidatorKey from the given filePath.
    /// If the file does not exist, it generates and saves a new FilePrivateValidatorKey.
    public static func loadOrGenerateFilePrivateValidatorKey(atPath path: String) throws -> FilePrivateValidatorKey {
        if FileManager.default.fileExists(atPath: path) {
            return try loadFilePrivateValidatorKey(atPath: path)
        }
        
        return try generateFilePrivateValidatorKey(atPath: path)
    }

    /// LoadOrGenFilePrivateValidatorState attempts to load the FilePrivateValidatorState from the given filePath.
    /// If the file does not exist, it generates and saves a new FilePrivateValidatorState.
    public static func loadOrGenerateFilePrivateValidatorState(atPath path: String) throws -> FilePrivateValidatorState {
        if FileManager.default.fileExists(atPath: path) {
            return try loadFilePrivateValidatorState(atPath: path)
        }
        
        return try generateFilePrivateValidatorState(atPath: path)
    }

    private static func loadFilePrivateValidatorKey(atPath path: String) throws -> FilePrivateValidatorKey {
        let url = URL(fileURLWithPath: path)
        let jsonData = try Data(contentsOf: url)

        do {
            return try JSONDecoder().decode(FilePrivateValidatorKey.self, from: jsonData)
        } catch {
            struct DecodingError: Error, CustomStringConvertible {
                var description: String
            }
            
            throw DecodingError(description: "error reading FilePrivateValidatorKey from \(path): \(error)")
        }
    }

    private static func loadFilePrivateValidatorState(atPath path: String) throws -> FilePrivateValidatorState {
        let url = URL(fileURLWithPath: path)
        let jsonData = try Data(contentsOf: url)

        do {
            return try JSONDecoder().decode(FilePrivateValidatorState.self, from: jsonData)
        } catch {
            struct DecodingError: Error, CustomStringConvertible {
                var description: String
            }
            
            throw DecodingError(description: "error reading FilePrivateValidatorState from \(path): \(error)")
        }
    }
    
    private static func generateFilePrivateValidatorKey(atPath path: String) throws -> FilePrivateValidatorKey {
        let privateKey = Ed25519PrivateKey.generate()
        let filePrivateValidatorKey = FilePrivateValidatorKey(privateKey: privateKey)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys,
            .withoutEscapingSlashes
        ]
        let jsonData = try encoder.encode(filePrivateValidatorKey)
        let url = URL(fileURLWithPath: path)
        try jsonData.write(to: url)

        // Check if this is required
//        try! FileManager.default.setAttributes(
//            [.posixPermissions: NSNumber(value: Int16(0600))],
//            ofItemAtPath: path
//        )

        return filePrivateValidatorKey
    }
    
    private static func generateFilePrivateValidatorState(atPath path: String) throws -> FilePrivateValidatorState {
        let filePrivateValidatorState = FilePrivateValidatorState(height: 0, round: 0, step: 0)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys,
            .withoutEscapingSlashes
        ]
        let jsonData = try encoder.encode(filePrivateValidatorState)
        let url = URL(fileURLWithPath: path)
        try jsonData.write(to: url)
        return filePrivateValidatorState
    }
}

