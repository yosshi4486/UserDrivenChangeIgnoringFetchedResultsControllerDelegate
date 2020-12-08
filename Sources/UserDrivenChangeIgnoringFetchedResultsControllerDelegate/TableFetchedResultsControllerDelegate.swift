//
//  TableFetchedResultsControllerDelegate.swift
//  UserDrivenChangeIgnoringFetchedResultsControllerDelegate
//
//  Created by yosshi4486 on 2020/11/30.
//

import CoreData

#if canImport(UIKit) || targetEnvironment(macCatalyst)

import UIKit

open class TableFetchedResultsControllerDelegate: UserDrivenChangeIgnoringFetchedResultsControllerDelegate {

    public unowned let tableView: UITableView

    public init(tableView: UITableView) {
        self.tableView = tableView
    }

    open override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        super.controllerWillChangeContent(controller)
    }

    open override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        super.controllerDidChangeContent(controller)

        changeIsUserDriven = false
    }

    open override func controllerWillChangeContentWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerWillChangeContentWhenChangeIsNotUserDriven(controller)

        tableView.beginUpdates()
    }

    open override func controllerDidChangeContentWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContentWhenChangeIsNotUserDriven(controller)

        tableView.endUpdates()
    }

    open override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)

        switch type {
        case .insert:

            guard let newIndexPath = newIndexPath else {
                return
            }

            tableView.insertRows(at: [newIndexPath], with: .automatic)

        case .delete:

            guard let indexPath = indexPath else {
                return
            }

            tableView.deleteRows(at: [indexPath], with: .automatic)

        case .update:

            guard let indexPath = indexPath else {
                return
            }

            // `configure(cell:at:)` doesn't refresh cell's states. It may be trouble in some cases.
            // Please subclass this class if you want to reduce cost of calling `reloadRows(at:with:)`.
            tableView.reloadRows(at: [indexPath], with: .automatic)

        case .move:

            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
                return
            }

            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)

        @unknown default:
            fatalError("New NSFetchedResultsChangeType has added by API changes.")
        }
    }

}

#endif
