import { Check, Sparkles, Flower2 } from 'lucide-react';
import { useState } from 'react';
import SuperheroAnimation from './SuperheroAnimation';
import ProgressMap from './ProgressMap';
import type { AvatarConfig } from './AvatarCustomizer';

interface HomeViewProps {
  userType: 'child' | 'parent';
  avatarConfig: AvatarConfig;
  onCustomizeAvatar: () => void;
}

export default function HomeView({ userType, avatarConfig, onCustomizeAvatar }: HomeViewProps) {
  const [showAnimation, setShowAnimation] = useState(false);
  const [medicineTaken, setMedicineTaken] = useState(false);

  const todayMedsTaken = 21;
  const totalMeds = 24;
  const progressPercentage = (todayMedsTaken / totalMeds) * 100;

  const handleTakeMedicine = () => {
    setMedicineTaken(true);
    if (userType === 'child') {
      setShowAnimation(true);
    }
  };

  if (showAnimation) {
    return (
      <SuperheroAnimation
        onComplete={() => setShowAnimation(false)}
        avatarConfig={avatarConfig}
      />
    );
  }

  // Vista para niños - Mapa de progreso
  if (userType === 'child') {
    return (
      <div className="space-y-4 md:space-y-5">
        {/* Next Mission Card */}
        <div className="bg-white rounded-3xl p-5 md:p-6 shadow-lg">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold">La siguiente misión</h3>
            {medicineTaken && (
              <div className="bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white px-4 py-2 rounded-full font-semibold text-sm md:text-base">
                ¡Hecho!
              </div>
            )}
          </div>

          <div className="bg-gradient-to-r from-[#FFF9E6] to-[#FFE6CC] rounded-2xl p-4 md:p-5">
            <div className="flex items-center justify-between gap-3 mb-4">
              <div className="flex-1">
                <p className="text-lg md:text-xl text-[#2D3748] font-semibold mb-2">Prednisona 💊</p>
                <p className="text-sm md:text-base text-[#4A5568]">Hoy a las 2:00 PM • 10 mg</p>
              </div>
            </div>

            {!medicineTaken && (
              <button
                onClick={handleTakeMedicine}
                className="w-full bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white py-3 rounded-full font-semibold hover:shadow-lg transition-all transform hover:scale-105 active:scale-95 flex items-center justify-center gap-2"
              >
                <Check className="w-5 h-5" />
                <span>Registrar medicina</span>
              </button>
            )}
          </div>
        </div>

        {/* Progress Map */}
        <ProgressMap avatarConfig={avatarConfig} progress={progressPercentage} />

        {/* Motivational Card */}
        <div className="bg-gradient-to-r from-[#B4A7D6] to-[#FFB366] rounded-3xl p-5 md:p-6 text-white shadow-lg">
          <div className="flex items-center gap-3">
            <span className="text-4xl md:text-5xl">🌟</span>
            <div>
              <p className="text-base md:text-lg font-semibold mb-1">
                ¡Vas muy bien, campeón!
              </p>
              <p className="text-sm md:text-base opacity-90">
                Cada día te vuelves más fuerte
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Vista para padres - Mantener diseño original con barra de progreso
  return (
    <div className="space-y-4 md:space-y-5">
      {/* Welcome Card */}
      <div className="bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] rounded-3xl p-6 md:p-8 text-white shadow-lg">
        <h2 className="text-2xl md:text-3xl mb-2 font-semibold">¡Bienvenido!</h2>
        <p className="text-base md:text-lg opacity-90">
          Apoyando a nuestro superhéroe
        </p>
      </div>

      {/* Progress Bar */}
      <div className="bg-white rounded-3xl p-5 md:p-6 shadow-lg">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold">Progreso de Hoy</h3>
          <span className="text-xl md:text-2xl font-bold text-[#7BC67E]">{todayMedsTaken}/{totalMeds}</span>
        </div>
        <div className="relative w-full bg-[#E8F5E9] rounded-full h-6 md:h-7 overflow-hidden">
          <div
            className="absolute top-0 left-0 h-full bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] rounded-full transition-all duration-500 flex items-center justify-end pr-2 md:pr-3"
            style={{ width: `${progressPercentage}%` }}
          >
            <span className="text-white text-xs md:text-sm font-semibold">{Math.round(progressPercentage)}%</span>
          </div>
        </div>
        <p className="text-xs md:text-sm text-[#718096] mt-2">
          ¡Excelente trabajo! Solo faltan {totalMeds - todayMedsTaken} medicinas
        </p>
      </div>

      {/* Next Medication */}
      <div className="bg-white rounded-3xl p-5 md:p-6 shadow-lg">
        <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold mb-4">Próxima Medicina</h3>
        <div className="bg-gradient-to-r from-[#FFF9E6] to-[#FFE6CC] rounded-2xl p-4 md:p-5">
          <div className="flex items-center justify-between gap-3">
            <div className="flex-1">
              <p className="text-lg md:text-xl text-[#2D3748] font-semibold mb-1">Prednisona</p>
              <p className="text-sm md:text-base text-[#4A5568]">Hoy a las 2:00 PM</p>
              <p className="text-xs md:text-sm text-[#718096] mt-1">Dosis: 10 mg (1 pastilla)</p>
            </div>
            <div className="text-5xl md:text-6xl flex-shrink-0">💊</div>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 gap-3">
        <StatCard
          icon={<Sparkles className="w-6 h-6 md:w-8 md:h-8 text-[#F9E784]" />}
          value="7"
          label="Días seguidos"
          bgColor="bg-gradient-to-br from-[#FFF9E6] to-[#F9E784]/30"
        />
        <StatCard
          icon={<Flower2 className="w-6 h-6 md:w-8 md:h-8 text-[#7BC67E]" />}
          value="⚡"
          label="Energía alta"
          bgColor="bg-gradient-to-br from-[#E8F5E9] to-[#7BC67E]/30"
        />
      </div>

      {/* Motivational Message */}
      <div className="bg-gradient-to-r from-[#B4A7D6] to-[#FFB366] rounded-3xl p-6 text-white shadow-lg">
        <div className="flex items-center gap-4">
          <span className="text-5xl">🌈</span>
          <div>
            <p className="text-lg font-semibold mb-1">
              {userType === 'child'
                ? '¡Sigue así, campeón!'
                : 'El amor y apoyo marcan la diferencia'}
            </p>
            <p className="text-sm opacity-90">
              Cada día eres más fuerte. Tu valentía inspira a todos.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

interface StatCardProps {
  icon: React.ReactNode;
  value: string;
  label: string;
  bgColor: string;
}

function StatCard({ icon, value, label, bgColor }: StatCardProps) {
  return (
    <div className={`${bgColor} rounded-2xl p-4 md:p-6 shadow-md`}>
      <div className="flex items-center justify-between mb-1 md:mb-2">
        {icon}
      </div>
      <p className="text-2xl md:text-3xl text-[#2D3748] mb-1">{value}</p>
      <p className="text-xs md:text-sm text-[#4A5568]">{label}</p>
    </div>
  );
}
