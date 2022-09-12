import UIKit

public enum LayoutXAxisAnchor {
    case leading
    case trailing
    case center

    func systemAnchor(for item: LayoutItem) -> NSLayoutXAxisAnchor {
        switch self {
        case .leading:
            return item.leadingAnchor
        case .trailing:
            return item.trailingAnchor
        case .center:
            return item.centerXAnchor
        }
    }
}
