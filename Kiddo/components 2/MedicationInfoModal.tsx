import { X, AlertTriangle, Info } from 'lucide-react';

interface MedicationInfoModalProps {
  medication: {
    name: string;
    genericName: string;
    description: string;
    sideEffects: string[];
    warnings: string[];
  };
  onClose: () => void;
}

export default function MedicationInfoModal({ medication, onClose }: MedicationInfoModalProps) {
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="sticky top-0 bg-gradient-to-r from-[#87CEEB] to-[#B4A7D6] text-white p-5 md:p-6 rounded-t-3xl flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="bg-white/20 rounded-full p-2">
              <Info className="w-6 h-6 md:w-7 md:h-7" />
            </div>
            <div>
              <h2 className="text-xl md:text-2xl font-semibold">{medication.name}</h2>
              <p className="text-sm md:text-base opacity-90">{medication.genericName}</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-white/20 rounded-full transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="p-5 md:p-6 space-y-5">
          {/* Description */}
          <div>
            <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold mb-3">
              ¿Para qué sirve?
            </h3>
            <p className="text-sm md:text-base text-[#4A5568] leading-relaxed">
              {medication.description}
            </p>
          </div>

          {/* Side Effects */}
          <div>
            <div className="flex items-center gap-2 mb-3">
              <AlertTriangle className="w-5 h-5 md:w-6 md:h-6 text-[#FFB366]" />
              <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold">
                Posibles efectos secundarios
              </h3>
            </div>
            <div className="bg-[#FFF9E6] rounded-2xl p-4">
              <ul className="space-y-2">
                {medication.sideEffects.map((effect, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm md:text-base text-[#4A5568]">
                    <span className="text-[#FFB366] mt-1">•</span>
                    <span>{effect}</span>
                  </li>
                ))}
              </ul>
            </div>
          </div>

          {/* Warnings */}
          {medication.warnings.length > 0 && (
            <div>
              <div className="flex items-center gap-2 mb-3">
                <div className="bg-[#FF8ED4] rounded-full p-1.5">
                  <AlertTriangle className="w-4 h-4 md:w-5 md:h-5 text-white" />
                </div>
                <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold">
                  Importante
                </h3>
              </div>
              <div className="bg-[#FFE6F0] rounded-2xl p-4">
                <ul className="space-y-2">
                  {medication.warnings.map((warning, i) => (
                    <li key={i} className="flex items-start gap-2 text-sm md:text-base text-[#4A5568]">
                      <span className="text-[#FF8ED4] mt-1">⚠️</span>
                      <span>{warning}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          )}

          {/* Disclaimer */}
          <div className="bg-gradient-to-r from-[#E8F5E9] to-[#F1F8E9] rounded-2xl p-4">
            <p className="text-xs md:text-sm text-[#4A5568] leading-relaxed">
              <strong>Nota:</strong> Esta información es solo educativa. Siempre consulta con tu médico o equipo de salud sobre cualquier duda o efecto secundario que experimentes.
            </p>
          </div>
        </div>

        <div className="p-5 md:p-6 bg-[#F7FAFC] rounded-b-3xl">
          <button
            onClick={onClose}
            className="w-full bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] text-white py-3 md:py-4 rounded-full font-semibold hover:shadow-lg transition-all transform hover:scale-105"
          >
            Entendido
          </button>
        </div>
      </div>
    </div>
  );
}
