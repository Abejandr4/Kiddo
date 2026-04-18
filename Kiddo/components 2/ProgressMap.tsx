import { motion } from 'motion/react';
import SuperheroSprite from './SuperheroSprite';
import type { AvatarConfig } from './AvatarCustomizer';

interface ProgressMapProps {
  avatarConfig: AvatarConfig;
  progress: number; // 0-100
}

export default function ProgressMap({ avatarConfig, progress }: ProgressMapProps) {
  // Calcular en qué punto del camino está (0-4) - ahora representa momentos del día
  const currentCheckpoint = Math.floor((progress / 100) * 5);

  // Posiciones de los checkpoints en el mapa (x, y en porcentaje) - Un día completo
  const checkpoints = [
    { x: 15, y: 85, label: 'Mañana', emoji: '🌅', time: '8:00 AM' },
    { x: 35, y: 60, label: 'Mediodía', emoji: '☀️', time: '12:00 PM' },
    { x: 55, y: 40, label: 'Tarde', emoji: '🌤️', time: '4:00 PM' },
    { x: 75, y: 25, label: 'Noche', emoji: '🌙', time: '8:00 PM' },
    { x: 85, y: 10, label: '¡Día completo!', emoji: '⭐', time: '' }
  ];

  return (
    <div className="relative w-full h-[450px] md:h-[500px] bg-gradient-to-b from-[#E8F5E9] via-[#F1F8E9] to-[#FFF9E6] rounded-3xl p-6 overflow-hidden shadow-lg">
      {/* Decorative background elements */}
      <div className="absolute top-10 left-10 text-4xl opacity-40">🌸</div>
      <div className="absolute top-20 right-16 text-3xl opacity-40">🦋</div>
      <div className="absolute bottom-20 left-16 text-3xl opacity-40">🌻</div>
      <div className="absolute bottom-32 right-12 text-4xl opacity-40">☀️</div>

      {/* Path SVG */}
      <svg className="absolute inset-0 w-full h-full" style={{ zIndex: 1 }}>
        {/* Draw dotted path between checkpoints */}
        {checkpoints.slice(0, -1).map((checkpoint, i) => {
          const next = checkpoints[i + 1];
          const isCompleted = currentCheckpoint > i;
          return (
            <line
              key={i}
              x1={`${checkpoint.x}%`}
              y1={`${checkpoint.y}%`}
              x2={`${next.x}%`}
              y2={`${next.y}%`}
              stroke={isCompleted ? '#7BC67E' : '#CBD5E0'}
              strokeWidth="3"
              strokeDasharray="8,8"
              strokeLinecap="round"
            />
          );
        })}
      </svg>

      {/* Checkpoints */}
      {checkpoints.map((checkpoint, i) => {
        const isActive = i === currentCheckpoint;
        const isCompleted = i < currentCheckpoint;
        const isFuture = i > currentCheckpoint;

        return (
          <div
            key={i}
            className="absolute"
            style={{
              left: `${checkpoint.x}%`,
              top: `${checkpoint.y}%`,
              transform: 'translate(-50%, -50%)',
              zIndex: isActive ? 10 : 2
            }}
          >
            {/* Checkpoint circle */}
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: i * 0.1 }}
              className={`relative flex items-center justify-center w-16 h-16 md:w-20 md:h-20 rounded-full ${
                isCompleted
                  ? 'bg-gradient-to-br from-[#7BC67E] to-[#87CEEB]'
                  : isFuture
                  ? 'bg-white border-4 border-[#E2E8F0]'
                  : 'bg-gradient-to-br from-[#F9E784] to-[#FFB366]'
              } shadow-lg`}
            >
              {isActive ? (
                <motion.div
                  animate={{
                    scale: [1, 1.1, 1],
                    rotate: [0, 5, -5, 0]
                  }}
                  transition={{
                    duration: 2,
                    repeat: Infinity,
                    ease: "easeInOut"
                  }}
                >
                  <SuperheroSprite {...avatarConfig} size={60} />
                </motion.div>
              ) : (
                <span className="text-2xl md:text-3xl">{checkpoint.emoji}</span>
              )}

              {/* Pulse animation for active checkpoint */}
              {isActive && (
                <motion.div
                  className="absolute inset-0 rounded-full bg-[#F9E784]"
                  animate={{
                    scale: [1, 1.5, 1],
                    opacity: [0.5, 0, 0.5]
                  }}
                  transition={{
                    duration: 2,
                    repeat: Infinity,
                    ease: "easeInOut"
                  }}
                />
              )}

              {/* Checkmark for completed */}
              {isCompleted && (
                <div className="absolute -top-1 -right-1 bg-white rounded-full w-6 h-6 flex items-center justify-center shadow-md">
                  <span className="text-[#7BC67E] text-sm">✓</span>
                </div>
              )}
            </motion.div>

            {/* Label */}
            <div className={`absolute top-full mt-2 whitespace-nowrap text-center ${
              isActive ? 'font-bold' : ''
            }`}>
              <p className={`text-xs md:text-sm ${
                isActive ? 'text-[#2D3748]' : 'text-[#718096]'
              }`}>
                {checkpoint.label}
              </p>
              {checkpoint.time && (
                <p className="text-[10px] md:text-xs text-[#718096] mt-0.5">
                  {checkpoint.time}
                </p>
              )}
            </div>
          </div>
        );
      })}

      {/* Progress indicator at bottom */}
      <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-white/90 rounded-full px-6 py-3 shadow-lg" style={{ zIndex: 20 }}>
        <p className="text-sm md:text-base text-[#2D3748] font-semibold">
          Progreso: {Math.round(progress)}%
        </p>
      </div>
    </div>
  );
}
