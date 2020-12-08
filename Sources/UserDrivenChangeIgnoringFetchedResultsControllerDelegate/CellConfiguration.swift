//
//  CellConfiguration.swift
//  UserDrivenChangeIgnoringFetchedResultsControllerDelegate
//
//  Created by yosshi4486 on 2020/12/08.
//

#if canImport(UIKit) || targetEnvironment(macCatalyst)

import UIKit

public protocol CellConfiguration : AnyObject {

    func configure(_ cell: UITableViewCell, at indexPath: IndexPath)

}

#endif
