import { Brain, TrendingDown, Lightbulb } from 'lucide-react';

interface AIInsightsProps {
  entries: Array<{
    date: Date;
    energyLevel: number;
    mood: string;
  }>;
}

export default function AIInsights({ entries }: AIInsightsProps) {
  // Mock AI analysis - En producción, esto vendría de un servicio de IA
  const analyzePatterns = () => {
    // Simular análisis de patrones de energía
    const insights = {
      lowEnergyPeriods: ['2:00 PM - 4:00 PM', '8:00 PM - 9:00 PM'],
      averageEnergy: 6.5,
      suggestions: [
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
      ],
      trend: 'improving'
    };

    return insights;
  };

  const insights = analyzePatterns();

  return (
    <div className="space-y-4">
      {/* AI Header */}
      <div className="bg-gradient-to-r from-[#B4A7D6] to-[#7BC67E] rounded-3xl p-4 md:p-6 text-white shadow-lg">
        <div className="flex items-center gap-3 mb-2">
          <Brain className="w-6 h-6 md:w-8 md:h-8" />
          <h3 className="text-lg md:text-xl font-semibold">Análisis Inteligente</h3>
        </div>
        <p className="text-sm md:text-base opacity-90">
          Basado en tus últimas 14 entradas, detectamos estos patrones
        </p>
      </div>

      {/* Energy Patterns */}
      <div className="bg-white rounded-3xl p-4 md:p-6 shadow-lg">
        <div className="flex items-center gap-2 mb-3">
          <TrendingDown className="w-5 h-5 md:w-6 md:h-6 text-[#FFB366]" />
          <h4 className="text-base md:text-lg text-[#2D3748] font-semibold">Períodos de Menor Energía</h4>
        </div>
        <div className="space-y-2">
          {insights.lowEnergyPeriods.map((period, i) => (
            <div key={i} className="flex items-center gap-2 bg-[#FFF9E6] rounded-xl p-3">
              <span className="text-xl md:text-2xl">⏰</span>
              <span className="text-sm md:text-base text-[#4A5568]">{period}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Suggestions */}
      <div className="bg-white rounded-3xl p-4 md:p-6 shadow-lg">
        <div className="flex items-center gap-2 mb-4">
          <Lightbulb className="w-5 h-5 md:w-6 md:h-6 text-[#F9E784]" />
          <h4 className="text-base md:text-lg text-[#2D3748] font-semibold">Sugerencias Personalizadas</h4>
        </div>
        <div className="space-y-3">
          {insights.suggestions.map((suggestion, i) => (
            <div key={i} className="bg-gradient-to-r from-[#E8F5E9] to-[#F1F8E9] rounded-2xl p-4">
              <div className="flex items-start gap-3">
                <span className="text-3xl md:text-4xl">{suggestion.icon}</span>
                <div className="flex-1">
                  <h5 className="text-base md:text-lg text-[#2D3748] font-semibold mb-1">
                    {suggestion.title}
                  </h5>
                  <p className="text-sm md:text-base text-[#4A5568] mb-2">
                    {suggestion.description}
                  </p>
                  <div className="flex items-center gap-2 text-xs md:text-sm text-[#7BC67E]">
                    <span>⏱️</span>
                    <span>{suggestion.time}</span>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Energy Trend */}
      <div className="bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] rounded-3xl p-4 md:p-6 text-white shadow-lg">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm md:text-base opacity-90 mb-1">Tendencia de Energía</p>
            <p className="text-xl md:text-2xl font-bold">
              {insights.trend === 'improving' ? '📈 Mejorando' : '📊 Estable'}
            </p>
          </div>
          <div className="text-right">
            <p className="text-sm md:text-base opacity-90 mb-1">Promedio</p>
            <p className="text-3xl md:text-4xl font-bold">{insights.averageEnergy}/10</p>
          </div>
        </div>
      </div>
    </div>
  );
}
