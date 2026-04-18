import { Lightbulb, Zap } from 'lucide-react';

export default function HeroTips() {
  const tips = [
    {
      icon: '🧘',
      title: 'Yoga suave',
      description: 'Practica yoga entre 2-3 PM para mantener energía',
      time: 'Después de comer'
    },
    {
      icon: '😴',
      title: 'Siesta reparadora',
      description: 'Una siesta de 20-30 minutos puede ayudar',
      time: '3:00 PM'
    },
    {
      icon: '🚶',
      title: 'Paseo ligero',
      description: 'Caminar 10 minutos al aire libre revitaliza',
      time: 'Por la tarde'
    }
  ];

  return (
    <div className="bg-white rounded-3xl p-4 md:p-6 shadow-lg">
      <div className="flex items-center gap-2 md:gap-3 mb-4">
        <div className="bg-gradient-to-br from-[#F9E784] to-[#FFB366] rounded-full p-2">
          <Zap className="w-5 h-5 md:w-6 md:h-6 text-white" />
        </div>
        <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold">Tips de Héroe</h3>
      </div>

      <div className="space-y-3">
        {tips.map((tip, i) => (
          <div key={i} className="bg-gradient-to-r from-[#E8F5E9] to-[#F1F8E9] rounded-2xl p-4">
            <div className="flex items-start gap-3">
              <span className="text-3xl md:text-4xl flex-shrink-0">{tip.icon}</span>
              <div className="flex-1">
                <h4 className="text-base md:text-lg text-[#2D3748] font-semibold mb-1">
                  {tip.title}
                </h4>
                <p className="text-sm md:text-base text-[#4A5568] mb-2">
                  {tip.description}
                </p>
                <div className="flex items-center gap-2 text-xs md:text-sm text-[#7BC67E]">
                  <span>⏱️</span>
                  <span>{tip.time}</span>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-4 bg-gradient-to-r from-[#B4A7D6]/20 to-[#7BC67E]/20 rounded-2xl p-3 md:p-4">
        <p className="text-xs md:text-sm text-[#4A5568] leading-relaxed">
          💡 <strong>Consejo:</strong> Estos tips están personalizados según tus patrones de energía. Prueba lo que mejor te funcione.
        </p>
      </div>
    </div>
  );
}
