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
    var imagesForGrid = [UIImageView]()
    var currentTemplate: Template
    private var totalImagesMaxForTemplate: Int
    var backgroundColorOfTHeFrame: UIColor

    init() {
        self.currentTemplate = .twoUpOneBottom
        self.totalImagesMaxForTemplate = 3
        self.backgroundColorOfTHeFrame = #colorLiteral(red: 0.05632288009, green: 0.396702528, blue: 0.5829991102, alpha: 1)
    }

        // we verify that the array content all the possible images for the template
    var didCompleteGrid: Bool {
        imagesForGrid.count >= totalImagesMaxForTemplate
    }

    func templateSetup() {
        switch currentTemplate {
            case .oneUpTwoBottom:
                totalImagesMaxForTemplate = 3
            case .twoUpOneBottom:
                totalImagesMaxForTemplate = 3
            case .twoUpTwoBottom:
                totalImagesMaxForTemplate = 4
        }
    }

        // add image in the grid and check that it is completely loaded (then hide the button +)
    func addImageInTheGrid(image: UIImageView) {
        imagesForGrid.append(image)
    }

        // begin the new images grid
    func newGrid() {
        imagesForGrid.removeAll()
        currentTemplate = .twoUpOneBottom
        templateSetup()
        backgroundColorOfTHeFrame = #colorLiteral(red: 0.05632288009, green: 0.396702528, blue: 0.5829991102, alpha: 1)
    }
}
