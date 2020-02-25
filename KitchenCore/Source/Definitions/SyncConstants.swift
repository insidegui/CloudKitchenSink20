//
//  SyncConstants.swift
//  KitchenCore
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import CloudKit

public struct SyncConstants {

    public static let containerIdentifier = "iCloud.codes.rambo.CloudKitchenSink20"

    public static let appGroup = "8C7439RJLG.group.codes.rambo.CloudKitchenSink20"

    public static let subsystemName = "codes.rambo.KitchenCore"

    public static let customZoneID: CKRecordZone.ID = {
        CKRecordZone.ID(zoneName: "KitchenZone", ownerName: CKCurrentUserDefaultName)
    }()

}
