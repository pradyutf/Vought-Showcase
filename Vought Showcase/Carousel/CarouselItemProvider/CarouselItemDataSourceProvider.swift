//
//  CarouselItemDataSourceProvider.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import Foundation

//class CarouselItemDataSourceProvider: CarouselItemDataSourceProviderType {
//    func items() -> [CarouselItem] {
//        return [
//            HomeLanderCarouselItem(),
//            MaeveCarouselItem(),
//            BlackNoirCarouselItem(),
//            ATrainCarouselItem(),
//        ]
//    }
//}

class CarouselItemDataSourceProvider {
    func items() -> [CarouselItem] {
        return [
            StoryItem(imageName: "billybutcher"),
            StoryItem(imageName: "frenchiee"),
            StoryItem(imageName: "hughie"),
            StoryItem(imageName: "mothersMilk")
        ]
    }
}
