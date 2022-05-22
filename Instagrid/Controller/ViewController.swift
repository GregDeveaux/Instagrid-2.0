//
//  ViewController.swift
//  Instagrid
//
//  Created by Greg-Mini on 12/05/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate {
    
        // Reusing LaunchScreen logo and gradient for animation
    lazy var logoInstagrid: UIImageView = {
        let logoInstagrid = UIImageView(image: UIImage(named: "LogoInstagrid"))
        logoInstagrid.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        logoInstagrid.center = self.view.center
        return logoInstagrid
    }()
    let backgroundGradient = UIImageView(image: UIImage(named: "BackgroundLaunchScreen"))
    
        // create a new Instagrid
    var instaGrid = InstaGrid()
    
        //add swipe label
    @IBOutlet weak var swipeLabel: UILabel!
    
        // create a new image view for the grid
    var editingImage: UIImageView!
        
        // add identical buttons and identical images view of the grid
    @IBOutlet var buttonsInsertImage: [UIButton]!
    @IBOutlet weak var imageUpLeft: UIImageView!
    @IBOutlet weak var imageUpRight: UIImageView!
    @IBOutlet weak var imageBottomLeft: UIImageView!
    @IBOutlet weak var imageBottomRight: UIImageView!
    
        // add the global view grid
    @IBOutlet weak var viewGrid: UIView!
    
        // add buttons template
    @IBOutlet weak var buttonOneUpTwoBottom: UIButton!
    @IBOutlet weak var buttonTwoUpOneBottom: UIButton!
    @IBOutlet weak var buttonTwoUpTwoBottom: UIButton!
    
        // add anime to check as a card
    var buttonChecked = false
    
        // view deleted using templates buttons
    @IBOutlet weak var deletedViewBottom: UIView!
    @IBOutlet weak var deletedViewUp: UIView!
    
        // create a picker controller to load the images from camera
    var pickerUI: UIImagePickerController {
        let pickerUI = UIImagePickerController()
            // image picked can to modify
        pickerUI.allowsEditing = true
            // choose the type camera to take the square photo in the viewController "picker"
        pickerUI.sourceType = .camera
        pickerUI.cameraCaptureMode = .photo
        pickerUI.modalPresentationStyle = .currentContext
            // picker delegate for UIImagePicker want the messages to come this class
        pickerUI.delegate = self
        return pickerUI
    }
    
        // create a picker controller to load the images from photo library
    var pickerPH: PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let pickerPH = PHPickerViewController(configuration: configuration)
            // picker delegate for PHPickerView want the messages to come this class
        pickerPH.delegate = self
        return pickerPH
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
            // animation logoScreen
        view.addSubview(backgroundGradient)
        view.addSubview(logoInstagrid)
        logoInstagridRotation()
        
            // create the new instagrid
        instaGrid.newGrid()
        
            // add round corner for all the UIImageView
        roundCorner(imageUpLeft)
        roundCorner(imageUpRight)
        roundCorner(imageBottomLeft)
        roundCorner(imageBottomRight)

            // activate swipe up than the image grid is completed
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
            swipeLabel.text = "Swipe left to share"
        } else if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact {
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
            swipeLabel.text = "Swipe up to share"
        }
        
        // swipe for edit background color
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // tap one of three buttons to modify the template
    @IBAction func templateOneUpTwoBottom(_ sender: UIButton) {
        deletedViewUp.isHidden = true
        deletedViewBottom.isHidden = false
        buttonTemplateToCheck(name: buttonOneUpTwoBottom,image1: "Layout-1-check.png", image2: "Layout-2.png", image3: "Layout-3.png")
    }
    @IBAction func templateTwoUpOneBottom(_ sender: UIButton) {
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = true
        buttonTemplateToCheck(name: buttonTwoUpOneBottom,image1: "Layout-1.png", image2: "Layout-2-check.png", image3: "Layout-3.png")
    }
    @IBAction func templateTwoUpTwoBottom(_ sender: UIButton) {
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = false
        buttonTemplateToCheck(name: buttonTwoUpTwoBottom, image1: "Layout-1.png", image2: "Layout-2.png", image3: "Layout-3-check.png")
    }
    
    // round corner the UIImageView
    func roundCorner(_ image: UIImageView) {
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
    }
    
        // animate buttons template with check
    func buttonTemplateToCheck(name button: UIButton, image1: String, image2: String, image3: String) {
        buttonFrontBack(name: button, imageCheck: image1)
        buttonFrontBack(name: button, imageCheck: image2)
        buttonFrontBack(name: button, imageCheck: image3)
//        buttonOneUpTwoBottom.setImage(UIImage(named: image1), for: .normal)
//        buttonTwoUpOneBottom.setImage(UIImage(named: image2), for: .normal)
//        buttonTwoUpTwoBottom.setImage(UIImage(named: image3), for: .normal)
    }
    
    // animation button template
    func buttonFrontBack(name button: UIButton, imageCheck: String) {
            button.setImage(UIImage(named: imageCheck), for: .normal)
            UIView.transition(with: button, duration: 0.25, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
        }
    
    
    
        // animate with rotation and alpha the Instagrid logo
    func logoInstagridRotation() {
        
        let rotationTransform = CGAffineTransform(rotationAngle: 180)
        
        UIImageView.animate(withDuration: 2, delay: 0.8, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, animations: {
            self.logoInstagrid.transform = rotationTransform
        })
                
        UIImageView.animate(withDuration: 0.5, delay: 2.2, animations: {
            self.logoInstagrid.alpha = 0
            self.backgroundGradient.alpha = 0
        })
    }

    @IBAction func touchToInsertImage(_ sender: UIButton) {
        let myButtonTag = sender.tag
        print(sender.tag)
        switch myButtonTag {
            case 0:
                editingImage = imageUpLeft
            case 1:
                editingImage = imageUpRight
            case 2:
                editingImage = imageBottomLeft
            case 3:
                editingImage = imageBottomRight
            default:
                print("no photo")
        }
        addNewImage()
        print(myButtonTag)
        buttonsInsertImage[myButtonTag].setImage(UIImage(named: "empty"), for: .normal)
    }
    

    private func addNewImage() {
        let alert = UIAlertController(title: "Choose your image", message: "", preferredStyle: .actionSheet)
        
            // we shared photoLibrary for images
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
                // present new frame to select a photo in the library
            self.present(self.pickerPH, animated: true)
        }))

            // we shared photoLibrary for images
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (button) in
            // present new frame to take a photo with a camera
            self.present(self.pickerUI, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    

// recover the image and applied a fullscreen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        editingImage.image = chosenImage
        editingImage.contentMode = .scaleAspectFit

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // if that not fonctionnaly, to dismiss the view controller
        dismiss(animated: true)
    }
    
    // call the UIActivityViewController to share the grid
    @objc func swipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up || gesture.direction == .left {
            let imageToShare = viewGrid.screenshot()
            print("to infinity and beyond! Up up up, share the photo")
            let shareController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            present(shareController, animated: true, completion: nil)
        }
        
        else if gesture.direction == .right {
            print("Right ]<-[ color")
            selectorColorForBorderFrame()
        }
    }
    
    private func selectorColorForBorderFrame() {
        let pickerColor = UIColorPickerViewController()
        pickerColor.delegate = self
        present(pickerColor, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        viewGrid.backgroundColor = color
    }

}

extension ViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = editingImage.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.sync {
                    guard let self = self, let image = image as? UIImage, self.editingImage.image == previousImage else { return }
                    self.editingImage.image = image
                }
            }
        }
    }
}

extension UIView {
    // create a square screenshot of the imageGrid
  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
    }
  }

}
