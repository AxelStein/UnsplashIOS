//
//  SearchPhotosViewController.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import UIKit

class SearchPhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let searchPhotos = SearchPhotosInteractor()
    private var photos = [Photo]()
    private let columnCount = 3
    private var page = 1
    private var pageCount = -1
    private var isFetching = false
    
    override func viewDidLoad() {
        fetch()
    }
    
    private func fetch() {
        if !isFetching && (page == 1 || (page > 1 && page < pageCount)) {
            isFetching = true
            print("loading page \(page)...")
            searchPhotos.invoke(SearchRequest(query: "turtle", page: page)) { result in
                self.isFetching = false
                switch result {
                case .success(let results):
                    print("loaded \(results.results.count)")
                    self.pageCount = results.totalPages
                    self.photos += results.results
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
            page += 1
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 && page < pageCount {
            fetch()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let url = photos[indexPath.row].smallPhotoURL {
            photoLoader.cancel(for: url)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoView.image = nil

        let item = photos[indexPath.row]
        cell.photoId = item.id
        
        if let url = item.smallPhotoURL {
            photoLoader.load(url: url, photo: item) { fetchedPhoto, image in
                if cell.photoId == fetchedPhoto.id {
                    cell.photoView.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 4 * (columnCount + 1)
        let width = collectionView.frame.width - CGFloat(spacing)
        let itemSize = width / CGFloat(columnCount)
        return CGSize(width: itemSize, height: itemSize)
    }
}
