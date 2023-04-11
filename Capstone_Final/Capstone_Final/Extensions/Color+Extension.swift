//
//  Color+Extension.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation
import SwiftUI

//MARK: - CONVERSION BETWEEN TYPE & VALUES
/* Initialise Color using a Hex String */
/** @note: change to UInt after testing for safety */
extension Color {
    init(hex: Int, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
