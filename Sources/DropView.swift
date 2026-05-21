//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit

internal final class DropView: UIView {
    required init(drop: Drop) {
        self.drop = drop
        super.init(frame: .zero)
        
        addSubview(stackView)
        
        let constraints = createLayoutConstraints(for: drop)
        NSLayoutConstraint.activate(constraints)
        configureViews(for: drop)
    }
    
    required init?(coder _: NSCoder) {
        return nil
    }
    
    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.cornerRadius
            glassEffectView?.layer.cornerRadius = frame.cornerRadius
        }
    }
    
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = frame.cornerRadius
            glassEffectView?.layer.cornerRadius = frame.cornerRadius
        }
    }
    
    let drop: Drop
    private var glassEffectView: UIVisualEffectView?
    
    func createLayoutConstraints(for drop: Drop) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += [
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25)
        ]
        
        constraints += [
            button.heightAnchor.constraint(equalToConstant: 35),
            button.widthAnchor.constraint(equalToConstant: 35)
        ]
        
        var insets = UIEdgeInsets(top: 7.5, left: 12.5, bottom: 7.5, right: 12.5)
        
        if drop.icon == nil {
            insets.left = 40
        }
        
        if drop.action?.icon == nil {
            insets.right = 40
        }
        
        if drop.subtitle == nil {
            insets.top = 15
            insets.bottom = 15
            if drop.action?.icon != nil {
                insets.top = 10
                insets.bottom = 10
                insets.right = 10
            }
        }
        
        if drop.icon == nil, drop.action?.icon == nil {
            insets.left = 50
            insets.right = 50
        }
        
        constraints += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
        
        return constraints
    }
    
    func configureViews(for drop: Drop) {
        titleLabel.text = drop.title
        titleLabel.numberOfLines = drop.titleNumberOfLines
        titleLabel.textColor = drop.titleColor ?? .label
        
        subtitleLabel.text = drop.subtitle
        subtitleLabel.numberOfLines = drop.subtitleNumberOfLines
        subtitleLabel.isHidden = drop.subtitle == nil
        subtitleLabel.textColor = drop.subtitleColor ?? (UIAccessibility.isDarkerSystemColorsEnabled ? .label : .secondaryLabel)
        
        imageView.image = drop.icon
        imageView.isHidden = drop.icon == nil
        if let iconColor = drop.iconColor {
            imageView.tintColor = iconColor
        }
        
        button.setImage(drop.action?.icon, for: .normal)
        button.isHidden = drop.action?.icon == nil
        
        if let action = drop.action, action.icon == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
            addGestureRecognizer(tap)
        }
        
        if #available(iOS 26.0, tvOS 26.0, visionOS 26.0, *), drop.background == .glass {
            backgroundColor = .clear
            clipsToBounds = true
            let effect = UIGlassEffect()
            let effectView = UIVisualEffectView(effect: effect)
            effectView.translatesAutoresizingMaskIntoConstraints = false
            effectView.clipsToBounds = true
            insertSubview(effectView, at: 0)
            glassEffectView = effectView
            NSLayoutConstraint.activate([
                effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
                effectView.trailingAnchor.constraint(equalTo: trailingAnchor),
                effectView.topAnchor.constraint(equalTo: topAnchor),
                effectView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            #if os(iOS) || os(visionOS)
            backgroundColor = .secondarySystemBackground
            #endif
            clipsToBounds = true
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = .zero
            layer.shadowRadius = 25
            layer.shadowOpacity = 0.15
            layer.shouldRasterize = true
            #if os(iOS)
            layer.rasterizationScale = UIScreen.main.scale
            #endif
            layer.masksToBounds = false
        }
    }
    
    @objc
    func didTapButton() {
        drop.action?.handler()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).bold
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIAccessibility.isDarkerSystemColorsEnabled ? .label : .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = RoundImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    lazy var button: UIButton = {
        let button = RoundButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .link
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()
    
    lazy var labelsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = -1
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, labelsStackView, button])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        if drop.icon != nil, drop.action?.icon != nil {
            view.spacing = 20
        } else {
            view.spacing = 15
        }
        return view
    }()
}

final class RoundButton: UIButton {
    override var bounds: CGRect {
        didSet { layer.cornerRadius = frame.cornerRadius }
    }
}

final class RoundImageView: UIImageView {
    override var bounds: CGRect {
        didSet { layer.cornerRadius = frame.cornerRadius }
    }
}

extension UIFont {
    var bold: UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

extension CGRect {
    var cornerRadius: CGFloat {
        return min(width, height) / 2
    }
}
#elseif os(macOS)
import AppKit

internal final class DropView: NSView {
    required init(drop: Drop) {
        self.drop = drop
        super.init(frame: .zero)
        wantsLayer = true
        
        addSubview(stackView)
        
        let constraints = createLayoutConstraints(for: drop)
        NSLayoutConstraint.activate(constraints)
        configureViews(for: drop)
    }
    
    required init?(coder _: NSCoder) {
        return nil
    }
    
    override var isFlipped: Bool { true }
    
    override func layout() {
        super.layout()
        layer?.cornerRadius = frame.cornerRadius
        glassEffectView?.layer?.cornerRadius = frame.cornerRadius
    }
    
    let drop: Drop
    private var glassEffectView: NSVisualEffectView?
    
    func createLayoutConstraints(for drop: Drop) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += [
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25)
        ]
        
        constraints += [
            button.heightAnchor.constraint(equalToConstant: 35),
            button.widthAnchor.constraint(equalToConstant: 35)
        ]
        
        var insets = NSEdgeInsets(top: 7.5, left: 12.5, bottom: 7.5, right: 12.5)
        
        if drop.icon == nil {
            insets.left = 40
        }
        
        if drop.action?.icon == nil {
            insets.right = 40
        }
        
        if drop.subtitle == nil {
            insets.top = 15
            insets.bottom = 15
            if drop.action?.icon != nil {
                insets.top = 10
                insets.bottom = 10
                insets.right = 10
            }
        }
        
        if drop.icon == nil, drop.action?.icon == nil {
            insets.left = 50
            insets.right = 50
        }
        
        constraints += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
        
        return constraints
    }
    
    func configureViews(for drop: Drop) {
        titleLabel.stringValue = drop.title
        titleLabel.maximumNumberOfLines = drop.titleNumberOfLines
        titleLabel.textColor = drop.titleColor ?? .labelColor
        
        subtitleLabel.stringValue = drop.subtitle ?? ""
        subtitleLabel.maximumNumberOfLines = drop.subtitleNumberOfLines
        subtitleLabel.isHidden = drop.subtitle == nil
        subtitleLabel.textColor = drop.subtitleColor ?? .secondaryLabelColor
        
        imageView.image = drop.icon
        imageView.isHidden = drop.icon == nil
        if let iconColor = drop.iconColor {
            imageView.contentTintColor = iconColor
        }
        
        button.image = drop.action?.icon
        button.isHidden = drop.action?.icon == nil
        
        if let action = drop.action, action.icon == nil {
            let click = NSClickGestureRecognizer(target: self, action: #selector(didTapButton))
            addGestureRecognizer(click)
        }
        
        if #available(macOS 26.0, *), drop.background == .glass {
            layer?.backgroundColor = NSColor.clear.cgColor
            let effectView = NSVisualEffectView()
            effectView.translatesAutoresizingMaskIntoConstraints = false
            effectView.material = .hudWindow
            effectView.blendingMode = .behindWindow
            effectView.state = .active
            effectView.wantsLayer = true
            effectView.layer?.masksToBounds = true
            addSubview(effectView, positioned: .below, relativeTo: stackView)
            glassEffectView = effectView
            NSLayoutConstraint.activate([
                effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
                effectView.trailingAnchor.constraint(equalTo: trailingAnchor),
                effectView.topAnchor.constraint(equalTo: topAnchor),
                effectView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
            layer?.masksToBounds = false
            let shadow = NSShadow()
            shadow.shadowColor = NSColor.black.withAlphaComponent(0.15)
            shadow.shadowOffset = .zero
            shadow.shadowBlurRadius = 25
            self.shadow = shadow
        }
    }
    
    @objc
    func didTapButton() {
        drop.action?.handler()
    }
    
    lazy var titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = .center
        label.textColor = .labelColor
        label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .small), weight: .bold)
        label.lineBreakMode = .byTruncatingTail
        label.cell?.truncatesLastVisibleLine = true
        return label
    }()
    
    lazy var subtitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = .center
        label.textColor = .secondaryLabelColor
        label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .small))
        label.lineBreakMode = .byTruncatingTail
        label.cell?.truncatesLastVisibleLine = true
        return label
    }()
    
    lazy var imageView: NSImageView = {
        let view = NSImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageScaling = .scaleProportionallyUpOrDown
        return view
    }()
    
    lazy var button: NSButton = {
        let button = NSButton(title: "", target: self, action: #selector(didTapButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
        button.contentTintColor = .white
        button.imageScaling = .scaleProportionallyUpOrDown
        button.imagePosition = .imageOnly
        return button
    }()
    
    lazy var labelsStackView: NSStackView = {
        let view = NSStackView(views: [titleLabel, subtitleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .vertical
        view.alignment = .centerX
        view.distribution = .fill
        view.spacing = 0
        return view
    }()
    
    lazy var stackView: NSStackView = {
        let view = NSStackView(views: [imageView, labelsStackView, button])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.orientation = .horizontal
        view.alignment = .centerY
        view.distribution = .fill
        if drop.icon != nil, drop.action?.icon != nil {
            view.spacing = 20
        } else {
            view.spacing = 15
        }
        return view
    }()
}

extension NSFont {
    var bold: NSFont {
        return NSFontManager.shared.convert(self, toHaveTrait: .boldFontMask)
    }
}

extension CGRect {
    var cornerRadius: CGFloat {
        return min(width, height) / 2
    }
}
#endif
