//
//  RGBColourParser.swift
//  Scalar2D
//
//  Created by Glenn Howes on 10/10/16.
//  Copyright © 2016 Generally Helpful Software. All rights reserved.
//
//
//
// The MIT License (MIT)

//  Copyright (c) 2016 Generally Helpful Software

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//
import Foundation

public struct RGBColourParser : ColourParser
{
    static let decimalSymbols = CharacterSet(charactersIn: "0123456789.")
    static let notRGBParameterSymbols = CharacterSet(charactersIn: "0123456789.%").inverted
    
    private func retrieveColourComponent(component: String) throws -> ColourFloat
    {
        // obviously this method is going to be pretty forgiving of garbled input.
        var componentString = component.trimmingCharacters(in: RGBColourParser.notRGBParameterSymbols)
        guard !componentString.isEmpty else
        {
            throw ColourParsingError.incomplete(component)
        }
        var isPercent = false
        if componentString.hasSuffix("%")
        {
            isPercent = true
            componentString = componentString.substring(to: componentString.index(before: componentString.endIndex))
        }
        
        guard let result = Double(componentString) else
        {
            throw ColourParsingError.unexpectedCharacter(component)
        }
        if(isPercent)
        {
            guard result >= 0.0, result <= 100.0 else
            {
                throw ColourParsingError.badRange(component)
            }
            return ColourFloat(result / 100.0)
        }
        else
        {
            guard result >= 0.0, result <= 255.0 else
            {
                throw ColourParsingError.badRange(component)
            }
            return ColourFloat(result / 255.0)
        }
    }
    
    public func deserializeString(textColour: String) throws -> Colour?
    {
        guard textColour.hasPrefix("rgb") else
        {
            return nil
        }
        
        let components = textColour.components(separatedBy: ",")
        guard  components.count == 3 else
        {
            throw ColourParsingError.unknown(textColour)
        }
        
        let red = try self.retrieveColourComponent(component: components[0])
        let green = try self.retrieveColourComponent(component: components[1])
        let blue = try self.retrieveColourComponent(component: components[2])
        
        
        return Colour.rgb(red: red, green: green, blue: blue)
        
    }
    
    public init()
    {
        
    }
}