//
//  UIView+Additions.swift
//  
//
//  Created by Neil Horton on 13/07/2020.
//

import UIKit

extension UIView {

    /// Adds subview, sets translatesAutoresizingMaskIntoConstraints to false and calls pin subview to set autolayout constraints.
    /// - Parameter subview: The subview to be added and pinned.
    /// - Parameter edges: UIRect edge mask describing which edges should have constraints added.
    /// - Parameter padding: The amount of padding applied as the constant parameter on the constraint.
    /// - Parameter usingSafeAreaLayoutGuides: The amount of padding applied as the constant parameter on the constraint.
    public func addAndPin(subview: UIView,
                          atEdges edges: UIRectEdge = .all,
                          withPadding padding: UIEdgeInsets = .zero,
                          usingSafeAreaLayoutGuides: Bool = false) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        usingSafeAreaLayoutGuides ? pinToSafeArea(subview: subview, atEdges: edges, withPadding: padding) : pin(subview: subview, atEdges: edges, withPadding: padding)
    }

    /// Adds autolayout constraints to subview edges WITHOUT adding it as a subview ot setting translatesAutoresizingMaskIntoConstraints to false
    /// - Parameter subview: The subview to be added and pinned.
    /// - Parameter edges: UIRect edge mask describing which edges should have constraints added.
    /// - Parameter padding: The amount of padding applied as the constant parameter on the constraint.
    public func pin(subview: UIView, atEdges edges: UIRectEdge = .all, withPadding padding: UIEdgeInsets = .zero) {
        subview.topAnchor.constraint(equalTo: topAnchor, constant: padding.top).isActive = edges.contains(.top)
        subview.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left).isActive = edges.contains(.left)
        subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right).isActive = edges.contains(.right)
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom).isActive = edges.contains(.bottom)
    }

    /// Adds autolayout constraints to subview safe area layour gutide WITHOUT adding it as a subview ot setting translatesAutoresizingMaskIntoConstraints to false
    /// - Parameter subview: The subview to be added and pinned.
    /// - Parameter edges: UIRect edge mask describing which edges should have constraints added.
    /// - Parameter padding: The amount of padding applied as the constant parameter on the constraint.
    public func pinToSafeArea(subview: UIView, atEdges edges: UIRectEdge = .all, withPadding padding: UIEdgeInsets = .zero) {
        subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = edges.contains(.top)
        subview.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left).isActive = edges.contains(.left)
        subview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right).isActive = edges.contains(.right)
        subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = edges.contains(.bottom)
    }

    public static func nib(named: String? = nil) -> UINib {
        let bundle = Bundle(for: self)
        let nibName = self.description().components(separatedBy: ".").last!
        return UINib(nibName: nibName, bundle: bundle)
    }

    public static func loadFromNib(_ nibNameOrNil: String? = nil) -> Self {
        return nib(named: nibNameOrNil).instantiate(withOwner: self, options: nil).first as! Self
    }
}
