//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 05/03/2021.
//

import Foundation
import ABCIMessages

public struct RESTABCIQueryParameters<Payload: Codable>: Codable {
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
    
    internal func mapPayload<T: Codable>(_ f: (Payload) throws -> T) rethrows -> RESTABCIQueryParameters<T> {
        return RESTABCIQueryParameters<T>(path: path, data: try f(data), height: height, prove: prove)
    }
}

public struct RESTBlockParameters: Codable {
    let height: Int64?
}

public struct RESTBlockByHashParameters: Codable {
    let hash: Data
}

public struct RESTBlockchainInfoParameters: Codable {
    let minHeight: Int64
    let maxHeight: Int64
}

public struct RESTBlockResultsParameters: Codable {
    let height: Int64?
}

public struct RESTBroadcastEvidenceParameters<Evidence: EvidenceProtocol>: Codable {
    let evidence: Evidence // types.Evidence
}


public struct RESTBroadcastTransactionParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case transaction = "tx"
    }
    
    let transaction: TransactionBytes // types.Tx
}

public struct RESTCommitParameters: Codable {
    let height: Int64?
}

public struct RESTConsensusParametersParameters: Codable {
    let height: Int?
}

public struct RESTSubscribeParameters: Codable {
    let query: String
}

public struct RESTTransactionParameters: Codable {
    let hash: Data
    let prove: Bool
}

public struct RESTTransactionSearchParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case query
        case prove
        case page
        case perPage
        case orderBy = "order_by"
    }
    
    let query: String
    let prove: Bool
    let page: Never?
    let perPage: Int?
    let orderBy: String
}

public struct RESTUnconfirmedTransactionsParameters: Codable {
    let limit: Int?
}

public struct RESTUnsubscribeParameters: Codable {
    let query: String
}

public struct RESTValidatorsParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case height
        case page
        case perPage = "per_page"
    }
    
    let height: Int64?
    let page: Never?
    let perPage: Int?
}
