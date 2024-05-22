//
//  WaterFlowLayout.swift
//  EmptyCommon
//
//  Created by empty on 2024/5/14.
//

import UIKit

@objc
public protocol CasadeFlowLayoutDelegate: NSObjectProtocol {
    /// section 一屏占几列或行
    func casadeFlowLayoutColum(section:Int)->Int
    func casadeFlowLayoutSize(indexPath:IndexPath)->CGFloat
    @objc optional func casadeFlowLayoutHeaderSize(indexPath:IndexPath)->CGFloat
    @objc optional func casadeFlowLayoutFooterSize(indexPath:IndexPath)->CGFloat
}

@objcMembers
public class CasadeFlowLayout: UICollectionViewLayout {
    
    public enum ScrollDirection {
        case horizontal
        case vertical
    }
    private var columMaxXYs = [[CGFloat]]() //每列最大Y
    private var attrsArray = [[UICollectionViewLayoutAttributes]] ()
    public var miniRow:CGFloat = 5 //item之间的行间距
    public var minColum:CGFloat = 5 // item 之间的列间距
    public var sectionEdgeInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    private var colums:[Int] = [Int]() //每个section 一行占多少列
    public var scrollDirection:ScrollDirection = .vertical //collectionView滚动方向
    private var tempAttrs = [[UICollectionViewLayoutAttributes]]()
    public weak var delegate: CasadeFlowLayoutDelegate?

    
    public override var collectionViewContentSize:CGSize{
        var destMaxY = columMaxXYs[0][0]
        for i in 0..<columMaxXYs.count {
            for j in 0..<columMaxXYs[i].count {
                if destMaxY < columMaxXYs[i][j] {
                    destMaxY = columMaxXYs[i][j]
                }
            }
            
        }
        if scrollDirection == .vertical {
            let with = collectionView?.bounds.size.width ?? 0
            return CGSize(width:with,height:destMaxY+sectionEdgeInset.bottom)
        }else {
            let height = collectionView?.bounds.size.height ?? 0
            return CGSize(width:destMaxY+sectionEdgeInset.left,height:height)
        }
    }
    
    public override func prepare() {
        super.prepare()
        colums = [Int]()
        self.columMaxXYs.removeAll()
        attrsArray.removeAll()
        let sectionCount = self.collectionView!.numberOfSections
        for j in 0..<sectionCount{
            
            self.columMaxXYs.append([CGFloat]())
            attrsArray.append([UICollectionViewLayoutAttributes]())
            let indexPath = IndexPath.init(row: 0, section: j)
            let colum = self.delegate?.casadeFlowLayoutColum(section: indexPath.section) ?? 0
            setHeader(colum:colum,indexPath: indexPath)
            
            let count = self.collectionView!.numberOfItems(inSection: j)
            for i in 0..<count {
                let indexPath = IndexPath.init(item: i, section: j)
                let attributes = self.layoutAttributesForItem(at: indexPath)
                attrsArray[indexPath.section].append(attributes!)
            }
            
            self.setFooter(colum: colum, indexPath: indexPath)
        
        }
        
    }
    
    private func setHeader(colum:Int,indexPath:IndexPath) {
        
        
        colums.append(colum)
        
        var x = sectionEdgeInset.left
        
        var y = sectionEdgeInset.top
        /// 获取上一组最大Y值
        if indexPath.section > 0 {
           y = (self.columMaxXYs[indexPath.section - 1].max(by: { a, b in
                return a < b
            }) ?? 0)
            
            if scrollDirection == .horizontal {
            
                x = (self.columMaxXYs[indexPath.section - 1].max(by: { a, b in
                    return a < b
                }) ?? 0) + minColum
            }
        }
        
        
        let headerHeight = self.delegate?.casadeFlowLayoutHeaderSize?(indexPath: indexPath) ?? 0
    
        if headerHeight > 0 {
            y += miniRow
            var width = self.collectionView!.bounds.width - sectionEdgeInset.left - sectionEdgeInset.right
            var height = headerHeight
            if scrollDirection == .horizontal {
                y = sectionEdgeInset.top
                width = headerHeight
                height = self.collectionView!.bounds.height - sectionEdgeInset.top - sectionEdgeInset.bottom
            }
            let header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
          
            header.frame = CGRect(x: x, y: y, width: width, height: height)
            self.attrsArray[indexPath.section].append(header)
        }
        
        for _ in 0..<colum {
            if scrollDirection == .horizontal {
                self.columMaxXYs[indexPath.section].append(x + headerHeight)
            }else {
                self.columMaxXYs[indexPath.section].append(y + headerHeight)
            }

        }
        
    }
    
    private func setFooter(colum:Int,indexPath:IndexPath) {
        let footerHeight = self.delegate?.casadeFlowLayoutFooterSize?(indexPath: indexPath) ?? 0
        //底部视图
        if footerHeight > 0 {
            let layoutFooter = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            
            let max = columMaxXYs[indexPath.section].max { a, b in
                return a < b
            } ?? 0
            
            attrsArray[indexPath.section].append(layoutFooter)
            
            var x: CGFloat = sectionEdgeInset.left
            var y: CGFloat = sectionEdgeInset.top
            var width = self.collectionView!.bounds.width - sectionEdgeInset.left - sectionEdgeInset.right
            var height = self.collectionView!.bounds.height - sectionEdgeInset.top - sectionEdgeInset.bottom
            if scrollDirection == .vertical {
                height = footerHeight
                y = max + miniRow
            }else {
                width = footerHeight
                x = max + minColum
            }
            layoutFooter.frame = CGRect.init(x: x, y: y, width: width, height: height)
            
            for i in 0..<colum{
                if scrollDirection == .horizontal {
                    self.columMaxXYs[indexPath.section][i] = layoutFooter.frame.maxX
                }else {
                    self.columMaxXYs[indexPath.section][i] = layoutFooter.frame.maxY
                }
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let sectionCount = self.collectionView!.numberOfSections
        var attr = [UICollectionViewLayoutAttributes]()
        for i in 0..<sectionCount {
            attr.append(contentsOf: self.attrsArray[i])
        }
        return attr
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        if scrollDirection == .vertical {
            let xMargin = sectionEdgeInset.left + sectionEdgeInset.right + CGFloat((colums[indexPath.section] - 1)) * minColum
            let cellWidth = (self.collectionView!.bounds.width - xMargin)/CGFloat(colums[indexPath.section])
            
            let height:CGFloat = self.delegate?.casadeFlowLayoutSize(indexPath: indexPath) ?? 0
            
            var min = columMaxXYs[indexPath.section][0] + miniRow
            var destColum = 0
            for (index,value) in columMaxXYs[indexPath.section].enumerated() {
                if min > value {
                    min = value + miniRow
                    destColum = index
                }

            }
            let x = sectionEdgeInset.left + CGFloat(destColum) * (cellWidth+minColum)
            attrs.frame = CGRect(x:x,y:min,width:cellWidth,height:height)
            self.columMaxXYs[indexPath.section][destColum] = attrs.frame.maxY
            
        }else{
            let yMargin = sectionEdgeInset.top + sectionEdgeInset.bottom + CGFloat((colums[indexPath.section] - 1)) * miniRow
            let cellHeight = (self.collectionView!.bounds.height - yMargin)/CGFloat(colums[indexPath.section])
            
            let width:CGFloat = self.delegate?.casadeFlowLayoutSize(indexPath: indexPath) ?? 0
            var min = columMaxXYs[indexPath.section][0] + minColum
            var destRow = 0
            for (index,value) in columMaxXYs[indexPath.section].enumerated() {
                if min > value {
                    min = value + minColum
                    destRow = index
                }

            }
            let y = sectionEdgeInset.top + CGFloat(destRow) * (cellHeight+minColum)
            attrs.frame = CGRect(x:min,y:y,width:width,height:cellHeight)
            self.columMaxXYs[indexPath.section][destRow] = attrs.frame.maxX
        }
        return attrs
    }
    
}
