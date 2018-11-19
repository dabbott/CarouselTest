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

    let verticalCarousel = LonaCollectionView(
      items: [
        VerticalItem.Model(),
        VerticalItem.Model(),
        VerticalItem.Model(),
      ],
      itemSpacing: 20)

    view.addSubview(verticalCarousel)

    verticalCarousel.translatesAutoresizingMaskIntoConstraints = false
    verticalCarousel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    verticalCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    verticalCarousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    verticalCarousel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }


}

