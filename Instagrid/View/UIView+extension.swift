//
//  UIView+extension.swift
//  Instagrid
//
//  Created by Gregory Deveaux on 09/06/2022.
//

import UIKit

    // -------------------------------------------------------
    // MARK: share final screenshot
    // -------------------------------------------------------

extension UIView {
        // create a square screenshot of the imageGrid
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
}
