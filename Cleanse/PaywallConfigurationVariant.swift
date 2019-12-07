//  PaywallConfigurationVariant.swift
//  BookNotesDebug
//
//  Created by Alek Matthiessen on 10/15/19.
//  Created by Alek Matthiessen on 10/14/19.
//

import CoreGraphics
import Foundation

class PaywallConfigurationLabelConfig {
    let title: String?
    let fontSize: CGFloat?

    init(title: String, fontSize: CGFloat) {
        self.title = title
        self.fontSize = fontSize
    }

    init(withJSON json: [String: Any]?) {
        self.title = json?["title"] as? String
        self.fontSize = json?["font_size"] as? CGFloat
    }
}

class PaywallConfigurationVariant {
    enum ActionButtonPosition: String {

        case top
        case bottom
    }

    let featureItems: [PaywallConfigurationLabelConfig]?
    let leadingText: PaywallConfigurationLabelConfig?
    let buttonText: PaywallConfigurationLabelConfig?
    let disclaimerText: PaywallConfigurationLabelConfig?
    let buttonPosition: PaywallConfigurationVariant.ActionButtonPosition

    init(
       featureItems: [PaywallConfigurationLabelConfig]?,
       leadingText: PaywallConfigurationLabelConfig?,
       buttonText: PaywallConfigurationLabelConfig?,
       disclaimerText: PaywallConfigurationLabelConfig?,
       buttonPosition: PaywallConfigurationVariant.ActionButtonPosition = .bottom
    ) {
        self.featureItems = featureItems
        self.leadingText = leadingText
        self.buttonText = buttonText
        self.disclaimerText = disclaimerText
        self.buttonPosition = buttonPosition
    }

    init(withJSON json: [String: Any]?) {
        let featureItemJSONs =  (json?["feature_items"] as? [[String: Any]])

        self.featureItems = featureItemJSONs?.map ({ (featureItemJSON) -> PaywallConfigurationLabelConfig in
            return PaywallConfigurationLabelConfig(withJSON: featureItemJSON)
        })

        self.leadingText = PaywallConfigurationLabelConfig(withJSON: json?["leading_text"] as? [String: Any])
        self.buttonText = PaywallConfigurationLabelConfig(withJSON: json?["button_text"] as? [String: Any])
        self.disclaimerText = PaywallConfigurationLabelConfig(withJSON: json?["disclaimer_text"] as? [String: Any])

        self.buttonPosition = {
            if let jsonPosition = json?["button_position"] as? String {
                return PaywallConfigurationVariant.ActionButtonPosition(rawValue: jsonPosition) ?? .bottom
            }

            return .bottom
        }()
    }
}
