//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation

// BlockMeta contains meta information.
struct BlockMeta: Codable {
    let blockID: Block.BlockID
    let blockSize: Int
    let header: Block.Header
    let numberOfTransactions: Int
    
    enum CodingKeys: String, CodingKey {
        case blockID = "block_id"
        case blockSize = "block_size"
        case header
        case numberOfTransactions = "num_txs"
    }
}
