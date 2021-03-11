//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 01/03/2021.
//

import Foundation
import AsyncHTTPClient
import NIO
import NIOHTTP1

public struct RESTClient {
    let url: String
    let client: HTTPClient
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    
    public init(url: String, httpClient: HTTPClient) {
        self.url = url
        self.client = httpClient
    }
    
    public static let jsonRpcVersion = "2.0"
    public static let httpClientType = "Swift ABCI Http client"
    
    private static var _id: Int = 0
    
    public static var nextId: Int {
        #warning("This is not thread safe.")
        self._id = self._id + 1
        return _id
    }
}

extension RESTClient {
    public func abciInfo(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<ABCIInfoResponse>> {
        struct RESTABCIInfoParameters: Codable { }
        let payload = RESTRequest(id: id, method: .abciInfo, params: RESTABCIInfoParameters())
        return self.sendRequest(payload: payload)
    }
    
    private func abciQuery(parameters: RESTABCIQueryParameters<Data>, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<ABCIQueryResponse<Data>>> {
        let payload = RESTRequest(id: id, method: .abciQuery, params: parameters)
        return self.sendRequest(payload: payload)
    }
    
    public func abciQueryMapToData<ParameterPayload, ResponsePayload>(parameters: RESTABCIQueryParameters<ParameterPayload>, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<ABCIQueryResponse<ResponsePayload>>> {
        let dataParameters: RESTABCIQueryParameters<Data>
        do {
            dataParameters = try parameters.mapPayload { (payload) throws -> Data in
                #warning("might have to do some hexstring encoding here?")
                return try jsonEncoder.encode(payload)
            }
        } catch {
            return client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return abciQuery(parameters: dataParameters, id: id).flatMap { response in
            do {
                let decodedResponse = try response.map { queryResponse in
                    try queryResponse.map { data -> ResponsePayload in
                        #warning("might have to do some base64 decoding here?")
                        return try jsonDecoder.decode(ResponsePayload.self, from: data)
                    }
                }
                return client.eventLoopGroup.next().makeSucceededFuture(decodedResponse)
            } catch {
                return self.client.eventLoopGroup.next().makeFailedFuture(error)
            }
        }
    }
    
    #warning("Where should this live?")
    /*public func abciQuery(parameters: ABCIQueryParameters<GetAccountPayload>) -> EventLoopFuture<RESTResponse<ABCIQueryResponse2<Account>>> {
        return abciQueryMapToData(id: id, parameters: parameters)
    }*/
    
    public func block(params: RESTBlockParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BlockResponse>> {
        let payload = RESTRequest(id: id, method: .block, params: params)
        return self.sendRequest(payload: payload)
    }

    public func blockByHash(params: RESTBlockByHashParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BlockResponse>> {
        let payload = RESTRequest(id: id, method: .blockByHash, params: params)
        return self.sendRequest(payload: payload)
    }

    public func blockchainInfo(params: RESTBlockchainInfoParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BlockchainInfoResponse>> {
        let payload = RESTRequest(id: id, method: .blockchain, params: params)
        return self.sendRequest(payload: payload)
    }

    public func blockResults(params: RESTBlockResultsParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BlockResultsResponse>> {
        let payload = RESTRequest(id: id, method: .blockResults, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastEvidence<Evidence: EvidenceProtocol>(params: RESTBroadcastEvidenceParameters<Evidence>, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BroadcastEvidenceResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastEvidence, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastTransactionAsync(params: RESTBroadcastTransactionParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BroadcastTransactionResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastTransactionAsync, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastTransactionCommit(params: RESTBroadcastTransactionParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BroadcastTransactionCommitResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastTransactionCommit, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastTransactionSync(params: RESTBroadcastTransactionParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<BroadcastTransactionResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastTransactionSync, params: params)
        return self.sendRequest(payload: payload)
    }

    public func checkTransaction(params: RESTBroadcastTransactionParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<CheckTransactionResponse>> {
        let payload = RESTRequest(id: id, method: .checkTransaction, params: params)
        return self.sendRequest(payload: payload)
    }

    public func commit(params: RESTCommitParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<CommitResponse>> {
        let payload = RESTRequest(id: id, method: .commit, params: params)
        return self.sendRequest(payload: payload)
    }

    public func consensusParameters(params: RESTConsensusParametersParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<ConsensusParametersResponse>> {
        let payload = RESTRequest(id: id, method: .consensusParameters, params: params)
        return self.sendRequest(payload: payload)
    }

    public func consensusState(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<ConsensusStateResponse>> {
        struct RESTConsensusStateParameters: Codable { }
        let payload = RESTRequest(id: id, method: .consensusState, params: RESTConsensusStateParameters())
        return self.sendRequest(payload: payload)
    }

    public func dumpConsensusState(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<DumpConsensusStateResponse>> {
        struct RESTDumpConsensusStateParameters: Codable { }
        let payload = RESTRequest(id: id, method: .dumpConsensusState, params: RESTDumpConsensusStateParameters())
        return self.sendRequest(payload: payload)
    }
    
    private struct RESTGenesisParameters: Codable { }
    public func genesis<AppState>(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<GenesisResponse<AppState>>> {
        let payload = RESTRequest(id: id, method: .genesis, params: RESTGenesisParameters())
        return self.sendRequest(payload: payload)
    }

    public func health(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<HealthResponse>> {
        struct RESTHealthParameters: Codable { }
        let payload = RESTRequest(id: id, method: .health, params: RESTHealthParameters())
        return self.sendRequest(payload: payload)
    }

    public func netInfo(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<NetInfoResponse>> {
        struct RESTNetInfoParameters: Codable { }
        let payload = RESTRequest(id: id, method: .netInfo, params: RESTNetInfoParameters())
        return self.sendRequest(payload: payload)
    }

    public func numUnconfirmedTransactions(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<UnconfirmedTransactionsResponse>> {
        struct RESTNumUnconfirmedTransactionsParameters: Codable { }
        let payload = RESTRequest(id: id, method: .numUnconfirmedTransactions, params: RESTNumUnconfirmedTransactionsParameters())
        return self.sendRequest(payload: payload)
    }

    private struct RESTStatusParameters: Codable { }
    public func status<PublicKey: PublicKeyProtocol>(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<StatusResponse<PublicKey>>> {
        let payload = RESTRequest(id: id, method: .status, params: RESTStatusParameters())
        return self.sendRequest(payload: payload)
    }

    public func subscribe(params: RESTSubscribeParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<SubscribeResponse>> {
        let payload = RESTRequest(id: id, method: .subscribe, params: params)
        return self.sendRequest(payload: payload)
    }

    public func transaction(params: RESTTransactionParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<TransactionResponse>> {
        let payload = RESTRequest(id: id, method: .transaction, params: params)
        return self.sendRequest(payload: payload)
    }

    public func transactionSearch(params: RESTTransactionSearchParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<TransactionSearchResponse>> {
        let payload = RESTRequest(id: id, method: .transactionSearch, params: params)
        return self.sendRequest(payload: payload)
    }

    public func unconfirmedTransactions(params: RESTUnconfirmedTransactionsParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<UnconfirmedTransactionsResponse>> {
        let payload = RESTRequest(id: id, method: .unconfirmedTransactions, params: params)
        return self.sendRequest(payload: payload)
    }
    
    public func unsubscribe(params: RESTUnsubscribeParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<UnsubscribeResponse>> {
        let payload = RESTRequest(id: id, method: .unsubscribe, params: params)
        return self.sendRequest(payload: payload)
    }

    public func unsubscribeAll(id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<UnsubscribeResponse>> {
        struct RESTUnsubscribeAllParameters: Codable { }
        let payload = RESTRequest(id: id, method: .unsubscribeAll, params: RESTUnsubscribeAllParameters())
        return self.sendRequest(payload: payload)
    }

    public func validators<PublicKey: PublicKeyProtocol>(params: RESTValidatorsParameters, id: Int = RESTClient.nextId) -> EventLoopFuture<RESTResponse<ValidatorsResponse<PublicKey>>> {
        let payload = RESTRequest(id: id, method: .validators, params: params)
        return self.sendRequest(payload: payload)
    }
}

extension RESTClient {
    func sendRequest<RequestPayload: Codable, ResponsePayload: Codable>(payload: RESTRequest<RequestPayload>) -> EventLoopFuture<RESTResponse<ResponsePayload>> {
        
        var headers: HTTPHeaders = [
            "User-Agent": RESTClient.httpClientType,
            "Content-Type": "text/json"
        ]
        headers.forEach { headers.replaceOrAdd(name: $0.name, value: $0.value) }
        
        do {
            guard let data = try? jsonEncoder.encode(payload) else {
                throw RESTRequestError.badRequest
            }
            
            let bodyString = String(data: data, encoding: .utf8) ?? ""
            
            let request = try HTTPClient.Request(url: url, method: .POST, headers: headers, body: .string(bodyString))
            
            return client.execute(request: request).flatMap { response in
                do {
                    guard let byteBuffer = response.body else {
                        throw RESTRequestError.badResponse
                    }
                    let responseData = Data(byteBuffer.readableBytesView)
                    
                    guard response.status == .ok else {
                        // decode some error for now throw error
                        //return self.client.eventLoopGroup.next().makeFailedFuture(jsonDecoder.decode(errorType, from: responseData))
                        throw RESTRequestError.badRequest
                    }
                    return client.eventLoopGroup.next().makeSucceededFuture(try jsonDecoder.decode(RESTResponse<ResponsePayload>.self, from: responseData))
                } catch {
                    return client.eventLoopGroup.next().makeFailedFuture(error)
                }
            }
        } catch {
            return client.eventLoopGroup.next().makeFailedFuture(error)
        }
    }
}
