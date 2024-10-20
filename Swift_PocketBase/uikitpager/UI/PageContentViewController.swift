//
//  PageContentViewController.swift
//  uikitpager
//
//  Created by User on 10/19/24.
//

import UIKit
import SnapKit
import SwiftUI

class PageContentViewController: UIViewController {
    
    // MARK: Properties
    var pageIndex: Int = 0
    var imageURL: String = ""
    var frontWord: String = ""
    var backWord: String = ""
    var dateDescription: String = ""

    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()

    // MARK: UI Elements
    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
        setupScrollView()
    }
    
    func getBoldFirstLetterString(from text: String) -> String {
        let boldedLetter = String(text.prefix(1)).uppercased()
        let remainingText = String(text.dropFirst())
        
        // Return a string with the first letter bolded using HTML formatting
        return "\(boldedLetter)\(remainingText)"
    }

    
    // Load image from a URL
    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Fetch the image asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors and valid data
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Couldn't load image from data")
                return
            }

            // Set the image on the main thread
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume() // Start the task
    }

    private func setupUI() {
        // Configure ImageView
        view.addSubview(imageView)
        imageView.layer.cornerRadius = 30 // Set the desired corner radius
        imageView.layer.masksToBounds = true // Ensure the corners are clipped
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(300)
        }

        // Load image from URL
        loadImage(from: imageURL, into: imageView)

        // Add Flashcard (SwiftUI component) to UIViewController
        let flashcard = Flashcard(frontWord: getBoldFirstLetterString(from: frontWord), backWord:  getBoldFirstLetterString(from: backWord))
        let flashcardHostingController = UIHostingController(rootView: flashcard)
        addChild(flashcardHostingController)
        view.addSubview(flashcardHostingController.view)
        flashcardHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(250)
        }
        flashcardHostingController.didMove(toParent: self)
        
        let formattedDate = formatDate(from: dateDescription)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.text = formattedDate
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        descriptionLabel.textColor = .black
        
        // Add border to the description label
        descriptionLabel.layer.borderColor = UIColor.gray.cgColor // Set border color
        descriptionLabel.layer.borderWidth = 1.0 // Set border width
        descriptionLabel.layer.cornerRadius = 8 // Optional: set corner radius for rounded corners
        descriptionLabel.layer.masksToBounds = true // Clip the bounds to match corner radius
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(flashcardHostingController.view.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
        }
    }

    private func setupScrollView() {
        // Configure ScrollView
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self // Set delegate
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // Set constraints for scrollView
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func formatDate(from dateString: String) -> String {
        let inputFormatter = createDateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss.SSSZ") // Input format
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = createDateFormatter(withFormat: "MM/dd/yyyy") // Desired output format
            return outputFormatter.string(from: date)
        }
        return dateString // Return original string if parsing fails
    }
    
    func createDateFormatter(withFormat format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")  // Use POSIX for consistent parsing
        return dateFormatter
    }
}

// MARK: UIScrollViewDelegate
extension PageContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This function can be removed if you are not using it for anything
    }
}
