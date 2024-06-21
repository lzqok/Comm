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
    public var minSpace: CGFloat = 10
    public var width: CGFloat = UIScreen.main.bounds.width - 80
    
    public override var collectionViewContentSize: CGSize {
        let width = CGFloat(self.layoutAttributes.count) * (width + minSpace) + minSpace + edgeInsets.left + edgeInsets.right
        guard let attribute = layoutAttributes.last else { return .zero}
        return CGSize(width: attribute.frame.maxX + (collectionView!.bounds.width - attribute.frame.width) / 2, height: attribute.frame.height)
    }
    
    public override func prepare() {
        super.prepare()
        layoutAttributes = [UICollectionViewLayoutAttributes]()
        guard let collectionView = collectionView else { return }
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: i, section: 0)
            if let layoutAttribute = self.layoutAttributesForItem(at: indexPath) {
                self.layoutAttributes.append(layoutAttribute)
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil}
        let visibleRect = CGRect(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        let centerX = collectionView.contentOffset.x + collectionView.frame.width / 2
        let maxDev = collectionView.frame.width / 2  + width / 2
        for layoutAttribute in layoutAttributes {
            if !visibleRect.intersects(layoutAttribute.frame) {
                continue
            }
            
//            let scale: CGFloat = 1 + (0.5 - abs(centerX - layoutAttribute.center.x)) / maxDev
//            layoutAttribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            
            
        }
        
        return layoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil}
        
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        var x: CGFloat = 0
        let y: CGFloat = edgeInsets.top
        let height: CGFloat = collectionView.frame.height - (edgeInsets.top + edgeInsets.bottom)
        
        if indexPath.row == 0 {
            x = (collectionView.bounds.width - width) / 2
        }else {
            x = self.layoutAttributes[indexPath.row - 1].frame.maxX + minSpace
        }
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        attr.frame = rect
        
        return attr
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return .zero }
        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        /// 当前屏幕中心在collectionview 上的 x
        let centerX = proposedContentOffset.x + collectionView.frame.width / 2
        
        let attrs = self.layoutAttributesForElements(in: lastRect)
        /// 偏移量
        var offset = CGFloat.greatestFiniteMagnitude
        for attribute in attrs! {
            let deviation = attribute.center.x - centerX
            if abs(deviation) < abs(offset) {
                offset = deviation
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offset, y: proposedContentOffset.y)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
