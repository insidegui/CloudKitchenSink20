//
//  RecipeListView.swift
//  CloudKitchenSink20
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import SwiftUI
import KitchenCore

struct RecipeListView: View {
    @EnvironmentObject var store: RecipeStore

    @State private var formVisible = false

    var body: some View {
        List {
            ForEach(store.recipes.sorted(by: { $0.createdAt > $1.createdAt })) { recipe in
                HStack {
                    if recipe.platformImage != nil {
                        Image(nsImage: recipe.platformImage!)
                            .resizable(resizingMode: .stretch)
                            .frame(width: 60, height: 60)
                            .cornerRadius(6)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(recipe.title)
                            .font(.system(.headline, design: .rounded))
                        Text(recipe.subtitle)
                            .font(.system(size: 14))
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        .overlay(VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                Button(action: { self.formVisible.toggle() }, label: { Text("Add Recipe") })
            }
        }.padding())
        .sheet(isPresented: $formVisible, content: {
            RecipeFormView(recipe: nil) {
                self.formVisible = false
            }.environmentObject(self.store)
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView().environmentObject(RecipeStore(recipes: Recipe.previewRecipes))
    }
}

#if os(macOS)

extension Recipe {
    var platformImage: NSImage? {
        guard let data = image else { return nil }
        return NSImage(data: data)
    }
}

#else

import UIKit

#endif
