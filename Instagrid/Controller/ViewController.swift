//
//  ViewController.swift
//  Instagrid
//
//  Created by Gregory Deveaux on 12/05/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UINavigationControllerDelegate {

        // Reusing LaunchScreen logo and gradient for animation
    lazy var logoInstagrid: UIImageView = {
        let logoInstagrid = UIImageView(image: UIImage(named: "LogoInstagrid"))
        logoInstagrid.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        logoInstagrid.center = self.view.center
        return logoInstagrid
    }()

    lazy var backgroundGradient: UIImageView = {
        let backgroundGradient = UIImageView(image: UIImage(named: "BackgroundLaunchScreen"))
        backgroundGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return backgroundGradient
    }()

        // create a Instagrid
    let instaGrid = InstaGrid()

        // create a new image view for the grid
    var editingImage: UIImageView!

    var currentIndex = 0

        // add swipe label
    @IBOutlet weak var swipeLabel: UILabel!

        // add identical buttons and identical images view of the grid
    @IBOutlet var buttonsInsertImage: [UIButton]!
    
    @IBOutlet var caseInsertImage: [UIImageView]!

    var numberButtonSelected = 0

        // add the global view grid for the interaction with border color
    @IBOutlet weak var viewGrid: UIView!

        // add buttons template
    @IBOutlet weak var buttonOneUpTwoBottom: UIButton!
    @IBOutlet weak var buttonTwoUpOneBottom: UIButton!
    @IBOutlet weak var buttonTwoUpTwoBottom: UIButton!

        // view deleted using templates buttons
    @IBOutlet weak var deletedViewBottom: UIView!
    @IBOutlet weak var deletedViewUp: UIView!


        // -------------------------------------------------------
        // MARK: viewDidLoad
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

            // animation logoScreen
        view.addSubview(backgroundGradient)
        view.addSubview(logoInstagrid)
        logoInstagridRotation()

            // add button active of the first grid
        allButtonTemplate()

            // design frame and cases
        roundCornerForImageView()
        shadowFrame()

            // add swipes
        swipesInstagrid()
    }


        // -------------------------------------------------------
        // MARK: iPhone orientation change
        // -------------------------------------------------------

        // immediately the orientation iPhone changes rewrite label and modify direction swipe
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        swipesInstagrid()
    }


        // -------------------------------------------------------
        // MARK: reset grid
        // -------------------------------------------------------

        // start new grid after share the screenshot template with the swipe
    private func reset() {
        currentIndex = 0

        instaGrid.newGrid()
        instaGrid.imagesForGrid.removeAll()
        
        caseInsertImage.forEach {
            $0.image = nil
        }

        buttonsInsertImage.forEach {
            $0.setImage(UIImage(named: "Plus"), for: .normal)
        }

        viewGrid.backgroundColor = instaGrid.backgroundColorOfTHeFrame
        allButtonTemplate()
    }

        // -------------------------------------------------------
        // MARK: swipe to share the final screenshot
        // -------------------------------------------------------

        // add function to multiply swipes action and direction
    private func swipeDirection(_ direction: UISwipeGestureRecognizer.Direction, action: Selector?) {
        let swipe = UISwipeGestureRecognizer(target: self, action: action)
        swipe.direction = direction
        self.view.addGestureRecognizer(swipe)
    }

        // swipe and save the grid (swipe up or swipe left according to orientation portrait or lanscape)
    private func swipesInstagrid() {
        swipeDirection(.right, action: #selector(swipeGestureColor(_:)))

        if traitCollection.verticalSizeClass == .regular {
            swipeDirection(.up, action: #selector(swipeGestureShare(_:)))
            swipeLabel.text = "Swipe up to share"
        } else if traitCollection.verticalSizeClass == .compact {
            swipeDirection(.left, action: #selector(swipeGestureShare(_:)))
            swipeLabel.text = "Swipe left to share"
        }
    }

        // swipe gesture to share the grid
    @objc private func swipeGestureShare(_ gesture: UISwipeGestureRecognizer) {
            // if swipe up or left share the instagrid and begin a new grid
        if (gesture.direction == .up && traitCollection.verticalSizeClass == .regular)
            || (gesture.direction == .left && traitCollection.verticalSizeClass == .compact) {

            guard instaGrid.didCompleteGrid else { return }

            animeGrid()

            let imageToShare = viewGrid.screenshot()

            let shareController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            shareController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?,
                                                            completed: Bool,
                                                            arrayReturnedItems: [Any]?,
                                                            error: Error?) in

                guard completed else { return self.animeShareCancelled() }
                    self.animeShareFinished()

                if let shareError = error {
                    self.animeShareFinished()
                    print("error while sharing: \(shareError.localizedDescription)")
                }
            }

            present(shareController, animated: true, completion: nil)
        }
    }


        // -------------------------------------------------------
        // MARK: buttons template
        // -------------------------------------------------------

        // tap one of three buttons to modify the template
    @IBAction private func templateOneUpTwoBottom(_ sender: UIButton) {
        instaGrid.currentTemplate = .oneUpTwoBottom
        allButtonTemplate()
    }

    @IBAction private func templateTwoUpOneBottom(_ sender: UIButton) {
        instaGrid.currentTemplate = .twoUpOneBottom
        allButtonTemplate()
    }

    @IBAction private func templateTwoUpTwoBottom(_ sender: UIButton) {
        instaGrid.currentTemplate = .twoUpTwoBottom
        allButtonTemplate()
    }

    private func allButtonTemplate() {
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = false

        switch instaGrid.currentTemplate {
            case .oneUpTwoBottom:
                deletedViewUp.isHidden = true
                buttonFrontBack(name: buttonOneUpTwoBottom, imageCheck: "Layout-1-check")
                buttonTwoUpOneBottom.setImage(UIImage(named: "Layout-2"), for: .normal)
                buttonTwoUpTwoBottom.setImage(UIImage(named: "Layout-3"), for: .normal)

            case .twoUpOneBottom:
                deletedViewBottom.isHidden = true
                buttonOneUpTwoBottom.setImage(UIImage(named: "Layout-1"), for: .normal)
                buttonFrontBack(name: buttonTwoUpOneBottom, imageCheck: "Layout-2-check")
                buttonTwoUpTwoBottom.setImage(UIImage(named: "Layout-3"), for: .normal)

            case .twoUpTwoBottom:
                buttonOneUpTwoBottom.setImage(UIImage(named: "Layout-1"), for: .normal)
                buttonTwoUpOneBottom.setImage(UIImage(named: "Layout-2"), for: .normal)
                buttonFrontBack(name: buttonTwoUpTwoBottom, imageCheck: "Layout-3-check")
        }
        instaGrid.templateSetup()
    }


        // -------------------------------------------------------
        // MARK: buttons insert images
        // -------------------------------------------------------

        // round corner of the cases of selected images
    private func roundCornerForImageView() {
        caseInsertImage.forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.contentMode = .scaleAspectFill
        }
    }

        // push button to insert image in the case
    @IBAction private func touchToInsertImage(_ sender: UIButton) {
        numberButtonSelected = sender.tag - 1
        editingImage = caseInsertImage[numberButtonSelected]
        chooseNewImage()
    }

        // modify image button after the loading image
    private func removePlusIfImageLoaded(_ buttonSelect: Int) {
        if instaGrid.imagesForGrid.count == currentIndex && instaGrid.imagesForGrid.count != 0 {
            buttonsInsertImage[buttonSelect].setImage(UIImage(named: "empty"), for: .normal)
        }
    }


        // -------------------------------------------------------
        // MARK: load the image (library or camera)
        // -------------------------------------------------------

    private func chooseNewImage() {
        let alert = UIAlertController(title: "Choose your image", message: "", preferredStyle: .actionSheet)

            // we shared photoLibrary for images
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (_) in
            self.present(self.pickerPH, animated: true)
        }))

            // we shared photoLibrary for images
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.present(self.pickerUI, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

        // insert image in the grid
    private func insertInGrid(the chosenImage: UIImage) {
        editingImage.image = chosenImage
        editingImage.contentMode = .scaleAspectFill
        instaGrid.addImageInTheGrid(image: editingImage)
        self.currentIndex += 1
        self.removePlusIfImageLoaded(self.numberButtonSelected)
    }


        // -------------------------------------------------------
        // MARK: border frame color
        // -------------------------------------------------------

    @objc private func swipeGestureColor(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            selectorColorForBorderFrame()
        }
    }

    private func shadowFrame() {
        viewGrid.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewGrid.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewGrid.layer.masksToBounds = false
        viewGrid.layer.shadowOpacity = 0.2
        viewGrid.layer.shadowRadius = 1.2
    }


        // -------------------------------------------------------
        // MARK: animations
        // -------------------------------------------------------

        // animate with rotation and alpha the Instagrid logo
    private func logoInstagridRotation() {
        let rotationTransform = CGAffineTransform(rotationAngle: 180)

        UIImageView.animate(withDuration: 1.7,
                            delay: 0.5,
                            usingSpringWithDamping: 0.2,
                            initialSpringVelocity: 0.1,
                            options: .curveEaseInOut) {
            self.logoInstagrid.transform = rotationTransform
        } completion: { finished in
            UIImageView.animate(withDuration: 0.5,
                                delay: 0.2) {
                self.logoInstagrid.alpha = 0
                self.backgroundGradient.alpha = 0
            }
        }
    }

    private func animeShareFinished() {
        reset()
        viewGrid.transform = .identity
        viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0) {
            self.viewGrid.transform = .identity
        }
    }

    private func animeShareCancelled() {
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.2) {
            self.viewGrid.transform = .identity
        }
    }

    private func animeGrid() {
        if traitCollection.verticalSizeClass == .regular {
            UIView.animate(withDuration: 0.5) {
                self.viewGrid.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height) }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.viewGrid.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0) }
        }
    }

        // animation button template
    private func buttonFrontBack(name button: UIButton, imageCheck: String) {
        button.setImage(UIImage(named: imageCheck), for: .normal)
        UIView.transition(with: button,
                          duration: 0.25,
                          options: UIView.AnimationOptions.transitionFlipFromLeft,
                          animations: nil)
    }
}


    // -------------------------------------------------------
    // MARK: picker image library
    // -------------------------------------------------------

extension ViewController: PHPickerViewControllerDelegate {

        // create a picker controller to load the images from photo library
    var pickerPH: PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let pickerPH = PHPickerViewController(configuration: configuration)
        pickerPH.delegate = self

        if let sheet = pickerPH.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 25.0
        }
        return pickerPH
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let sheet = pickerPH.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        }

        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = editingImage.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.sync {
                    guard let self = self, let chosenImage = image as? UIImage,
                          self.editingImage.image == previousImage else { return }
                    self.insertInGrid(the: chosenImage)
                }
            }
        }
        dismiss(animated: true)
    }
}


    // -------------------------------------------------------
    // MARK: picker camera
    // -------------------------------------------------------

extension ViewController: UIImagePickerControllerDelegate {

        // create a picker controller to load the images from camera
    var pickerUI: UIImagePickerController {
        let pickerUI = UIImagePickerController()
        pickerUI.allowsEditing = true
        pickerUI.sourceType = .camera
        pickerUI.cameraCaptureMode = .photo
        pickerUI.modalPresentationStyle = .currentContext
        pickerUI.delegate = self
        return pickerUI
    }

        // recover the image and applied a fullscreen
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        insertInGrid(the: chosenImage)

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


    // -------------------------------------------------------
    // MARK: picker color
    // -------------------------------------------------------

extension ViewController: UIColorPickerViewControllerDelegate {
    private func selectorColorForBorderFrame() {
        let pickerColor = UIColorPickerViewController()
        pickerColor.delegate = self
        pickerColor.supportsAlpha = false
        present(pickerColor, animated: true, completion: nil)
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        viewGrid.backgroundColor = color
    }
}
