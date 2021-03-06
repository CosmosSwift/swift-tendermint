public struct RESTResponse<Payload: Codable>: Codable {
    public let id: Int // Can be -1 in the response
    public let result: Result<Payload, ErrorWrapper>
    
    enum CodingKeys: CodingKey {
        case jsonrpc
        case id
        case result
        case error
    }
    
    public func map<T: Codable>(_ f: (Payload) throws -> T) rethrows -> RESTResponse<T> {
        switch self.result {
        case let .success(payload):
            return RESTResponse<T>(id: id, result: .success(try f(payload)))
        case let .failure(error):
            return RESTResponse<T>(id: id, result: .failure(error))
        }
    }
}

extension RESTResponse {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let jsonrpc = try? container.decode(String.self, forKey: .jsonrpc), jsonrpc == RESTClient.jsonRpcVersion else {
            throw RESTRequestError.wrongJSONRPCVersion
        }
        self.id = try container.decode(Int.self, forKey: .id)
        if let result = try? container.decode(Payload.self, forKey: .result) {
            self.result = .success(result)
        } else if let error = try? container.decode(ErrorWrapper.self, forKey: .error) {
            self.result = .failure(error)
        } else {
            self.result = .failure(ErrorWrapper())
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(RESTClient.jsonRpcVersion, forKey: .jsonrpc)
        try container.encode(self.id, forKey: .id)
        switch self.result {
        case let .success(s):
            try container.encode(s, forKey: .result)
        case let .failure(f):
            try container.encode(f, forKey: .error)
        }
    }
}

//extension Result: Codable where Success: Codable, Failure == ErrorWrapper {
//    enum CodingKeys: CodingKey {
//        case success
//        case failure
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let success = try? container.decode(Success.self, forKey: .success) {
//            self = .success(success)
//            return
//        }
//        if let failure = try? container.decode(Failure.self, forKey: .failure) {
//            self = .failure(failure)
//            return
//        }
//
//        print("TOTO")
//
//        throw RESTRequestError.badPayload
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case let .success(success):
//            try container.encode(success, forKey: .success)
//        case let .failure(failure):
//            try container.encode(failure, forKey: .failure)
//        }
//    }
//}
