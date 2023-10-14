@inlinable
public func trainTestSplit<S: Sequence, G: RandomNumberGenerator>(
  _ sequence: S,
  by proportion: Double,
  using generator: inout G
) -> (train: ArraySlice<S.Element>, test: ArraySlice<S.Element>) {
  let shuffled = sequence.shuffled(using: &generator)
  let splitPosition = Int(Double(shuffled.count) * proportion)
  return (shuffled[..<splitPosition], shuffled[splitPosition...])
}

@inlinable
public func trainTestSplit<S: Sequence>(
  _ sequence: S,
  by proportion: Double
) -> (train: ArraySlice<S.Element>, test: ArraySlice<S.Element>) {
  var generator = SystemRandomNumberGenerator()
  return trainTestSplit(sequence, by: proportion, using: &generator)
}
