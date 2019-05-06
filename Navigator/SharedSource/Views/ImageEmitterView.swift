import UIKit

let emitterDefaultColors: [UIColor] = [.brown, .magenta, .cyan, .purple, .red, .blue, .green, .orange, .yellow]

extension UIView {
    @discardableResult func addEmitterView(imageType: EmitterImageType, colors: [UIColor] = emitterDefaultColors) -> ImageEmitterView {
        let emitterView = ImageEmitterView(frame: bounds)
        self.addSubview(emitterView)
        emitterView.constrain(to: self)
        emitterView.startConfetti(imageType: imageType, colors: colors)
        return emitterView
    }
}

enum EmitterImageType {
    case confetti
    case triangle
    case star
    case diamond
    case image(UIImage)

    func image() -> UIImage {
        var fileName: String
        switch self {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .image(customImage):
            return customImage
        }

        guard let image = UIImage.init(named: fileName) else {
            preconditionFailure("EmitterImageType introduced requires a backing image.")
        }
        return image
    }
}

final class ImageEmitterView: UIView {

    var emitter: CAEmitterLayer!
    public var type: EmitterImageType!
    public var colors: [UIColor]!
    public var intensity: Float = 0.4
    private var active = false

    func startConfetti(imageType: EmitterImageType, colors: [UIColor]) {
        self.colors = colors
        self.type = imageType
        clipsToBounds = true
        isUserInteractionEnabled = false

        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        emitter.emitterCells = colors.map { confettiWithColor(color: $0, image: type.image(), intensity: intensity) }
        layer.addSublayer(emitter)
    }

    func stopConfetti() {
        emitter?.birthRate = 0
    }

    func confettiWithColor(color: UIColor, image: UIImage, intensity: Float) -> CAEmitterCell {
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
        confetti.contents = image.cgImage //imageForType(type)!.cgImage
        return confetti
    }
}
