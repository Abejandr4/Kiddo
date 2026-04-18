import { X, Sparkles } from 'lucide-react';
import SuperheroSprite from './SuperheroSprite';

export interface AvatarConfig {
  maskType: 'classic' | 'cat' | 'star' | 'lightning';
  capeType: 'long' | 'short' | 'pointed' | 'none';
  maskColor: string;
  capeColor: string;
  skinTone: string;
}

interface AvatarCustomizerProps {
  config: AvatarConfig;
  onConfigChange: (config: AvatarConfig) => void;
  onClose: () => void;
}

export default function AvatarCustomizer({ config, onConfigChange, onClose }: AvatarCustomizerProps) {
  const maskTypes: Array<{ value: AvatarConfig['maskType']; label: string; icon: string }> = [
    { value: 'classic', label: 'Clásica', icon: '😎' },
    { value: 'cat', label: 'Gatuno', icon: '🐱' },
    { value: 'star', label: 'Estrella', icon: '⭐' },
    { value: 'lightning', label: 'Rayo', icon: '⚡' }
  ];

  const capeTypes: Array<{ value: AvatarConfig['capeType']; label: string; icon: string }> = [
    { value: 'long', label: 'Larga', icon: '🦸' },
    { value: 'short', label: 'Corta', icon: '🎽' },
    { value: 'pointed', label: 'Puntiaguda', icon: '🔺' },
    { value: 'none', label: 'Sin capa', icon: '🚫' }
  ];

  const colors = [
    { value: '#FF6B6B', label: 'Rojo' },
    { value: '#4ECDC4', label: 'Turquesa' },
    { value: '#45B7D1', label: 'Azul' },
    { value: '#F9E784', label: 'Amarillo' },
    { value: '#B4A7D6', label: 'Morado' },
    { value: '#FFB366', label: 'Naranja' },
    { value: '#7BC67E', label: 'Verde' },
    { value: '#FF8ED4', label: 'Rosa' }
  ];

  const skinTones = [
    { value: '#FFDAB9', label: 'Claro' },
    { value: '#F0C08E', label: 'Medio claro' },
    { value: '#D4A574', label: 'Medio' },
    { value: '#C68642', label: 'Medio oscuro' },
    { value: '#8D5524', label: 'Oscuro' }
  ];

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-3xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div className="sticky top-0 bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white p-6 rounded-t-3xl flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Sparkles className="w-8 h-8" />
            <h2 className="text-2xl">Personaliza tu Superhéroe</h2>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-white/20 rounded-full transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="p-6 grid md:grid-cols-2 gap-8">
          {/* Preview */}
          <div className="flex flex-col items-center">
            <div className="bg-gradient-to-b from-[#E8F5E9] to-[#C8E6C9] rounded-3xl p-8 mb-4">
              <SuperheroSprite {...config} size={250} />
            </div>
            <p className="text-sm text-[#718096]">Vista previa de tu superhéroe</p>
          </div>

          {/* Customization Options */}
          <div className="space-y-6">
            {/* Mask Type */}
            <div>
              <label className="block text-lg text-[#2D3748] mb-3">Tipo de Máscara</label>
              <div className="grid grid-cols-2 gap-3">
                {maskTypes.map(mask => (
                  <button
                    key={mask.value}
                    onClick={() => onConfigChange({ ...config, maskType: mask.value })}
                    className={`p-4 rounded-2xl border-2 transition-all ${
                      config.maskType === mask.value
                        ? 'border-[#7BC67E] bg-[#E8F5E9]'
                        : 'border-[#E2E8F0] hover:border-[#7BC67E]'
                    }`}
                  >
                    <span className="text-3xl block mb-1">{mask.icon}</span>
                    <span className="text-sm text-[#4A5568]">{mask.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Cape Type */}
            <div>
              <label className="block text-lg text-[#2D3748] mb-3">Tipo de Capa</label>
              <div className="grid grid-cols-2 gap-3">
                {capeTypes.map(cape => (
                  <button
                    key={cape.value}
                    onClick={() => onConfigChange({ ...config, capeType: cape.value })}
                    className={`p-4 rounded-2xl border-2 transition-all ${
                      config.capeType === cape.value
                        ? 'border-[#87CEEB] bg-[#E3F2FD]'
                        : 'border-[#E2E8F0] hover:border-[#87CEEB]'
                    }`}
                  >
                    <span className="text-3xl block mb-1">{cape.icon}</span>
                    <span className="text-sm text-[#4A5568]">{cape.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Mask Color */}
            <div>
              <label className="block text-lg text-[#2D3748] mb-3">Color de Máscara</label>
              <div className="grid grid-cols-4 gap-3">
                {colors.map(color => (
                  <button
                    key={color.value}
                    onClick={() => onConfigChange({ ...config, maskColor: color.value })}
                    className={`p-3 rounded-xl border-2 transition-all ${
                      config.maskColor === color.value
                        ? 'border-[#2D3748] scale-110'
                        : 'border-[#E2E8F0] hover:scale-105'
                    }`}
                    style={{ backgroundColor: color.value }}
                    title={color.label}
                  >
                    <div className="h-8" />
                  </button>
                ))}
              </div>
            </div>

            {/* Cape Color */}
            <div>
              <label className="block text-lg text-[#2D3748] mb-3">Color de Capa</label>
              <div className="grid grid-cols-4 gap-3">
                {colors.map(color => (
                  <button
                    key={color.value}
                    onClick={() => onConfigChange({ ...config, capeColor: color.value })}
                    className={`p-3 rounded-xl border-2 transition-all ${
                      config.capeColor === color.value
                        ? 'border-[#2D3748] scale-110'
                        : 'border-[#E2E8F0] hover:scale-105'
                    }`}
                    style={{ backgroundColor: color.value }}
                    title={color.label}
                  >
                    <div className="h-8" />
                  </button>
                ))}
              </div>
            </div>

            {/* Skin Tone */}
            <div>
              <label className="block text-lg text-[#2D3748] mb-3">Tono de Piel</label>
              <div className="grid grid-cols-5 gap-2">
                {skinTones.map(tone => (
                  <button
                    key={tone.value}
                    onClick={() => onConfigChange({ ...config, skinTone: tone.value })}
                    className={`p-3 rounded-xl border-2 transition-all ${
                      config.skinTone === tone.value
                        ? 'border-[#2D3748] scale-110'
                        : 'border-[#E2E8F0] hover:scale-105'
                    }`}
                    style={{ backgroundColor: tone.value }}
                    title={tone.label}
                  >
                    <div className="h-8" />
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>

        <div className="p-6 bg-[#F7FAFC] rounded-b-3xl">
          <button
            onClick={onClose}
            className="w-full bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white py-4 rounded-full font-semibold hover:shadow-lg transition-all transform hover:scale-105"
          >
            ¡Guardar mi Superhéroe!
          </button>
        </div>
      </div>
    </div>
  );
}
