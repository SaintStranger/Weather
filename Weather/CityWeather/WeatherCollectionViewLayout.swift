//
//  WeatherCollectionViewLayout.swift
//  Weather
//
//  Created by Антон Чечевичкин on 10.11.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class WeatherCollectionViewLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    var columnsCount = 2
    
    var cellHeight: CGFloat = 128
    
    private var totalCellHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        guard itemsCount > 0 else {
            return
        }
        
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / 2
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (index + 1) % (self.columnsCount + 1) == 0
            
            if isBigCell {
                attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: self.cellHeight)
                
                //lastY += self.cellHeight

            } else {
                attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: self.cellHeight)
            }
            
            let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 || isBigCell == true
            
            if isLastColumn {
                lastY += self.cellHeight
                lastX = 0
            } else {
                lastX += smallCellWidth
            }
            
            cacheAttributes[indexPath] = attributes
            
            self.totalCellHeight = lastY
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in return rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0, height: self.totalCellHeight)
    }

}
