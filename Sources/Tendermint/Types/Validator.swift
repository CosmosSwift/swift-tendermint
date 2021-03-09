//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation

struct Validator<PublicKey: PublicKeyProtocol>: Codable {
    let address: Address
    let publicKey: PublicKey
    let votingPower: Int64
    let proposerPriority: Int64
    
    enum CodingKeys: String, CodingKey {
        case address
        case publicKey = "pub_key"
        case votingPower = "voting_power"
        case proposerPriority = "proposer_priority"
    }
}
