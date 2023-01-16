//
//  ViewLayoutProtocols.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/16.
//

import UIKit

///UIView type's default configure
protocol ConfigureSubviewsCase: UIView {
    
    /// Combine setupview's all configuration
    func configureSubviews()

    /// Init subviews
    func createSubviews()

    /// Add view to view's subview
    func addSubviews()

    /// Setup subview's layout
    func setupLayouts()
}

protocol SetupSubviewsLayouts: UIView {
    
    ///Use ConfigureUI.setupLayout(detail:apply:)
    func setupSubviewsLayouts()
    
}

protocol SetupSubviewsConstraints: UIView {
    
    ///Use ConfigureUI.setupConstraints(detail:apply:)
    func setupSubviewsConstratins()
    
}

struct ConfigureUI {
    
    typealias Element = NSLayoutConstraint
    
    /// Subview's detail setup layouts
    static func setupLayout<T>(detail view: T, apply: @escaping (T)->Void) where T: UIView {
        apply(view)
    }
    
    /// Subview's constraints setup.
    static func setupConstraints<T>(with view: T, apply: (T)->[Element]) where T: UIView {
        let constraints = apply(view)
        Element.activate(constraints)
    }
}

extension UIView {
    
    typealias NSXAnchor = NSLayoutXAxisAnchor
    
    typealias NSYAnchor = NSLayoutYAxisAnchor
    
    typealias NSDimension = NSLayoutDimension
    
    var leading: NSXAnchor {
        return leadingAnchor
    }
    
    var trailing: NSXAnchor {
        return trailingAnchor
    }
    
    var top: NSYAnchor {
        return topAnchor
    }
    
    var bottom: NSYAnchor {
        return bottomAnchor
    }
    
    var width: NSDimension {
        return widthAnchor
    }
    
    var height: NSDimension {
        return heightAnchor
    }
    
    var centerY: NSYAnchor {
        return centerYAnchor
    }
    
    var centerX: NSXAnchor {
        return centerXAnchor
    }
}
