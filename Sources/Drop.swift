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
#elseif os(macOS)
import AppKit
#endif

#if os(iOS) || os(tvOS) || os(visionOS) || os(macOS)

/// An object representing a drop.
@available(iOSApplicationExtension, unavailable)
@available(tvOSApplicationExtension, unavailable)
@available(macOSApplicationExtension, unavailable)
public struct Drop: ExpressibleByStringLiteral {
  #if os(macOS)
  /// Create a new drop.
  /// - Parameters:
  ///   - title: Title.
  ///   - titleNumberOfLines: Maximum number of lines that `title` can occupy. Defaults to `1`.
  ///   A value of 0 means no limit.
  ///   - titleColor: Optional title text color. Defaults to `nil` which uses the system label color.
  ///   - subtitle: Optional subtitle. Defaults to `nil`.
  ///   - subtitleNumberOfLines: Maximum number of lines that `subtitle` can occupy. Defaults to `1`.
  ///   A value of 0 means no limit.
  ///   - subtitleColor: Optional subtitle text color. Defaults to `nil` which uses the system secondary label color.
  ///   - icon: Optional icon.
  ///   - iconColor: Optional icon tint color. Defaults to `nil` which uses the app's accent color.
  ///   - background: Background style. Defaults to `.glass` on macOS 26+ and `.standard` on earlier versions.
  ///   - action: Optional action.
  ///   - position: Position. Defaults to `Drop.Position.top`.
  ///   - duration: Duration. Defaults to `Drop.Duration.recommended`.
  ///   - accessibility: Accessibility options. Defaults to `nil` which will use "title, subtitle" as its message.
  public init(
    title: String,
    titleNumberOfLines: Int = 1,
    titleColor: NSColor? = nil,
    subtitle: String? = nil,
    subtitleNumberOfLines: Int = 1,
    subtitleColor: NSColor? = nil,
    icon: NSImage? = nil,
    iconColor: NSColor? = nil,
    background: Background = .default,
    action: Action? = nil,
    position: Position = .top,
    duration: Duration = .recommended,
    accessibility: Accessibility? = nil
  ) {
    self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
    self.titleNumberOfLines = titleNumberOfLines
    self.titleColor = titleColor
    if let subtitle = subtitle?.trimmingCharacters(in: .whitespacesAndNewlines), !subtitle.isEmpty {
      self.subtitle = subtitle
    }
    self.subtitleNumberOfLines = subtitleNumberOfLines
    self.subtitleColor = subtitleColor
    self.icon = icon
    self.iconColor = iconColor
    self.background = background
    self.action = action
    self.position = position
    self.duration = duration
    self.accessibility = accessibility
    ?? .init(message: [title, subtitle].compactMap { $0 }.joined(separator: ", "))
  }
  #else
  /// Create a new drop.
  /// - Parameters:
  ///   - title: Title.
  ///   - titleNumberOfLines: Maximum number of lines that `title` can occupy. Defaults to `1`.
  ///   A value of 0 means no limit.
  ///   - titleColor: Optional title text color. Defaults to `nil` which uses the system label color.
  ///   - subtitle: Optional subtitle. Defaults to `nil`.
  ///   - subtitleNumberOfLines: Maximum number of lines that `subtitle` can occupy. Defaults to `1`.
  ///   A value of 0 means no limit.
  ///   - subtitleColor: Optional subtitle text color. Defaults to `nil` which uses the system secondary label color.
  ///   - icon: Optional icon.
  ///   - iconColor: Optional icon tint color. Defaults to `nil` which uses the app's accent color.
  ///   - background: Background style. Defaults to `.glass` on iOS/tvOS/visionOS 26+ and `.standard` on earlier versions.
  ///   - action: Optional action.
  ///   - position: Position. Defaults to `Drop.Position.top`.
  ///   - duration: Duration. Defaults to `Drop.Duration.recommended`.
  ///   - accessibility: Accessibility options. Defaults to `nil` which will use "title, subtitle" as its message.
  public init(
    title: String,
    titleNumberOfLines: Int = 1,
    titleColor: UIColor? = nil,
    subtitle: String? = nil,
    subtitleNumberOfLines: Int = 1,
    subtitleColor: UIColor? = nil,
    icon: UIImage? = nil,
    iconColor: UIColor? = nil,
    background: Background = .default,
    action: Action? = nil,
    position: Position = .top,
    duration: Duration = .recommended,
    accessibility: Accessibility? = nil
  ) {
    self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
    self.titleNumberOfLines = titleNumberOfLines
    self.titleColor = titleColor
    if let subtitle = subtitle?.trimmingCharacters(in: .whitespacesAndNewlines), !subtitle.isEmpty {
      self.subtitle = subtitle
    }
    self.subtitleNumberOfLines = subtitleNumberOfLines
    self.subtitleColor = subtitleColor
    self.icon = icon
    self.iconColor = iconColor
    self.background = background
    self.action = action
    self.position = position
    self.duration = duration
    self.accessibility = accessibility
    ?? .init(message: [title, subtitle].compactMap { $0 }.joined(separator: ", "))
  }
  #endif

  /// Create a drop from a string literal.
  /// - Parameter title: Title string.
  public init(stringLiteral title: String) {
    self.title = title
    titleNumberOfLines = 1
    subtitleNumberOfLines = 1
    background = .default
    position = .top
    duration = .recommended
    accessibility = .init(message: title)
  }

  /// Title.
  public var title: String

  /// Maximum number of lines that `title` can occupy. A value of 0 means no limit.
  public var titleNumberOfLines: Int

  #if os(macOS)
  /// Optional title text color. `nil` uses the system label color.
  public var titleColor: NSColor?

  /// Subtitle.
  public var subtitle: String?

  /// Maximum number of lines that `subtitle` can occupy. A value of 0 means no limit.
  public var subtitleNumberOfLines: Int

  /// Optional subtitle text color. `nil` uses the system secondary label color.
  public var subtitleColor: NSColor?

  /// Icon.
  public var icon: NSImage?

  /// Optional icon tint color. `nil` uses the app's accent color.
  public var iconColor: NSColor?
  #else
  /// Optional title text color. `nil` uses `.label`.
  public var titleColor: UIColor?

  /// Subtitle.
  public var subtitle: String?

  /// Maximum number of lines that `subtitle` can occupy. A value of 0 means no limit.
  public var subtitleNumberOfLines: Int

  /// Optional subtitle text color. `nil` uses `.secondaryLabel`.
  public var subtitleColor: UIColor?

  /// Icon.
  public var icon: UIImage?

  /// Optional icon tint color. `nil` uses the app's accent color.
  public var iconColor: UIColor?
  #endif

  /// Background style.
  public var background: Background

  /// Action.
  public var action: Action?

  /// Position.
  public var position: Position

  /// Duration.
  public var duration: Duration

  /// Accessibility.
  public var accessibility: Accessibility
}

public extension Drop {
  /// An enum representing drop presentation position.
  enum Position: Equatable {
    /// Drop is presented from top.
    case top
    /// Drop is presented from bottom.
    case bottom
  }
}

public extension Drop {
  /// An enum representing a drop duration on screen.
  enum Duration: Equatable, ExpressibleByFloatLiteral {
    /// Hides the drop after 2.0 seconds.
    case recommended
    /// Hides the drop after the specified number of seconds.
    case seconds(TimeInterval)

    /// Create a new duration object.
    /// - Parameter value: Duration in seconds
    public init(floatLiteral value: TimeInterval) {
      self = .seconds(value)
    }

    internal var value: TimeInterval {
      switch self {
      case .recommended:
        return 2.0
      case let .seconds(custom):
        return abs(custom)
      }
    }
  }
}

public extension Drop {
  /// An object representing a drop action.
  struct Action {
    /// Create a new action.
    /// - Parameters:
    ///   - icon: Optional icon image.
    ///   - handler: Handler to be called when the drop is tapped.
    #if os(macOS)
    public init(
      icon: NSImage? = nil,
      handler: @escaping () -> Void
    ) {
      self.icon = icon
      self.handler = handler
    }
    #else
    public init(
      icon: UIImage? = nil,
      handler: @escaping () -> Void
    ) {
      self.icon = icon
      self.handler = handler
    }
    #endif

    #if os(macOS)
    /// Icon.
    public var icon: NSImage?
    #else
    /// Icon.
    public var icon: UIImage?
    #endif

    /// Handler.
    public var handler: () -> Void
  }
}

public extension Drop {
  /// An enum representing the background style of a drop.
  enum Background: Equatable {
    /// Standard opaque background using the system secondary background color.
    case standard
    /// Liquid Glass material background. Falls back to `.standard` on platforms prior to iOS/macOS 26.
    case glass

    /// The platform-appropriate default background.
    /// Returns `.glass` on iOS/tvOS/visionOS/macOS 26.0+ and `.standard` on earlier versions.
    public static var `default`: Background {
      #if os(iOS) || os(tvOS) || os(visionOS)
      if #available(iOS 26.0, tvOS 26.0, visionOS 26.0, *) {
        return .glass
      }
      #elseif os(macOS)
      if #available(macOS 26.0, *) {
        return .glass
      }
      #endif
      return .standard
    }
  }
}

public extension Drop {
  /// An object representing accessibility options.
  struct Accessibility: ExpressibleByStringLiteral {
    /// Create a new accessibility object.
    /// - Parameter message: Message to be announced when the drop is shown. Defaults to drop's "title, subtitle"
    public init(message: String) {
      self.message = message
    }

    /// Create a new accessibility object.
    /// - Parameter message: Message to be announced when the drop is shown. Defaults to drop's "title, subtitle"
    public init(stringLiteral message: String) {
      self.message = message
    }

    /// Accessibility message to be announced when the drop is shown.
    public let message: String
  }
}
#endif
