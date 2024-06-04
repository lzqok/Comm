//
//  GalleryLayout.swift
//  ECommon
//
//  Created by empty on 2024/5/22.
//

import UIKit

public class GalleryLayout: UICollectionViewLayout {
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    public var edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    public var minSpace = 5
    
    public override var collectionViewContentSize: CGSize {
        let width = CGFloat(self.layoutAttributes.count * 100) + edgeInsets.left + edgeInsets.right
        
        return CGSize(width: width, height: self.collectionView?.bounds.height ?? 0)
    }
    
    public override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: i, section: 0)
            if let layoutAttribute = self.layoutAttributesForItem(at: indexPath) {
                self.layoutAttributes.append(layoutAttribute)
            }
        }
        self.collectionView?.setContentOffset(CGPointMake(100, 0), animated: false)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil}
        
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        var x: CGFloat = CGFloat(self.layoutAttributes.count * (100 + minSpace) - minSpace)
        var y: CGFloat = edgeInsets.top
        var width: CGFloat = 100
        var height: CGFloat = collectionView.frame.height - (edgeInsets.top + edgeInsets.bottom)
        
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        attr.frame = rect
        
        return attr
    }
    
    
//    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
}
