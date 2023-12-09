//
//  BaiduTranslate.swift
//
//  Created by karelrooted on 2023/12/09.
//

import Foundation

public class BaiduTranslate: TranslateBackend {
    /// Shared instance.
    public static let shared = BaiduTranslate()

    var appID: String!
    var appKey: String!
    let baseURL = "https://fanyi-api.baidu.com/api/trans/vip/translate?"
    private let session = URLSession(configuration: .default)

    public func start(with appKey: String, appID: String) {
        self.appID = appID
        self.appKey = appKey
    }

    func generateSign(textToTranslate: String!, saltNumber: Int!, appID: String!, appKey: String!) -> String {
        let concatnation = "\(appID!)\(textToTranslate!)\(saltNumber!)\(appKey!)"
        return concatnation.MD5
    }

    func translate(_ q: String, _ target: String, _ source: String = "auto") async throws -> String {
        var sourceLanguage = source == "" ? "auto" : source
        // let textToTranslate = q.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
        let textToTranslate = q
        let textToTranslatedEncoded = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        let saltNumber = Int.random(in: 0 ... 100000)

        let sign = generateSign(textToTranslate: textToTranslate, saltNumber: saltNumber, appID: appID, appKey: appKey)

        let params = "q=\(textToTranslatedEncoded!)&from=\(sourceLanguage)&to=\(target)&appid=\(appID!)&salt=\(saltNumber)&sign=\(sign)"
        let urlToRequest = "\(baseURL)\(params)"

        let url = URL(string: urlToRequest)!
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse, // is there HTTP response
              (200 ..< 300) ~= response.statusCode // is statusCode 2XX
        else { // was there no error, otherwise ...
            return ""
        }

        guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["trans_result"] as? [[String: String]], let translation = d.first, let translatedText = translation["dst"] else {
            return ""
        }
        return translatedText
    }
}
