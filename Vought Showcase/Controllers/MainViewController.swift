//
//  ViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //initCarouselView()
    }
    
//    private func initCarouselView() {
//        // Create a carousel item provider
//        let carouselItemProvider = CarouselItemDataSourceProvider()
//        
//        // Create carouselViewController
//        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
//        
//        // Add carousel view controller in container view
//        add(asChildViewController: carouselViewController, containerView: containerView)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         initCarouselView()
     }
    
    private func initCarouselView() {
        // Create a carousel item provider
        let carouselItemProvider = CarouselItemDataSourceProvider()
        
        // Create carouselViewController
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        
        // Present the carouselViewController full screen
        carouselViewController.modalPresentationStyle = .fullScreen
        present(carouselViewController, animated: true, completion: nil)
    }
    
}

