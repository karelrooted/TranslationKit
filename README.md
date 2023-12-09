# TranslationKit

translate using Cloud Translation API (google, baidu, etc...) in swift

## Requirements

- iOS 17.0+ / macOS 15.0+ / tvOS 17.0+
- Xcode 15.0+

## Usage

```swift
import Foundation
import TranslationKit

TKTranslate.shared.setGoogleAppKey(with: "YourApiKey")
TKTranslate.shared.setBaiduAppKey(with: "YourAppKey", appID: "YourAppID")

let targetLanguage = "zh"
let sourceLanguage = "en"
let text = "hello world"
let targetText = try await TKTranslate.shared.translate(text, targetLanguage, sourceLanguage, provider: .google)
// auto detect source language
// let targetText = try await TKTranslate.shared.translate(text, targetLanguage, provider: .google)
```

## Credits

- [maximbilan/SwiftGoogleTranslate](https://github.com/maximbilan/SwiftGoogleTranslate)
- [acane77/BaiduTranslateAPI-swift](https://github.com/acane77/BaiduTranslateAPI-swift)
