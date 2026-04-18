import { LogOut, Palette, User, Info, Shield } from 'lucide-react';
import SuperheroSprite from './SuperheroSprite';
import type { AvatarConfig } from './AvatarCustomizer';

interface SettingsViewProps {
  userType: 'child' | 'parent';
  avatarConfig: AvatarConfig;
  onCustomizeAvatar: () => void;
  onLogout: () => void;
}

export default function SettingsView({ userType, avatarConfig, onCustomizeAvatar, onLogout }: SettingsViewProps) {
  return (
    <div className="space-y-4 md:space-y-6">
      <div className="flex items-center gap-2 md:gap-3 mb-4 md:mb-6">
        <User className="w-6 h-6 md:w-8 md:h-8 text-[#7BC67E]" />
        <h2 className="text-2xl md:text-3xl text-[#2D3748]">Configuración</h2>
      </div>

      {/* User Profile Card */}
      <div className="bg-gradient-to-b from-[#E8F5E9] to-white rounded-3xl p-6 md:p-8 shadow-lg">
        <div className="flex flex-col items-center">
          <div className="relative mb-6">
            <div className="w-32 h-32 md:w-40 md:h-40 rounded-full bg-gradient-to-br from-[#7BC67E] to-[#87CEEB] p-1 shadow-xl">
              <div className="w-full h-full rounded-full bg-white flex items-center justify-center">
                <SuperheroSprite {...avatarConfig} size={110} />
              </div>
            </div>
          </div>
          <h3 className="text-xl md:text-2xl text-[#2D3748] font-semibold mb-1">
            {userType === 'child' ? '¡Mi Superhéroe!' : 'Cuidador'}
          </h3>
          <p className="text-sm md:text-base text-[#718096]">
            {userType === 'child' ? 'Cuenta personal' : 'Cuenta de apoyo'}
          </p>
        </div>
      </div>

      {/* Settings Options */}
      <div className="bg-white rounded-3xl shadow-lg overflow-hidden">
        {userType === 'child' && (
          <button
            onClick={onCustomizeAvatar}
            className="w-full flex items-center gap-4 p-4 md:p-5 hover:bg-[#F7FAFC] transition-colors border-b border-[#E2E8F0]"
          >
            <div className="bg-gradient-to-br from-[#B4A7D6] to-[#FFB366] rounded-full p-3">
              <Palette className="w-5 h-5 md:w-6 md:h-6 text-white" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-base md:text-lg text-[#2D3748] font-semibold">
                Personalizar Superhéroe
              </p>
              <p className="text-xs md:text-sm text-[#718096]">
                Cambia tu máscara, capa y colores
              </p>
            </div>
            <span className="text-[#CBD5E0]">▶</span>
          </button>
        )}

        <button className="w-full flex items-center gap-4 p-4 md:p-5 hover:bg-[#F7FAFC] transition-colors border-b border-[#E2E8F0]">
          <div className="bg-gradient-to-br from-[#87CEEB] to-[#7BC67E] rounded-full p-3">
            <Shield className="w-5 h-5 md:w-6 md:h-6 text-white" />
          </div>
          <div className="flex-1 text-left">
            <p className="text-base md:text-lg text-[#2D3748] font-semibold">
              Privacidad
            </p>
            <p className="text-xs md:text-sm text-[#718096]">
              {userType === 'child'
                ? 'Tu diario es solo tuyo'
                : 'Configuración de acceso'}
            </p>
          </div>
          <span className="text-[#CBD5E0]">▶</span>
        </button>

        <button className="w-full flex items-center gap-4 p-4 md:p-5 hover:bg-[#F7FAFC] transition-colors">
          <div className="bg-gradient-to-br from-[#F9E784] to-[#FFB366] rounded-full p-3">
            <Info className="w-5 h-5 md:w-6 md:h-6 text-white" />
          </div>
          <div className="flex-1 text-left">
            <p className="text-base md:text-lg text-[#2D3748] font-semibold">
              Acerca de
            </p>
            <p className="text-xs md:text-sm text-[#718096]">
              Versión 1.0.0 - Mi Jardín de Salud
            </p>
          </div>
          <span className="text-[#CBD5E0]">▶</span>
        </button>
      </div>

      {/* App Info */}
      <div className="bg-gradient-to-r from-[#B4A7D6] to-[#7BC67E] rounded-3xl p-6 text-white shadow-lg">
        <div className="flex items-center gap-4 mb-4">
          <span className="text-4xl">🌸</span>
          <div>
            <p className="text-lg font-semibold mb-1">Mi Jardín de Salud</p>
            <p className="text-sm opacity-90">
              Una app para cuidar de ti con amor
            </p>
          </div>
        </div>
        <p className="text-xs opacity-75">
          Recuerda: Esta app es una herramienta de apoyo. Siempre consulta con tu equipo médico para decisiones importantes sobre tu salud.
        </p>
      </div>

      {/* Logout Button */}
      <button
        onClick={onLogout}
        className="w-full bg-gradient-to-r from-[#FF8ED4] to-[#FFB366] text-white p-4 md:p-5 rounded-3xl shadow-lg hover:shadow-xl transition-all flex items-center justify-center gap-3"
      >
        <LogOut className="w-5 h-5 md:w-6 md:h-6" />
        <span className="text-base md:text-lg font-semibold">Cerrar Sesión</span>
      </button>
    </div>
  );
}
