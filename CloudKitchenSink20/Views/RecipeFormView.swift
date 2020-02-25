//
//  RecipeFormView.swift
//  CloudKitchenSink20
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import SwiftUI
import KitchenCore

struct RecipeFormView: View {
    @EnvironmentObject var store: RecipeStore
    @ObservedObject private var viewModel = AddRecipeViewModel()

    private let title: String

    var onSave: () -> Void

    init(recipe: Recipe? = nil, onSave: @escaping () -> Void = { }) {
        self.viewModel = AddRecipeViewModel(recipe: recipe)
        self.title = recipe == nil ? "New Recipe" : "Edit Recipe"
        self.onSave = onSave
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.system(.headline, design: .rounded))
            Form {
                HStack {
                    DropZoneView(image: self.viewModel.platformImage, dropHandler: { url in
                        self.viewModel.imageURL = url
                    })
                    VStack {
                        TextField("Title", text: $viewModel.title)
                        TextField("Subtitle", text: $viewModel.subtitle)
                        TextField("Ingredients", text: $viewModel.ingredients)
                    }
                    Spacer()
                }
                MacEditorTextView(text: $viewModel.instructions)
                Button(action: save, label: { Text("Save") }).buttonStyle(DefaultButtonStyle())
            }
        }
        .padding()
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }

    private func save() {
        store.addOrUpdate(viewModel.recipe)
        onSave()
    }
}

struct RecipeFormView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFormView(recipe: Recipe.previewRecipes[0])
            .environmentObject(RecipeStore(recipes: Recipe.previewRecipes))
    }
}
