//
//  ImageInfo.swift
//  TC
//
//  Created by Oleg Granchenko on 22.04.2021.
//

import SwiftUI
import Combine

struct ImageInfo: Identifiable {
    let id: UUID
    let image: String
    var blackPixelsPercent: CGFloat?
    var isHideLoader: Bool = true 
}
