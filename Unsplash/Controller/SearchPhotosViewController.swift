//
//  SearchPhotosViewController.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import UIKit

class SearchPhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let searchPhotos = SearchPhotosInteractor()
    private var searchResults: SearchResults? = nil
    private let columnCount = 3
    
    override func viewDidLoad() {
        print("loading...")
        searchPhotos.invoke(SearchRequest(query: "cat")) { result in
            switch result {
            case .success(let results):
                print("loaded \(results.results.count)")
                self.searchResults = results
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchResults != nil ? 1 : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let item = searchResults?.results[indexPath.row] {
            cell.setPhoto(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 4 * (columnCount + 1)
        let width = collectionView.frame.width - CGFloat(spacing)
        let itemSize = CGFloat(width / 3)
        return CGSize(width: itemSize, height: itemSize)
    }
}
