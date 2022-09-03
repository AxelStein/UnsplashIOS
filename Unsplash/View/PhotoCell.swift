//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    
    func setPhoto(_ photo: Photo) {
        URLSession.shared.dataTask(with: photo.smallPhotoURL) { data, res, err in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.photoView.image = image
                }
            } else if let err = err {
                print(err)
            }
        }.resume()
    }
}
