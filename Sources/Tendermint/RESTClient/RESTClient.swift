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
}

extension RESTClient {
    public func abciInfo(id: Int) -> EventLoopFuture<RESTResponse<ABCIInfoResponse>> {
        struct RESTABCIInfoParameters: Codable { }
        let payload = RESTRequest(id: id, method: .abciInfo, params: RESTABCIInfoParameters())
        return self.sendRequest(payload: payload)
    }
    
    private func abciQuery(id: Int, parameters: RESTABCIQueryParameters<Data>) -> EventLoopFuture<RESTResponse<ABCIQueryResponse<Data>>> {
        let payload = RESTRequest(id: id, method: .abciQuery, params: parameters)
        return self.sendRequest(payload: payload)
    }
    
    private func abciQueryMapToData<ParameterPayload, ResponsePayload>(id: Int, parameters: RESTABCIQueryParameters<ParameterPayload>) -> EventLoopFuture<RESTResponse<ABCIQueryResponse<ResponsePayload>>> {
        let dataParameters: RESTABCIQueryParameters<Data>
        do {
            dataParameters = try parameters.mapPayload { (payload) throws -> Data in
                #warning("might have to do some hexstring encoding here?")
                return try jsonEncoder.encode(payload)
            }
        } catch {
            return client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return abciQuery(id: id, parameters: dataParameters).flatMap { response in
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
    
    /*public func abciQuery(id: Int, parameters: ABCIQueryParameters<GetAccountPayload>) -> EventLoopFuture<RESTResponse<ABCIQueryResponse2<Account>>> {
        return abciQueryMapToData(id: id, parameters: parameters)
    }*/
    
    public func block(id: Int, params: RESTBlockParameters) -> EventLoopFuture<RESTResponse<BlockResponse>> {
        let payload = RESTRequest(id: id, method: .block, params: params)
        return self.sendRequest(payload: payload)
    }

    public func blockByHash(id: Int, params: RESTBlockByHashParameters) -> EventLoopFuture<RESTResponse<BlockResponse>> {
        let payload = RESTRequest(id: id, method: .blockByHash, params: params)
        return self.sendRequest(payload: payload)
    }

    public func blockchainInfo(id: Int, params: RESTBlockchainInfoParameters) -> EventLoopFuture<RESTResponse<BlockchainInfoResponse>> {
        let payload = RESTRequest(id: id, method: .blockchain, params: params)
        return self.sendRequest(payload: payload)
    }

    public func blockResults(id: Int, params: RESTBlockResultsParameters) -> EventLoopFuture<RESTResponse<BlockResultsResponse>> {
        let payload = RESTRequest(id: id, method: .blockResults, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastEvidence<Evidence: EvidenceProtocol>(id: Int, params: RESTBroadcastEvidenceParameters<Evidence>) -> EventLoopFuture<RESTResponse<BroadcastEvidenceResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastEvidence, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastTransactionAsync(id: Int, params: RESTBroadcastTransactionParameters) -> EventLoopFuture<RESTResponse<BroadcastTransactionResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastTransactionAsync, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastTransactionCommit(id: Int, params: RESTBroadcastTransactionCommitParameters) -> EventLoopFuture<RESTResponse<BroadcastTransactionCommitResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastTransactionCommit, params: params)
        return self.sendRequest(payload: payload)
    }

    public func broadcastTransactionSync(id: Int, params: RESTBroadcastTransactionParameters) -> EventLoopFuture<RESTResponse<BroadcastTransactionResponse>> {
        let payload = RESTRequest(id: id, method: .broadcastTransactionSync, params: params)
        return self.sendRequest(payload: payload)
    }

    public func checkTransaction(id: Int, params: RESTCheckTransactionParameters) -> EventLoopFuture<RESTResponse<CheckTransactionResponse>> {
        let payload = RESTRequest(id: id, method: .checkTransaction, params: params)
        return self.sendRequest(payload: payload)
    }

    public func commit(id: Int, params: RESTCommitParameters) -> EventLoopFuture<RESTResponse<CommitResponse>> {
        let payload = RESTRequest(id: id, method: .commit, params: params)
        return self.sendRequest(payload: payload)
    }

    public func consensusParameters(id: Int, params: RESTConsensusParametersParameters) -> EventLoopFuture<RESTResponse<ConsensusParametersResponse>> {
        let payload = RESTRequest(id: id, method: .consensusParameters, params: params)
        return self.sendRequest(payload: payload)
    }

    public func consensusState(id: Int) -> EventLoopFuture<RESTResponse<ConsensusStateResponse>> {
        struct RESTConsensusStateParameters: Codable { }
        let payload = RESTRequest(id: id, method: .consensusState, params: RESTConsensusStateParameters())
        return self.sendRequest(payload: payload)
    }

    public func dumpConsensusState(id: Int) -> EventLoopFuture<RESTResponse<DumpConsensusStateResponse>> {
        struct RESTDumpConsensusStateParameters: Codable { }
        let payload = RESTRequest(id: id, method: .dumpConsensusState, params: RESTDumpConsensusStateParameters())
        return self.sendRequest(payload: payload)
    }

    public func genesis(id: Int) -> EventLoopFuture<RESTResponse<GenesisResponse>> {
        struct RESTGenesisParameters: Codable { }
        let payload = RESTRequest(id: id, method: .genesis, params: RESTGenesisParameters())
        return self.sendRequest(payload: payload)
    }

    public func health(id: Int) -> EventLoopFuture<RESTResponse<HealthResponse>> {
        struct RESTHealthParameters: Codable { }
        let payload = RESTRequest(id: id, method: .health, params: RESTHealthParameters())
        return self.sendRequest(payload: payload)
    }

    public func netInfo(id: Int) -> EventLoopFuture<RESTResponse<NetInfoResponse>> {
        struct RESTNetInfoParameters: Codable { }
        let payload = RESTRequest(id: id, method: .netInfo, params: RESTNetInfoParameters())
        return self.sendRequest(payload: payload)
    }

    public func numUnconfirmedTransactions(id: Int) -> EventLoopFuture<RESTResponse<UnconfirmedTransactionsResponse>> {
        struct RESTNumUnconfirmedTransactionsParameters: Codable { }
        let payload = RESTRequest(id: id, method: .numUnconfirmedTransactions, params: RESTNumUnconfirmedTransactionsParameters())
        return self.sendRequest(payload: payload)
    }

    public func status(id: Int) -> EventLoopFuture<RESTResponse<StatusResponse>> {
        struct RESTStatusParameters: Codable { }
        let payload = RESTRequest(id: id, method: .status, params: RESTStatusParameters())
        return self.sendRequest(payload: payload)
    }

    public func subscribe(id: Int, params: RESTSubscribeParameters) -> EventLoopFuture<RESTResponse<SubscribeResponse>> {
        let payload = RESTRequest(id: id, method: .subscribe, params: params)
        return self.sendRequest(payload: payload)
    }

    public func transaction(id: Int, params: RESTTransactionParameters) -> EventLoopFuture<RESTResponse<TransactionResponse>> {
        let payload = RESTRequest(id: id, method: .transaction, params: params)
        return self.sendRequest(payload: payload)
    }

    public func transactionSearch(id: Int, params: RESTTransactionSearchParameters) -> EventLoopFuture<RESTResponse<TransactionSearchResponse>> {
        let payload = RESTRequest(id: id, method: .transactionSearch, params: params)
        return self.sendRequest(payload: payload)
    }

    public func unconfirmedTransactions(id: Int, params: RESTUnconfirmedTransactionsParameters) -> EventLoopFuture<RESTResponse<UnconfirmedTransactionsResponse>> {
        let payload = RESTRequest(id: id, method: .unconfirmedTransactions, params: params)
        return self.sendRequest(payload: payload)
    }
    
    public func unsubscribe(id: Int, params: RESTUnsubscribeParameters) -> EventLoopFuture<RESTResponse<UnsubscribeResponse>> {
        let payload = RESTRequest(id: id, method: .unsubscribe, params: params)
        return self.sendRequest(payload: payload)
    }

    public func unsubscribeAll(id: Int) -> EventLoopFuture<RESTResponse<UnsubscribeResponse>> {
        struct RESTUnsubscribeAllParameters: Codable { }
        let payload = RESTRequest(id: id, method: .unsubscribeAll, params: RESTUnsubscribeAllParameters())
        return self.sendRequest(payload: payload)
    }

    public func validators(id: Int, params: RESTValidatorsParameters) -> EventLoopFuture<RESTResponse<ValidatorsResponse>> {
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
