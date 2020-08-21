//
//  ImagesViewController.swift
//  Project1
//
//  Created by Josh Zandman on 8/20/20.
//  Copyright © 2020 Josh Zandman. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

  @IBOutlet var spinner: UIActivityIndicatorView!
  @IBOutlet var creditLabel: UILabel!
  
  var category = ""
  var appID = "jfjLRY_Qy7mJPY-Q2G__9BNU4AtRdtVM491tNHYOIjA"
  
  var imageViews = [UIImageView]()
  var images = [JSON]()
  var imageCounter = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    imageViews = view.subviews.compactMap { $0 as? UIImageView }
    imageViews.forEach { $0.alpha = 0 }
    creditLabel.layer.cornerRadius = 15
    
    guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(appID)&query=\(category)&per_page=100") else { return }
    
    DispatchQueue.global(qos: .userInteractive).async {
      self.fetch(url)
    }
  }
  
  func fetch(_ url: URL) {
    if let data = try? Data(contentsOf: url) {
      let json = JSON(data)
      images = json["results"].arrayValue
      downloadImage()
    }
  }
  
  func downloadImage() {
    let currentImage = images[imageCounter % images.count]
    let imageName = currentImage["urls"]["full"].stringValue
    let imageCredit = currentImage["user"]["name"].stringValue
    imageCounter += 1
    
    guard let imageURL = URL(string: imageName) else { return }
    guard let imageData = try? Data(contentsOf: imageURL) else { return }
    guard let image = UIImage(data: imageData) else { return }
    
    DispatchQueue.main.async {
      self.show(image, credit: imageCredit)
    }
  }
  
  func show(_ image: UIImage, credit: String) {
    spinner.stopAnimating()

    let imageViewToUse = imageViews[imageCounter % imageViews.count]
    let otherImageView = imageViews[(imageCounter + 1) % imageViews.count]

    UIView.animate(withDuration: 2.0, animations: {
      imageViewToUse.image = image
      imageViewToUse.alpha = 1
      self.creditLabel.alpha = 0

      self.view.sendSubviewToBack(otherImageView)
    }) { _ in
      self.creditLabel.text = "  \(credit.uppercased())"
      self.creditLabel.alpha = 1
      otherImageView.alpha = 0
      otherImageView.transform = .identity

      UIView.animate(withDuration: 10.0, animations: {
          imageViewToUse.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      }) { _ in
        DispatchQueue.global(qos: .userInteractive).async {
          self.downloadImage()
        }
      }
    }
  }
}
