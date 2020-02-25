//
//  DropZoneView.swift
//  CloudKitchenSink20
//
//  Created by Guilherme Rambo on 24/02/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Cocoa
import SwiftUI
import CoreServices

struct DropZoneView: View {
    @State private(set) var url: URL?
    @State private(set) var image: NSImage? = nil
    @State private var isActive = false

    var dropHandler: (URL) -> Void = { _ in }

    var body: some View {
        Group {
            ZStack {
                if image != nil {
                    Image(nsImage: image!).resizable()
                }
                Text("Drop image here")
                    .padding(4)
                    .background(Color(NSColor(calibratedWhite: 0.1, alpha: 0.7)))
                    .foregroundColor(Color(.secondaryLabelColor))
                    .cornerRadius(4)
            }
        }
        .frame(width: 120, height: 120)
        .background(Color(self.isActive ? .systemBlue : .quaternaryLabelColor))
        .cornerRadius(6)
        .onDrop(
            of: [kUTTypeFileURL as String],
            delegate: ImageDropDelegate(
                url: $url,
                image: $image,
                isActive: $isActive,
                handler: self.dropHandler
            )
        )
    }
}

struct DropZoneView_Previews: PreviewProvider {
    static var previews: some View {
        DropZoneView(url: nil, image: nil)
    }
}

fileprivate struct ImageDropDelegate: DropDelegate {
    @Binding var url: URL?
    @Binding var image: NSImage?
    @Binding var isActive: Bool
    var handler: (URL) -> Void = { _ in }

    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [kUTTypeFileURL as String])
    }

    func dropEntered(info: DropInfo) {
        isActive = true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        isActive = true

        return nil
    }

    func dropExited(info: DropInfo) {
        isActive = false
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let provider = info.itemProviders(for: [kUTTypeFileURL as String]).first else { return false }

        provider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil) { data, error in
            guard let data = data as? Data else {
                if let error = error {
                    print(error)
                }
                return
            }

            guard let url = URL(dataRepresentation: data, relativeTo: nil) else { return }

            DispatchQueue.main.async {
                self.url = url
                self.image = NSImage(contentsOf: url)
                self.handler(url)
            }
        }

        return true
    }


}
