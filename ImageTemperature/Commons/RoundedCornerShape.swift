//
//  RoundedCornerShape.swift
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//

import SwiftUI

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
