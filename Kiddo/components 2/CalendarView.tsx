import { useState } from 'react';
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight, Pill, Stethoscope } from 'lucide-react';
import { format, startOfWeek, addDays, isSameDay, addWeeks, subWeeks } from 'date-fns';
import { es } from 'date-fns/locale';

interface CalendarViewProps {
  userType: 'child' | 'parent';
}

interface CalendarEvent {
  id: number;
  title: string;
  type: 'medication' | 'appointment';
  date: Date;
  startTime: string;
  endTime?: string;
  description?: string;
  color: string;
}

export default function CalendarView({ userType }: CalendarViewProps) {
  const [currentWeek, setCurrentWeek] = useState(new Date());
  const weekStart = startOfWeek(currentWeek, { locale: es });

  // Mock events - medicinas y citas
  const events: CalendarEvent[] = [
    // Medicinas
    { id: 1, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 0), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 2, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 0), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 3, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 0), startTime: '20:00', color: '#87CEEB', description: '4 mg' },

    { id: 4, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 1), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 5, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 1), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 6, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 1), startTime: '20:00', color: '#87CEEB', description: '4 mg' },

    { id: 7, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 2), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 8, title: 'Cita Oncología', type: 'appointment', date: addDays(weekStart, 2), startTime: '10:00', endTime: '11:00', color: '#FFB366', description: 'Dr. García - Revisión' },
    { id: 9, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 2), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 10, title: 'Metotrexato', type: 'medication', date: addDays(weekStart, 2), startTime: '18:00', color: '#B4A7D6', description: 'Quimioterapia semanal' },
    { id: 11, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 2), startTime: '20:00', color: '#87CEEB', description: '4 mg' },

    { id: 12, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 3), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 13, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 3), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 14, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 3), startTime: '20:00', color: '#87CEEB', description: '4 mg' },

    { id: 15, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 4), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 16, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 4), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 17, title: 'Análisis de Sangre', type: 'appointment', date: addDays(weekStart, 4), startTime: '09:00', endTime: '09:30', color: '#FFB366', description: 'Laboratorio - Ayunas' },
    { id: 18, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 4), startTime: '20:00', color: '#87CEEB', description: '4 mg' },

    { id: 19, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 5), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 20, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 5), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 21, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 5), startTime: '20:00', color: '#87CEEB', description: '4 mg' },

    { id: 22, title: 'Prednisona', type: 'medication', date: addDays(weekStart, 6), startTime: '08:00', color: '#87CEEB', description: '10 mg' },
    { id: 23, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 6), startTime: '12:00', color: '#87CEEB', description: '4 mg' },
    { id: 24, title: 'Ondansetrón', type: 'medication', date: addDays(weekStart, 6), startTime: '20:00', color: '#87CEEB', description: '4 mg' },
  ];

  const hours = ['8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM', '7 PM', '8 PM'];
  const days = Array.from({ length: 7 }, (_, i) => addDays(weekStart, i));

  const getEventsForDayAndHour = (day: Date, hour: string) => {
    return events.filter(event => {
      if (!isSameDay(event.date, day)) return false;

      // Convertir hora del evento a formato comparable
      const eventHour = parseInt(event.startTime.split(':')[0]);
      const isPM = eventHour >= 12;
      const displayHour = eventHour > 12 ? eventHour - 12 : eventHour === 0 ? 12 : eventHour;
      const eventHourStr = `${displayHour} ${isPM ? 'PM' : 'AM'}`;

      return eventHourStr === hour;
    });
  };

  const isToday = (date: Date) => isSameDay(date, new Date());

  return (
    <div className="space-y-4 md:space-y-5">
      <div className="flex items-center justify-between mb-4 md:mb-6">
        <div className="flex items-center gap-2 md:gap-3">
          <CalendarIcon className="w-6 h-6 md:w-8 md:h-8 text-[#F9E784]" />
          <h2 className="text-2xl md:text-3xl text-[#2D3748]">Calendario</h2>
        </div>
      </div>

      {/* Week Navigation */}
      <div className="bg-white rounded-3xl p-4 md:p-5 shadow-lg">
        <div className="flex items-center justify-between mb-4">
          <button
            onClick={() => setCurrentWeek(subWeeks(currentWeek, 1))}
            className="p-2 hover:bg-[#E8F5E9] rounded-full transition-colors"
          >
            <ChevronLeft className="w-5 h-5 md:w-6 md:h-6 text-[#4A5568]" />
          </button>
          <h3 className="text-lg md:text-xl text-[#2D3748] font-semibold">
            {format(weekStart, 'd', { locale: es })} - {format(addDays(weekStart, 6), "d 'de' MMMM yyyy", { locale: es })}
          </h3>
          <button
            onClick={() => setCurrentWeek(addWeeks(currentWeek, 1))}
            className="p-2 hover:bg-[#E8F5E9] rounded-full transition-colors"
          >
            <ChevronRight className="w-5 h-5 md:w-6 md:h-6 text-[#4A5568]" />
          </button>
        </div>

        {/* Legend */}
        <div className="flex flex-wrap gap-3 md:gap-4 mb-4 pb-4 border-b border-[#E2E8F0]">
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-[#87CEEB]"></div>
            <span className="text-xs md:text-sm text-[#4A5568]">Medicinas</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-[#FFB366]"></div>
            <span className="text-xs md:text-sm text-[#4A5568]">Citas médicas</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-[#B4A7D6]"></div>
            <span className="text-xs md:text-sm text-[#4A5568]">Quimioterapia</span>
          </div>
        </div>

        {/* Calendar Grid */}
        <div className="overflow-x-auto">
          <div className="min-w-[800px]">
            {/* Day Headers */}
            <div className="grid grid-cols-8 gap-px bg-[#E2E8F0] border border-[#E2E8F0]">
              <div className="bg-white p-2 md:p-3"></div>
              {days.map((day, i) => (
                <div
                  key={i}
                  className={`bg-white p-2 md:p-3 text-center ${
                    isToday(day) ? 'bg-gradient-to-br from-[#E8F5E9] to-[#F1F8E9]' : ''
                  }`}
                >
                  <p className={`text-xs md:text-sm ${isToday(day) ? 'text-[#7BC67E] font-semibold' : 'text-[#718096]'}`}>
                    {format(day, 'EEE', { locale: es }).toUpperCase()}
                  </p>
                  <p className={`text-lg md:text-xl font-semibold mt-1 ${
                    isToday(day) ? 'text-[#7BC67E]' : 'text-[#2D3748]'
                  }`}>
                    {format(day, 'd')}
                  </p>
                </div>
              ))}
            </div>

            {/* Time Slots */}
            {hours.map((hour, hourIdx) => (
              <div key={hourIdx} className="grid grid-cols-8 gap-px bg-[#E2E8F0] border-b border-l border-r border-[#E2E8F0]">
                <div className="bg-[#F7FAFC] p-2 md:p-3 text-right">
                  <span className="text-xs md:text-sm text-[#718096]">{hour}</span>
                </div>
                {days.map((day, dayIdx) => {
                  const dayEvents = getEventsForDayAndHour(day, hour);
                  return (
                    <div
                      key={dayIdx}
                      className={`bg-white p-1 md:p-2 min-h-[60px] md:min-h-[70px] ${
                        isToday(day) ? 'bg-[#F7FAFC]' : ''
                      }`}
                    >
                      {dayEvents.map(event => (
                        <div
                          key={event.id}
                          className="mb-1 p-1.5 md:p-2 rounded-lg text-white text-xs md:text-sm shadow-sm hover:shadow-md transition-shadow cursor-pointer"
                          style={{ backgroundColor: event.color }}
                        >
                          <div className="flex items-center gap-1 mb-0.5">
                            {event.type === 'medication' ? (
                              <Pill className="w-3 h-3 flex-shrink-0" />
                            ) : (
                              <Stethoscope className="w-3 h-3 flex-shrink-0" />
                            )}
                            <span className="font-semibold truncate">{event.title}</span>
                          </div>
                          {event.description && (
                            <p className="text-[10px] md:text-xs opacity-90 truncate">
                              {event.description}
                            </p>
                          )}
                          {event.endTime && (
                            <p className="text-[10px] opacity-75 mt-0.5">
                              {event.startTime} - {event.endTime}
                            </p>
                          )}
                        </div>
                      ))}
                    </div>
                  );
                })}
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Summary Card */}
      <div className="bg-gradient-to-r from-[#7BC67E] to-[#87CEEB] rounded-3xl p-5 md:p-6 text-white shadow-lg">
        <h3 className="text-lg md:text-xl font-semibold mb-3">Resumen de la Semana</h3>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <p className="text-3xl md:text-4xl font-bold mb-1">
              {events.filter(e => e.type === 'medication').length}
            </p>
            <p className="text-sm md:text-base opacity-90">Medicinas programadas</p>
          </div>
          <div>
            <p className="text-3xl md:text-4xl font-bold mb-1">
              {events.filter(e => e.type === 'appointment').length}
            </p>
            <p className="text-sm md:text-base opacity-90">Citas médicas</p>
          </div>
        </div>
      </div>
    </div>
  );
}
