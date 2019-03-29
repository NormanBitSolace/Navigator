import UIKit

extension UIView {
    @discardableResult public func addEmitterView(imageType: EmitterImageType, colors: [UIColor] = [.brown,.magenta,.cyan,.purple,.red,.blue,.green,.orange,.yellow]) -> ImageEmitterView {
        let emitterView = ImageEmitterView(frame: bounds)
        self.addSubview(emitterView)
        emitterView.constrain(to: self)
        emitterView.startConfetti(imageType: imageType, colors: colors)
        return emitterView
    }
}

public enum EmitterImageType {
    case confetti
    case triangle
    case star
    case diamond
    case Image(UIImage)
}

public class ImageEmitterView: UIView {

    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    public var type: EmitterImageType!
    private var active :Bool!

    public func startConfetti(imageType: EmitterImageType, colors: [UIColor]) {
        self.colors = colors
        intensity = 0.4
        type = imageType
        active = false
        clipsToBounds = true
        isUserInteractionEnabled = false

        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)

        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color))
        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }

    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }

    func imageForType(_ type: EmitterImageType) -> UIImage? {

        var fileName: String!

        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .Image(customImage):
            return customImage
        }

        let image = UIImage.init(named: fileName)
        return image
    }

    func confettiWithColor(_ color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 24.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = .pi
        confetti.emissionRange = .pi / 4.0
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type)!.cgImage
        return confetti
    }

    public func isActive() -> Bool {
        return self.active
    }
}

