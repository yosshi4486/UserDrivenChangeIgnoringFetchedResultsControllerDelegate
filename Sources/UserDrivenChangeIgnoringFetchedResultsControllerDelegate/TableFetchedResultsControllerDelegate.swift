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

    public var insertAnimation: UITableView.RowAnimation = .automatic

    public var deleteAnimation: UITableView.RowAnimation = .automatic

    public var updateAnimation: UITableView.RowAnimation = .automatic

    public var moveAnimation: UITableView.RowAnimation = .automatic

    public weak var cellConfiguration: CellConfiguration? = nil

    public init(tableView: UITableView) {
        self.tableView = tableView
    }

    open override func controllerWillChangeContentWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerWillChangeContentWhenChangeIsNotUserDriven(controller)

        tableView.beginUpdates()
    }

    open override func controllerDidChangeContentWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContentWhenChangeIsNotUserDriven(controller)

        tableView.endUpdates()
    }

    open override func controllerWhenChangeIsNotUserDriven(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:

            guard let newIndexPath = newIndexPath else {
                return
            }

            tableView.insertRows(at: [newIndexPath], with: insertAnimation)

        case .delete:

            guard let indexPath = indexPath else {
                return
            }

            tableView.deleteRows(at: [indexPath], with: deleteAnimation)

        case .update:

            guard let indexPath = indexPath else {
                return
            }

            if let cellConfiguration = self.cellConfiguration, let cell = tableView.cellForRow(at: indexPath) {
                cellConfiguration.configure(cell, at: indexPath)
            } else {
                tableView.reloadRows(at: [indexPath], with: updateAnimation)
            }

        case .move:

            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
                return
            }

            tableView.deleteRows(at: [indexPath], with: moveAnimation)
            tableView.insertRows(at: [newIndexPath], with: moveAnimation)

        @unknown default:
            fatalError("New NSFetchedResultsChangeType has added by API changes.")
        }

    }

}

#endif
