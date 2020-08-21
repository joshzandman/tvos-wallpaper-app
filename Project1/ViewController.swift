//
//  ViewController.swift
//  Project1
//
//  Created by Josh Zandman on 8/20/20.
//  Copyright © 2020 Josh Zandman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var categories = ["Airplanes", "Beaches", "Cats", "Cities", "Dogs", "Earth", "Forests", "Galaxies", "Landmarks", "Mountains", "People", "Roads", "Sports", "Sunsets"]
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.textLabel?.text = categories[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "Images") as? ImagesViewController else { return }
    vc.category = categories[indexPath.row]
    present(vc, animated: true)
    
  }

}

