//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation

public struct Validator<PublicKey: PublicKeyProtocol>: Codable {
    public let address: Address
    public let publicKey: PublicKey
    public let votingPower: Int64
    public let proposerPriority: Int64
    
    enum CodingKeys: String, CodingKey {
        case address
        case publicKey = "pub_key"
        case votingPower = "voting_power"
        case proposerPriority = "proposer_priority"
    }
}
