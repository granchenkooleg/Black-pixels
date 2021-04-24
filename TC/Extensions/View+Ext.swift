//
//  View+Ext.swift
//  TC
//
//  Created by Oleg Granchenko on 24.04.2021.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
