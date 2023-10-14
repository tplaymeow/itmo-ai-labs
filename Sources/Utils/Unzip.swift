@inlinable
public func unzip<S: Sequence, A, B>(
  _ sequence: S
) -> ([A], [B]) where S.Element == (A, B) {
  sequence.reduce(into: ([], [])) {
    $0.0.append($1.0)
    $0.1.append($1.1)
  }
}
