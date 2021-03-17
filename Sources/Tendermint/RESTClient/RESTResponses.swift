//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 05/03/2021.
//

import Foundation
import ABCIMessages

public struct ABCIInfoResponse: Codable {
    public let response: ResponseInfo
}

public struct ABCIQueryResponse<Payload: Codable>: Codable {
    public let response: ResponseQuery<Payload>
    
    func map<T: Codable>(_ f: (Payload) throws -> T) rethrows -> ABCIQueryResponse<T> {
        ABCIQueryResponse<T>(response: try response.mapPayload(f))
    }
}

public struct BlockResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case blockID = "block_id"
        case block
    }
    
    public let blockID: Block.BlockID
    public let block: Block
}

public struct BlockchainInfoResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case lastHeight = "last_height"
        case blockMetas = "block_metas"
    }
    
    public let lastHeight: Int64
    public let blockMetas: [BlockMeta]
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
    
    public let height: Int64
    public let transactionResults: [ResponseDeliverTx]
    public let beginBlockEvents: [Event]
    public let endBlockEvents: [Event]
    public let validatorUpdates: Never // []abci.ValidatorUpdate
    public let consensusParameterUpdates: Never // *tmproto.ConsensusParams
}

public struct BroadcastEvidenceResponse: Codable {
    public let hash: Data
}

public struct BroadcastTransactionResponse: Codable {
    public let code: UInt32
    public let data: Data // bytes.HexBytes
    public let log: String
    public let codespace: String // TODO: is this necessary?
    public let hash: Data //bytes.HexBytes
}

public struct BroadcastTransactionCommitResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case checkTransaction = "check_tx"
        case deliverTransaction = "deliver_tx"
        case hash
        case height
    }
    
    public let checkTransaction: ResponseCheckTx
    public let deliverTransaction: ResponseDeliverTx
    public let hash: Data // bytes.HexBytes
    public let height: Int64
}

public struct CheckTransactionResponse: Codable {
    // this wraps abci.ResponseCheckTx by inheriting all it's properties
//    // ResultCheckTx wraps abci.ResponseCheckTx.
//    type ResultCheckTx struct {
//        abci.ResponseCheckTx
//    }
    public let checkTransaction: ResponseCheckTx
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
    
    public let signedHeader: Never // not sure if this is a dedicated wrapping of SignedHeader or all Signedheader properties are inherited
    public let canonicalCommit: Bool
}

public struct ConsensusParametersResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeight = "block_height"
        case consensusParameters = "consensus_params"
    }
    
    public let blockHeight: Int64
    public let consensusParameters: ConsensusParameters //types.ConsensusParams
}

public struct ConsensusStateResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case roundState = "round_state"
    }
    
    public let roundState: Never // json.RawMessage
}

public struct DumpConsensusStateResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case roundState = "round_state"
        case peers
    }
    
    public let roundState: Never // json.RawMessage
    public let peers: [PeerStateInfo]
    
    public struct PeerStateInfo: Codable {
        enum CodingKeys: String, CodingKey {
            case nodeAddress = "node_address"
            case peerState = "peer_state"
        }
        
        public let nodeAddress: String
        public let peerState: Never // json.RawMessage
    }
}

public struct GenesisResponse<AppState: Codable>: Codable {
    public let genesis: GenesisDocument<AppState> // types.GenesisDoc
}

public struct HealthResponse: Codable { /* Empty on purpose */ }

public struct NetInfoResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case listening
        case listeners
        case numberOfPeers = "n_peers"
        case peers
    }
    
    public let listening: Bool
    public let listeners: [String]
    public let numberOfPeers: Int
    public let peers: [Peer]
    
    public struct Peer: Codable {
        enum CodingKeys: String, CodingKey {
            case nodeInfo = "node_info"
            case isOutbound = "is_outbound"
            case connectionStatus = "connection_status"
            case remoteIP = "remote_ip"
        }
        
        public let nodeInfo: Never // p2p.NodeInfo
        public let isOutbound: Bool
        public let connectionStatus: Never // p2p.ConnectionStatus
        public let remoteIP: String
    }
}

// Node Status
public struct StatusResponse<PublicKey: PublicKeyProtocol>: Codable {
    enum CodingKeys: String, CodingKey {
        case nodeInfo = "node_info"
        case syncInfo = "sync_info"
        case validatorInfo = "validator_info"
    }
    
    public let nodeInfo: Never // p2p.NodeInfo
    public let syncInfo: SyncInfo
    public let validatorInfo: ValidatorInfo<PublicKey>
    
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
        
        public let latestBlockHash: Data // bytes.HexBytes
        public let latestAppHash: Data // bytes.HexBytes
        public let latestBlockHeight: Int64
        public let latestBlockTime: Date // time.Time

        public let earliestBlockHash: Data // bytes.HexBytes
        public let earliestAppHash: Data // bytes.HexBytes
        public let earliestBlockHeight: Int64
        public let earliestBlockTime: Date // time.Time
        
        public let catchingUp: Bool
    }
    
    // Info about the node's validator
    public struct ValidatorInfo<PublicKey: PublicKeyProtocol>: Codable {
        enum CodingKeys: String, CodingKey {
            case address
            case pubKey = "pub_key"
            case votingPower = "voting_power"
        }
        
        public let address: Data // bytes.HexBytes
        public let pubKey: PublicKey // crypto.PubKey
        public let votingPower: Int64
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
    
    public let hash: Data // bytes.HexBytes
    public let height: Int64
    public let index: UInt32
    public let transactionResult: ResponseDeliverTx
    public let transaction: TransactionBytes // types.Tx
    public let proof: Never // types.TxProof
}

public struct TransactionSearchResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case transactions = "txs"
        case totalCount = "total_count"
    }
    
    public let transactions: [TransactionResponse]
    public let totalCount: Int
}

public struct UnconfirmedTransactionsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case count = "n_txs"
        case total
        case totalBytes = "total_bytes"
        case transactions = "txs"
    }
    
    public let count: Int
    public let total: Int
    public let totalBytes: Int64
    public let transactions: [TransactionBytes] // []types.Tx
}

public struct UnsubscribeResponse: Codable { /* Empty on purpose */ }

public struct ValidatorsResponse<PublicKey: PublicKeyProtocol>: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeight = "block_height"
        case validators
        case count
        case total
    }
    
    public let blockHeight: Int64
    public let validators: [Validator<PublicKey>]
    public let count: Int
    public let total: Int
}
