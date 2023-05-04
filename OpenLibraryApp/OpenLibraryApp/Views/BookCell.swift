//
//  BookCell.swift
//  OpenLibraryApp
//
//  Created by Artyom Butorin on 15.04.23.
//

import UIKit
import Kingfisher

class BookCell: UICollectionViewCell {

    private(set) var book: Book!

    // MARK: - GUI

    private(set) lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()

    private(set) lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initView()
        self.constraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.yearLabel)
    }

    func configure(with book: Book) {

        if let posterURL = URL(string: "https://covers.openlibrary.org/b/id/\(book.coverURL ?? 0).jpg") {
            self.posterImageView.kf.setImage(with: posterURL) }
        self.titleLabel.text = book.title
        self.yearLabel.text = "\(book.publishDate ?? 0)"

        self.book = book
    }

    func constraints() {
        self.posterImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(self.contentView.snp.width).offset(80) //40
        }
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.posterImageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
        }
        self.yearLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
    }
}
