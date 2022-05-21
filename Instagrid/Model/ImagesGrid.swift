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
    var imagesForGrid: [UIImage] = []
    
        // current activity
    enum State {
        case inProgress
        case completed
    }
    
        // we begin the grid
    var currentTemplate: Template = .oneUpTwoBottom
    var totalImagesMaxForTemplate = 3
    
        // initial background color for restart (hidden bonus : swipe left to change color)
    var backgroundColorOfTHeFrame = #colorLiteral(red: 0.05632288009, green: 0.396702528, blue: 0.5829991102, alpha: 1)
    var state: State = .inProgress
    
    // we verify that the array content all the possible images for the template
    func numberLoadedImageMax(currentTemplate: Template) {
        switch currentTemplate {
            case .oneUpTwoBottom:
                totalImagesMaxForTemplate = 3
            case .twoUpOneBottom:
                totalImagesMaxForTemplate = 3
            case .twoUpTwoBottom:
                totalImagesMaxForTemplate = 4
        }
        
            // we activate the swipe touch when the selection is complete
        if imagesForGrid.count == totalImagesMaxForTemplate {
            selectionCompleted()
        }
    }
    
    
    // after the selection completed, activation of the swipe function
    private func selectionCompleted() {
        state = .completed
    }
    
    // after the swipe, we again begin the new images grid
    func newGrid() {
        imagesForGrid.removeAll()
        currentTemplate = .oneUpTwoBottom
        totalImagesMaxForTemplate = 3
        backgroundColorOfTHeFrame = #colorLiteral(red: 0.05632288009, green: 0.396702528, blue: 0.5829991102, alpha: 1)
        state = .inProgress
    }
}



