//
//  File.swift
//  
//
//  Created by Daniel Munoz on 14.09.22.
//

import UIKit

public extension DMLayoutCompatible where Self: UIView {
//    var dmui: DMLayout<Self> {
////        translatesAutoresizingMaskIntoConstraints = false
//        return DMLayout(self)
//    }
    
    @discardableResult
    func add(into view: UIView) -> DMLayout<Self> {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        return dmui
    }
}

// MARK: - Private extension

private extension DMLayout where Base: UIView {
    func connect<Axis>(
        anchor anchor1: NSLayoutAnchor<Axis>,
        to anchor2: NSLayoutAnchor<Axis>,
        relatedBy relation: NSLayoutConstraint.Relation,
        priority: UILayoutPriority?,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = anchor1.constraint(equalTo: anchor2, constant: constant)
        case .greaterThanOrEqual:
            constraint = anchor1.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        case .lessThanOrEqual:
            constraint = anchor1.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        @unknown default:
            preconditionFailure("Unexpected constraint's relation")
        }
        if let priority = priority {
            constraint.priority = priority
        }
        return constraint
    }

    func connect(
        _ dimension: NSLayoutDimension,
        to dimension2: NSLayoutDimension?,
        relatedBy relation: NSLayoutConstraint.Relation,
        priority: UILayoutPriority?,
        multiplier: CGFloat,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            if let dimension2 = dimension2 {
                constraint = dimension.constraint(equalTo: dimension2, multiplier: multiplier, constant: constant)
            } else {
                constraint = dimension.constraint(equalToConstant: constant)
            }
        case .greaterThanOrEqual:
            if let dimension2 = dimension2 {
                constraint = dimension.constraint(
                    greaterThanOrEqualTo: dimension2,
                    multiplier: multiplier,
                    constant: constant
                )
            } else {
                constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
            }
        case .lessThanOrEqual:
            if let dimension2 = dimension2 {
                constraint = dimension.constraint(
                    lessThanOrEqualTo: dimension2,
                    multiplier: multiplier,
                    constant: constant
                )
            } else {
                constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
            }
        @unknown default:
            preconditionFailure("Unexpected constraint's relation")
        }
        if let priority = priority {
            constraint.priority = priority
        }
        return constraint
    }
}

// MARK: - Public extension

public extension DMLayout where Base: UIView {

    /// Activates all configured constraints
    /// - returns: The UIView object

    @discardableResult
    func activateConstraints() -> Base {
        NSLayoutConstraint.activate(inactiveConstraints)
        defer {
            inactiveConstraints.removeAll()
        }
        constraints.append(contentsOf: inactiveConstraints)
        return base
    }

    /// Constrains `self`'s **top** anchor to it's superView.
    ///
    /// - Parameters:
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainTop(
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        guard let parentView = base.superview else {
            assertionFailure("The view provided doesn't have a superView")
            return self
        }
        return constrainTop(
            to: parentView,
            viewAnchor: .top,
            relatedBy: relation,
            priority: priority,
            constant: constant)
    }
    
    /// Constrains `self`'s **top** anchor to the given view.
    ///
    /// - Parameters:
    ///     - item: The layout item for the right side of the constraint.
    ///     - viewAnchor: The anchor of the view for the right side of the constraint. Defaults to `.top`
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.
    
    func constrainTop(
        to item: LayoutItem,
        viewAnchor: LayoutYAxisAnchor = .top,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        inactiveConstraints.append(
            connect(
                anchor: base.topAnchor,
                to: viewAnchor.systemAnchor(for: item),
                relatedBy: relation,
                priority: priority,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self`'s **leading** anchor to the given view.
    ///
    /// - Parameters:
    ///     - item: The layout item for the right side of the constraint.
    ///     - viewAnchor: The anchor of the view for the right side of the constraint. Defaults to `.leading`
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainLeading(
        to item: LayoutItem,
        viewAnchor: LayoutXAxisAnchor = .leading,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        inactiveConstraints.append(
            connect(
                anchor: base.leadingAnchor,
                to: viewAnchor.systemAnchor(for: item),
                relatedBy: relation,
                priority: priority,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self`'s **leading** anchor to it's superView.
    ///
    /// - Parameters:
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainLeading(
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        guard let parentView = base.superview else {
            assertionFailure("The view provided doesn't have a superView")
            return self
        }
        return constrainLeading(
            to: parentView,
            viewAnchor: .leading,
            relatedBy: relation,
            priority: priority,
            constant: constant)
    }

    /// Constrains `self`'s **trailing** anchor to the given view.
    ///
    /// - Parameters:
    ///     - item: The layout item for the right side of the constraint.
    ///     - viewAnchor: The anchor of the view for the right side of the constraint. Defaults to `.trailing`
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainTrailing(
        to item: LayoutItem,
        viewAnchor: LayoutXAxisAnchor = .trailing,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        inactiveConstraints.append(
            connect(
                anchor: base.trailingAnchor,
                to: viewAnchor.systemAnchor(for: item),
                relatedBy: relation,
                priority: priority,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self`'s **trailing** anchor to it's superView.
    ///
    /// - Parameters:
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainTrailing(
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        guard let parentView = base.superview else {
            assertionFailure("The view provided doesn't have a superView")
            return self
        }
        return constrainTrailing(
            to: parentView,
            viewAnchor: .trailing,
            relatedBy: relation,
            priority: priority,
            constant: constant)
    }

    /// Constrains `self`'s **bottom** anchor to the given view.
    ///
    /// - Parameters:
    ///     - item: The layout item for the right side of the constraint.
    ///     - viewAnchor: The anchor of the view for the right side of the constraint. Defaults to `.bottom`
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainBottom(
        to item: LayoutItem,
        viewAnchor: LayoutYAxisAnchor = .bottom,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        inactiveConstraints.append(
            connect(
                anchor: base.bottomAnchor,
                to: viewAnchor.systemAnchor(for: item),
                relatedBy: relation,
                priority: priority,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self`'s **bottom** anchor to it's superView.
    ///
    /// - Parameters:
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant added to the multiplied attribute value on the right side of the constraint to yield the final modified attribute. Defaults to `0`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainBottom(
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        guard let parentView = base.superview else {
            assertionFailure("The view provided doesn't have a superView")
            return self
        }
        return constrainBottom(
            to: parentView,
            viewAnchor: .bottom,
            relatedBy: relation,
            priority: priority,
            constant: constant)
    }

    /// Constrains all sides of `self` to the given view. Optionally, a constant value can be provided to add a constant spacing between the views.
    ///
    /// - Parameters:
    ///     - item: The layout item for the right side of the constraint.
    ///     - constant: The constant value to use as spacing between the views.
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainAll(
        to item: LayoutItem,
        constant: CGFloat = 0
    ) -> Self {
        constrainTop(to: item, constant: constant)
            .constrainLeading(to: item, constant: constant)
            .constrainTrailing(to: item, constant: -constant)
            .constrainBottom(to: item, constant: -constant)
    }

    /// Constrains all sides of `self` to the given view using a provided `NSDirectionalEdgeInsets` to add custom spacing between the views.
    ///
    /// - Parameters:
    ///     - item: The layout item for the right side of the constraint.
    ///     - insets: The directional inset value to use as spacing between the views.
    ///
    /// - returns: `Self` to make methods chainable.

    @available(iOS 11.0, *)
    func constrainAll(
        to item: LayoutItem,
        insets: NSDirectionalEdgeInsets
    ) -> Self {
        constrainTop(to: item, constant: insets.top)
            .constrainLeading(to: item, constant: insets.leading)
            .constrainTrailing(to: item, constant: -insets.trailing)
            .constrainBottom(to: item, constant: -insets.bottom)
    }

    /// Constrains `self` height to a given constant.
    ///
    /// - Parameters:
    ///     - constant: The constant value to use as height.
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainHeight(
        constant: CGFloat,
        priority: UILayoutPriority? = nil
    ) -> Self {
        inactiveConstraints.append(
            connect(
                base.heightAnchor,
                to: nil,
                relatedBy: .equal,
                priority: priority,
                multiplier: 1.0,
                constant: constant
            )
        )
        return self
    }

    // Constrains `self` height to a given view.
    ///
    /// - Parameters:
    ///     - view: The constant value to use as width.
    ///     - constant: The constant value to use as height.
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - multiplier: The multiplier constant for the constraint. Defaults to `1.0`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainHeight(
        to view: UIView? = nil,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1.0,
        priority: UILayoutPriority? = nil
    ) -> Self {
        inactiveConstraints.append(
            connect(
                base.heightAnchor,
                to: view?.heightAnchor,
                relatedBy: relation,
                priority: priority,
                multiplier: multiplier,
                constant: 0
            )
        )
        return self
    }

    /// Constrains `self` width to a given constant.
    ///
    /// - Parameters:
    ///     - constant: The constant value to use as width.
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainWidth(
        constant: CGFloat,
        priority: UILayoutPriority? = nil
    ) -> Self {
        inactiveConstraints.append(
            connect(
                base.widthAnchor,
                to: nil,
                relatedBy: .equal,
                priority: priority,
                multiplier: 1.0,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self` width to a given view.
    ///
    /// - Parameters:
    ///     - view: The constant value to use as width.
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - multiplier: The multiplier constant for the constraint. Defaults to `1.0`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainWidth(
        to view: UIView,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1.0,
        priority: UILayoutPriority? = nil
    ) -> Self {
        inactiveConstraints.append(
            connect(
                base.widthAnchor,
                to: view.widthAnchor,
                relatedBy: relation,
                priority: priority,
                multiplier: multiplier,
                constant: 0
            )
        )
        return self
    }

    /// Constrains `self` size to a given `CGSize`.
    ///
    /// - Parameters:
    ///     - size: The `CGSize` object containing the width and height.
    ///     - widthPriority: The priority of the width constraint. Defaults to `nil`
    ///     - heightPriority: The priority of the height constraint. Defaults to `nil`
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainSize(
        size: CGSize,
        widthPriority: UILayoutPriority? = nil,
        heightPriority: UILayoutPriority? = nil
    ) -> Self {
        constrainWidth(constant: size.width, priority: widthPriority)
            .constrainHeight(constant: size.height, priority: heightPriority)
    }

    /// Constrains `self`'s **centerX** attribute to the given view.
    ///
    /// - Parameters:
    ///     - view: The view for the right side of the constraint.
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant value to use as spacing. Defaults to `0`.
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainCenterX(
        to view: UIView,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        inactiveConstraints.append(
            connect(
                anchor: base.centerXAnchor,
                to: view.centerXAnchor,
                relatedBy: relation,
                priority: priority,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self`'s **centerY** attribute to the given view.
    ///
    /// - Parameters:
    ///     - view: The view for the right side of the constraint.
    ///     - relatedBy: The relationship between the left side of the constraint and the right side of the constraint. Defaults to `.equal`
    ///     - priority: The priority of the constraint. Defaults to `nil`
    ///     - constant: The constant value to use as spacing. Defaults to `0`.
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainCenterY(
        to view: UIView,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority? = nil,
        constant: CGFloat = 0
    ) -> Self {
        inactiveConstraints.append(
            connect(
                anchor: base.centerYAnchor,
                to: view.centerYAnchor,
                relatedBy: relation,
                priority: priority,
                constant: constant
            )
        )
        return self
    }

    /// Constrains `self`'s **center** to match the given view's center.
    ///
    /// - Parameters:
    ///     - view: The view for the right side of the constraint.
    ///     - priorityX: The priority of the constraint for the x axis. Defaults to `nil`
    ///     - priorityY: The priority of the constraint for the y axis. Defaults to `nil`
    ///     - constantX: The constant value to use as spacing on the x axis. Defaults to `0`.
    ///     - constantY: The constant value to use as spacing on the y axis. Defaults to `0`.
    ///
    /// - returns: `Self` to make methods chainable.

    func constrainCenter(
        to view: UIView,
        priorityX: UILayoutPriority? = nil,
        priorityY: UILayoutPriority? = nil,
        constantX: CGFloat = 0,
        constantY: CGFloat = 0
    ) -> Self {
        constrainCenterX(to: view, priority: priorityX, constant: constantX)
            .constrainCenterY(to: view, priority: priorityY, constant: constantY)
    }
}
