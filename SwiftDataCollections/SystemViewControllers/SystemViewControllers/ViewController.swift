//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Антон Шалимов on 09.02.2023.
//

import UIKit
import SafariServices
import Photos
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    var selectedImages: [UIImage] = []
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) } // filter for possible UIImages
        
        let dispatchGroup = DispatchGroup()
        var images = [UIImage]()
        
        for imageItem in imageItems {
            dispatchGroup.enter() // signal IN
            
            imageItem.loadObject(ofClass: UIImage.self) { image, _ in
                if let image = image as? UIImage {
                    images.append(image)
                }
                dispatchGroup.leave() // signal OUT
            }
        }
        
        // This is called at the end; after all signals are matched (IN/OUT)
        dispatchGroup.notify(queue: .main) {
            // DO whatever you want with `images` array
            self.selectedImages = images
            self.imageView.image = images.first
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet var imageView: UIImageView!
    
    func sayPuk(alert: UIAlertAction) {
        print("Puk Puk")
    }
    
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "https://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        var phpicker = PHPickerConfiguration()
        phpicker.selectionLimit = 1
        //        phpicker.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        phpicker.filter = PHPickerFilter.images
        let vc = PHPickerViewController(configuration: phpicker)
        // Получаем коллбек для результатов выбора пользователя
        vc.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } )
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.present(vc, animated: true)
        })
        let pukAction = UIAlertAction(title: "Puk", style: .destructive, handler: sayPuk)
        
        alertController.addAction(cancelAction)
        alertController.addAction(pukAction)
        alertController.addAction(photoLibraryAction)
        
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
    }
    
    
}

