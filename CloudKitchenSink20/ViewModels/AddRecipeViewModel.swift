//
//  AddRecipeViewModel.swift
//  CloudKitchenSink20
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import Combine
import KitchenCore
import Cocoa

final class AddRecipeViewModel: ObservableObject {
    private var initialRecipe: Recipe?

    private var id: String = UUID().uuidString
    @Published var title: String = ""
    @Published var subtitle: String = ""
    @Published var ingredients: String = ""
    @Published var instructions: String = ""
    @Published var image: Data? = nil

    var platformImage: NSImage? {
        guard let data = image else { return nil }
        return NSImage(data: data)
    }

    var imageURL: URL? {
        get { nil }
        set {
            guard let url = newValue else {
                self.image = nil
                return
            }
            self.image = try? Data(contentsOf: url)
        }
    }

    init(recipe: Recipe? = nil) {
        self.initialRecipe = recipe
        self.id = recipe?.id ?? UUID().uuidString
        self.title = recipe?.title ?? ""
        self.subtitle = recipe?.subtitle ?? ""
        self.ingredients = recipe?.ingredients.joined(separator: ",") ?? ""
        self.instructions = recipe?.instructions ?? ""
        self.image = recipe?.image
    }

    var recipe: Recipe {
        Recipe(
            id: initialRecipe?.id ?? id,
            createdAt: Date(),
            title: title,
            subtitle: subtitle,
            ingredients: ingredients.components(separatedBy: ","),
            instructions: instructions,
            image: image
        )
    }
}
