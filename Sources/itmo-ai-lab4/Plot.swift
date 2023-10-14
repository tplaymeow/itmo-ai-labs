import Foundation

internal func boxplot(
  x: [Double],
  output: String
) throws {
  try gnuplot(path: "/usr/local/bin/gnuplot") {
    """
    $data << EOD
    \(x.map { "\($0)" }.joined(separator: "\n"))
    EOD

    reset

    set terminal pngcairo size 1440,900 enhanced font 'Times,12'
    set output '\(output)'

    set offset graph 0.05, graph 0.05, graph 0.05, graph 0.05

    set style fill solid 0.25 border -1
    set style boxplot outliers pointtype 7
    set style data boxplot

    plot '$data'

    q
    """
  }
}

internal func scatter(
  x: [Double],
  y: [Double],
  output: String
) throws {
  try gnuplot(path: "/usr/local/bin/gnuplot") {
    """
    $data << EOD
    \(zip(x, y).map { "\($0) \($1)" }.joined(separator: "\n"))
    EOD

    reset

    set terminal pngcairo size 1440,900 enhanced font 'Times,12'
    set output '\(output)'

    set offset graph 0.05, graph 0.05, graph 0.05, graph 0.05

    set border linewidth 1.5
    set style line 1 lc rgb '#200060ad' pt 7 ps 1.5 lt 1 lw 2 # --- blue

    unset key

    set style line 11 lc rgb '#808080' lt 1
    set border 3 back ls 11
    set tics nomirror out scale 0.75
    set style line 12 lc rgb'#808080' lt 0 lw 1
    set grid back ls 12

    plot '$data' w p ls 1

    q
    """
  }
}

internal func gnuplot(
  path: String,
  command: () -> String
) throws {
  let process = Process()
  let input = Pipe()

  process.executableURL = URL(fileURLWithPath: path)
  process.standardInput = input
  process.launch()

  if let data = command().data(using: .utf8) {
    try input.fileHandleForWriting.write(contentsOf: data)
  }
}
