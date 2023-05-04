//
//  MainVC+CollectionView.swift
//  OpenLibraryApp
//
//  Created by Artyom Butorin on 21.04.23.
//

import UIKit

extension MainVC: UICollectionViewDelegate,
                  UICollectionViewDataSource,
                  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell",
                                                            for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        let book: Book
        
        guard !self.books.isEmpty else { return UICollectionViewCell() }
        book = self.books[indexPath.item]
        
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2
        cell.configure(with: book)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width + 130)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedBook: Book
        
        selectedBook = books[indexPath.item]
        
        self.showBookDetails(for: selectedBook)
    }
    
    func showBookDetails(for book: Book) {
        let bookDetailsViewController = BookDetailsViewController()
        bookDetailsViewController.book = book
        present(bookDetailsViewController, animated: true)
    }
}

