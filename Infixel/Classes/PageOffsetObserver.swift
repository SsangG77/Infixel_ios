//
//  PageOffsetObserver.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import Foundation
import UIKit



@available(iOS 17.0, *)
@Observable
class PageOffsetObserver: NSObject {
    var collecttionVIew: UICollectionView?
    var offset: CGFloat = 0
    private(set) var isObserving: Bool = false
    
    deinit {
        remove()
    }
    
    func observe() {
        guard !isObserving else { return }
        collecttionVIew?.addObserver(self, forKeyPath: "contentOffset", context: nil)
        isObserving = true
    }
    
    func remove() {
        collecttionVIew?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        if let contentOffset = (object as? UICollectionView)?.contentOffset {
            offset = contentOffset.x
        }
    }
    
    
}//PageOffsetObserver
