import Cocoa
@testable import Utils

class SelectParser {
    /**
     * Returns the  first selected ISelectable in an array of an NSView with ISelectables (returns nil if it doesn't exist)
     * TODO: Rename to firstSelected
     */
    static func selected(_ view:NSView) -> ISelectable? {
        let selectables:[ISelectable] = self.selectables(view)
        return selected(selectables)
    }
    /**
     * Returns the  first selected ISelectable in an array of ISelectables or a
     * TODO: Rename to firstSelected
     */
    static func selected(_ selectables:[ISelectable]) -> ISelectable? {
        return selectables.first(where: {$0.getSelected()})
    }
    /**
     * Returns an array from every child that is an ISelectable in PARAM: displayObjectContainer
     */
    static func selectables(_ view:NSView)->[ISelectable] {
        return NSViewParser.childrenOfType(view, ISelectable.self)
    }
    /**
     * Returns all selectables that are selected
     */
    static func allSelected(_ selectables:[ISelectable])->[ISelectable] {
        return selectables.filter(){$0.getSelected()}
    }
    /**
     * Returns the index of the first selected ISelectable instance in a NSView instance (returns -1 if non is found)
     * TODO: make a similar method for Array instead of NSView
     * NOTE: you could return nil instead of -1
     */
    static func index(_ view:NSView) -> Int{
        for i in 0..<view.numSubViews{//swift 3 support
            let child:NSView? = view.getSubViewAt(i)
            if(child is ISelectable && (child as! ISelectable).selected){ return i }
        }
        return -1
    }
}
