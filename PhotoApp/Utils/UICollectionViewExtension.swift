//
//  UICollectionViewExtension.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 9/4/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import PHDiff

extension UICollectionView {
    
    /**
     Applies a batch update the receiver with given items.
     - parameters:
     - oldItems: The current items of collection view data source.
     - newItems: The new items collection view should be updated to.
     - section: The section where these changes should take place.
     - completion: A block to execute when batch update is completed.
     */
    func update<T: Diffable>(from oldItems: [T], to newItems: [T], section: Int = 0, completion: ((Bool) -> Void)? = nil) {
        var moves = [(from: IndexPath, to: IndexPath)]()
        var inserts = [IndexPath]()
        var deletes = [IndexPath]()
        var reloads = [IndexPath]()
        // Get the diff between old and new items.
        let steps = PHDiff.steps(fromArray: oldItems, toArray: newItems)
        // Seperate steps based on type.
        steps.forEach { step in
            switch step {
            case let .insert(_, index): inserts.append(IndexPath(item: index, section: section))
            case let .delete(_, index): deletes.append(IndexPath(item: index, section: section))
            case let .update(_, index): reloads.append(IndexPath(item: index, section: section))
            case let .move(_, fromIndex, toIndex):
                moves.append((from: IndexPath(item: fromIndex, section: section),
                              to: IndexPath(item: toIndex, section: section)))
            }
        }
        // Apply the diff steps on collection view.
        performBatchUpdates({
            reloadItems(at: reloads)
            deleteItems(at: deletes)
            insertItems(at: inserts)
            moves.forEach { moveItem(at: $0.from, to: $0.to) }
        }, completion: completion)
    }
}
