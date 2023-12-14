//
//  TKTranslate.swift
//
//
//  Created by karelrooted on 12/9/23.
//

import Foundation

public enum TranslateProvider: String {
    case google
    case baidu
    case googleWeb

    var backend: any TranslateBackend {
        switch self {
        case .google:
            GoogleTranslate.shared
        case .googleWeb:
            GoogleWebTranslate.shared
        case .baidu:
            BaiduTranslate.shared
        }
    }
}

public class TKTranslate {
    /// Shared instance.
    public static let shared = TKTranslate()

    public func setBaiduAppKey(with appKey: String, appID: String) {
        BaiduTranslate.shared.start(with: appKey, appID: appID)
    }

    public func setGoogleAppKey(with appKey: String) {
        GoogleTranslate.shared.start(with: appKey)
    }

    public func translate(_ q: String, _ target: String, _ source: String = "", provider: TranslateProvider = .google) async throws -> String {
        return try await provider.backend.translate(q, target, source)
    }
}
