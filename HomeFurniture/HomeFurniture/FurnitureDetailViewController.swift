
import UIKit
import SafariServices
import Photos
import PhotosUI

class FurnitureDetailViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
            // Retrieve image
            let image = images.first
            self.furniture?.imageData = image?.jpegData(compressionQuality: 0.9)
            self.photoImageView.image = image
        }
    }
    
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        // Configuring image picker (For camera support)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Configuring photo picker
        var photoPicker = PHPickerConfiguration()
        photoPicker.selectionLimit = 1
        photoPicker.filter = PHPickerFilter.images
        let photoSelectorViewController = PHPickerViewController(configuration: photoPicker)
        photoSelectorViewController.delegate = self
        
        // Configuring alert controller
        let alertController = UIAlertController(title: "Select or add new photo", message: "Select or take a new photo", preferredStyle: .actionSheet)
        // Create dismiss action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Create take photo srction
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } )
            alertController.addAction(cameraAction)
        }
        
        let selectPhotoAction = UIAlertAction(title: "Select from library", style: .default) { UIAlertAction in
            self.present(photoSelectorViewController, animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(selectPhotoAction)
        present(alertController, animated: true)
        
    }

    // Implementing delegate method for grabbing photo from camera and saving it
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as?
           UIImage else { return }
        
        self.photoImageView.image = selectedImage
        self.furniture?.imageData = selectedImage.jpegData(compressionQuality: 0.9)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
    }
    
}
