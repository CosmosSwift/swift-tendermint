//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation

// BlockMeta contains meta information.
public struct BlockMeta: Codable {
    public let blockID: Block.BlockID
    public let blockSize: Int
    public let header: Block.Header
    public let numberOfTransactions: Int
    
    enum CodingKeys: String, CodingKey {
        case blockID = "block_id"
        case blockSize = "block_size"
        case header
        case numberOfTransactions = "num_txs"
    }
}
