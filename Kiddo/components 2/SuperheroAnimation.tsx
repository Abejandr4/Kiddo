import { motion } from 'motion/react';
import { useEffect } from 'react';
import confetti from 'canvas-confetti';
import { Sparkles, Star } from 'lucide-react';
import SuperheroSprite from './SuperheroSprite';
import type { AvatarConfig } from './AvatarCustomizer';

interface SuperheroAnimationProps {
  onComplete: () => void;
  avatarConfig: AvatarConfig;
}

export default function SuperheroAnimation({ onComplete, avatarConfig }: SuperheroAnimationProps) {
  useEffect(() => {
    // Confetti celebration
    const duration = 3000;
    const end = Date.now() + duration;

    const colors = ['#7BC67E', '#87CEEB', '#F9E784', '#B4A7D6', '#FFB366'];

    const frame = () => {
      confetti({
        particleCount: 3,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: colors
      });
      confetti({
        particleCount: 3,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: colors
      });

      if (Date.now() < end) {
        requestAnimationFrame(frame);
      }
    };
    frame();

    const timer = setTimeout(onComplete, 3000);
    return () => clearTimeout(timer);
  }, [onComplete]);

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 bg-gradient-to-b from-[#87CEEB] to-[#7BC67E] flex flex-col items-center justify-center z-50"
    >
      <motion.div
        initial={{ scale: 0, rotate: -180 }}
        animate={{ scale: 1, rotate: 0 }}
        transition={{ type: "spring", duration: 1 }}
        className="relative"
      >
        <motion.div
          animate={{
            scale: [1, 1.2, 1],
            rotate: [0, 10, -10, 0]
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: "easeInOut"
          }}
        >
          <SuperheroSprite {...avatarConfig} size={300} />
        </motion.div>

        <motion.div
          animate={{
            rotate: 360,
            scale: [1, 1.3, 1]
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: "linear"
          }}
          className="absolute -top-4 -right-4"
        >
          <Star className="w-16 h-16 text-[#F9E784] fill-[#F9E784]" />
        </motion.div>

        <motion.div
          animate={{
            rotate: -360,
            scale: [1, 1.2, 1]
          }}
          transition={{
            duration: 2.5,
            repeat: Infinity,
            ease: "linear"
          }}
          className="absolute -bottom-4 -left-4"
        >
          <Sparkles className="w-14 h-14 text-[#FFB366] fill-[#FFB366]" />
        </motion.div>
      </motion.div>

      <motion.div
        initial={{ y: 50, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ delay: 0.5 }}
        className="mt-12 text-center"
      >
        <h2 className="text-5xl text-white mb-3">¡Increíble!</h2>
        <p className="text-2xl text-white opacity-90">¡Eres un verdadero superhéroe! 🌟</p>
        <motion.p
          animate={{ scale: [1, 1.1, 1] }}
          transition={{ duration: 1.5, repeat: Infinity }}
          className="text-xl text-white mt-4"
        >
          Tu fuerza inspira a todos
        </motion.p>
      </motion.div>

      <motion.div
        animate={{ y: [0, -10, 0] }}
        transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
        className="absolute bottom-12 flex gap-4"
      >
        {['🌸', '🌻', '🌺', '🌼', '🌷'].map((flower, i) => (
          <motion.span
            key={i}
            animate={{ rotate: [0, 15, -15, 0] }}
            transition={{ duration: 2, delay: i * 0.2, repeat: Infinity }}
            className="text-4xl"
          >
            {flower}
          </motion.span>
        ))}
      </motion.div>
    </motion.div>
  );
}
