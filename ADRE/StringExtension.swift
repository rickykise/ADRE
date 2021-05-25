//
//  StringExtension.swift
//  ADRE
//
//  Created by youngwoo Choi on 2020/08/14.
//  Copyright © 2020 youngwoo Choi. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
