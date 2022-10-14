//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import UIKit

class PhotoViewController: UITableViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var userPhotoView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        userNameLabel.text = photo.user.name
        descriptionLabel.text = photo.description
        likesLabel.text = "\(photo.likes) likes"
        if let userPhotoUrl = photo.user.photoUrl {
            photoLoader.load(url: userPhotoUrl, photo: photo) { _, image in
                self.userPhotoView.image = image
            }
        }
        if let photoUrl = photo.regularPhotoURL {
            photoLoader.load(url: photoUrl, photo: photo) { _, image in
                self.photoView.image = image
            }
        }
        createdAtLabel.text = photo.createdAt.dateText
    }
    
    @IBAction func zoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .ended {
            photoView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        if sender.state == .began || sender.state == .changed {
            let scale = sender.scale
            photoView.transform = photoView.transform.scaledBy(x: scale, y: scale)
            sender.scale = 1
        }
    }
    
    @IBAction func share(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [ self.photoView.image! ], applicationActivities: nil)
        present(vc, animated: true)
    }
}
