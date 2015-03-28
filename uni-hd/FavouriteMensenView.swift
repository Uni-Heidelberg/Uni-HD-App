//
//  FavouriteMensenView.swift
//  uni-hd
//
//  Created by Felix on 18.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit


@objc class FavouriteMensenView: UIView, NSFetchedResultsControllerDelegate {
    
    
    /// The MOC for database access
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            configureView() // TODO: reload collection view instead when implemented
        }
    }
    
    /// The fetched results controller fetches all favourites from the database and updates automatically.
    private var fetchedResultsController: NSFetchedResultsController? {
        if _fetchedResultsController == nil {
            if let managedObjectContext = self.managedObjectContext {
            
                let fetchRequest = NSFetchRequest(entityName: Mensa.entityName())
                fetchRequest.predicate = NSPredicate(format: "isFavourite = true", argumentArray: nil)
                fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "remoteObjectId", ascending: true) ]
                
                let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchedResultsController.delegate = self
                fetchedResultsController.performFetch(nil)
                _fetchedResultsController = fetchedResultsController
            }
        }
        return _fetchedResultsController
    }
    private var _fetchedResultsController: NSFetchedResultsController?
    
    
    // MARK: Interface Elements
    
    @IBOutlet var imageViews: [UIImageView]! // TODO: use a UICollectionView instead to display mensa images
    
    
    // MARK: Fetched Results Controller Delegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        // TODO: implement fine-grained change methods instead to insert, update or delete items in collection view. See NSFetchedResultsControllerDelegate documentation.
        configureView()
    }
    
    
    private func configureView()
    {
        let favouriteMensen = fetchedResultsController?.fetchedObjects as? [Mensa] ?? [Mensa]()
        for (i, imageView) in enumerate(imageViews) {
            self.imageViews[i].image = i < favouriteMensen.count ? favouriteMensen[i].location?.image : nil
        }
    }

}