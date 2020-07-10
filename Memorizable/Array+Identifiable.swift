//
//  Array+Identifiable.swift
//  Memorizable
//
//  Created by Samuel Pinheiro Junior on 09/07/20.
//  Copyright © 2020 Samuel Pinheiro Junior. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
