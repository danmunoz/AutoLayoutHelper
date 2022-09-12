//
//  DMLayout.swift
//  
//
//  Created by Daniel Munoz on 14.09.22.
//

import UIKit

public class DMLayout<Base> {
    public let base: Base
    var constraints: [NSLayoutConstraint] = []
    var inactiveConstraints: [NSLayoutConstraint] = []

    public init(_ base: Base) {
        self.base = base
    }
}

/// Protocol used as customization point for UI extensions.
/// After creating the extension, the **dmui** property is available and serves as a group for custom extensions within this package.
///
/// # Usage
/// An extendable class should conform to `DMLayoutCompatible` protocol.
/// `DMLayout` must be extended and `Self` should be constrained to the desired extension Type.
///
/// ## Example:
/// ```
/// extension UIView: DMLayoutCompatible {}
///
/// public extension DMLayoutCompatible where Self: UIView {
///     func printTag() {
///         print("View tag: \(base.tag)")
///     }
/// }
///
/// let view = UIView()
/// view.tag = 10
/// view.dmui.printTag() // 10
/// ```
public protocol DMLayoutCompatible {
    associatedtype CompatibleType

    var dmui: DMLayout<CompatibleType> { get }
}

public extension DMLayoutCompatible {
    var dmui: DMLayout<Self> {
        DMLayout(self)
    }
}

// MARK: Custom extensions

extension UIView: DMLayoutCompatible {}

