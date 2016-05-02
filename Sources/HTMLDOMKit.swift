import Foundation

public protocol DOMConvertible {
    func toHTML() -> String
}

public extension DOMConvertible {
    var DOMKeyTag:String {
        return "tag"
    }
    
    var DOMKeyAttributes:String {
        return "attributes"
    }
    
    var DOMKeyChildren:String {
        return "children"
    }
    
    var DOMKeyContent:String {
        return "content"
    }
}

public struct DOMElement {
    public var tag:String = ""
    public var attributes:[DOMAttribute] = []
    public var content:String = ""
    public var children:[DOMElement] = []
    
    public init() {
        
    }
    
    public init?<K:Hashable, V>(dictionary:Dictionary<K, V>) {
        
        if let tag = dictionary.valueForKey(DOMKeyTag) as? String {
            self.tag = tag
        }
        
        if let content = dictionary.valueForKey(DOMKeyContent) as? String where tag.isEmpty {
            self.content = content
        }
        
        guard !tag.isEmpty || !content.isEmpty else {
            return
        }
        
        if let att = dictionary.valueForKey(DOMKeyAttributes) as? [String:AnyObject] {
            let attr = att.attributesFromDictionary()
            attributes = attr
        }
        
        if let children = dictionary.valueForKey(DOMKeyChildren) as? [AnyObject] {
            for child in children {
                if let object = child as? Dictionary<K, V>, let item = DOMElement(dictionary:object) {
                    self.children.append(item)
                }
            }
        }
    }
}

public struct DOMAttribute {
    public let key:String
    public let value:AnyObject
    public init(key:String, value:AnyObject) {
        self.key = key
        self.value = value
    }
}
extension DOMAttribute: DOMConvertible{
    public func toHTML() -> String {
        
        let dict = [key:value]
        
        return dict.attributeStringFromDictionary()
    }
}

extension Dictionary {
    public func valueForKey(key:String) -> AnyObject? {
        let values = Array(self.values)
        for (index, k) in self.keys.enumerate() {
            if
                let k = k as? String, let value = values[index] as? AnyObject where k == key {
                
                return value
                
            }
        }
        return nil
    }
}

extension DOMElement: DOMConvertible{
    public func toHTML() -> String {
        
        if !tag.isEmpty {
            var startTag = "<\(tag)"
            let endTag = "</\(tag)>"
            
            var dict:[String:AnyObject] = [:]
            for attribute in attributes {
                dict.updateValue(attribute.value, forKey: attribute.key)
            }
            startTag += dict.attributeStringFromDictionary()
            
            startTag += ">"
            
            for child in children {
                
                startTag += child.toHTML()
            }
            
            return startTag + endTag
        }
        
        return content
    }
}

extension Dictionary: DOMConvertible{
    
    public func toHTML() -> String {
        
        if let tagName = self.valueForKey(DOMKeyTag) {
            var startTag = "<\(tagName)"
            let endTag = "</\(tagName)>"
            
            if let att = self.valueForKey(DOMKeyAttributes) as? [String:AnyObject] {
                let attr = att.attributeStringFromDictionary()
                
                startTag += attr
            }
            
            startTag += ">"
            
            if let children = self.valueForKey(DOMKeyChildren) as? [AnyObject] {
                
                for child in children {
                    
                    if let object = child as? Dictionary {
                        let item = object.toHTML()
                        startTag += item
                    }
                }
            }
            
            return startTag + endTag
        }
        
        if let content = self.valueForKey(DOMKeyContent) as? String {
            return content
        }
        
        return ""
    }
    
    func attributesFromDictionary() -> [DOMAttribute] {
        
        var attributes:[DOMAttribute] = []
        
        for (key, value) in self {
            guard let key = key as? String, let value = value as? AnyObject else {
                break
            }
            
            switch value {
            case is String, is Int8, is Int16, is Int32, is Int64, is Float, is Double:
                
                let attribute = DOMAttribute(key: key, value: value)
                
                attributes.append(attribute)
            default:
                break
            }
            
        }
        
        return attributes
    }
    
    func attributeStringFromDictionary() -> String {
        
        var att = ""
        
        for (key, value) in self {
            
            switch value {
            case is String:
                att += " \(key)=\"\(value)\" "
            case is Int8, is Int16, is Int32, is Int64, is Float, is Double:
                att += " \(key)=\(value) "
            default:
                break
            }
            
        }
        
        return att
    }
}