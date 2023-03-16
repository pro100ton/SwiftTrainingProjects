//
//  ViewController.swift
//  ISpy
//
//  Created by Антон Шалимов on 04.02.2023.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateZoomFor(size: CGSize) {
        // MARK: Note: the code underneath calculating the scale, necessary to show the entire image on screen, depending on what is smaller by setting scale to minimum of twos. Then it set the min zoom scale to not allow user to zoom out alot and set current zoom scale to fit entire image on screen
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateZoomFor(size: view.bounds.size)
    }

    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
}

