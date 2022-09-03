//
//  ViewController.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchPhotos = SearchPhotosInteractor()
        searchPhotos.invoke(SearchRequest(query: "cat")) { result in
            switch result {
            case .success(let searchResults):
                print(searchResults)
            case .failure(let error):
                print(error)
            }
        }
    }
}

