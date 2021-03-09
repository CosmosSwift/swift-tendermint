//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation
import ABCIMessages

public protocol EvidenceProtocol: Codable {
    func abci() -> ABCIMessages.Evidence
    func data() -> Data
    func hash() -> Data
    func height() -> Int64
    func string() -> String
    func time() -> Date
    func validateBasic() -> Error
}
