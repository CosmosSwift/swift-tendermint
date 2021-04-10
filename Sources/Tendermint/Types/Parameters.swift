import Foundation

// ConsensusParams contains consensus critical parameters that determine the
// validity of blocks.
public struct ConsensusParameters: Codable {
    // MaxBlockSizeBytes is the maximum permitted size of the blocks.
    static let maximumBlockSizeBytes = 104857600 // 100MB

    // BlockPartSizeBytes is the size of one block part.
    static let blockPartSizeBytes = 65536 // 64kB

    // MaxBlockPartsCount is the maximum number of block parts.
    static let maximumBlockPartsCount = (maximumBlockSizeBytes / blockPartSizeBytes) + 1

    public let block: BlockParameters
    public let evidence: EvidenceParameters
    public let validator: ValidatorParameters
    public let version: VersionParameters
}

// BlockParams define limits on the block size and gas plus minimum time
// between blocks.
public struct BlockParameters: Codable {
    public let maximumBytes: StringRepresentedInt<Int64>
    public let maximumGas: StringRepresentedInt<Int64>
    public let timeIotaMs: StringRepresentedInt<Int64>

    private enum CodingKeys: String, CodingKey {
        case maximumBytes = "max_bytes"
        case maximumGas = "max_gas"
        case timeIotaMs = "time_iota_ms"
    }
}

// EvidenceParams determine how we handle evidence of malfeasance.
public struct EvidenceParameters: Codable {
    // only accept new evidence more recent than this
    public let maximumAgeNumberBlocks: StringRepresentedInt<Int64>
    public let maximumAgeDuration: StringRepresentedInt<Int64>
    public let maxBytes: StringRepresentedInt<Int64>
    
    private enum CodingKeys: String, CodingKey {
        case maximumAgeNumberBlocks = "max_age_num_blocks"
        case maximumAgeDuration = "max_age_duration"
        case maxBytes = "max_bytes"
    }
}

// ValidatorParams restrict the public key types validators can use.
// NOTE: uses ABCI pubkey naming, not Amino names.
public struct ValidatorParameters: Codable {
    public enum PublicKeyType: String, Codable {
        case ed25519
        case sr25519
        case secp256k1
    }

    public let publicKeyTypes: [PublicKeyType]
    
    private enum CodingKeys: String, CodingKey {
        case publicKeyTypes = "pub_key_types"
    }
}

public struct VersionParameters: Codable {
    public let appVersion: UInt64?
    
    private enum CodingKeys: String, CodingKey {
        case appVersion = "app_version"
    }
}

extension ConsensusParameters {
    // DefaultConsensusParams returns a default ConsensusParams.
    static var `default`: ConsensusParameters {
        ConsensusParameters(
            block: .default,
            evidence: .default,
            validator: .default,
            version: .default
        )
    }
}

extension BlockParameters {
    // DefaultBlockParams returns a default BlockParams.
    static var `default`: BlockParameters {
        BlockParameters(
            maximumBytes: StringRepresentedInt<Int64>(22020096), // 21MB
            maximumGas: StringRepresentedInt<Int64>(-1),
            timeIotaMs: StringRepresentedInt<Int64>(500)
        )
    }
}

public enum Time: RawRepresentable, Codable, CustomStringConvertible {
    case nanoSecond(TimeInterval)
    case microSecond(TimeInterval)
    case milliSecond(TimeInterval)
    case second(TimeInterval)
    case minute(TimeInterval)
    case hour(TimeInterval)
    
    public init?(rawValue: Double) {
        self = .nanoSecond(rawValue)
    }
    
    public var rawValue: TimeInterval {
        switch self {
        case .nanoSecond(let value):
            return value
        case .microSecond(let value):
            return value * 1000
        case .milliSecond(let value):
            return value * 1000 * 1000
        case .second(let value):
            return value * 1000 * 1000 * 1000
        case .minute(let value):
            return value * 1000 * 1000 * 1000 * 60
        case .hour(let value):
            return value * 1000 * 1000 * 1000 * 60 * 60
        }
    }
    
    public var description: String {
        switch self {
        case .nanoSecond(let value):
            return "\(value)ns"
        case .microSecond(let value):
            return "\(value)us"
        case .milliSecond(let value):
            return "\(value)ms"
        case .second(let value):
            return "\(value)s"
        case .minute(let value):
            return "\(value)m"
        case .hour(let value):
            return "\(value)h"
        }
    }
}

extension EvidenceParameters {
    // DefaultEvidenceParams Params returns a default EvidenceParams.
    static var `default`: EvidenceParameters {
        EvidenceParameters(
            maximumAgeNumberBlocks: StringRepresentedInt<Int64>(100000), // 27.8 hrs at 1block/s,
            maximumAgeDuration: StringRepresentedInt<Int64>(Int64(Time.hour(48).rawValue)), // 48 hours
            maxBytes: StringRepresentedInt<Int64>(1048576) // 1MB
        )
    }
}

// DefaultValidatorParams returns a default ValidatorParams, which allows
// only ed25519 pubkeys.
extension ValidatorParameters {
    static var `default`: ValidatorParameters {
        ValidatorParameters(publicKeyTypes: [.ed25519])
    }
}

extension VersionParameters {
    static var `default`: VersionParameters {
        VersionParameters(appVersion: 0)
    }
}

extension ConsensusParameters {
    // Validate validates the ConsensusParams to ensure all values are within their
    // allowed limits, and returns an error if they are not.
    func validate() throws {
        struct ValidationError: Error, CustomStringConvertible {
            let description: String
        }
        
        if Int64(block.maximumBytes) <= 0 {
            throw ValidationError(description: "block.MaxBytes must be greater than 0. Got \(block.maximumBytes)")
        }
        
        if Int64(block.maximumBytes) > Int64(Self.maximumBlockSizeBytes) {
            throw ValidationError(description: "block.MaxBytes is too big. \(block.maximumBytes) > \(Self.maximumBlockSizeBytes)")
        }

        if Int64(block.maximumGas) < -1 {
            throw ValidationError(description: "block.MaxGas must be greater or equal to -1. Got \(block.maximumGas)")
        }

        if Int64(evidence.maximumAgeNumberBlocks) <= 0 {
            throw ValidationError(description: "evidenceParams.MaxAgeNumBlocks must be greater than 0. Got \(evidence.maximumAgeNumberBlocks)")
        }

        if Int64(evidence.maximumAgeDuration) <= 0 {
            throw ValidationError(description: "evidenceParams.MaxAgeDuration must be grater than 0 if provided, Got \(evidence.maximumAgeDuration)")
        }
        
        if evidence.maxBytes > block.maximumBytes {
            throw ValidationError(description: "evidenceParams.maxBytesEvidence is greater than upper bound \(evidence.maxBytes) > \(block.maximumBytes)")
        }
        
        if Int64(evidence.maxBytes) < 0 {
            throw ValidationError(description: "evidenceParams.MaxBytes must be non negative. Got: \(evidence.maxBytes)")
        }

        if validator.publicKeyTypes.count == 0 {
            throw ValidationError(description: "len(Validator.PubKeyTypes) must be greater than 0")
        }
    }
}
