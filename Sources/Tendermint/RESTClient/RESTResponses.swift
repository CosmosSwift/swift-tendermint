//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 05/03/2021.
//

import Foundation
import ABCIMessages

public struct ABCIInfoResponse: Codable {
    let response: ResponseInfo
}

public struct ABCIQueryResponse<Payload: Codable>: Codable {
    let response: ResponseQuery<Payload>
    
    func map<T: Codable>(_ f: (Payload) throws -> T) rethrows -> ABCIQueryResponse<T> {
        ABCIQueryResponse<T>(response: try response.mapPayload(f))
    }
}

public struct BlockResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case blockID = "block_id"
        case block
    }
    
    let blockID: Block.BlockID
    let block: Block
}

public struct BlockchainInfoResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case lastHeight = "last_height"
        case blockMetas = "block_metas"
    }
    
    let lastHeight: Int64
    let blockMetas: [BlockMeta]
}

public struct BlockResultsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case height
        case transactionResults = "txs_results"
        case beginBlockEvents = "begin_block_events"
        case endBlockEvents = "end_block_events"
        case validatorUpdates = "validator_updates"
        case consensusParameterUpdates = "consensus_param_updates"
    }
    
    let height: Int64
    let transactionResults: [ResponseDeliverTx]
    let beginBlockEvents: [Event]
    let endBlockEvents: [Event]
    let validatorUpdates: Never // []abci.ValidatorUpdate
    let consensusParameterUpdates: Never // *tmproto.ConsensusParams
}

public struct BroadcastEvidenceResponse: Codable {
    let hash: Data
}

public struct BroadcastTransactionResponse: Codable {
    let code: UInt32
    let data: Data // bytes.HexBytes
    let log: String
    let codespace: String // TODO: is this necessary?
    let hash: Data //bytes.HexBytes
}

public struct BroadcastTransactionCommitResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case checkTransaction = "check_tx"
        case deliverTransaction = "deliver_tx"
        case hash
        case height
    }
    
    let checkTransaction: ResponseCheckTx
    let deliverTransaction: ResponseDeliverTx
    let hash: Data // bytes.HexBytes
    let height: Int64
}

public struct CheckTransactionResponse: Codable {
    // this wraps abci.ResponseCheckTx by inheriting all it's properties
//    // ResultCheckTx wraps abci.ResponseCheckTx.
//    type ResultCheckTx struct {
//        abci.ResponseCheckTx
//    }
    let checkTransaction: ResponseCheckTx
}

public struct CommitResponse: Codable {
//    // Commit and Header
//    type ResultCommit struct {
//        types.SignedHeader `json:"signed_header"`
//    CanonicalCommit    bool `json:"canonical"`
//    }
    enum CodingKeys: String, CodingKey {
        case signedHeader = "signed_header"
        case canonicalCommit = "canonical"
    }
    
    let signedHeader: Never // not sure if this is a dedicated wrapping of SignedHeader or all Signedheader properties are inherited
    let canonicalCommit: Bool
}

public struct ConsensusParametersResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeight = "block_height"
        case consensusParameters = "consensus_params"
    }
    
    let blockHeight: Int64
    let consensusParameters: ConsensusParameters //types.ConsensusParams
}

public struct ConsensusStateResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case roundState = "round_state"
    }
    
    let roundState: Never // json.RawMessage
}

public struct DumpConsensusStateResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case roundState = "round_state"
        case peers
    }
    
    let roundState: Never // json.RawMessage
    let peers: [PeerStateInfo]
    
    public struct PeerStateInfo: Codable {
        enum CodingKeys: String, CodingKey {
            case nodeAddress = "node_address"
            case peerState = "peer_state"
        }
        
        let nodeAddress: String
        let peerState: Never // json.RawMessage
    }
}

public struct GenesisResponse<AppState: Codable>: Codable {
    let genesis: GenesisDocument<AppState> // types.GenesisDoc
}

public struct HealthResponse: Codable { /* Empty on purpose */ }

public struct NetInfoResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case listening
        case listeners
        case numberOfPeers = "n_peers"
        case peers
    }
    
    let listening: Bool
    let listeners: [String]
    let numberOfPeers: Int
    let peers: [Peer]
    
    public struct Peer: Codable {
        enum CodingKeys: String, CodingKey {
            case nodeInfo = "node_info"
            case isOutbound = "is_outbound"
            case connectionStatus = "connection_status"
            case remoteIP = "remote_ip"
        }
        
        let nodeInfo: Never // p2p.NodeInfo
        let isOutbound: Bool
        let connectionStatus: Never // p2p.ConnectionStatus
        let remoteIP: String
    }
}

// Node Status
public struct StatusResponse<PublicKey: PublicKeyProtocol>: Codable {
    enum CodingKeys: String, CodingKey {
        case nodeInfo = "node_info"
        case syncInfo = "sync_info"
        case validatorInfo = "validator_info"
    }
    
    let nodeInfo: Never // p2p.NodeInfo
    let syncInfo: SyncInfo
    let validatorInfo: ValidatorInfo<PublicKey>
    
    // Info about the node's syncing state
    public struct SyncInfo: Codable {
        enum CodingKeys: String, CodingKey {
            case latestBlockHash = "latest_block_hash"
            case latestAppHash = "latest_app_hash"
            case latestBlockHeight = "latest_block_height"
            case latestBlockTime = "latest_block_time"
            
            case earliestBlockHash = "earliest_block_hash"
            case earliestAppHash = "earliest_app_hash"
            case earliestBlockHeight = "earliest_block_height"
            case earliestBlockTime = "earliest_block_time"
            
            case catchingUp = "catching_up"
        }
        
        let latestBlockHash: Data // bytes.HexBytes
        let latestAppHash: Data // bytes.HexBytes
        let latestBlockHeight: Int64
        let latestBlockTime: Date // time.Time
        
        let earliestBlockHash: Data // bytes.HexBytes
        let earliestAppHash: Data // bytes.HexBytes
        let earliestBlockHeight: Int64
        let earliestBlockTime: Date // time.Time
        
        let catchingUp: Bool
    }
    
    // Info about the node's validator
    public struct ValidatorInfo<PublicKey: PublicKeyProtocol>: Codable {
        enum CodingKeys: String, CodingKey {
            case address
            case pubKey = "pub_key"
            case votingPower = "voting_power"
        }
        
        let address: Data // bytes.HexBytes
        let pubKey: PublicKey // crypto.PubKey
        let votingPower: Int64
    }
}

public struct SubscribeResponse: Codable { /* Empty on purpose */ }

public struct TransactionResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case hash
        case height
        case index
        case transactionResult = "tx_result"
        case transaction = "tx"
        case proof
    }
    
    let hash: Data // bytes.HexBytes
    let height: Int64
    let index: UInt32
    let transactionResult: ResponseDeliverTx
    let transaction: TransactionBytes // types.Tx
    let proof: Never // types.TxProof
}

public struct TransactionSearchResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case transactions = "txs"
        case totalCount = "total_count"
    }
    
    let transactions: [TransactionResponse]
    let totalCount: Int
}

public struct UnconfirmedTransactionsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case count = "n_txs"
        case total
        case totalBytes = "total_bytes"
        case transactions = "txs"
    }
    
    let count: Int
    let total: Int
    let totalBytes: Int64
    let transactions: [TransactionBytes] // []types.Tx
}

public struct UnsubscribeResponse: Codable { /* Empty on purpose */ }

public struct ValidatorsResponse<PublicKey: PublicKeyProtocol>: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeight = "block_height"
        case validators
        case count
        case total
    }
    
    let blockHeight: Int64
    let validators: [Validator<PublicKey>]
    let count: Int
    let total: Int
}
