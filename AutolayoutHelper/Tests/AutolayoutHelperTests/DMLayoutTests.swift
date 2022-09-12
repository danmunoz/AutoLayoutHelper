import XCTest
@testable import AutolayoutHelper

private class FooClass: DMLayoutCompatible {}

extension DMLayout where Base: FooClass {
    var isTrue: Bool { true }
}

final class DMLayoutTests: XCTestCase {
    func testExtension() throws {
        let foo = FooClass()
        XCTAssertTrue(foo.dmui.isTrue)
    }
    
    func testAddInto() throws {
        let superView = UIView()
        let view = UIView()
        XCTAssertTrue(superView.subviews.isEmpty)

        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        view.add(into: superView)
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        let subview = try XCTUnwrap(superView.subviews.first)
        XCTAssertEqual(superView.subviews.count, 1)
        XCTAssertEqual(subview, view)
    }
    
    func testWithoutCallToActivate() throws {
        let superView = UIView()
        let view = UIView()

        _ = view.add(into: superView)
            .constrainTop()
        XCTAssertTrue(superView.constraints.isEmpty)
    }

    func testWithCallToActivate() throws {
        let superView = UIView()
        let view = UIView()

        XCTAssertTrue(superView.constraints.isEmpty)
        view.add(into: superView)
            .constrainTop()
            .activateConstraints()

        XCTAssertFalse(superView.constraints.isEmpty)
        let constraint = try XCTUnwrap(superView.constraints.first)
        XCTAssertEqual(constraint.constant, 0)
        XCTAssertTrue(constraint.isActive)
    }

    func testDefaultTopSuperView() throws {
        let superView = UIView()
        let view = UIView()

        view.add(into: superView)
            .constrainTop()
            .activateConstraints()

        let constraint = try XCTUnwrap(superView.constraints.first)
        try testConstraint(
            constraint: constraint,
            firstView: view,
            secondView: superView,
            constant: 0,
            firstAttribute: .top,
            secondAttribute: .top,
            priority: .required,
            relation: .equal
        )
    }

    func testDefaultTopGivenView() throws {
        let superView = UIView()
        let view = UIView()
        let sisterView = UIView()

        [view, sisterView].forEach {
            superView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.dmui
            .constrainTop(to: sisterView)
            .activateConstraints()

        let constraint = try XCTUnwrap(superView.constraints.first)
        try testConstraint(
            constraint: constraint,
            firstView: view,
            secondView: sisterView,
            constant: 0,
            firstAttribute: .top,
            secondAttribute: .top,
            priority: .required,
            relation: .equal
        )
    }

    func testTopGivenView() throws {
        let superView = UIView()
        let view = UIView()
        let sisterView = UIView()

        [view, sisterView].forEach {
            superView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.dmui
            .constrainTop(
                to: sisterView,
                viewAnchor: .bottom,
                relatedBy: .greaterThanOrEqual,
                priority: .defaultLow,
                constant: 16)
            .activateConstraints()

        let constraint = try XCTUnwrap(superView.constraints.first)
        try testConstraint(
            constraint: constraint,
            firstView: view,
            secondView: sisterView,
            constant: 16,
            firstAttribute: .top,
            secondAttribute: .bottom,
            priority: .defaultLow,
            relation: .greaterThanOrEqual
        )
    }

    func testBottomGivenView() throws {
        let superView = UIView()
        let view = UIView()
        let sisterView = UIView()

        [view, sisterView].forEach {
            superView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.dmui
            .constrainBottom(
                to: sisterView,
                viewAnchor: .top,
                relatedBy: .greaterThanOrEqual,
                priority: .defaultLow,
                constant: 16)
            .activateConstraints()

        let constraint = try XCTUnwrap(superView.constraints.first)
        try testConstraint(
            constraint: constraint,
            firstView: view,
            secondView: sisterView,
            constant: 16,
            firstAttribute: .bottom,
            secondAttribute: .top,
            priority: .defaultLow,
            relation: .greaterThanOrEqual
        )
    }

    func testLeadingGivenView() throws {
        let superView = UIView()
        let view = UIView()
        let sisterView = UIView()

        [view, sisterView].forEach {
            superView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.dmui
            .constrainLeading(
                to: sisterView,
                viewAnchor: .trailing,
                relatedBy: .greaterThanOrEqual,
                priority: .defaultLow,
                constant: 16)
            .activateConstraints()

        let constraint = try XCTUnwrap(superView.constraints.first)
        try testConstraint(
            constraint: constraint,
            firstView: view,
            secondView: sisterView,
            constant: 16,
            firstAttribute: .leading,
            secondAttribute: .trailing,
            priority: .defaultLow,
            relation: .greaterThanOrEqual
        )
    }

    func testTrailingGivenView() throws {
        let superView = UIView()
        let view = UIView()
        let sisterView = UIView()

        [view, sisterView].forEach {
            superView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.dmui
            .constrainTrailing(
                to: sisterView,
                viewAnchor: .leading,
                relatedBy: .greaterThanOrEqual,
                priority: .defaultLow,
                constant: 16)
            .activateConstraints()

        let constraint = try XCTUnwrap(superView.constraints.first)
        try testConstraint(
            constraint: constraint,
            firstView: view,
            secondView: sisterView,
            constant: 16,
            firstAttribute: .trailing,
            secondAttribute: .leading,
            priority: .defaultLow,
            relation: .greaterThanOrEqual
        )
    }

    func testAll() throws {
        let superView = UIView()
        let view = UIView()
        let insets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 15, trailing: 20)

        view.add(into: superView)
            .constrainAll(to: superView, insets: insets)
            .activateConstraints()

        let topConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .top }.first)
        try testConstraint(
            constraint: topConstraint,
            firstView: view,
            secondView: superView,
            constant: insets.top,
            firstAttribute: .top,
            secondAttribute: .top,
            priority: .required,
            relation: .equal)

        let bottomConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .bottom }.first)
        try testConstraint(
            constraint: bottomConstraint,
            firstView: view,
            secondView: superView,
            constant: insets.bottom * -1,
            firstAttribute: .bottom,
            secondAttribute: .bottom,
            priority: .required,
            relation: .equal)

        let leadingConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .leading }.first)
        try testConstraint(
            constraint: leadingConstraint,
            firstView: view,
            secondView: superView,
            constant: insets.leading,
            firstAttribute: .leading,
            secondAttribute: .leading,
            priority: .required,
            relation: .equal)

        let trailingConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .trailing }.first)
        try testConstraint(
            constraint: trailingConstraint,
            firstView: view,
            secondView: superView,
            constant: insets.trailing * -1,
            firstAttribute: .trailing,
            secondAttribute: .trailing,
            priority: .required,
            relation: .equal)
    }

    func testAllConstant() throws {
        let superView = UIView()
        let view = UIView()
        let constant = 16.0

        view.add(into: superView)
            .constrainAll(to: superView, constant: constant)
            .activateConstraints()

        let topConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .top }.first)
        try testConstraint(
            constraint: topConstraint,
            firstView: view,
            secondView: superView,
            constant: constant,
            firstAttribute: .top,
            secondAttribute: .top,
            priority: .required,
            relation: .equal)

        let bottomConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .bottom }.first)
        try testConstraint(
            constraint: bottomConstraint,
            firstView: view,
            secondView: superView,
            constant: constant * -1,
            firstAttribute: .bottom,
            secondAttribute: .bottom,
            priority: .required,
            relation: .equal)

        let leadingConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .leading }.first)
        try testConstraint(
            constraint: leadingConstraint,
            firstView: view,
            secondView: superView,
            constant: constant,
            firstAttribute: .leading,
            secondAttribute: .leading,
            priority: .required,
            relation: .equal)

        let trailingConstraint = try XCTUnwrap(superView.constraints.filter { $0.firstAttribute == .trailing }.first)
        try testConstraint(
            constraint: trailingConstraint,
            firstView: view,
            secondView: superView,
            constant: constant * -1,
            firstAttribute: .trailing,
            secondAttribute: .trailing,
            priority: .required,
            relation: .equal)
    }

    func testConstraint(
        constraint: NSLayoutConstraint,
        firstView: UIView,
        secondView: UIView,
        constant: CGFloat,
        firstAttribute: NSLayoutConstraint.Attribute,
        secondAttribute: NSLayoutConstraint.Attribute,
        priority: UILayoutPriority,
        relation: NSLayoutConstraint.Relation
    ) throws
    {
        XCTAssertEqual(constraint.constant, constant)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.priority, priority)
        let firstItem = try XCTUnwrap(constraint.firstItem) as? UIView
        XCTAssertEqual(firstItem, firstView)
        let secondItem = try XCTUnwrap(constraint.secondItem) as? UIView
        XCTAssertEqual(secondItem, secondView)
        XCTAssertEqual(constraint.firstAttribute, firstAttribute)
        XCTAssertEqual(constraint.secondAttribute, secondAttribute)
        switch firstAttribute {
        case .top:
            XCTAssertEqual(constraint.firstAnchor, firstView.topAnchor)
        case .bottom:
            XCTAssertEqual(constraint.firstAnchor, firstView.bottomAnchor)
        case .leading:
            XCTAssertEqual(constraint.firstAnchor, firstView.leadingAnchor)
        case .trailing:
            XCTAssertEqual(constraint.firstAnchor, firstView.trailingAnchor)
        case .width:
            break
        case .height:
            break
        case .centerX:
            break
        case .centerY:
            break
        default:
            break
        }

        switch secondAttribute {
        case .top:
            XCTAssertEqual(constraint.secondAnchor, secondView.topAnchor)
        case .bottom:
            XCTAssertEqual(constraint.secondAnchor, secondView.bottomAnchor)
        case .leading:
            XCTAssertEqual(constraint.secondAnchor, secondView.leadingAnchor)
        case .trailing:
            XCTAssertEqual(constraint.secondAnchor, secondView.trailingAnchor)
        case .width:
            break
        case .height:
            break
        case .centerX:
            break
        case .centerY:
            break
        default:
            break
        }
        XCTAssertEqual(constraint.relation, relation)
    }
}
