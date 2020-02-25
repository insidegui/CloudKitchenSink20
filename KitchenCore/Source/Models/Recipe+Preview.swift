//
//  Recipe+Preview.swift
//  KitchenCore
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation

public extension Recipe {
    static let previewRecipes: [Recipe] = [
        Recipe(
            id: "1",
            createdAt: Date(),
            title: "Simple Cajun Seasoning",
            subtitle: "A delicious mix of spices that goes great with chicken, french fries, and much more.",
            ingredients: [
                "2 1/2 tablespoons salt",
                "1 tablespoon dried oregano",
                "1 tablespoon paprika",
                "1 tablespoon cayenne pepper",
                "1 tablespoon ground black pepper"
        ], instructions: "Mix all ingredients together and process in a blender or coffee grinder until a fine powder is formed.",
           image: Bundle.main.data(named: "1", withExtension: "jpg")
        ),
        Recipe(
            id: "2",
            createdAt: Date(),
            title: "Spaghetti Carbonara",
            subtitle: "The easiest pasta dish you will ever make with just 5 ingredients in 15 min.",
            ingredients: [
                "8 ounces spaghetti",
                "2 large eggs",
                "1/2 cup freshly grated Parmesan",
                "4 slices bacon, diced",
                "4 cloves garlic, minced",
                "Kosher salt and freshly ground black pepper, to taste",
                "2 tablespoons chopped fresh parsley leaves"
        ], instructions: """
        In a large pot of boiling salted water, cook pasta according to package instructions; reserve 1/2 cup water and drain well.

        In a small bowl, whisk together eggs and Parmesan; set aside.

        Heat a large skillet over medium high heat. Add bacon and cook until brown and crispy, about 6-8 minutes; reserve excess fat.

        Stir in garlic until fragrant, about 1 minute. Reduce heat to low.

        Working quickly, stir in pasta and egg mixture, and gently toss to combine; season with salt and pepper, to taste. Add reserved pasta water, one tablespoon at a time, until desired consistency is reached.

        Serve immediately, garnished with parsley, if desired.
        """,
           image: Bundle.main.data(named: "2", withExtension: "jpg")
        )
    ]
}

fileprivate extension Bundle {
    func data(named name: String, withExtension ext: String) -> Data? {
        guard let url = self.url(forResource: name, withExtension: ext) else { return nil }
        return try? Data(contentsOf: url)
    }
}
