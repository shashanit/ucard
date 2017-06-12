//
//  CardLayout.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 3. 13..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit

let BottomPercent:CGFloat = 0.85

public enum SequenceStyle:Int {
    case normal
    case cover
}

class CardLayoutAttributes: UICollectionViewLayoutAttributes {
    var isExpand = false
    override func copy(with zone: NSZone? = nil) -> Any {
        let attribute = super.copy(with: zone) as! CardLayoutAttributes
        attribute.isExpand = isExpand
        return attribute
    }
}

class CardLayout: UICollectionViewLayout {
    fileprivate var insertPath = [IndexPath]()
    fileprivate var deletePath = [IndexPath]()
    fileprivate var attributeList:[CardLayoutAttributes]!
    fileprivate var bottomDisplaySet = [Int]()
    var showStyle:SequenceStyle = .cover {
        didSet {
            self.collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    var _selected = -1
    var selected:Int {
        set {
            
            if self.collectionView?.numberOfItems(inSection: 0) == 1 {
                self.collectionView?.isScrollEnabled = false
                _selected = 0
            } else if selected >= 0 && newValue >= 0 {
                self.collectionView?.isScrollEnabled = true
                _selected = -1
            } else {
                if newValue >= 0 {
                    self.collectionView?.isScrollEnabled = false
                }
                _selected = newValue
            }
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadData()
            }, completion: nil)
        } get {
            return _selected
        }
    }
    
    var bottomDisplayCount = 6
    
    var isFullScreen = false {
        didSet {
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadData()
            }, completion: nil)
        }
    }
    
    var marginHeight:CGFloat = 56.0 { // the height that shows the card
        didSet {
            self.collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    lazy var cellSize:CGSize = {
        let w = self.collectionView!.bounds.width
        //let h:CGFloat = self.collectionView!.bounds.width * 0.618
        let h:CGFloat = self.collectionView!.bounds.width * 0.525 // card ratio
        let size = CGSize.init(width: w, height: h)
        return size
    }()
    
    override var collectionViewContentSize: CGSize {
        set {}
        get {
            let count = self.collectionView!.numberOfItems(inSection: 0)
            let contentHeight = marginHeight*CGFloat(count-1) + cellSize.height
            return CGSize.init(width: cellSize.width, height: contentHeight )
        }
    }
    
    override func prepare() {
        super.prepare()
        self.attributeList = self.generateAttributeList()
    }
    
    private func generateAttributeList() -> [CardLayoutAttributes] {
        
        var arr = [CardLayoutAttributes]()
        let count = self.collectionView!.numberOfItems(inSection: 0)
        var bottomIdx:CGFloat = 0
        bottomDisplaySet = self.bottomIdxArr()
        
        for i in 0..<count {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = CardLayoutAttributes.init(forCellWith: indexPath)
            attr.zIndex = i
            if selected < 0 {
                self.setNoSelect(attribute: attr)
            } else if selected == i{
                self.setSelect(attribute: attr)
            } else {
                self.setBottom(attribute: attr, bottomIndex: &bottomIdx)
            }
            arr.append(attr)
        }
        return arr
    }
    
    private func setNoSelect(attribute:CardLayoutAttributes) {
        
        let shitIdx = Int(self.collectionView!.contentOffset.y/marginHeight)
        let index = attribute.indexPath.row
        var currentFrame = CGRect.zero
        currentFrame = CGRect(x: self.collectionView!.frame.origin.x, y: marginHeight * CGFloat(index), width: cellSize.width, height: cellSize.height)
        switch showStyle {
        case .cover:
            if index <= shitIdx && (index >= shitIdx-2) || index == 0{
                attribute.frame = CGRect(x: currentFrame.origin.x, y: self.collectionView!.contentOffset.y, width: cellSize.width, height: cellSize.height)
            } else if index <= shitIdx-2 && currentFrame.maxY > self.collectionView!.contentOffset.y{
                currentFrame.origin.y -= (currentFrame.maxY - self.collectionView!.contentOffset.y)
                attribute.frame = currentFrame
            }else {
                attribute.frame = currentFrame
            }
        case .normal:
            attribute.frame = currentFrame
        }
    }
    
    fileprivate func setSelect(attribute:CardLayoutAttributes) {
        attribute.isExpand = true
        // 0.01 prevent no reload
        attribute.frame = CGRect.init(x: self.collectionView!.frame.origin.x, y: self.collectionView!.contentOffset.y+0.01 , width: cellSize.width, height: cellSize.height)
    }
    
    fileprivate func setBottom(attribute:CardLayoutAttributes, bottomIndex:inout CGFloat) {
        let index = attribute.indexPath.row
        let currentFrame = CGRect(x: self.collectionView!.frame.origin.x, y: marginHeight * CGFloat(index), width: cellSize.width, height: cellSize.height)
        let baseHeight = self.collectionView!.contentOffset.y + collectionView!.bounds.height * 0.90
        let bottomMargin = cellSize.height  * 0.3
        let margin:CGFloat = bottomMargin/CGFloat(bottomDisplayCount)
        attribute.isExpand = false
        let maxY = self.collectionView!.contentOffset.y + self.collectionView!.frame.height
        let contentFrame = CGRect(x: 0, y: self.collectionView!.contentOffset.y, width: self.collectionView!.frame.width, height: maxY)
        
        if bottomDisplaySet.contains(index) {
            let yPos = (self.isFullScreen) ? (self.collectionView!.contentOffset.y + collectionView!.bounds.height) : bottomIndex * margin + baseHeight
            attribute.frame = CGRect.init(x: 0, y: yPos, width: cellSize.width, height: cellSize.height)
            bottomIndex += 1
        } else if contentFrame.intersects(currentFrame)  {
            attribute.frame = CGRect.init(x: 0, y: maxY, width: cellSize.width, height: cellSize.height)
        }else {
            attribute.frame = CGRect(x: 0, y: marginHeight * CGFloat(index), width: cellSize.width, height: cellSize.height)
        }
    }
    
    fileprivate func bottomIdxArr() -> [Int] {
        
        if selected == -1 { return [Int]() }
        
        let count = self.collectionView!.numberOfItems(inSection: 0) - 1
        
        let half = Int(bottomDisplayCount/2)
        var min = selected - half
        var max = selected + half
        
        if selected - half < 0 {
            min = 0
            max = selected + half + abs(selected-half)
        } else if selected + half > count {
            min = count - 2*half
            max = count
        }
        
        return Array(min...max).filter({ (value) -> Bool in
            return value > 0 && value != selected
        })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributeList[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr =  attributeList.filter { (layout) -> Bool in
            return layout.frame.intersects(rect)
        }
        
        return arr
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        
        let at = (itemIndexPath.row > attributeList.count-1) ? super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) :attributeList[itemIndexPath.row]
        if self.deletePath.contains(itemIndexPath) {
            let randomLoc = (itemIndexPath.row%2 == 0) ? 1 : -1
            let x = self.collectionView!.frame.width * CGFloat(randomLoc)
            
            at?.transform = CGAffineTransform.init(translationX: x, y: 0)
        }
        
        return at
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let at = (itemIndexPath.row > attributeList.count-1) ? super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) :attributeList[itemIndexPath.row]
        if self.insertPath.contains(itemIndexPath) {
            let randomLoc = (itemIndexPath.row%2 == 0) ? 1 : -1
            let x = self.collectionView!.frame.width * CGFloat(randomLoc)
            
            at?.transform = CGAffineTransform.init(translationX: x, y: 0)
        }
        
        return at
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        deletePath.removeAll()
        insertPath.removeAll()
        for update in updateItems {
            if update.updateAction == .delete {
                
                let path = (update.indexPathBeforeUpdate != nil) ? update.indexPathBeforeUpdate : update.indexPathAfterUpdate
                if let p = path {
                    deletePath.append(p)
                }
            } else if let path = update.indexPathAfterUpdate, update.updateAction == .insert {
                insertPath.append(path)
            }
        }
    }
}
