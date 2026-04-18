import { useState } from 'react';
import { Pill, Calendar, BookHeart, Home, Settings } from 'lucide-react';
import MedicationView from './MedicationView';
import CalendarView from './CalendarView';
import DiaryView from './DiaryView';
import HomeView from './HomeView';
import SettingsView from './SettingsView';
import AvatarCustomizer, { type AvatarConfig } from './AvatarCustomizer';

interface DashboardProps {
  userType: 'child' | 'parent';
  onLogout: () => void;
  avatarConfig: AvatarConfig;
  onAvatarConfigChange: (config: AvatarConfig) => void;
}

type View = 'home' | 'medications' | 'calendar' | 'diary' | 'settings';

export default function Dashboard({ userType, onLogout, avatarConfig, onAvatarConfigChange }: DashboardProps) {
  const [currentView, setCurrentView] = useState<View>('home');
  const [showCustomizer, setShowCustomizer] = useState(false);

  const renderView = () => {
    switch (currentView) {
      case 'home':
        return (
          <HomeView
            userType={userType}
            avatarConfig={avatarConfig}
            onCustomizeAvatar={() => setShowCustomizer(true)}
          />
        );
      case 'medications':
        return <MedicationView userType={userType} avatarConfig={avatarConfig} />;
      case 'calendar':
        return <CalendarView userType={userType} />;
      case 'diary':
        return <DiaryView />;
      case 'settings':
        return (
          <SettingsView
            userType={userType}
            avatarConfig={avatarConfig}
            onCustomizeAvatar={() => setShowCustomizer(true)}
            onLogout={onLogout}
          />
        );
      default:
        return (
          <HomeView
            userType={userType}
            avatarConfig={avatarConfig}
            onCustomizeAvatar={() => setShowCustomizer(true)}
          />
        );
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8F5E9] to-[#F1F8E9] flex flex-col">
      {/* Avatar Customizer Modal */}
      {showCustomizer && (
        <AvatarCustomizer
          config={avatarConfig}
          onConfigChange={onAvatarConfigChange}
          onClose={() => setShowCustomizer(false)}
        />
      )}

      {/* Main Content */}
      <main className="flex-1 p-4 md:p-6 max-w-7xl mx-auto w-full pb-20 pt-4">
        {renderView()}
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white shadow-lg border-t border-[#E2E8F0]">
        <div className="max-w-7xl mx-auto px-2 md:px-6 py-2 md:py-3">
          <div className="flex justify-around items-center">
            <NavButton
              icon={<Home className="w-5 h-5 md:w-6 md:h-6" />}
              label="Inicio"
              active={currentView === 'home'}
              onClick={() => setCurrentView('home')}
              color="#7BC67E"
            />
            {userType === 'parent' && (
              <NavButton
                icon={<Pill className="w-5 h-5 md:w-6 md:h-6" />}
                label="Medicinas"
                active={currentView === 'medications'}
                onClick={() => setCurrentView('medications')}
                color="#87CEEB"
              />
            )}
            <NavButton
              icon={<Calendar className="w-5 h-5 md:w-6 md:h-6" />}
              label="Calendario"
              active={currentView === 'calendar'}
              onClick={() => setCurrentView('calendar')}
              color="#F9E784"
            />
            {userType === 'child' && (
              <NavButton
                icon={<BookHeart className="w-5 h-5 md:w-6 md:h-6" />}
                label="Diario"
                active={currentView === 'diary'}
                onClick={() => setCurrentView('diary')}
                color="#B4A7D6"
              />
            )}
            <NavButton
              icon={<Settings className="w-5 h-5 md:w-6 md:h-6" />}
              label="Ajustes"
              active={currentView === 'settings'}
              onClick={() => setCurrentView('settings')}
              color="#FFB366"
            />
          </div>
        </div>
      </nav>
    </div>
  );
}

interface NavButtonProps {
  icon: React.ReactNode;
  label: string;
  active: boolean;
  onClick: () => void;
  color: string;
}

function NavButton({ icon, label, active, onClick, color }: NavButtonProps) {
  return (
    <button
      onClick={onClick}
      className={`flex flex-col items-center gap-0.5 md:gap-1 px-2 md:px-4 py-1.5 md:py-2 rounded-xl transition-all ${
        active ? 'transform scale-105 md:scale-110' : ''
      }`}
      style={{
        color: active ? color : '#718096'
      }}
    >
      <div className={active ? 'transform scale-110 md:scale-125' : ''}>
        {icon}
      </div>
      <span className="text-[10px] md:text-xs font-medium">{label}</span>
    </button>
  );
}
