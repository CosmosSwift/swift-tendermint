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
    var height: Height?
    let prove: Bool?
    
    public init(path: String, data: Payload) {
        self.path = path
        self.data = data
        self.height = nil
        self.prove = nil
    }
    
    public init(path: String, data: Payload, height: Height, prove: Bool) {
        self.path = path
        self.data = data
        self.height = height
        self.prove = prove
    }
    
    private init(path: String, data: Payload, height: Height?, prove: Bool?) {
        self.path = path
        self.data = data
        self.height = height
        self.prove = prove
    }
    
    internal func mapPayload<T: Codable>(_ f: (Payload) throws -> T) rethrows -> RESTABCIQueryParameters<T> {
        return RESTABCIQueryParameters<T>(path: path, data: try f(data), height: height, prove: prove)
    }
}

public struct RESTHeightParameters: Codable {
    var height: Height?
    
    public init(height: Height? = nil) {
        self.height = height
    }
}

public struct RESTBlockByHashParameters: Codable {
    let hash: Data
    
    public init(hash: Data) { self.hash = hash }
}

public struct RESTBlockchainInfoParameters: Codable {
    var minHeight: Height
    var maxHeight: Height
    
    public init(minHeight: Height, maxHeight: Height) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }
}

public struct RESTBroadcastEvidenceParameters<Evidence: EvidenceProtocol>: Codable {
    let evidence: Evidence // types.Evidence
    
    public init(evidence: Evidence) {
        self.evidence = evidence
    }
}

public struct RESTBroadcastTransactionParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case transaction = "tx"
    }
    
    public let transaction: TransactionBytes // types.Tx
    
    public init(transaction: TransactionBytes) {
        self.transaction = transaction
    }
}

public struct RESTSubscribeParameters: Codable {
    let query: String
    
    public init(query: String) {
        self.query = query
    }
}

public struct RESTTransactionParameters: Codable {
    let hash: Data
    let prove: Bool
    
    public init(hash: Data, prove: Bool) {
        self.hash = hash
        self.prove = prove
    }
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
    
    public init(query: String, prove: Bool, page: Never?, perPage: Int?, orderBy: String) {
        self.query = query
        self.prove = prove
        self.page = page
        self.perPage = perPage
        self.orderBy = orderBy
    }
}

public struct RESTUnconfirmedTransactionsParameters: Codable {
    let limit: Int?
    
    public init(limit: Int? = nil) {
        self.limit = limit
    }
}

public struct RESTUnsubscribeParameters: Codable {
    let query: String
    
    public init(query: String) {
        self.query = query
    }
}

public struct RESTValidatorsParameters: Codable {
    enum CodingKeys: String, CodingKey {
        case height
        case page
        case perPage = "per_page"
    }
    
    var height: Height?
    let page: Never?
    let perPage: Int?
    
    public init(height: Height?, page: Never?, perPage: Int?) {
        self.height = height
        self.page = page
        self.perPage = perPage
    }
}
