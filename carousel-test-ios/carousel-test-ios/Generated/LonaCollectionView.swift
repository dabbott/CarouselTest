
import UIKit

// MARK: - LonaCollectionViewCell

public class LonaCollectionViewCell<T: UIView>: UICollectionViewCell {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    setUpViews()
    setUpConstraints()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public var view: T = T()

  public var scrollDirection = UICollectionView.ScrollDirection.vertical

  override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    layoutIfNeeded()

    let preferredLayoutAttributes =
      super.preferredLayoutAttributesFitting(layoutAttributes);
    preferredLayoutAttributes.bounds = layoutAttributes.bounds;

    switch scrollDirection {
    case .vertical:
      preferredLayoutAttributes.bounds.size.height = systemLayoutSizeFitting(
        UIView.layoutFittingCompressedSize,
        withHorizontalFittingPriority: .required,
        verticalFittingPriority: .defaultLow).height
    case .horizontal:
      preferredLayoutAttributes.bounds.size.width = systemLayoutSizeFitting(
        UIView.layoutFittingCompressedSize,
        withHorizontalFittingPriority: .defaultLow,
        verticalFittingPriority: .required).width
    }

    return preferredLayoutAttributes
  }

  // MARK: Private

  private func setUpViews() {
    contentView.addSubview(view)
  }

  private func setUpConstraints() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

    let width = contentView.widthAnchor.constraint(equalTo: widthAnchor)
    width.priority = .required - 1
    width.isActive = true

    let height = contentView.heightAnchor.constraint(equalTo: heightAnchor)
    height.priority = .required - 1
    height.isActive = true

    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }

}

// MARK: - LonaCollectionViewListLayout

public class LonaCollectionViewListLayout: UICollectionViewFlowLayout {
  override public init() {
    super.init()

    self.minimumInteritemSpacing = 0
    self.minimumLineSpacing = 0
    self.sectionInset = .zero
    self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath),
      let collectionView = collectionView else { return nil }

    switch scrollDirection {
    case .vertical:
      layoutAttributes.bounds.size.width =
        collectionView.safeAreaLayoutGuide.layoutFrame.width -
        sectionInset.left - sectionInset.right -
        collectionView.adjustedContentInset.left - collectionView.adjustedContentInset.right
    case .horizontal:
      layoutAttributes.bounds.size.height =
        collectionView.safeAreaLayoutGuide.layoutFrame.height -
        sectionInset.top - sectionInset.bottom -
        collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom
    }

    return layoutAttributes
  }

  override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let superLayoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

    let computedAttributes = superLayoutAttributes.compactMap { layoutAttribute in
      return layoutAttribute.representedElementCategory == .cell
        ? layoutAttributesForItem(at: layoutAttribute.indexPath)
        : layoutAttribute
    }

    return computedAttributes
  }
}

// MARK: - LonaCollectionView

public class LonaCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

  // MARK: Lifecycle

  private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    parameters = Parameters()

    super.init(frame: frame, collectionViewLayout: LonaCollectionViewListLayout())

    contentInsetAdjustmentBehavior = .automatic
    backgroundColor = .clear

    delegate = self
    dataSource = self

    register(LonaNestedCollectionViewCell.self, forCellWithReuseIdentifier: LonaNestedCollectionViewCell.identifier)
    
    register(HorizontalItemCell.self, forCellWithReuseIdentifier: HorizontalItemCell.identifier)
    register(VerticalItemCell.self, forCellWithReuseIdentifier: VerticalItemCell.identifier)
  }

  public convenience init(
    _ parameters: Parameters = Parameters(),
    collectionViewLayout layout: UICollectionViewLayout = LonaCollectionViewListLayout()) {
    self.init(frame: .zero, collectionViewLayout: layout)

    self.parameters = parameters
  }

  public convenience init(
    items: [LonaViewModel] = [],
    scrollDirection: UICollectionView.ScrollDirection = .vertical,
    padding: UIEdgeInsets = .zero,
    itemSpacing: CGFloat = 0,
    fixedSize: CGFloat? = nil,
    collectionViewLayout layout: UICollectionViewLayout = LonaCollectionViewListLayout()) {
    self.init(
      Parameters(
        items: items,
        scrollDirection: scrollDirection,
        padding: padding,
        itemSpacing: itemSpacing,
        fixedSize: fixedSize),
      collectionViewLayout: layout)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public var parameters: Parameters {
    didSet {
      parametersDidChange(oldValue: oldValue)
    }
  }

  public var items: [LonaViewModel] {
    get { return parameters.items }
    set { parameters.items = newValue }
  }

  public var scrollDirection: UICollectionView.ScrollDirection {
    get { return parameters.scrollDirection }
    set { parameters.scrollDirection = newValue }
  }

  // MARK: Data Source

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = items[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.type, for: indexPath)
    let scrollDirection = self.scrollDirection

    switch (item.type) {
    case LonaNestedCollectionViewCell.identifier:
      if let cell = cell as? LonaNestedCollectionViewCell, let item = item as? LonaCollectionView.Model {
        cell.parameters = item.parameters
        cell.scrollDirection = scrollDirection
      }
    case HorizontalItemCell.identifier:
      if let cell = cell as? HorizontalItemCell, let item = item as? HorizontalItem.Model {
        cell.parameters = item.parameters
        cell.scrollDirection = scrollDirection
      }
    case VerticalItemCell.identifier:
      if let cell = cell as? VerticalItemCell, let item = item as? VerticalItem.Model {
        cell.parameters = item.parameters
        cell.scrollDirection = scrollDirection
      }
    default:
      break
    }

    return cell
  }

  // MARK: - Delegate

  public var onSelectItem: ((LonaViewModel) -> Void)?

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    let cell = cellForItem(at: indexPath)

    switch (item.type) {
    
    default:
      break
    }

    onSelectItem?(item)
  }

  // MARK: Scrolling

  override public func touchesShouldCancel(in view: UIView) -> Bool {
    if view is LonaControl {
      return true
    }

    return super.touchesShouldCancel(in: view)
  }

  // MARK: Private

  private func updateAlwaysBounce(for scrollDirection: ScrollDirection) {
    alwaysBounceVertical = scrollDirection == .vertical
    alwaysBounceHorizontal = scrollDirection == .horizontal
  }

  private func parametersDidChange(oldValue: Parameters) {
    updateAlwaysBounce(for: parameters.scrollDirection)
    contentInset = parameters.padding

    switch parameters.scrollDirection {
    case .horizontal:
      showsHorizontalScrollIndicator = false
    case .vertical:
      showsHorizontalScrollIndicator = true
    }
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.minimumLineSpacing = parameters.itemSpacing
      layout.scrollDirection = parameters.scrollDirection
      layout.invalidateLayout()
    }

    reloadData()
    layoutIfNeeded()

    contentOffset = CGPoint(
      x: contentOffset.x - parameters.padding.left + oldValue.padding.left,
      y: contentOffset.y - parameters.padding.top + oldValue.padding.top)
  }
}


// MARK: - Parameters

extension LonaCollectionView {
  public struct Parameters {
    public var items: [LonaViewModel]
    public var scrollDirection: UICollectionView.ScrollDirection
    public var padding: UIEdgeInsets
    public var itemSpacing: CGFloat
    public var fixedSize: CGFloat?

    public init(
      items: [LonaViewModel],
      scrollDirection: UICollectionView.ScrollDirection,
      padding: UIEdgeInsets,
      itemSpacing: CGFloat,
      fixedSize: CGFloat? = nil)
    {
      self.items = items
      self.scrollDirection = scrollDirection
      self.padding = padding
      self.itemSpacing = itemSpacing
      self.fixedSize = fixedSize
    }

    public init() {
      self.init(items: [], scrollDirection: .vertical, padding: .zero, itemSpacing: 0)
    }
  }
}

// MARK: - Model

extension LonaCollectionView {
  public struct Model: LonaViewModel {
    public var parameters: Parameters
    public var type: String {
      return "LonaCollectionView"
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(
      items: [LonaViewModel],
      scrollDirection: UICollectionView.ScrollDirection,
      padding: UIEdgeInsets = .zero,
      itemSpacing: CGFloat = 0,
      fixedSize: CGFloat? = nil)
    {
      self.init(
        Parameters(
          items: items,
          scrollDirection: scrollDirection,
          padding: padding,
          itemSpacing: itemSpacing,
          fixedSize: fixedSize))
    }

    public init() {
      self.init(items: [], scrollDirection: .vertical)
    }
  }
}

// MARK: - Cell Classes

public class LonaNestedCollectionViewCell: LonaCollectionViewCell<LonaCollectionView> {
  public var parameters: LonaCollectionView.Parameters {
    get { return view.parameters }
    set { view.parameters = newValue }
  }
  public static var identifier: String {
    return "LonaCollectionView"
  }
  override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let preferredLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

    if let fixedSize = parameters.fixedSize {
      switch scrollDirection {
      case .vertical:
        preferredLayoutAttributes.bounds.size.height = fixedSize
      case .horizontal:
        preferredLayoutAttributes.bounds.size.width = fixedSize
      }
    }

    return preferredLayoutAttributes
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    if (contentView.bounds != view.bounds) {
      view.collectionViewLayout.invalidateLayout()
    }
  }
}

public class HorizontalItemCell: LonaCollectionViewCell<HorizontalItem> {
  public var parameters: HorizontalItem.Parameters {
    get { return view.parameters }
    set { view.parameters = newValue }
  }
  public static var identifier: String {
    return "HorizontalItem"
  }
}

public class VerticalItemCell: LonaCollectionViewCell<VerticalItem> {
  public var parameters: VerticalItem.Parameters {
    get { return view.parameters }
    set { view.parameters = newValue }
  }
  public static var identifier: String {
    return "VerticalItem"
  }
}
