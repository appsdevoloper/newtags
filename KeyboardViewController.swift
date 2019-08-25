//
//  HomeViewController.swift
//  Demo
//
//  Created by Apple on 29/07/19.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit
import NextGrowingTextView

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myLabel: UILabel!
}

class KeyboardViewController: UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
   
  @IBOutlet weak var collectionview: UICollectionView!
  @IBOutlet weak var inputContainerView: UIView!
  @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
  @IBOutlet weak var growingTextView: NextGrowingTextView!
  @IBOutlet var toolbarview: UIView!
  @IBOutlet weak var cornerView: UIView!
  
  let reuseIdentifier = "cell"
  var items = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    self.growingTextView.layer.cornerRadius = 4
    self.growingTextView.backgroundColor = UIColor.clear
    self.growingTextView.placeholderAttributedText = NSAttributedString(
      string: "Placeholder text",
      attributes: [
        .font: self.growingTextView.textView.font!,
        .foregroundColor: UIColor.gray
      ]
    )
    growingTextView.textView.inputAccessoryView = toolbarview
    
    // MARK: TapGesture For Self View
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.view.addGestureRecognizer(tap)
    
    // MARK: View Background
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
    //MARK:- Corner Radius of only two side of UIViews
    self.cornerView.roundCorners([.topLeft, .topRight], radius: 12)
    
    
  }
  
  @IBAction func sendAction(_ sender: Any) {
    self.growingTextView.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.growingTextView.becomeFirstResponder()
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    self.growingTextView.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  @objc func keyboardWillHide(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.inputContainerViewBottom.constant =  0
        UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
      }
    }
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.inputContainerViewBottom.constant = keyboardHeight
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
      }
    }
  }
  
    @IBAction func adAction(_ sender: Any) {
        let newIndexPath = IndexPath(item: items.count, section: 0)
        items.append("hello")
        collectionview.insertItems(at: [newIndexPath])
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        cell.myLabel.layer.cornerRadius = 2
        cell.myLabel.layer.masksToBounds = true
        cell.myLabel.text = self.items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print("You selected cell #\(indexPath.item)!")
      self.remove(index: indexPath.item)
    }
    
    func remove(index: Int) {
        items.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        collectionview.performBatchUpdates({
            self.collectionview.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.collectionview.reloadItems(at: self.collectionview.indexPathsForVisibleItems)
        })
    }
}

extension UIView {
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}

