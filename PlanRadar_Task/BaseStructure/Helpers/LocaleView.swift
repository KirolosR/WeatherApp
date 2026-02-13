//
//  LocaleView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI

/// Previews view in all supported locales
public struct LocalePreview<Content: View>: View {
    let content: () -> Content
    public let previewContent: [LocalePreviewContent]
    
    public init(
        previewDevices: [PreviewDevice] = [],
        _ content: @escaping  () -> Content
    ) {
        self.content = content
        self.previewContent = Self.preview(forDevices: previewDevices)
    }
    
    public static func preview(
        forDevices previewDevices: [PreviewDevice]
    ) -> [LocalePreviewContent] {
        var previewContent = [LocalePreviewContent]()
        for locale in Locale.appSupported {
            guard !previewDevices.isEmpty else {
                previewContent.append(.init(device: nil, locale: locale))
                continue
            }
            for previewDevice in previewDevices {
                previewContent.append(.init(device: previewDevice, locale: locale))
            }
        }
        return previewContent
    }
    
    public var body: some View {
        Group {
            ForEach(previewContent) { preview in
                content()
                    .locale(preview.locale)
                    .previewDisplayName("\(preview.device?.rawValue ?? "") Locale: \(preview.locale.languageCode ?? "")")
                    .if(let: preview.device) { $0.previewDevice($1) }
            }
        }
    }
}

// MARK: - LocalePreviewContent

public struct LocalePreviewContent: Identifiable {
    public let id = UUID()
    public let device: PreviewDevice?
    public let locale: Locale
}

// MARK: - Preview devices
public extension Array where Element == PreviewDevice {
    static var defaultPreviewSet: [PreviewDevice] {
        [
            PreviewDevice(rawValue: "iPhone SE (2nd generation)"),
            PreviewDevice(rawValue: "iPhone SE (2nd generation)")
        ]
    }
}
