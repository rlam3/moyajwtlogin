//
//  UserFeedViewController.swift
//  Midori
//
//  Created by Raymond Lam on 5/18/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
import CollectionViewWaterfallLayout


class UserFeedViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            
            _cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        
        return _cellSizes
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        if let label = cell.contentView.viewWithTag(1) as? UILabel {
            label.text = String(indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            
            if let view = reusableView {
                view.backgroundColor = UIColor.redColor()
            }
        }
        else if kind == CollectionViewWaterfallElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath)
            if let view = reusableView {
                view.backgroundColor = UIColor.blueColor()
            }
        }
        
        return reusableView!
    }
    
    // MARK: WaterfallLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
    
}