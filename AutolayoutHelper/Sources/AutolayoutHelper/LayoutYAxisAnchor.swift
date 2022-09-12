import UIKit

public enum LayoutYAxisAnchor {
    case top
    case bottom
    case center

    func systemAnchor(for item: LayoutItem) -> NSLayoutYAxisAnchor {
        switch self {
        case .top:
            return item.topAnchor
        case .bottom:
            return item.bottomAnchor
        case .center:
            return item.centerYAnchor
        }
    }
}
