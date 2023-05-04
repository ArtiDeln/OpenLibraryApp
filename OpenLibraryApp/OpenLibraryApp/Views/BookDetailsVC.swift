//
//  BookDetailsVC.swift
//  OpenLibraryApp
//
//  Created by Artyom Butorin on 21.04.23.
//

import UIKit
import Alamofire

class BookDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var book: Book!
    var bookDetail: BookDetail!
    var anotherBookDetail: AnotherBookDetail!
    
    // MARK: - GUI
    
    private(set) lazy var moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private(set) lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private(set) lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private(set) lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private(set) lazy var overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = book.title
        
        self.initView()
        self.constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchBookDetail()
    }
    
    private func initView() {
        self.view.addSubview(self.moviePosterImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.releaseDateLabel)
        self.view.addSubview(self.voteAverageLabel)
        self.view.addSubview(self.overviewTextView)
    }
    
    // MARK: - Configuration
    
    func fetchBookDetail() {
        let group = DispatchGroup()
        group.enter()
        AF.request("https://openlibrary.org/\(book.key).json")
            .responseDecodable(of: BookData.self) { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let bookData = try decoder.decode(BookDetail.self, from: data)
                    self.bookDetail = bookData
                    group.leave()
                } catch {
                    print("Error decoding books: \(error)")
                    group.leave()
                }
            }
        group.notify(queue: .main) {
            self.configureMovieDetails()
        }
    }
    
    private func configureMovieDetails() {
        self.titleLabel.text = book.title
        self.releaseDateLabel.text = "Release date: \(book.publishDate ?? 0)"
    // FIXME: - Error if the "description" in the json has a "value" item
        self.overviewTextView.text = "Overview: \(String(describing: bookDetail.description ?? ""))"
    // TODO: - Add a rating display.
        self.voteAverageLabel.text = "Vote average: \(String(describing: book.averageRating))"
        let posterPath = "https://covers.openlibrary.org/b/id/\(book.coverURL ?? 0).jpg"
        let url = URL(string: posterPath)
        self.moviePosterImageView.kf.setImage(with: url)
    }
    
    // MARK: - Constraints
    
    private func constraints() {
        self.moviePosterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(102)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(180)
        }
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.moviePosterImageView)
            $0.leading.equalTo(self.moviePosterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        self.releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.titleLabel)
            $0.trailing.equalTo(self.titleLabel)
        }
        self.voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(self.releaseDateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.releaseDateLabel)
        }
        self.overviewTextView.snp.makeConstraints {
            $0.top.equalTo(self.moviePosterImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}

