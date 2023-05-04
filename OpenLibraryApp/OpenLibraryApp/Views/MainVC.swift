//
//  MainVC.swift
//  OpenLibraryApp
//
//  Created by Artyom Butorin on 15.04.23.
//

import UIKit
import Alamofire

class MainVC: UIViewController {
    
    var books: [Book] = []
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
        return collectionView
    }()
    
    private(set) lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.fetchBooks()
        self.collectionViewSettings()
        self.constraints()
    }
    
    private func initView() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.loadingIndicator)
    }
    
    private func collectionViewSettings() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
    }
    
    func fetchBooks() {
        loadingIndicator.startAnimating()
        let group = DispatchGroup()
        group.enter()
        AF.request("https://openlibrary.org/trending/yearly.json")
            .responseDecodable(of: BookData.self) { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let bookData = try decoder.decode(BookData.self, from: data)
                    self.books = bookData.works
                    print(self.books)
                    group.leave()
                } catch {
                    print("Error decoding books: \(error)")
                    group.leave()
                }
            }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func constraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

