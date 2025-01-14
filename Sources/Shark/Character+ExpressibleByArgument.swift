//
//  File.swift
//  File
//
//  Created by Kaan Dedeoglu on 24.08.21.
//

import ArgumentParser

extension Character: ExpressibleByArgument {
    public init?(argument: String) {
        guard argument.count == 1 else {
            return nil
        }
        self = argument.first!
    }
}
