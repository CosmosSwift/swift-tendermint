//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation


public typealias TransactionBytes = Data

extension TransactionBytes {
    public var data: Data {
        self
    }
    
    public var hash: Data {
        Hash.sum(data: self.data)
    }
}
