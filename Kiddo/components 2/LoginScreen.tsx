import { Flower2, Heart } from 'lucide-react';

interface LoginScreenProps {
  onSelectUserType: (type: 'child' | 'parent') => void;
}

export default function LoginScreen({ onSelectUserType }: LoginScreenProps) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8F5E9] to-[#C8E6C9] flex flex-col items-center justify-center p-6">
      <div className="text-center mb-12">
        <div className="flex justify-center gap-3 mb-4">
          <Flower2 className="w-12 h-12 text-[#7BC67E]" />
          <Heart className="w-12 h-12 text-[#FFB366]" />
          <Flower2 className="w-12 h-12 text-[#B4A7D6]" />
        </div>
        <h1 className="text-4xl mb-2 text-[#2D3748]">Mi Jardín de Salud</h1>
        <p className="text-lg text-[#4A5568]">Tu espacio seguro para cuidarte</p>
      </div>

      <div className="flex flex-col gap-4 w-full max-w-md">
        <button
          onClick={() => onSelectUserType('child')}
          className="bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white py-6 px-8 rounded-3xl shadow-lg hover:shadow-xl transition-all transform hover:scale-105 active:scale-95"
        >
          <div className="flex items-center justify-center gap-3">
            <span className="text-5xl">🦸</span>
            <div className="text-left">
              <div className="text-2xl font-semibold">Soy el Superhéroe</div>
              <div className="text-sm opacity-90">Mi diario personal</div>
            </div>
          </div>
        </button>

        <button
          onClick={() => onSelectUserType('parent')}
          className="bg-gradient-to-r from-[#B4A7D6] to-[#FFB366] text-white py-6 px-8 rounded-3xl shadow-lg hover:shadow-xl transition-all transform hover:scale-105 active:scale-95"
        >
          <div className="flex items-center justify-center gap-3">
            <span className="text-5xl">👨‍👩‍👧‍👦</span>
            <div className="text-left">
              <div className="text-2xl font-semibold">Soy el Cuidador</div>
              <div className="text-sm opacity-90">Apoyo a mi superhéroe</div>
            </div>
          </div>
        </button>
      </div>

      <div className="mt-12 flex gap-2">
        {[...Array(5)].map((_, i) => (
          <Flower2
            key={i}
            className="w-8 h-8 text-[#F9E784] opacity-60"
            style={{ transform: `rotate(${i * 15}deg)` }}
          />
        ))}
      </div>
    </div>
  );
}
