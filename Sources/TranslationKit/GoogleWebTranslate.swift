//
//  GoogleTranslate.swift
//
//  Created by karelrooted on 11/12/23.
//

import Foundation

/// A helper class for using Google Translate API.
public class GoogleWebTranslate: TranslateBackend {
    /// Shared instance.
    public static let shared = GoogleWebTranslate()

    /// Language response structure.
    public struct Language {
        public let language: String
        public let name: String
    }
    
    /// Detect response structure.
    public struct Detection {
        public let language: String
        public let isReliable: Bool
        public let confidence: Float
    }
    
    /// API structure.
    private enum API {
        /// Base Google Translation API url.
        static let base = "https://translate.googleapis.com/translate_a/single?client=gtx&dt=t"
        
        /// A translate endpoint.
        enum translate {
            static let method = "GET"
            static let url = API.base
        }
        
        /// A detect endpoint.
        enum detect {
            static let method = "POST"
            static let url = API.base + "/detect"
        }
        
        /// A list of languages endpoint.
        enum languages {
            static let method = "GET"
            static let url = API.base + "/languages"
        }
    }
    
    /// Default URL session.
    private let session = URLSession(configuration: .default)
    
    /**
         Translates input text, returning translated text.
    
         - Parameters:
             - q: The input text to translate. Repeat this parameter to perform translation operations on multiple text inputs.
             - target: The language to use for translation of the input text.
             - source: The language of the source text. If the source language is not specified, the API will attempt to detect the source language automatically and return it within the response.
     */
    public func translate(_ q: String, _ target: String, _ source: String = "") async throws -> String {
        guard var urlComponents = URLComponents(string: API.translate.url) else {
            return ""
        }
        
        var queryItems = urlComponents.queryItems!
        queryItems.append(URLQueryItem(name: "q", value: q))
        queryItems.append(URLQueryItem(name: "sl", value: source))
        queryItems.append(URLQueryItem(name: "tl", value: target))
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return ""
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.translate.method
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, // is there HTTP response
              (200 ..< 300) ~= response.statusCode // is statusCode 2XX
        else { // was there no error, otherwise ...
            return ""
        }
        
        guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [Any], let d = object.first as? [Any], let translations = d.first as? [Any], let translatedText = translations.first as? String else {
            return ""
        }
        return translatedText
    }
}
