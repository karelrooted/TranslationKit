//
//  TranslateBackend.swift
//
//
//  Created by karelrooted on 12/9/23.
//

import Foundation

protocol TranslateBackend {
    func translate(_ q: String, _ target: String, _ source: String) async throws -> String
}
