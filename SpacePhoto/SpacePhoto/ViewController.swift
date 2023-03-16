//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Антон Шалимов on 15.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var nasaImageView: UIImageView!
    @IBOutlet var pictureDescription: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    // MARK: Properties
    /// Property инстанса класса `PhotoInfoController` через которую можно выполнять запросы
    let photoInfoController = PhotoInfoController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureDescription.text = "sample description"
        copyrightLabel.text = "sample copyright"
        nasaImageView.image = UIImage(systemName: "photo.on.rectangle")
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    // MARK: Helper functions
    
    func updateUI(with photoInfo: PhotoInfo) {
        Task {
            do {
                let image = try await photoInfoController.fetchPhotoImage(from: photoInfo.url)
                self.title = photoInfo.title
                self.nasaImageView.image = image
                pictureDescription.text = photoInfo.description
                copyrightLabel.text = photoInfo.copyright
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    func updateUI(with error: Error) {
        self.title = "Error while fetching photo"
        self.nasaImageView.image = UIImage(systemName: "exclamationmarl.octagon")
        self.pictureDescription.text = error.localizedDescription
        copyrightLabel.text = ""
    }


}

