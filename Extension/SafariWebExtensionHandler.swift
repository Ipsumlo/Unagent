//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by 堅書 on 2023/04/23.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.tsubuzaki.BingBong")!

    func beginRequest(with context: NSExtensionContext) {
        let response = NSExtensionItem()
        var responseContent: [String:String] = [:]
        if let currentUserAgent = defaults.string(forKey: "UserAgent") {
            responseContent.updateValue(currentUserAgent, forKey: "userAgent")
        }
        if let siteSettings = defaults.string(forKey: "SiteSettings") {
            responseContent.updateValue(siteSettings.replacingOccurrences(of: "\\", with: ""), forKey: "siteSettings")
        }
        response.userInfo = ["message": responseContent]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
