//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 05/03/2021.
//

import Foundation
import ABCIMessages

public struct ABCIQueryParameters<Payload: Codable>: Codable {
    let path: String
    let data: Payload // bytes.HexBytes
    let height: Int64?
    let prove: Bool?
    
    public init(path: String, data: Payload) {
        self.path = path
        self.data = data
        self.height = nil
        self.prove = nil
    }
    
    public init(path: String, data: Payload, height: Int64, prove: Bool) {
        self.path = path
        self.data = data
        self.height = height
        self.prove = prove
    }
    
    private init(path: String, data: Payload, height: Int64?, prove: Bool?) {
        self.path = path
        self.data = data
        self.height = height
        self.prove = prove
    }
    
    internal func mapPayload<T: Codable>(_ f: (Payload) throws -> T) rethrows -> ABCIQueryParameters<T> {
        return ABCIQueryParameters<T>(path: path, data: try f(data), height: height, prove: prove)
    }
}

public struct BlockParameters: Codable {
    let height: Int64?
}

public struct BlockByHashParameters: Codable {
    let hash: Data
}

public struct BlockchainInfoParameters: Codable {
    let minHeight: Int64
    let maxHeight: Int64
}

public struct BlockResultsParameters: Codable {
    let height: Int64?
}

public protocol EvidenceProtocol: Codable {
    func abci() -> ABCIMessages.Evidence
    func data() -> Data
    func hash() -> Data
    func height() -> Int64
    func string() -> String
    func time() -> Date
    func validateBasic() -> Error
}

public struct BroadcastEvidenceParameters<Evidence: EvidenceProtocol>: Codable {
    let evidence: Evidence // types.Evidence
}

public struct BroadcastTransactionParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case transaction = "tx"
    }
    
    let transaction: Never // types.Tx
}

public struct BroadcastTransactionCommitParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case transaction = "tx"
    }
    let transaction: Never // types.Tx
}

public struct CheckTransactionParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case transaction = "tx"
    }
    let transaction: Never // types.Tx
}

public struct CommitParameters: Codable {
    let height: Int64?
}

public struct ConsensusParametersParameters: Codable {
    let height: Int?
}

public struct SubscribeParameters: Codable {
    let query: String
}

public struct TransactionParameters: Codable {
    let hash: Data
    let prove: Bool
}

public struct TransactionSearchParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case query = "query"
        case prove = "prove"
        case page = "page"
        case perPage = "perPage"
        case orderBy = "order_by"
    }
    
    let query: String
    let prove: Bool
    let page: Never?
    let perPage: Int?
    let orderBy: String
}

public struct UnconfirmedTransactionsParameters: Codable {
    let limit: Int?
}

public struct UnsubscribeParameters: Codable {
    let query: String
}

public struct ValidatorsParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case page = "page"
        case perPage = "per_page"
    }
    
    let height: Int64?
    let page: Never?
    let perPage: Int?
}
