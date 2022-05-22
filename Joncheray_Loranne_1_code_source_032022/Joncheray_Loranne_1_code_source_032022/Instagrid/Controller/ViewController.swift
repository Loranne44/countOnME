//
//  ViewController.swift
//  Instagrid
//
//  Created by Loranne Joncheray on 18/02/2022.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //=====
    //MODEL
    //=====
    
    var currentTappedTag = 0
    
    // Outlet for view in middle view
    @IBOutlet weak var downLeftView: UIView!
    @IBOutlet weak var topLeftView: UIView!
    
    
    // Outlet for image selected
    @IBOutlet weak var selected1: UIImageView!
    @IBOutlet weak var selected2: UIImageView!
    @IBOutlet weak var selected3: UIImageView!
    
    // Outlet for swipe  left or up
    @IBOutlet weak var swipeLeft: UIImageView!
    @IBOutlet weak var swipeUp: UIImageView!
    @IBOutlet weak var labelSwipeUp: UILabel!
    @IBOutlet weak var labelSwipeLeft: UILabel!
    
    // Outlet for all views of the middle view
    @IBOutlet weak var imagePhotos: UIView!
    
    // Collection outlets for image view
    @IBOutlet var imageViews: [UIImageView]!
    
    // Define a default direction swipe
    private func defaultSwipe () {
        let swipDirection = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipDirection.direction = .up
        self.view.addGestureRecognizer(swipDirection)
    }
    
    //==========
    //CONTROLLER
    //==========
    
    // Layout of the views and the selected icon according to the user's choice
    @IBAction func buttonChangeLayout1(_ sender: UIButton) {
        downLeftView.isHidden = false
        topLeftView.isHidden = true
        selected1.isHidden = false
        selected2.isHidden = true
        selected3.isHidden = true
    }
    
    @IBAction func buttonChangeLayout2(_ sender: UIButton) {
        downLeftView.isHidden = true
        topLeftView.isHidden = false
        selected1.isHidden = true
        selected2.isHidden = false
        selected3.isHidden = true
    }
    
    @IBAction func buttonChangeLayout3(_ sender: UIButton) {
        downLeftView.isHidden = false
        topLeftView.isHidden = false
        selected1.isHidden = true
        selected2.isHidden = true
        selected3.isHidden = false
    }
    
    
    // Choose an image when user tap on a + button
    @IBAction private func addPhoto(_ sender: UIButton) {
        currentTappedTag = sender.tag
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSwipe()
    }
    
    // Detect screen orientation and display user indicator for swipe correctly
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let swipeDirection = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        
        let isLandscape =  UIDevice.current.orientation.isLandscape
        
        // Evaluates and executes a condition for is lanscape or not
        swipeDirection.direction = isLandscape ? .left : .up
        
        // Remove last gesture recognizer
        view.gestureRecognizers?.removeLast()
        
        // Add new gesture recognizer
        self.view.addGestureRecognizer(swipeDirection)
        
        // Determine if swipUp and swipLeft is hidden or not
        swipeUp.isHidden = isLandscape
        swipeLeft.isHidden = !isLandscape
        labelSwipeUp.isHidden = isLandscape
        labelSwipeLeft.isHidden = !isLandscape
    }
    
    // When swipe is detected
    @objc private func swiped(_ sender:UISwipeGestureRecognizer) {
        
        // Check if an imagePhoto is assigned to imageview
        guard let imageView = imagePhotos  else {
            return
        }
        
        // Turns the user's photo montage into an image
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { _ in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        
        // Stock value of heigh and width of the screen
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        // Define initial location of frame montage photo
        let initialLocation = imagePhotos.frame.origin
        
        //If user swipe up
        if sender.direction == .up {
            // Animation for disappears the frame montage photo from the screen
            UIView.animate(withDuration: 1, animations: {
                self.imagePhotos.frame.origin.y -= screenHeight
            }, completion: { (success) in
                if success {
                    self.setUpActivity(image: image, location: initialLocation)
                }
            })
        } else if sender.direction == .left { //If user swipe left
            // Animation for disappears the frame montage photo from the screen
            UIView.animate(withDuration: 1, animations: {
                self.imagePhotos.frame.origin.x -= screenWidth
            }, completion: { (success) in
                if success {
                    self.setUpActivity(image: image, location: initialLocation)
                }
            })
        }
    }
    
    // Launch iOS sharing screen and after, return initial position
    private func setUpActivity(image: UIImage, location: CGPoint?) {
        
        let imageToShare = [image]
        
        // Launch iOS sharing screen
        let activityViewController = UIActivityViewController(activityItems: imageToShare , applicationActivities: nil)
        
        // It's ok or cancel, animation return to initial position
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            UIView.animate(withDuration: 1) {
                if let point = location {
                    self.imagePhotos.frame.origin = point
                }
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // Put selected photo in the view at the right place
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Assign photo to the correct view using tapped tag
            let targetImageView = imageViews.first { imageView in
                imageView.tag == currentTappedTag
            }
            
            // Define which image and how it should be placed in the view
            targetImageView?.contentMode = .scaleAspectFill
            targetImageView?.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
