//
//  CarouselItem.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

//import UIKit
//
///// Carousel item protocol
//protocol CarouselItem {
//    
//    /// Get controller
//    /// - Returns: UIViewController
//    func getController() -> UIViewController
//}

import UIKit

/// Carousel item protocol
protocol CarouselItem {
    /// The name of the image to display
    var imageName: String { get }
 
}

/// Concrete implementation of CarouselItem for story-like UI
struct StoryItem: CarouselItem {
    let imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
      
    }
}
