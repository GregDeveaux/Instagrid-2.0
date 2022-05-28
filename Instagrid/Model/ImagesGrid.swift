//
//  GridImages.swift
//  Instagrid
//
//  Created by Greg-Mini on 13/05/2022.
//

import Foundation
import UIKit

    // differente possible template on Instagrid
enum Template {
    case oneUpTwoBottom
    case twoUpOneBottom
    case twoUpTwoBottom
}

class InstaGrid {

        // whole possible images for grid
    var imagesForGrid: [UIImageView] = []
    var currentTemplate: Template
    var totalImagesMaxForTemplate: Int
    var backgroundColorOfTHeFrame: UIColor

    init() {
        self.currentTemplate = .twoUpTwoBottom
        self.totalImagesMaxForTemplate = 4
        self.backgroundColorOfTHeFrame = #colorLiteral(red: 0.05632288009, green: 0.396702528, blue: 0.5829991102, alpha: 1)
    }

        // we verify that the array content all the possible images for the template
    var didCompleteGrid: Bool {
        imagesForGrid.count >= totalImagesMaxForTemplate
    }

        // add image in the grid and check that it is completely loaded (then hide the button +)
    func addImageInTheGrid(image: UIImageView) {
        imagesForGrid.append(image)
        NotificationCenter.default.post(name: .didLoadImage, object: nil)
    }

        // after the swipe, we again begin the new images grid
    func newGrid() {
        imagesForGrid.removeAll()
        currentTemplate = .twoUpTwoBottom
        backgroundColorOfTHeFrame = #colorLiteral(red: 0.05632288009, green: 0.396702528, blue: 0.5829991102, alpha: 1)
    }
}

    // integration of notification name in the class Notification for autocompletion
extension Notification.Name {
    static let didLoadImage = Notification.Name("didLoadImage")
}
