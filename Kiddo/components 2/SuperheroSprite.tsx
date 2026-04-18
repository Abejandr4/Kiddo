interface SuperheroSpriteProps {
  maskType: 'classic' | 'cat' | 'star' | 'lightning';
  capeType: 'long' | 'short' | 'pointed' | 'none';
  maskColor: string;
  capeColor: string;
  skinTone: string;
  size?: number;
}

export default function SuperheroSprite({
  maskType,
  capeType,
  maskColor,
  capeColor,
  skinTone,
  size = 200
}: SuperheroSpriteProps) {
  const renderMask = () => {
    switch (maskType) {
      case 'classic':
        return (
          <>
            <ellipse cx="100" cy="85" rx="35" ry="18" fill={maskColor} />
            <ellipse cx="70" cy="85" rx="12" ry="10" fill="white" />
            <ellipse cx="130" cy="85" rx="12" ry="10" fill="white" />
            <ellipse cx="70" cy="85" rx="6" ry="6" fill="#2D3748" />
            <ellipse cx="130" cy="85" rx="6" ry="6" fill="#2D3748" />
          </>
        );
      case 'cat':
        return (
          <>
            <path d="M 50 75 Q 45 65 55 70 L 65 85 Z" fill={maskColor} />
            <path d="M 150 75 Q 155 65 145 70 L 135 85 Z" fill={maskColor} />
            <ellipse cx="100" cy="90" rx="40" ry="20" fill={maskColor} />
            <ellipse cx="75" cy="90" rx="10" ry="8" fill="white" />
            <ellipse cx="125" cy="90" rx="10" ry="8" fill="white" />
            <ellipse cx="75" cy="90" rx="5" ry="5" fill="#2D3748" />
            <ellipse cx="125" cy="90" rx="5" ry="5" fill="#2D3748" />
          </>
        );
      case 'star':
        return (
          <>
            <path d="M 100 65 L 105 80 L 120 82 L 108 92 L 112 107 L 100 98 L 88 107 L 92 92 L 80 82 L 95 80 Z" fill={maskColor} />
            <ellipse cx="75" cy="88" rx="10" ry="8" fill="white" />
            <ellipse cx="125" cy="88" rx="10" ry="8" fill="white" />
            <ellipse cx="75" cy="88" rx="5" ry="5" fill="#2D3748" />
            <ellipse cx="125" cy="88" rx="5" ry="5" fill="#2D3748" />
          </>
        );
      case 'lightning':
        return (
          <>
            <path d="M 55 75 L 75 75 L 65 85 L 80 85 L 60 100 L 68 88 L 58 88 Z" fill={maskColor} />
            <path d="M 145 75 L 125 75 L 135 85 L 120 85 L 140 100 L 132 88 L 142 88 Z" fill={maskColor} />
            <ellipse cx="100" cy="90" rx="38" ry="18" fill={maskColor} />
            <ellipse cx="75" cy="90" rx="10" ry="8" fill="white" />
            <ellipse cx="125" cy="90" rx="10" ry="8" fill="white" />
            <ellipse cx="75" cy="90" rx="5" ry="5" fill="#2D3748" />
            <ellipse cx="125" cy="90" rx="5" ry="5" fill="#2D3748" />
          </>
        );
    }
  };

  const renderCape = () => {
    switch (capeType) {
      case 'long':
        return (
          <path
            d="M 85 110 Q 70 130 75 180 Q 80 200 85 210 L 100 160 L 115 210 Q 120 200 125 180 Q 130 130 115 110 Z"
            fill={capeColor}
            opacity="0.9"
          />
        );
      case 'short':
        return (
          <path
            d="M 85 110 Q 75 125 80 145 L 100 130 L 120 145 Q 125 125 115 110 Z"
            fill={capeColor}
            opacity="0.9"
          />
        );
      case 'pointed':
        return (
          <path
            d="M 85 110 L 75 180 L 85 175 L 100 160 L 115 175 L 125 180 L 115 110 Z"
            fill={capeColor}
            opacity="0.9"
          />
        );
      case 'none':
        return null;
    }
  };

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 200 220"
      className="superhero-sprite"
    >
      {/* Cape (behind body) */}
      {renderCape()}

      {/* Body */}
      <ellipse cx="100" cy="130" rx="30" ry="40" fill="#7BC67E" />

      {/* Arms */}
      <ellipse cx="70" cy="135" rx="12" ry="30" fill={skinTone} />
      <ellipse cx="130" cy="135" rx="12" ry="30" fill={skinTone} />

      {/* Legs */}
      <rect x="85" y="160" width="12" height="35" rx="6" fill="#4A5568" />
      <rect x="103" y="160" width="12" height="35" rx="6" fill="#4A5568" />

      {/* Boots */}
      <ellipse cx="91" cy="195" rx="10" ry="8" fill="#2D3748" />
      <ellipse cx="109" cy="195" rx="10" ry="8" fill="#2D3748" />

      {/* Head */}
      <circle cx="100" cy="80" r="35" fill={skinTone} />

      {/* Hair */}
      <path d="M 70 65 Q 100 50 130 65" fill="#2D3748" />

      {/* Mask */}
      {renderMask()}

      {/* Smile */}
      <path d="M 85 100 Q 100 105 115 100" stroke="#2D3748" strokeWidth="2" fill="none" />

      {/* Cape collar */}
      {capeType !== 'none' && (
        <>
          <circle cx="85" cy="110" r="5" fill={capeColor} />
          <circle cx="115" cy="110" r="5" fill={capeColor} />
        </>
      )}

      {/* Belt */}
      <rect x="70" y="128" width="60" height="6" fill="#F9E784" />
      <circle cx="100" cy="131" r="5" fill="#FFB366" />
    </svg>
  );
}
