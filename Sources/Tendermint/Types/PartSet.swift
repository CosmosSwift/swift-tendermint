//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation

struct Part: Codable {
    let index: UInt32
    let bytes: Data // tmbytes.HexBytes
    let proof: Never // crypto.MerkleProof
}

struct PartSetHeader: Codable {
    let total: UInt32
    let hash: Data // tmbytes.HexBytes
}

struct PartSet {
    let total: UInt32
    let hash: Data
    let mtx: Never
    let parts: [Part]
    let partsBitArray: Never // *bits.BitArray
    let count: UInt32
    let byteSize: Int64
}
