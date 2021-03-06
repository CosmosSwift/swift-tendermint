import Foundation
import ABCIMessages

extension RequestQuery {
    internal func mapPayload<T: Codable>(_ f: (Payload) throws -> T) rethrows -> RequestQuery<T> {
        return RequestQuery<T>(path: path, data: try f(data), height: height, prove: prove)
    }
}

public struct RESTHeightParameters: Codable {
    @OptionalStringBackedInt var height: Int64?
    
    public init(height: Int64? = nil) {
        self.height = height
    }
}

public struct RESTBlockByHashParameters: Codable {
    let hash: Data
    
    public init(hash: Data) { self.hash = hash }
}

public struct RESTBlockchainInfoParameters: Codable {
    @StringBackedInt var minHeight: Int64
    @StringBackedInt var maxHeight: Int64
    
    public init(minHeight: Int64, maxHeight: Int64) {
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
    
    @OptionalStringBackedInt var height: Int64?
    let page: Never?
    let perPage: Int?
    
    public init(height: Int64?, page: Never?, perPage: Int?) {
        self.height = height
        self.page = page
        self.perPage = perPage
    }
}
