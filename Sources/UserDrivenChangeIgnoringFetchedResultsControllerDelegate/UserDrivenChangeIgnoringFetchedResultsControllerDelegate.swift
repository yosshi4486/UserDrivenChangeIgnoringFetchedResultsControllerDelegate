//
//  UserDrivenChangeIgnoringFetchedResultsControllerDelegate.swift
//  UserDrivenChangeIgnoringFetchedResultsControllerDelegate
//
//  Created by yosshi4486 on 2020/11/30.
//

import CoreData

#if canImport(UIKit) || targetEnvironment(macCatalyst)

import UIKit

/// A type ignores user driven update of FetchedResultsControllerDelegate.
open class UserDrivenChangeIgnoringFetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Public API (Not overidable)

    /// The flag indicates whether the change is user driven.
    ///
    /// A UITableView has some user driven gestures that change table content, but it may cause inconsistency by trigered its frc delegates.
    /// To avoid unnessesory frc delegate's update, the flag is used to ignore the update.
    ///
    /// This problem is described in official doc bellow:
    /// https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate
    public var changeIsUserDriven: Bool = false

    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        if changeIsUserDriven {
            controllerWillChangeContentWhenChangeIsUserDriven(controller)
            return
        } else {
            controllerWillChangeContentWhenChangeIsNotUserDriven(controller)
        }

    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        if changeIsUserDriven {
            controllerDidChangeContentWhenChangeIsUserDriven(controller)
        } else {
            controllerDidChangeContentWhenChangeIsNotUserDriven(controller)
        }

        changeIsUserDriven = false
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if changeIsUserDriven {
            controllerWhenChangeIsUserDriven(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
            return
        }

        controllerWhenChangeIsNotUserDriven(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
    }

    // MARK: - Open API (Overidable)

    /// Notifies the receiver that the fetched results controller is about to start processing of one or more changes that is user deiven. Default implementation is empty.
    open func controllerWillChangeContentWhenChangeIsUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    /// Notifies the receiver that the fetched results controller is about to start processing of one or more changes that is not user deiven. Default implementation is empty
    open func controllerWillChangeContentWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    /// Notifies the receiver that the fetched results controller has completed processing of one or more changes  that is user deiven. Default implementation is empty
    open func controllerDidChangeContentWhenChangeIsUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    /// Notifies the receiver that the fetched results controller has completed processing of one or more changes  that is not user deiven. Default implementation is empty
    open func controllerDidChangeContentWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    /// Call this method when the change is user driven. Default implementation is empty
    open func controllerWhenChangeIsUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}

    /// Call this method when the change is not user driven. Default implementation is empty
    open func controllerWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}

}

#endif
