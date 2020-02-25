//
//  Recipe+CloudKit.swift
//  KitchenCore
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord.RecordType {
    static let recipe = "Recipe"
}

extension Recipe {

    struct RecordError: LocalizedError {
        var localizedDescription: String

        static func missingKey(_ key: RecordKey) -> RecordError {
            RecordError(localizedDescription: "Missing required key \(key.rawValue)")
        }
    }

    enum RecordKey: String {
        case title
        case subtitle
        case ingredients
        case instructions
        case image
    }

    var recordID: CKRecord.ID {
        CKRecord.ID(recordName: id, zoneID: SyncConstants.customZoneID)
    }

    var imageAsset: CKAsset? {
        guard let data = image else { return nil }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent(id)

        do {
            try data.write(to: url)
        } catch {
            return nil
        }

        return CKAsset(fileURL: url)
    }

    var record: CKRecord {
        let r = CKRecord(recordType: .recipe, recordID: recordID)

        r[.title] = title
        r[.subtitle] = subtitle
        r[.ingredients] = ingredients
        r[.instructions] = instructions
        r[.image] = imageAsset

        return r
    }

    init(record: CKRecord) throws {
        guard let title = record[.title] as? String else {
            throw RecordError.missingKey(.title)
        }
        guard let subtitle = record[.subtitle] as? String else {
            throw RecordError.missingKey(.subtitle)
        }
        guard let ingredients = record[.ingredients] as? [String] else {
            throw RecordError.missingKey(.ingredients)
        }
        guard let instructions = record[.instructions] as? String else {
            throw RecordError.missingKey(.instructions)
        }

        var imageData: Data?

        if let imageAsset = record[.image] as? CKAsset {
            imageData = imageAsset.data
        }

        self.ckData = record.encodedSystemFields
        self.id = record.recordID.recordName
        self.createdAt = record.creationDate ?? Date()
        self.title = title
        self.subtitle = subtitle
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = imageData
    }

}

extension CKRecord {

    var encodedSystemFields: Data {
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        encodeSystemFields(with: coder)
        coder.finishEncoding()

        return coder.encodedData
    }

}

extension CKAsset {
    var data: Data? {
        guard let url = fileURL else { return nil }
        return try? Data(contentsOf: url)
    }
}

extension Recipe {
    static func resolveConflict(clientRecord: CKRecord, serverRecord: CKRecord) -> CKRecord? {
        // Most recent record wins. This might not be the best solution but YOLO.

        guard let clientDate = clientRecord.modificationDate, let serverDate = serverRecord.modificationDate else {
            return clientRecord
        }

        if clientDate > serverDate {
            return clientRecord
        } else {
            return serverRecord
        }
    }
}

fileprivate extension CKRecord {
    subscript(key: Recipe.RecordKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}

