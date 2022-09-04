//
//  SearchPhotosViewController.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import UIKit

class SearchPhotosViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let searchPhotos = SearchPhotosInteractor()
    var photos = [Photo]()
    let columnCount = 3
    var page = 1
    var pageCount = -1
    var isFetching = false
    var currentQuery = ""
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }
    
    private func fetch() {
        if currentQuery.isEmpty {
            return
        }
        if !isFetching && (page == 1 || (page > 1 && page < pageCount)) {
            isFetching = true
            print("loading page \(page)/\(pageCount) for query \(currentQuery)...")
            searchPhotos.invoke(SearchRequest(query: currentQuery, page: page)) { result in
                self.isFetching = false
                switch result {
                case .success(let results):
                    print("loaded \(results.results.count)")
                    self.pageCount = results.totalPages
                    self.photos += results.results
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    self.page -= 1
                    if self.page < 1 {
                        self.page = 1
                    }
                }
            }
            page += 1
        }
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        let q = searchBar.text ?? ""
        if q.isEmpty {
            return
        }
        
        currentQuery = q
        if !photos.isEmpty {
            collectionView.scrollToItem(at: [0, 0], at: .top, animated: false)
        }
        photos = [Photo]()
        page = 1
        pageCount = -1
        isFetching = false
        fetch()
    }
}

extension SearchPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 && page < pageCount {
            fetch()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            let vc = segue.destination as! PhotoViewController
            if let indexPath = collectionView.indexPathsForSelectedItems?.first,
               let item = getItem(at: indexPath) {
                vc.photo = item
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let item = getItem(at: indexPath), let url = item.smallPhotoURL {
            photoLoader.cancel(for: url)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoView.image = nil

        if let item = getItem(at: indexPath), let url = item.smallPhotoURL {
            cell.photoId = item.id
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
    
    private func getItem(at indexPath: IndexPath) -> Photo? {
        if photos.indices.contains(indexPath.row) {
            return photos[indexPath.row]
        }
        return nil
    }
}
