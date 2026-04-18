import { useState } from 'react';
import { Info, Clock, Pill } from 'lucide-react';
import MedicationInfoModal from './MedicationInfoModal';
import type { AvatarConfig } from './AvatarCustomizer';

interface MedicationViewProps {
  userType: 'child' | 'parent';
  avatarConfig: AvatarConfig;
}

interface Medication {
  id: number;
  name: string;
  genericName: string;
  time: string;
  dose: string;
  emoji: string;
  description: string;
  sideEffects: string[];
  warnings: string[];
}

export default function MedicationView({ userType, avatarConfig }: MedicationViewProps) {
  const [selectedMedication, setSelectedMedication] = useState<Medication | null>(null);
  const [medications] = useState<Medication[]>([
    {
      id: 1,
      name: 'Prednisona',
      genericName: 'Corticosteroide',
      time: '8:00 AM',
      dose: '10 mg (1 tableta)',
      emoji: '💊',
      description: 'La prednisona es un corticosteroide que ayuda a reducir la inflamación en el cuerpo. Se usa para tratar diversos tipos de cáncer y reducir la inflamación asociada con la quimioterapia.',
      sideEffects: [
        'Aumento del apetito',
        'Cambios de humor o irritabilidad',
        'Dificultad para dormir',
        'Aumento de peso',
        'Retención de líquidos',
        'Dolor de estómago'
      ],
      warnings: [
        'Tomar con alimentos para reducir molestias estomacales',
        'No suspender súbitamente sin consultar al médico',
        'Puede aumentar el nivel de azúcar en sangre'
      ]
    },
    {
      id: 2,
      name: 'Ondansetrón',
      genericName: 'Antiemético',
      time: '12:00 PM y 8:00 PM',
      dose: '4 mg (1 tableta)',
      emoji: '🌊',
      description: 'El ondansetrón ayuda a prevenir las náuseas y vómitos causados por la quimioterapia. Funciona bloqueando las sustancias en el cuerpo que provocan náuseas.',
      sideEffects: [
        'Dolor de cabeza leve',
        'Mareos',
        'Estreñimiento',
        'Cansancio',
        'Sensación de calor o enrojecimiento'
      ],
      warnings: [
        'Puede causar mareos, evita levantarte rápidamente',
        'Bebe suficiente agua para prevenir estreñimiento',
        'Informa si tienes latidos cardíacos irregulares'
      ]
    },
    {
      id: 3,
      name: 'Ácido Fólico',
      genericName: 'Suplemento vitamínico',
      time: '9:00 AM',
      dose: '1 mg (1 tableta)',
      emoji: '🍃',
      description: 'El ácido fólico es una vitamina B que ayuda a tu cuerpo a producir células sanguíneas sanas. Es especialmente importante durante el tratamiento de leucemia.',
      sideEffects: [
        'Náuseas leves (poco común)',
        'Sabor amargo en la boca',
        'Dificultad para dormir (raro)',
        'Irritabilidad (raro)'
      ],
      warnings: [
        'Tomar con un vaso lleno de agua',
        'Se puede tomar con o sin alimentos',
        'Es importante no saltarse las dosis'
      ]
    },
    {
      id: 4,
      name: 'Metotrexato',
      genericName: 'Antimetabolito',
      time: '6:00 PM (solo martes)',
      dose: 'Según indicación médica',
      emoji: '💉',
      description: 'El metotrexato es un medicamento de quimioterapia que ayuda a eliminar las células cancerosas. Se administra una vez por semana en un día específico.',
      sideEffects: [
        'Náuseas y vómitos',
        'Llagas en la boca',
        'Pérdida del apetito',
        'Cansancio extremo',
        'Mayor riesgo de infecciones',
        'Sensibilidad al sol'
      ],
      warnings: [
        'IMPORTANTE: Solo tomar el día indicado por el médico',
        'Usar protector solar cuando estés al aire libre',
        'Avisar inmediatamente si tienes fiebre o señales de infección',
        'Evitar contacto con personas enfermas',
        'Beber mucha agua para ayudar a eliminar el medicamento'
      ]
    }
  ]);

  return (
    <div className="space-y-4 md:space-y-6">
      {selectedMedication && (
        <MedicationInfoModal
          medication={selectedMedication}
          onClose={() => setSelectedMedication(null)}
        />
      )}

      <div className="flex items-center gap-2 md:gap-3 mb-4 md:mb-6">
        <Pill className="w-6 h-6 md:w-8 md:h-8 text-[#87CEEB]" />
        <h2 className="text-2xl md:text-3xl text-[#2D3748]">Mis Medicinas</h2>
      </div>

      {/* Medication List */}
      <div className="space-y-3 md:space-y-4">
        {medications.map((med) => (
          <div
            key={med.id}
            className="bg-white rounded-3xl p-4 md:p-6 shadow-lg"
          >
            <div className="flex items-start gap-3 md:gap-4">
              <div className="text-4xl md:text-5xl flex-shrink-0">{med.emoji}</div>
              <div className="flex-1 min-w-0">
                <h3 className="text-lg md:text-2xl text-[#2D3748] font-semibold mb-1">
                  {med.name}
                </h3>
                <p className="text-xs md:text-sm text-[#718096] mb-2">{med.genericName}</p>
                <div className="flex items-center gap-2 text-[#4A5568] mb-1">
                  <Clock className="w-3 h-3 md:w-4 md:h-4" />
                  <span className="text-xs md:text-sm">{med.time}</span>
                </div>
                <div className="flex items-center gap-2 text-[#718096]">
                  <Pill className="w-3 h-3 md:w-4 md:h-4" />
                  <p className="text-xs md:text-sm">{med.dose}</p>
                </div>

                <button
                  onClick={() => setSelectedMedication(med)}
                  className="mt-3 w-full sm:w-auto bg-gradient-to-r from-[#87CEEB] to-[#B4A7D6] text-white px-4 md:px-5 py-2 md:py-2.5 rounded-full text-sm md:text-base font-semibold hover:shadow-lg transition-all transform hover:scale-105 active:scale-95 flex items-center justify-center gap-2"
                >
                  <Info className="w-4 h-4" />
                  <span>Aprender más</span>
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Info Card */}
      <div className="bg-gradient-to-r from-[#B4A7D6] to-[#FFB366] rounded-3xl p-5 md:p-6 text-white shadow-lg">
        <div className="flex items-center gap-3 mb-3">
          <Info className="w-6 h-6 md:w-7 md:h-7" />
          <h3 className="text-lg md:text-xl font-semibold">Información Importante</h3>
        </div>
        <p className="text-sm md:text-base opacity-90 leading-relaxed">
          Toca "Aprender más" en cada medicina para conocer sus efectos secundarios y recomendaciones. Si experimentas algo inusual, informa a tu equipo médico de inmediato.
        </p>
      </div>
    </div>
  );
}
