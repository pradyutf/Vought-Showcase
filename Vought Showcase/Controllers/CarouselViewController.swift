//
//  CarouselViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//
//
//import Foundation
//import UIKit
//
//
//final class CarouselViewController: UIViewController {
//    
//    /// Container view for the carousel
//    @IBOutlet private weak var containerView: UIView!
//    
//    /// Carousel control with page indicator
//    @IBOutlet private weak var carouselControl: UIPageControl!
//
//
//    /// Page view controller for carousel
//    private var pageViewController: UIPageViewController?
//    
//    /// Carousel items
//    private var items: [CarouselItem] = []
//    
//    /// Current item index
//    private var currentItemIndex: Int = 0 {
//        didSet {
//            // Update carousel control page
//            self.carouselControl.currentPage = currentItemIndex
//        }
//    }
//
//    /// Initializer
//    /// - Parameter items: Carousel items
//    public init(items: [CarouselItem]) {
//        self.items = items
//        super.init(nibName: "CarouselViewController", bundle: nil)
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initPageViewController()
//        initCarouselControl()
//    }
//    
//    
//    /// Initialize page view controller
//    private func initPageViewController() {
//
//        // Create pageViewController
//        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,
//        options: nil)
//
//        // Set up pageViewController
//        pageViewController?.dataSource = self
//        pageViewController?.delegate = self
//        pageViewController?.setViewControllers(
//            [getController(at: currentItemIndex)], direction: .forward, animated: true)
//
//        guard let theController = pageViewController else {
//            return
//        }
//        
//        // Add pageViewController in container view
//        add(asChildViewController: theController,
//            containerView: containerView)
//    }
//
//    /// Initialize carousel control
//    private func initCarouselControl() {
//        // Set page indicator color
//        carouselControl.currentPageIndicatorTintColor = UIColor.darkGray
//        carouselControl.pageIndicatorTintColor = UIColor.lightGray
//        
//        // Set number of pages in carousel control and current page
//        carouselControl.numberOfPages = items.count
//        carouselControl.currentPage = currentItemIndex
//        
//        // Add target for page control value change
//        carouselControl.addTarget(
//                    self,
//                    action: #selector(updateCurrentPage(sender:)),
//                    for: .valueChanged)
//    }
//
//    /// Update current page
//    /// Parameter sender: UIPageControl
//    @objc func updateCurrentPage(sender: UIPageControl) {
//        // Get direction of page change based on current item index
//        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentItemIndex ? .forward : .reverse
//        
//        // Get controller for the page
//        let controller = getController(at: sender.currentPage)
//        
//        // Set view controller in pageViewController
//        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
//        
//        // Update current item index
//        currentItemIndex = sender.currentPage
//    }
//    
//    /// Get controller at index
//    /// - Parameter index: Index of the controller
//    /// - Returns: UIViewController
//    private func getController(at index: Int) -> UIViewController {
//        return items[index].getController()
//    }
//
//}
//
//// MARK: UIPageViewControllerDataSource methods
//extension CarouselViewController: UIPageViewControllerDataSource {
//    
//    /// Get previous view controller
//    /// - Parameters:
//    ///  - pageViewController: UIPageViewController
//    ///  - viewController: UIViewController
//    /// - Returns: UIViewController
//    public func pageViewController(
//        _ pageViewController: UIPageViewController,
//        viewControllerBefore viewController: UIViewController) -> UIViewController? {
//            
//            // Check if current item index is first item
//            // If yes, return last item controller
//            // Else, return previous item controller
//            if currentItemIndex == 0 {
//                return items.last?.getController()
//            }
//            return getController(at: currentItemIndex-1)
//        }
//
//    /// Get next view controller
//    /// - Parameters:
//    ///  - pageViewController: UIPageViewController
//    ///  - viewController: UIViewController
//    /// - Returns: UIViewController
//    public func pageViewController(
//        _ pageViewController: UIPageViewController,
//        viewControllerAfter viewController: UIViewController) -> UIViewController? {
//           
//            // Check if current item index is last item
//            // If yes, return first item controller
//            // Else, return next item controller
//            if currentItemIndex + 1 == items.count {
//                return items.first?.getController()
//            }
//            return getController(at: currentItemIndex + 1)
//        }
//}
//
//// MARK: UIPageViewControllerDelegate methods
//extension CarouselViewController: UIPageViewControllerDelegate {
//    
//    /// Page view controller did finish animating
//    /// - Parameters:
//    /// - pageViewController: UIPageViewController
//    /// - finished: Bool
//    /// - previousViewControllers: [UIViewController]
//    /// - completed: Bool
//    public func pageViewController(
//        _ pageViewController: UIPageViewController,
//        didFinishAnimating finished: Bool,
//        previousViewControllers: [UIViewController],
//        transitionCompleted completed: Bool) {
//            if completed,
//               let visibleViewController = pageViewController.viewControllers?.first,
//               let index = items.firstIndex(where: { $0.getController() == visibleViewController }){
//                currentItemIndex = index
//            }
//        }
//}



import Foundation
import UIKit

final class CarouselViewController: UIViewController {
    
    // MARK: - Properties
    
    private var containerView: UIView!
    private var segmentedProgressBar: SegmentedProgressBar!
    private var currentImageView: UIImageView!
    
    private var items: [CarouselItem] = []
    private var currentItemIndex: Int = 0
    
    // MARK: - Initialization
    
    init(items: [CarouselItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        showCurrentItem()
        //segmentedProgressBar.startAnimation()
    }
    
    
    
    // was causing the segments to not work as aspected before
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentedProgressBar.startAnimation()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Setup container view
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
       

        
        // Setup image view
        currentImageView = UIImageView()
        currentImageView.contentMode = .scaleAspectFill
        currentImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(currentImageView)
        NSLayoutConstraint.activate([
            currentImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            currentImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            currentImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            currentImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Setup segmented progress bar
        segmentedProgressBar = SegmentedProgressBar(numberOfSegments: items.count)
        segmentedProgressBar.delegate = self
        segmentedProgressBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(segmentedProgressBar)
        NSLayoutConstraint.activate([
            segmentedProgressBar.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 60),
            segmentedProgressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            segmentedProgressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            segmentedProgressBar.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        containerView.bringSubviewToFront(segmentedProgressBar)
       
    }
    
    // MARK: - Gesture Setup
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        containerView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.1 // Adjust as needed
        containerView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: containerView)
        let halfWidth = containerView.bounds.width / 2
        
        if tapLocation.x > halfWidth {
            moveToNextItem()
        } else {
            moveToPreviousItem()
        }
    }
    
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            segmentedProgressBar.isPaused = true
        case .ended, .cancelled:
            segmentedProgressBar.isPaused = false
        default:
            break
        }
    }

    
    // MARK: - Navigation
    
    private func moveToNextItem() {
        if currentItemIndex < items.count - 1 {
            currentItemIndex += 1
            showCurrentItem()
            segmentedProgressBar.skip()
        } else {
            // Handle end of story
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func moveToPreviousItem() {
        if currentItemIndex > 0 {
            currentItemIndex -= 1
            showCurrentItem()
            segmentedProgressBar.rewind()
        }
    }
    
    // MARK: - Content Display
    
    private func showCurrentItem() {
        let currentItem = items[currentItemIndex]
        currentImageView.image = UIImage(named: currentItem.imageName)
    }
}

// MARK: - SegmentedProgressBarDelegate

extension CarouselViewController: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        currentItemIndex = index
        showCurrentItem()
    }
    
    func segmentedProgressBarFinished() {
        // Handle end of story
        dismiss(animated: true, completion: nil)
    }
}
