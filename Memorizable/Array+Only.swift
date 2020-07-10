//
//  Array+Only.swift
//  Memorizable
//
//  Created by Samuel Pinheiro Junior on 09/07/20.
//  Copyright © 2020 Samuel Pinheiro Junior. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
