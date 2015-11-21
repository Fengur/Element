import Foundation

class Button:Element {
    override init(_ width: CGFloat, _ height: CGFloat, _ parent:IElement? = nil,_ id:String? = nil){
        super(width,height,parent,id)
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
