
import Foundation
import ABCIMessages

public struct Validator<PublicKey: PublicKeyProtocol>: Codable {
    public let address: Address
    public let publicKey: PublicKey
    @StringBackedInt public var votingPower: Int64
    @StringBackedInt public var proposerPriority: Int64
    
    enum CodingKeys: String, CodingKey {
        case address
        case publicKey = "pub_key"
        case votingPower = "voting_power"
        case proposerPriority = "proposer_priority"
    }
}
