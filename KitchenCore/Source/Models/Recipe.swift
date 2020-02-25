//
//  Recipe.swift
//  KitchenCore
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation

public struct Recipe: Hashable, Codable, Identifiable {

    /// Used to store the encoded `CKRecord.ID` so that local records can be matched with
    /// records on the server. This ensures updates don't cause duplication of records.
    var ckData: Data? = nil

    public let id: String
    public let createdAt: Date
    public let title: String
    public let subtitle: String
    public let ingredients: [String]
    public let instructions: String
    public let image: Data?

    public init(title: String,
                subtitle: String,
                ingredients: [String],
                instructions: String,
                image: Data? = nil)
    {
        self.id = UUID().uuidString
        self.createdAt = Date()
        self.title = title
        self.subtitle = subtitle
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
    }

    public init(id: String,
                createdAt: Date,
                title: String,
                subtitle: String,
                ingredients: [String],
                instructions: String,
                image: Data? = nil)
    {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.subtitle = subtitle
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
    }

}
