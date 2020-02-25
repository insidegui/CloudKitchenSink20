//
//  RecipeStore.swift
//  KitchenCore
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import Combine
import CloudKit
import os.log

public final class RecipeStore: ObservableObject {

    @Published public private(set) var recipes: [Recipe] = []

    private let log = OSLog(subsystem: SyncConstants.subsystemName, category: String(describing: RecipeStore.self))

    private let fileManager = FileManager()

    private let queue = DispatchQueue(label: "RecipeStore")

    private let container: CKContainer
    private let defaults: UserDefaults
    private var syncEngine: SyncEngine?

    public init(recipes: [Recipe] = []) {
        self.container = CKContainer(identifier: SyncConstants.containerIdentifier)

        guard let defaults = UserDefaults(suiteName: SyncConstants.appGroup) else {
            fatalError("Invalid app group")
        }
        self.defaults = defaults

        if !recipes.isEmpty {
            self.recipes = recipes
            save()
        } else {
            load()
        }

        self.syncEngine = SyncEngine(
            defaults: self.defaults,
            initialRecipes: self.recipes
        )

        self.syncEngine?.didUpdateModels = { [weak self] recipes in
            self?.updateAfterSync(recipes)
        }

        self.syncEngine?.didDeleteModels = { [weak self] identifiers in
            self?.recipes.removeAll(where: { identifiers.contains($0.id) })
            self?.save()
        }
    }

    private var storeURL: URL {
        let baseURL: URL

        if let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: SyncConstants.appGroup) {
            baseURL = containerURL
        } else {
            os_log("Failed to get container URL for app security group %@", log: self.log, type: .fault, SyncConstants.appGroup)

            baseURL = fileManager.temporaryDirectory
        }

        let url = baseURL.appendingPathComponent("RecipeStore.plist")

        if !fileManager.fileExists(atPath: url.path) {
            os_log("Creating store file at %@", log: self.log, type: .debug, url.path)

            if !fileManager.createFile(atPath: url.path, contents: nil, attributes: nil) {
                os_log("Failed to create store file at %@", log: self.log, type: .fault, url.path)
            }
        }

        return url
    }

    private func updateAfterSync(_ recipes: [Recipe]) {
        os_log("%{public}@", log: log, type: .debug, #function)

        recipes.forEach { updatedRecipe in
            guard let idx = self.recipes.firstIndex(where: { $0.id == updatedRecipe.id }) else { return }
            self.recipes[idx] = updatedRecipe
        }

        save()
    }

    public func addOrUpdate(_ recipe: Recipe) {
        if let idx = recipes.lastIndex(where: { $0.id == recipe.id }) {
            recipes[idx] = recipe
        } else {
            recipes.append(recipe)
        }

        syncEngine?.upload(recipe)
        save()
    }

    public func delete(with id: String) {
        guard let recipe = self.recipe(with: id) else {
            os_log("Recipe not found with id %@ for deletion.", log: self.log, type: .error, id)
            return
        }

        syncEngine?.delete(recipe)
        save()
    }

    public func recipe(with id: String) -> Recipe? {
        recipes.first(where: { $0.id == id })
    }

    private func save() {
        os_log("%{public}@", log: log, type: .debug, #function)

        do {
            let data = try PropertyListEncoder().encode(recipes)
            try data.write(to: storeURL)
        } catch {
            os_log("Failed to save recipes: %{public}@", log: self.log, type: .error, String(describing: error))
        }
    }

    private func load() {
        os_log("%{public}@", log: log, type: .debug, #function)
        
        do {
            let data = try Data(contentsOf: storeURL)

            guard !data.isEmpty else { return }

            self.recipes = try PropertyListDecoder().decode([Recipe].self, from: data)
        } catch {
            os_log("Failed to load recipes: %{public}@", log: self.log, type: .error, String(describing: error))
        }
    }

    public func processSubscriptionNotification(with userInfo: [AnyHashable : Any]) {
        syncEngine?.processSubscriptionNotification(with: userInfo)
    }

}
