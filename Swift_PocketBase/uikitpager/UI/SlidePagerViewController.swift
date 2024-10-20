//
//  SlidePagerViewController.swift
//  uikitpager
//
//  Created by User on 10/19/24.
//

import UIKit
import SnapKit

class SlidePagerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    private let bottomBar = UIView()
    var slideData: [SlideData] = []
    var currentIndex: Int = 0 // Track the current page index

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch slide data from API
        fetchSlidesData { [weak self] data in
            guard let data = data else { return }
            self?.slideData = data
            DispatchQueue.main.async {
                self?.setupPageViewController() // Setup after data is fetched
                self?.setupBottomBar()
            }
        }
    }

    func fetchSlidesData(completion: @escaping ([SlideData]?) -> Void) {
        let urlString = "http://127.0.0.1:8090/api/collections/images/records"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        // Perform the API request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error in API call: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // Decode the JSON response
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                let slideDataArray = apiResponse.items
                completion(slideDataArray) // Return the decoded items
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }

    func setupPageViewController() {
        // Initialize UIPageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        if let startingViewController = viewControllerAtIndex(currentIndex) {
            pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50) // Space for page control
        }

        pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor(red: 255/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1.0)
        pageControl.numberOfPages = slideData.count
        pageControl.currentPage = currentIndex // Set the current page to the tracked index
        pageControl.pageIndicatorTintColor = UIColor.white // Set inactive page indicator color
        pageControl.currentPageIndicatorTintColor = UIColor.gray // Set active page indicator color
        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }

        pageViewController.didMove(toParent: self)
    }
    
    private func setupBottomBar() {
        // Configure the bottom bar
        bottomBar.backgroundColor = UIColor(red: 255/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1.0) // Set the background color to yellow
        view.addSubview(bottomBar) // Add it to the view
        
        // Set constraints for the bottom bar
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // Align to the bottom
            make.height.equalTo(50) // Set a height for the bottom bar
        }
    }

    func viewControllerAtIndex(_ index: Int) -> PageContentViewController? {
        guard slideData.indices.contains(index) else { return nil }

        let slide = slideData[index]
        let slideContentVC = PageContentViewController()
        slideContentVC.imageURL = "http://127.0.0.1:8090/api/files/" + slide.collectionId + "/" + slide.id + "/" + slide.image
        slideContentVC.frontWord = slide.word
        slideContentVC.backWord = slide.translation
        slideContentVC.dateDescription = formatDate(slide.created) // Format the date

        // Set the page index on the content view controller
        slideContentVC.pageIndex = index

        return slideContentVC
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! PageContentViewController).pageIndex
        return index == 0 ? nil : viewControllerAtIndex(index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! PageContentViewController).pageIndex
        return index == slideData.count - 1 ? nil : viewControllerAtIndex(index + 1)
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first as? PageContentViewController {
            currentIndex = visibleViewController.pageIndex
            pageControl.currentPage = currentIndex // Update the current page index
        }
    }

    // Helper to format the date string from API
    func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString // Fallback to raw string if parsing fails
    }
}
