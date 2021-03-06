import UIKit
import Foundation

// MARK: - HorizontalItem

public class HorizontalItem: UIView {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()
  }

  public convenience init() {
    self.init(Parameters())
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public var parameters: Parameters { didSet { update() } }

  // MARK: Private

  private var innerView = UIView(frame: .zero)

  private func setUpViews() {
    addSubview(innerView)

    innerView.backgroundColor = Colors.secondary
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    innerView.translatesAutoresizingMaskIntoConstraints = false

    let widthAnchorConstraint = widthAnchor.constraint(equalToConstant: 30)
    let innerViewTopAnchorConstraint = innerView.topAnchor.constraint(equalTo: topAnchor)
    let innerViewBottomAnchorConstraint = innerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    let innerViewLeadingAnchorConstraint = innerView.leadingAnchor.constraint(equalTo: leadingAnchor)
    let innerViewWidthAnchorConstraint = innerView.widthAnchor.constraint(equalToConstant: 30)

    NSLayoutConstraint.activate([
      widthAnchorConstraint,
      innerViewTopAnchorConstraint,
      innerViewBottomAnchorConstraint,
      innerViewLeadingAnchorConstraint,
      innerViewWidthAnchorConstraint
    ])
  }

  private func update() {}
}

// MARK: - Parameters

extension HorizontalItem {
  public struct Parameters: Equatable {
    public init() {}
  }
}

// MARK: - Model

extension HorizontalItem {
  public struct Model: LonaViewModel, Equatable {
    public var parameters: Parameters
    public var type: String {
      return "HorizontalItem"
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init() {
      self.init(Parameters())
    }
  }
}
