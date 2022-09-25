import SwiftUI
//
//  FlexStack.swift
//  SearchMart
//
//  Created by Tanshow on 2022/9/25.
//
//  FlexStack Layout

@available(iOS 16.0, *)
struct FlexStack: Layout {
  
  public var verticalSpacing = 8.0
  public var horzontalSpacing = 8.0
  
  
  static var layoutProperties: LayoutProperties {
    var properties = LayoutProperties()
    properties.stackOrientation = .none
    return properties
  }
  
  struct CacheData {
    var matrix: [[Subviews.Element]] = [[]]
    var maxHeight: CGFloat = 0.0
  }
  
  func makeCache(subviews: Subviews) -> CacheData {
    return CacheData()
  }
  
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
    
    let matrix = getMetrix(from: subviews, in: proposal)
    
    cache.matrix = matrix
    
    let maxHeight = matrix.reduce(0) { $0 + getMaxHeight(of: $1) + verticalSpacing } - verticalSpacing
    
    cache.maxHeight = maxHeight
    
    return CGSize(width: proposal.width ?? .infinity, height: maxHeight)
    
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
    var pointer = CGPoint(x: bounds.minX, y: bounds.minY)
    for line in cache.matrix {
      line.forEach { subview in
        subview.place(at: pointer, proposal: .unspecified)
        pointer.x += subview.sizeThatFits(.unspecified).width + horzontalSpacing
      }
      pointer.x = bounds.minX
      pointer.y += getMaxHeight(of: line) + verticalSpacing
    }
  }
  
  /// Caculate the matrix of subviews
  func getMetrix(from subviews: Subviews, in proposal: ProposedViewSize) -> [[Subviews.Element]] {
    var matrixBuffer = [[]] as [[Subviews.Element]]
    
    // Flags
    let maxLineWidth = proposal.width ?? .infinity
    var lineWidthBuffer = 0.0
    var outterIndexBuffer = 0
    var isFirstOfLine = false
    
    for (_, subview) in subviews.enumerated() {
      
      lineWidthBuffer += subview.sizeThatFits(.unspecified).width
      
      // Handle with that the width of the first of line is wider than fmaxLineWidth
      if isFirstOfLine && lineWidthBuffer >= maxLineWidth {
        // Break line
        outterIndexBuffer += 1
        matrixBuffer.append([subview])
        lineWidthBuffer = 0.0
        isFirstOfLine = true
        continue
      }
      
      // Normal handle
      if lineWidthBuffer > maxLineWidth {
        // Break line
        outterIndexBuffer += 1
        lineWidthBuffer = subview.sizeThatFits(.unspecified).width + horzontalSpacing
        matrixBuffer.append([subview])
        isFirstOfLine = true
      } else {
        // Not break line
        matrixBuffer[outterIndexBuffer].append(subview)
        lineWidthBuffer += horzontalSpacing
        isFirstOfLine = false
      }
      
    }
    
    // print(matrixBuffer.map {$0.map { $0.sizeThatFits(.unspecified).width }})
    return matrixBuffer
  }
  
  /// Calculate max height of subviews
  func getMaxHeight(of subviews: [Subviews.Element]) -> CGFloat{
    return subviews.reduce(0) { max($0, $1.sizeThatFits(.unspecified).height) }
  }
  
}
