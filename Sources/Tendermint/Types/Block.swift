//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation

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
        // Header defines the structure of a Tendermint block header.
        // NOTE: changes to the Header should be duplicated in:
        // - header.Hash()
        // - abci.Header
        // - https://github.com/tendermint/spec/blob/master/spec/blockchain/blockchain.md
    //    type Header struct {
    //        // basic block info
    //        Version tmversion.Consensus `json:"version"`
    //        ChainID string              `json:"chain_id"`
    //        Height  int64               `json:"height"`
    //        Time    time.Time           `json:"time"`
    //
    //        // prev block info
    //        LastBlockID BlockID `json:"last_block_id"`
    //
    //        // hashes of block data
    //        LastCommitHash tmbytes.HexBytes `json:"last_commit_hash"` // commit from validators from the last block
    //        DataHash       tmbytes.HexBytes `json:"data_hash"`        // transactions
    //
    //        // hashes from the app output from the prev block
    //        ValidatorsHash     tmbytes.HexBytes `json:"validators_hash"`      // validators for the current block
    //        NextValidatorsHash tmbytes.HexBytes `json:"next_validators_hash"` // validators for the next block
    //        ConsensusHash      tmbytes.HexBytes `json:"consensus_hash"`       // consensus params for current block
    //        AppHash            tmbytes.HexBytes `json:"app_hash"`             // state after txs from the previous block
    //        // root hash of all results from the txs from the previous block
    //        LastResultsHash tmbytes.HexBytes `json:"last_results_hash"`
    //
    //        // consensus info
    //        EvidenceHash    tmbytes.HexBytes `json:"evidence_hash"`    // evidence included in the block
    //        ProposerAddress Address          `json:"proposer_address"` // original proposer of the block
    //    }
        
        let toBeImplemented: Never

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
        public let height: Int64
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

    
