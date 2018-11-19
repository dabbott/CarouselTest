//
//  ViewController.swift
//  carousel-test-ios
//
//  Created by Devin Abbott on 11/19/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Vertical Carousel

    let verticalCarousel = LonaCollectionView(
      items: [
        VerticalItem.Model(),
        VerticalItem.Model(),
        VerticalItem.Model(),
      ],
      itemSpacing: 10)

    view.addSubview(verticalCarousel)

    verticalCarousel.backgroundColor = UIColor.gray

    verticalCarousel.translatesAutoresizingMaskIntoConstraints = false
    verticalCarousel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    verticalCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    verticalCarousel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true

//    verticalCarousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    verticalCarousel.widthAnchor.constraint(equalToConstant: 50).isActive = true

    // Horizontal Carousel

    let horizontalCarousel = LonaCollectionView(
      items: [
        HorizontalItem.Model(),
        HorizontalItem.Model(),
        HorizontalItem.Model(),
        ],
      scrollDirection: .horizontal,
      itemSpacing: 10)

    view.addSubview(horizontalCarousel)

    horizontalCarousel.backgroundColor = UIColor.lightGray

    horizontalCarousel.translatesAutoresizingMaskIntoConstraints = false
    horizontalCarousel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    horizontalCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    horizontalCarousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

//    horizontalCarousel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    horizontalCarousel.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
}

