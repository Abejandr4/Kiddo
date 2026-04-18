import { useState } from 'react';
import { BookHeart, Plus, Battery, BatteryLow, BatteryMedium, BatteryFull, Zap, Heart, HeartPulse, HeartCrack } from 'lucide-react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import HeroTips from './HeroTips';

interface DiaryEntry {
  id: number;
  date: Date;
  time: string;
  mood: 'great' | 'good' | 'neutral' | 'bad' | 'terrible';
  energyLevel: number;
  painLevel: number;
  sideEffects: string[];
  notes: string;
}

export default function DiaryView() {
  const [entries, setEntries] = useState<DiaryEntry[]>([
    {
      id: 1,
      date: new Date(2026, 3, 17),
      time: '18:30',
      mood: 'great',
      energyLevel: 8,
      painLevel: 2,
      sideEffects: [],
      notes: '¡Me sentí muy bien hoy! Jugué mucho.'
    },
    {
      id: 2,
      date: new Date(2026, 3, 16),
      time: '15:20',
      mood: 'neutral',
      energyLevel: 5,
      painLevel: 4,
      sideEffects: ['Cansancio leve', 'Dolor de cabeza'],
      notes: 'Día tranquilo, vi películas.'
    }
  ]);
  const [showNewEntry, setShowNewEntry] = useState(false);
  const [newMood, setNewMood] = useState<'great' | 'good' | 'neutral' | 'bad' | 'terrible'>('good');
  const [newEnergyLevel, setNewEnergyLevel] = useState(5);
  const [newPainLevel, setNewPainLevel] = useState(1);
  const [newNotes, setNewNotes] = useState('');
  const [selectedSideEffects, setSelectedSideEffects] = useState<string[]>([]);

  const sideEffectOptions = [
    'Cansancio leve',
    'Cansancio moderado',
    'Cansancio extremo',
    'Náuseas',
    'Dolor de cabeza',
    'Mareos',
    'Falta de apetito',
    'Dolor de estómago',
    'Dificultad para dormir',
    'Irritabilidad',
    'Ninguno'
  ];

  const toggleSideEffect = (effect: string) => {
    if (effect === 'Ninguno') {
      setSelectedSideEffects(['Ninguno']);
    } else {
      const filtered = selectedSideEffects.filter(e => e !== 'Ninguno');
      if (filtered.includes(effect)) {
        setSelectedSideEffects(filtered.filter(e => e !== effect));
      } else {
        setSelectedSideEffects([...filtered, effect]);
      }
    }
  };

  const getMoodEmoji = (mood: 'great' | 'good' | 'neutral' | 'bad' | 'terrible') => {
    const moods = {
      great: '😄',
      good: '🙂',
      neutral: '😐',
      bad: '😟',
      terrible: '😢'
    };
    return moods[mood];
  };

  const getMoodLabel = (mood: 'great' | 'good' | 'neutral' | 'bad' | 'terrible') => {
    const labels = {
      great: 'Excelente',
      good: 'Bien',
      neutral: 'Normal',
      bad: 'Mal',
      terrible: 'Muy mal'
    };
    return labels[mood];
  };

  const getMoodColor = (mood: 'great' | 'good' | 'neutral' | 'bad' | 'terrible') => {
    const colors = {
      great: 'from-[#7BC67E] to-[#87CEEB]',
      good: 'from-[#87CEEB] to-[#B4A7D6]',
      neutral: 'from-[#F9E784] to-[#FFB366]',
      bad: 'from-[#FFB366] to-[#FF8ED4]',
      terrible: 'from-[#FF8ED4] to-[#B4A7D6]'
    };
    return colors[mood];
  };

  const getEnergyIcon = (level: number) => {
    if (level >= 8) return <BatteryFull className="w-5 h-5 md:w-6 md:h-6 text-[#7BC67E]" />;
    if (level >= 5) return <BatteryMedium className="w-5 h-5 md:w-6 md:h-6 text-[#F9E784]" />;
    if (level >= 3) return <BatteryLow className="w-5 h-5 md:w-6 md:h-6 text-[#FFB366]" />;
    return <Battery className="w-5 h-5 md:w-6 md:h-6 text-[#FF6B6B]" />;
  };

  const getEnergyLabel = (level: number) => {
    if (level >= 8) return 'Muy energético';
    if (level >= 5) return 'Normal';
    if (level >= 3) return 'Algo cansado';
    return 'Muy cansado';
  };

  const getPainIcon = (level: number) => {
    if (level >= 7) return <HeartCrack className="w-5 h-5 md:w-6 md:h-6 text-[#FF6B6B]" />;
    if (level >= 4) return <HeartPulse className="w-5 h-5 md:w-6 md:h-6 text-[#FFB366]" />;
    return <Heart className="w-5 h-5 md:w-6 md:h-6 text-[#7BC67E]" />;
  };

  const getPainLabel = (level: number) => {
    if (level >= 7) return 'Dolor fuerte';
    if (level >= 4) return 'Dolor moderado';
    if (level >= 2) return 'Dolor leve';
    return 'Sin dolor';
  };

  const handleSaveEntry = () => {
    const now = new Date();
    const newEntry: DiaryEntry = {
      id: entries.length + 1,
      date: now,
      time: format(now, 'HH:mm'),
      mood: newMood,
      energyLevel: newEnergyLevel,
      painLevel: newPainLevel,
      sideEffects: selectedSideEffects.length > 0 ? selectedSideEffects : ['Ninguno'],
      notes: newNotes
    };
    setEntries([newEntry, ...entries]);
    setShowNewEntry(false);
    setNewNotes('');
    setNewMood('good');
    setNewEnergyLevel(5);
    setNewPainLevel(1);
    setSelectedSideEffects([]);
  };

  return (
    <div className="space-y-4 md:space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 mb-4 md:mb-6">
        <div className="flex items-center gap-2 md:gap-3">
          <BookHeart className="w-6 h-6 md:w-8 md:h-8 text-[#B4A7D6]" />
          <h2 className="text-2xl md:text-3xl text-[#2D3748]">Mi Diario Secreto</h2>
        </div>
      </div>

      {/* Privacy Notice */}
      <div className="bg-gradient-to-r from-[#B4A7D6] to-[#7BC67E] rounded-3xl p-4 md:p-6 text-white shadow-lg">
        <div className="flex items-center gap-3 md:gap-4">
          <span className="text-3xl md:text-4xl">🔒</span>
          <div>
            <p className="text-base md:text-lg font-semibold mb-1">Tu espacio privado</p>
            <p className="text-xs md:text-sm opacity-90">
              Solo tú puedes ver lo que escribes aquí. Es tu diario secreto para expresar cómo te sientes.
            </p>
          </div>
        </div>
      </div>

      {/* Hero Tips */}
      <HeroTips />

      {/* Registro de batallas (New Entry Button) */}
      <button
        onClick={() => setShowNewEntry(!showNewEntry)}
        className="w-full bg-gradient-to-r from-[#B4A7D6] to-[#FFB366] text-white p-4 md:p-5 rounded-3xl shadow-lg hover:shadow-xl transition-all flex items-center justify-center gap-3 text-base md:text-lg font-semibold"
      >
        <Plus className="w-5 h-5 md:w-6 md:h-6" />
        <span>Registro de Batallas</span>
      </button>

      {/* New Entry Form */}
      {showNewEntry && (
        <div className="bg-white rounded-3xl p-4 md:p-6 shadow-lg">
          <h3 className="text-lg md:text-xl text-[#2D3748] mb-4">¿Cómo te sientes hoy?</h3>

          {/* Mood Selector */}
          <div className="mb-6">
            <label className="block text-sm md:text-base text-[#4A5568] mb-3 font-semibold">Estado de ánimo</label>
            <div className="grid grid-cols-5 gap-2">
              {[
                { value: 'great' as const, emoji: '😄', label: 'Excelente' },
                { value: 'good' as const, emoji: '🙂', label: 'Bien' },
                { value: 'neutral' as const, emoji: '😐', label: 'Normal' },
                { value: 'bad' as const, emoji: '😟', label: 'Mal' },
                { value: 'terrible' as const, emoji: '😢', label: 'Muy mal' }
              ].map(mood => (
                <button
                  key={mood.value}
                  onClick={() => setNewMood(mood.value)}
                  className={`p-2 md:p-3 rounded-xl border-2 transition-all ${
                    newMood === mood.value
                      ? 'border-[#7BC67E] bg-[#E8F5E9] scale-105'
                      : 'border-[#E2E8F0] hover:border-[#7BC67E]'
                  }`}
                >
                  <span className="text-2xl md:text-3xl block mb-1">{mood.emoji}</span>
                  <p className="text-[10px] md:text-xs text-[#4A5568]">{mood.label}</p>
                </button>
              ))}
            </div>
          </div>

          {/* Energy Level */}
          <div className="mb-4">
            <label className="block text-sm md:text-base text-[#4A5568] mb-3 font-semibold">
              Nivel de energía: {newEnergyLevel}/10 - {getEnergyLabel(newEnergyLevel)}
            </label>
            <div className="flex items-center gap-3">
              <Battery className="w-5 h-5 text-[#718096]" />
              <input
                type="range"
                min="1"
                max="10"
                value={newEnergyLevel}
                onChange={(e) => setNewEnergyLevel(parseInt(e.target.value))}
                className="flex-1 h-3 bg-[#E2E8F0] rounded-full appearance-none cursor-pointer"
                style={{
                  background: `linear-gradient(to right, #7BC67E 0%, #7BC67E ${newEnergyLevel * 10}%, #E2E8F0 ${newEnergyLevel * 10}%, #E2E8F0 100%)`
                }}
              />
              <Zap className="w-5 h-5 text-[#F9E784]" />
            </div>
          </div>

          {/* Pain Level */}
          <div className="mb-6">
            <label className="block text-sm md:text-base text-[#4A5568] mb-3 font-semibold">
              Nivel de dolor: {newPainLevel}/10 - {getPainLabel(newPainLevel)}
            </label>
            <div className="flex items-center gap-3">
              <Heart className="w-5 h-5 text-[#7BC67E]" />
              <input
                type="range"
                min="0"
                max="10"
                value={newPainLevel}
                onChange={(e) => setNewPainLevel(parseInt(e.target.value))}
                className="flex-1 h-3 bg-[#E2E8F0] rounded-full appearance-none cursor-pointer"
                style={{
                  background: `linear-gradient(to right, #FF6B6B 0%, #FF6B6B ${newPainLevel * 10}%, #E2E8F0 ${newPainLevel * 10}%, #E2E8F0 100%)`
                }}
              />
              <HeartCrack className="w-5 h-5 text-[#FF6B6B]" />
            </div>
          </div>

          {/* Side Effects */}
          <div className="mb-4">
            <label className="block text-sm md:text-base text-[#4A5568] mb-3 font-semibold">Efectos secundarios</label>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
              {sideEffectOptions.map(effect => (
                <button
                  key={effect}
                  onClick={() => toggleSideEffect(effect)}
                  className={`p-2 md:p-3 rounded-xl border-2 transition-all text-xs md:text-sm ${
                    selectedSideEffects.includes(effect)
                      ? 'border-[#FFB366] bg-[#FFE6CC] text-[#2D3748]'
                      : 'border-[#E2E8F0] text-[#718096] hover:border-[#FFB366]'
                  }`}
                >
                  {effect}
                </button>
              ))}
            </div>
          </div>

          {/* Notes */}
          <div className="mb-4">
            <label className="block text-sm md:text-base text-[#4A5568] mb-2 font-semibold">Notas adicionales</label>
            <textarea
              value={newNotes}
              onChange={(e) => setNewNotes(e.target.value)}
              className="w-full p-3 md:p-4 border-2 border-[#E2E8F0] rounded-2xl focus:border-[#7BC67E] focus:outline-none resize-none text-sm md:text-base"
              rows={4}
              placeholder="¿Qué hiciste hoy? ¿Cómo te sentiste? Escribe lo que quieras..."
            />
          </div>

          {/* Buttons */}
          <div className="flex gap-2 md:gap-3">
            <button
              onClick={handleSaveEntry}
              className="flex-1 bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white py-2.5 md:py-3 rounded-full font-semibold hover:shadow-lg transition-all text-sm md:text-base"
            >
              Guardar
            </button>
            <button
              onClick={() => setShowNewEntry(false)}
              className="flex-1 bg-[#E2E8F0] text-[#4A5568] py-2.5 md:py-3 rounded-full font-semibold hover:bg-[#CBD5E0] transition-all text-sm md:text-base"
            >
              Cancelar
            </button>
          </div>
        </div>
      )}

      {/* Villanos de hoy - Historial */}
      <div className="bg-gradient-to-r from-[#E8F5E9] to-[#F1F8E9] rounded-2xl p-4 md:p-5">
        <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold mb-1">Villanos de Hoy</h3>
        <p className="text-sm md:text-base text-[#718096] mb-4">Registro de batallas y síntomas</p>
      </div>

      {/* Entries List */}
      <div className="space-y-3 md:space-y-4">
        {entries.map(entry => (
          <div key={entry.id} className="bg-white rounded-3xl p-4 md:p-6 shadow-lg">
            {/* Header */}
            <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3 mb-4">
              <div className="flex items-start gap-3">
                <span className="text-4xl md:text-5xl">{getMoodEmoji(entry.mood)}</span>
                <div className="flex-1">
                  <p className="text-base md:text-lg text-[#2D3748] font-semibold capitalize">
                    {format(entry.date, "EEEE, d 'de' MMMM", { locale: es })}
                  </p>
                  <p className="text-xs md:text-sm text-[#718096]">
                    {entry.time}
                  </p>
                </div>
              </div>
              <div className={`px-3 md:px-4 py-1.5 md:py-2 rounded-full bg-gradient-to-r ${getMoodColor(entry.mood)} text-white text-xs md:text-sm whitespace-nowrap`}>
                {getMoodLabel(entry.mood)}
              </div>
            </div>

            {/* Energy and Pain Levels */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-3">
              {/* Energy Level */}
              <div className="bg-[#F7FAFC] rounded-xl p-3">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs md:text-sm text-[#718096]">Energía</span>
                  <div className="flex items-center gap-2">
                    {getEnergyIcon(entry.energyLevel)}
                    <span className="text-sm md:text-base font-semibold text-[#2D3748]">
                      {entry.energyLevel}/10
                    </span>
                  </div>
                </div>
                <div className="w-full bg-[#E2E8F0] rounded-full h-2">
                  <div
                    className="bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] h-2 rounded-full transition-all"
                    style={{ width: `${entry.energyLevel * 10}%` }}
                  />
                </div>
                <p className="text-xs text-[#718096] mt-1">{getEnergyLabel(entry.energyLevel)}</p>
              </div>

              {/* Pain Level */}
              <div className="bg-[#F7FAFC] rounded-xl p-3">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs md:text-sm text-[#718096]">Dolor</span>
                  <div className="flex items-center gap-2">
                    {getPainIcon(entry.painLevel)}
                    <span className="text-sm md:text-base font-semibold text-[#2D3748]">
                      {entry.painLevel}/10
                    </span>
                  </div>
                </div>
                <div className="w-full bg-[#E2E8F0] rounded-full h-2">
                  <div
                    className="bg-gradient-to-r from-[#7BC67E] via-[#FFB366] to-[#FF6B6B] h-2 rounded-full transition-all"
                    style={{ width: `${entry.painLevel * 10}%` }}
                  />
                </div>
                <p className="text-xs text-[#718096] mt-1">{getPainLabel(entry.painLevel)}</p>
              </div>
            </div>

            {/* Side Effects */}
            {entry.sideEffects.length > 0 && !entry.sideEffects.includes('Ninguno') && (
              <div className="mb-3">
                <p className="text-xs md:text-sm text-[#718096] mb-2 font-semibold">Efectos secundarios:</p>
                <div className="flex flex-wrap gap-1.5 md:gap-2">
                  {entry.sideEffects.map((effect, i) => (
                    <span key={i} className="px-2 md:px-3 py-1 bg-[#FFE6CC] text-[#4A5568] rounded-full text-xs md:text-sm">
                      {effect}
                    </span>
                  ))}
                </div>
              </div>
            )}

            {/* Notes */}
            {entry.notes && (
              <div className="mt-3 pt-3 border-t border-[#E2E8F0]">
                <p className="text-xs md:text-sm text-[#718096] mb-1 font-semibold">Notas:</p>
                <p className="text-sm md:text-base text-[#2D3748] leading-relaxed">
                  {entry.notes}
                </p>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
