//
//  Summary.swift
//  BookNotesDebug
//
//  Created by Alek Matthiessen on 8/23/19.
//

import Foundation

public struct Summary {

    let audio: Audio?

    public init(withJSON json: [String: Any]?) {

        self.audio = Audio(audioURLStrings: json?["Audio"] as? [String])

    }
}
