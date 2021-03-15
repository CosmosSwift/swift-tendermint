//
//  File.swift
//  
//
//  Created by Jaap Wijnen on 09/03/2021.
//

import Foundation


public typealias TransactionBytes = Data

extension TransactionBytes {
    var data: Data {
        self
    }
    
    var hash: Data {
        Hash.sum(data: self.data)
    }
}
