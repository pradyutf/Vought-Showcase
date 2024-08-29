//
//  CarouselViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//


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
        longPressGesture.minimumPressDuration = 0.1
        containerView.addGestureRecognizer(longPressGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDownGesture.direction = .down
        containerView.addGestureRecognizer(swipeDownGesture)
        
        //longPressGesture.require(toFail: swipeDownGesture)
        
        // Set the delegate for both gestures
        longPressGesture.delegate = self
        swipeDownGesture.delegate = self

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
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
            if gesture.state == .ended {
                dismiss(animated: true, completion: nil)
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

extension CarouselViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow simultaneous recognition of long press and swipe down gestures
        if (gestureRecognizer is UILongPressGestureRecognizer && otherGestureRecognizer is UISwipeGestureRecognizer) ||
           (gestureRecognizer is UISwipeGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer) {
            return true
        }
        return false
    }
}
