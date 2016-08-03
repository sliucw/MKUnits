//
//  Unit.swift
//  MKUnits
//
//  Copyright (c) 2016 Michal Konturek <michal.konturek@gmail.com>
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
//

import Foundation

public class Unit {
    public let name: String
    public let symbol: String
    public let ratio: NSDecimalNumber

    public init(name: String, symbol: String, ratio: NSNumber) {
        self.name = name
        self.symbol = symbol
        self.ratio = NSDecimalNumber(decimal: ratio.decimalValue)
    }

    public func convertFromBaseUnit(amount: NSNumber) -> NSNumber {
        let converted = NSDecimalNumber(decimal: amount.decimalValue)
        return converted.decimalNumberByDividingBy(self.ratio)
    }

    public func convertToBaseUnit(amount: NSNumber) -> NSNumber {
        let converted = NSDecimalNumber(decimal: amount.decimalValue)
        return converted.decimalNumberByMultiplyingBy(self.ratio)
    }
}

// MARK: - CustomStringConvertible

extension Unit: CustomStringConvertible {
    public var description: String {
        return self.symbol
    }
}

// MARK: - UnitConvertible

public protocol UnitConvertible {
    func convert(amount: NSNumber, to: Unit) -> NSNumber
    func convert(amount: NSNumber, from: Unit) -> NSNumber
    func convert(amount: NSNumber, from: Unit, to: Unit) -> NSNumber
    func isConvertible(with: Unit) -> Bool
}

extension Unit: UnitConvertible {

    public func convert(amount: NSNumber, to: Unit) -> NSNumber {
        return self.convert(amount, from: self, to: to)
    }

    public func convert(amount: NSNumber, from: Unit) -> NSNumber {
        return self.convert(amount, from: from, to: self)
    }

    public func convert(amount: NSNumber, from: Unit, to: Unit) -> NSNumber {
        let baseAmount = from.convertToBaseUnit(amount)
        let converted = to.convertFromBaseUnit(baseAmount)
        return converted
    }

    public func isConvertible(with: Unit) -> Bool {
        return with.dynamicType == self.dynamicType
    }
}

// MARK: - Equatable

extension Unit: Equatable {
    public func equals(other: Unit) -> Bool {
        if other.dynamicType !== self.dynamicType {
            return false
        }
        return self.symbol == other.symbol
    }
}
public func == <T where T: Unit>(lhs: T, rhs: T) -> Bool {
    return lhs.equals(rhs)
}