import Foundation
import ABCIMessages

// Block defines the atomic unit of a Tendermint blockchain.
public struct Block: Codable {
    enum CodingKeys: String, CodingKey {
        case header
        case data
        case evidence
        case lastCommit = "last_commit"
    }
    
    public let mtx: Never? = nil // tmsync.Mutex
    public let header: Header
    public let data: BlockData
    public let evidence: EvidenceData
    public let lastCommit: Commit
    
//    // Block defines the atomic unit of a Tendermint blockchain.
//    type Block struct {
//        mtx tmsync.Mutex
//
//        Header     `json:"header"`
//        Data       `json:"data"`
//        Evidence   EvidenceData `json:"evidence"`
//        LastCommit *Commit      `json:"last_commit"`
//    }
    
    
    public struct Header: Codable {
        public let version: Never
        public let chainID: String
        public var height: Height
        public let time: Date
        
        public let lastBlockID: BlockID
        
        // hashes of block data
        public let lastCommitHash: Data // tmbytes.HexBytes
        public let dataHash: Data // tmbytes.HexBytes
        
        // hashes from the app output from the prev block
        public let validatorsHash: Data // tmbytes.HexBytes
        public let nextValidatorsHash: Data // tmbytes.HexBytes
        public let consensusHash: Data // tmbytes.HexBytes
        public let appHash: Data // tmbytes.HexBytes
        
        // root hash of all results from the txs from the previous block
        public let lastResultsHash: Data // tmbytes.HexBytes
         
        // consensus info
        public let evidenceHash: Data // tmbytes.HexBytes
        public let proposerAddress: Address
        
        enum CodingKeys: String, CodingKey {
            case version
            case chainID = "chain_id"
            case height
            case time
            case lastBlockID = "last_block_id"
            case lastCommitHash = "last_commit_hash"
            case dataHash = "data_hash"
            case validatorsHash = "validators_hash"
            case nextValidatorsHash = "next_validators_hash"
            case consensusHash = "consensus_hash"
            case appHash = "app_hash"
            case lastResultsHash = "last_results_hash"
            case evidenceHash = "evidence_hash"
            case proposerAddress = "proposer_address"
        }
    }
    
    public typealias BlockIDFlag = UInt8
    
    // CommitSig is a part of the Vote included in a Commit.
    public struct CommitSignature: Codable {
        public let blockIDFlag: BlockIDFlag
        public let validatorAddress: Address
        public let timestamp: Date
        public let signature: Data
        
        enum CodingKeys: String, CodingKey {
            case blockIDFlag = "block_id_flag"
            case validatorAddress = "validator_address"
            case timestamp
            case signature
        }
    }

    // Commit contains the evidence that a block was committed by a set of validators.
    // NOTE: Commit is empty for height 1, but never nil.
    public struct Commit: Codable {
        public var height: Height
        public let round: Int32
        public let blockID: Never
        public let signatures: [CommitSignature]
        public let hash: Data? = nil //tmbytes.HexBytes,    no json? optional and default value set to nil in order to compile
        public let bitArray: Never? = nil //*bits.BitArray, no json? optional and default value set to nil in order to compile
        
        enum CodingKeys: String, CodingKey {
            case height
            case round
            case blockID = "block_id"
            case signatures
        }
    }

    public struct BlockData: Codable {
        public let transactions: Never // Txs // type Txs []Tx
        public let hash: Data? = nil // tmbytes.HexBytes, no json? optional and default value set to nil in order to compile
        
        enum CodingKeys: String, CodingKey {
            case transactions = "txs"
        }
    }
    
    public struct EvidenceData: Codable {
        public let evidence: [Never] // probably need to do some type erasure using something like AnyEvidence, that or generic over Evidence: EvidenceProtocol
        public let hash: Data // tmbytes.HexBytes
    }
    
    public struct BlockID: Codable {
        public let hash: Data //tmbytes.HexBytes
        public let partSetHeader: PartSetHeader
        
        enum CodingKeys: String, CodingKey {
            case hash
            case partSetHeader = "parts"
        }
    }
}

    
