//
//  UITableView+Additions.swift
//  
//
//  Created by Neil Horton on 13/07/2020.
//

import UIKit

public protocol ReusableCell: class {

    /// The cell types unique reuseIdentifier
    static var reuseIdentifier: String { get }
}

extension UITableView {

    /// Registers a type of cell conforming to ReusableCell to the tableview allowing it to be dequeued.
    /// - Parameter cellType: Used to inform the generic allowing the function to identify the cell.
    public func register<T: ReusableCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        // swiftlint:disable:next identifier_name
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    /// Dequeus a ReusableCell and returns already cast to that type.  allowing cell to be configured.
    /// - Parameter indexPath: Used to inform the generic allowing the function to identify the cell.
    public func dequeueCell<T: ReusableCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier , for: indexPath) as! T //swiftlint:disable:this force_cast
    }
}
