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
    
        // create a new image view for the grid
    var editingImage: UIImageView!
        
        // add identical buttons and identical images view of the grid
    @IBOutlet var buttonsInsertImage: [UIButton]!
    @IBOutlet var imagesAdded: [UIImageView]!
    
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
        imagesAdded.forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.contentMode = .scaleAspectFill
        }
        
        // activate swipe up than the image grid is completed
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
       
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    // tap one of three buttons to modify the template
    @IBAction func templateOneUpTwoBottom(_ sender: UIButton) {
        deletedViewUp.isHidden = true
        deletedViewBottom.isHidden = false
        buttonTemplateToCheck(name: buttonOneUpTwoBottom,image1: "Layout-1-check.png", image2: "Layout-2.png", image3: "Layout-3-check.png")
    }
    @IBAction func templateTwoUpOneBottom(_ sender: UIButton) {
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = true
        buttonTemplateToCheck(name: buttonTwoUpOneBottom,image1: "Layout-1.png", image2: "Layout-2-check.png", image3: "Layout-3-check.png")
    }
    @IBAction func templateTwoUpTwoBottom(_ sender: UIButton) {
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = false
        buttonTemplateToCheck(name: buttonTwoUpTwoBottom, image1: "Layout-1.png", image2: "Layout-2.png", image3: "Layout-3-check.png")
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
    
    
    func buttonFrontBack (name button: UIButton, imageCheck: String) {
            let pushAndMove = CASpringAnimation(keyPath: "transform.scale")
            pushAndMove.duration = 0.2
            pushAndMove.autoreverses = true
            pushAndMove.damping = 1
            pushAndMove.initialVelocity = 0.3
            
            button.layer.add(pushAndMove, forKey: nil)
            button.setImage(UIImage(named: imageCheck), for: .normal)
            UIView.transition(with: button, duration: 0.2, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
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
        print(myButtonTag)
        editingImage = imagesAdded[myButtonTag]
        addNewImage()
        buttonsInsertImage[myButtonTag].setImage(nil, for: .normal)
        buttonsInsertImage[myButtonTag].backgroundColor = .red
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
        if gesture.direction == .up {
            let imageToShare = viewGrid.screenshot()
            print("to infinity and beyond! Up up up, share the photo")
            let shareController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            present(shareController, animated: true, completion: nil)
        }
        
        else if gesture.direction == .left {
            print("Left ]->[")
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
