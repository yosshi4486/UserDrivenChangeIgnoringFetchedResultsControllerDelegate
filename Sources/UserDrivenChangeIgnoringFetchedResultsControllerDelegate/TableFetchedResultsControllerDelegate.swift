//
//  TableFetchedResultsControllerDelegate.swift
//  UserDrivenChangeIgnoringFetchedResultsControllerDelegate
//
//  Created by yosshi4486 on 2020/11/30.
//

import CoreData

#if canImport(UIKit) || targetEnvironment(macCatalyst)

import UIKit

public protocol CellConfigurable: AnyObject {

    func configure(cell: UITableViewCell, at indexPath: IndexPath)

}

open class TableFetchedResultsControllerDelegate: UserDrivenChangeIgnoringFetchedResultsControllerDelegate {

    public unowned let tableView: UITableView

    public unowned let cellConfiguable: CellConfigurable

    public init(tableView: UITableView, cellConfiguable: CellConfigurable) {
        self.tableView = tableView
        self.cellConfiguable = cellConfiguable
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

            guard let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) else {
                return
            }

            cellConfiguable.configure(cell: cell, at: indexPath)

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
