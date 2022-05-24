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
    
        // create a Instagrid
    var instaGrid = InstaGrid()
    
        // create a new image view for the grid
    var editingImage: UIImageView!
    
        //add swipe label
    @IBOutlet weak var swipeLabel: UILabel!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageLoaded), name: .didLoadImage, object: nil)
        
            // animation logoScreen
        view.addSubview(backgroundGradient)
        view.addSubview(logoInstagrid)
        logoInstagridRotation()
        
        instaGrid.newGrid()
            // add round corner for all the UIImageView
        roundCorner(imageUpLeft)
        roundCorner(imageUpRight)
        roundCorner(imageBottomLeft)
        roundCorner(imageBottomRight)
        
            // swipe for edit background color
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureColor(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
        // start new grid after share the screenshot template with the swipe
    private func startNewGrid() {
        instaGrid.newGrid()
    }
    
    @objc func imageLoaded(button number: Int) {
        buttonsInsertImage[instaGrid.currentNumberButton].setImage(UIImage(named: "empty"), for: .normal)
    }
    
    @objc func saveImageCompletedGrid() {
        guard instaGrid.state == .completed else {return}
            // activate swipe up than the image grid is completed
//        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureShare(_:)))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
            swipeLabel.text = "Swipe left to share"
//        } else if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact {
//            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureShare(_:)))
//            swipeUp.direction = .up
//            self.view.addGestureRecognizer(swipeUp)
//            swipeLabel.text = "Swipe up to share"
//        }
        startNewGrid()
    }
    
        //-------------------------------------------------------
        // MARK: buttons template
        //-------------------------------------------------------
    
        // tap one of three buttons to modify the template
    @IBAction func templateOneUpTwoBottom(_ sender: UIButton) {
        instaGrid.currentTemplate = .oneUpTwoBottom
        deletedViewUp.isHidden = true
        deletedViewBottom.isHidden = false
        allButtonTemplate()
    }
    @IBAction func templateTwoUpOneBottom(_ sender: UIButton) {
        instaGrid.currentTemplate = .twoUpOneBottom
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = true
        allButtonTemplate()
    }
    @IBAction func templateTwoUpTwoBottom(_ sender: UIButton) {
        instaGrid.currentTemplate = .twoUpTwoBottom
        deletedViewUp.isHidden = false
        deletedViewBottom.isHidden = false
        allButtonTemplate()
    }
    
    func allButtonTemplate() {
        switch instaGrid.currentTemplate {
            case .oneUpTwoBottom:
                buttonFrontBack(name: buttonOneUpTwoBottom, imageCheck: "Layout-1-check")
                buttonTwoUpOneBottom.setImage(UIImage(named: "Layout-2"), for: .normal)
                buttonTwoUpTwoBottom.setImage(UIImage(named: "Layout-3"), for: .normal)
                
            case .twoUpOneBottom:
                buttonOneUpTwoBottom.setImage(UIImage(named: "Layout-1"), for: .normal)
                buttonFrontBack(name: buttonTwoUpOneBottom, imageCheck: "Layout-2-check")
                buttonTwoUpTwoBottom.setImage(UIImage(named: "Layout-3"), for: .normal)
                
            case .twoUpTwoBottom:
                buttonOneUpTwoBottom.setImage(UIImage(named: "Layout-1"), for: .normal)
                buttonTwoUpOneBottom.setImage(UIImage(named: "Layout-2"), for: .normal)
                buttonFrontBack(name: buttonTwoUpTwoBottom, imageCheck: "Layout-3-check")
        }
    }
    
        // animation button template
    func buttonFrontBack(name button: UIButton, imageCheck: String) {
        button.setImage(UIImage(named: imageCheck), for: .normal)
        UIView.transition(with: button, duration: 0.25, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
        //-------------------------------------------------------
        // MARK: animations after LaunchScreen
        //-------------------------------------------------------
    
        // animate with rotation and alpha the Instagrid logo
    func logoInstagridRotation() {
            // integrate a rotation of 180°
        let rotationTransform = CGAffineTransform(rotationAngle: 180)
        
            // animate the logo with rebound
        UIImageView.animate(withDuration: 2, delay: 0.8, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, animations: {
            self.logoInstagrid.transform = rotationTransform
        })
        
            // then, the fake launchscreen disappears
        UIImageView.animate(withDuration: 0.5, delay: 2.2, animations: {
            self.logoInstagrid.alpha = 0
            self.backgroundGradient.alpha = 0
        })
    }
    
        //-------------------------------------------------------
        // MARK: buttons images
        //-------------------------------------------------------
    
        // round corner the UIImageView
    func roundCorner(_ image: UIImageView) {
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
    }
    
    @IBAction func touchToInsertImage(_ sender: UIButton) {
        let myButtonTag = sender.tag
        print(sender.tag)
        switch myButtonTag {
            case 0:
                instaGrid.currentNumberButton = 0
                editingImage = imageUpLeft
                print("imageUpLeft")
            case 1:
                instaGrid.currentNumberButton = 1
                editingImage = imageUpRight
                print("imageUpRight")
            case 2:
                instaGrid.currentNumberButton = 2
                editingImage = imageBottomLeft
                print("imageBottomLeft")
            case 3:
                instaGrid.currentNumberButton = 3
                editingImage = imageBottomRight
                print("imageBottomRight")
            default:
                print("no photo")
        }
        chooseNewImage()
        print(myButtonTag)
    }
    
        //-------------------------------------------------------
        // MARK: swipe to share the final screenshot
        //-------------------------------------------------------
    
        // swipe gesture to share the grid
    @objc func swipeGestureShare(_ gesture: UISwipeGestureRecognizer) {
            // if swipe up or left share the instagrid and begin a new grid
        if gesture.direction == .up || gesture.direction == .left {
            let imageToShare = viewGrid.screenshot()
            print("to infinity and beyond! Up! (or left) and share the photo")
            let shareController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            present(shareController, animated: true, completion: nil)
            startNewGrid()
        }
    }
    
    @objc func swipeGestureColor(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            print("Right ]<-[ color")
            selectorColorForBorderFrame()
        }
    }
    
        //-------------------------------------------------------
        // MARK: border frame color
        //-------------------------------------------------------
    
    private func selectorColorForBorderFrame() {
        let pickerColor = UIColorPickerViewController()
        pickerColor.delegate = self
        present(pickerColor, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        viewGrid.backgroundColor = color
        print("Color modified")
    }
    
        //-------------------------------------------------------
        // MARK: load the image (library or camera)
        //-------------------------------------------------------
    
    private func chooseNewImage() {
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
            // add new image in the array
        instaGrid.addImageInTheGrid(editingImage)
        print("image camera added")
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // if that not fonctionnaly, to dismiss the view controller
        dismiss(animated: true)
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
                        // add new image in the array
                    self.instaGrid.addImageInTheGrid(self.editingImage)
                    print("image library added")
                }
            }
        }
    }
}

    //-------------------------------------------------------
    // MARK: share final screenshot
    //-------------------------------------------------------

extension UIView {
        // create a square screenshot of the imageGrid
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
}
