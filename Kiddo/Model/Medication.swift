//
//  Medication.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import Foundation

struct Medication: Identifiable {
    let id = UUID()
    let name: String
    let genericName: String
    let time: String? 
    let dose: String?
    let emoji: String?
    let description: String
    let sideEffects: [String]
    let warnings: [String]
}

let medicationList: [Medication] = [
    Medication(
        name: "Erwinaze",
        genericName: "Asparaginasa de Erwinia chrysanthemi",
        time: nil,
        dose: nil,
        emoji: "🧪",
        description: "Enzima utilizada para agotar los niveles de asparagina en la sangre, necesaria para el crecimiento de ciertas células tumorales.",
        sideEffects: ["Náuseas", "Fatiga", "Dolor abdominal"],
        warnings: ["Riesgo de pancreatitis", "Reacciones de hipersensibilidad", "Problemas de coagulación"]
    ),
    Medication(
        name: "Rylaze",
        genericName: "Asparaginasa de Erwinia chrysanthemi (recombinante)-rywn",
        time: nil,
        dose: nil,
        emoji: "🧬",
        description: "Forma recombinante de la enzima asparaginasa para pacientes con hipersensibilidad a la derivada de E. coli.",
        sideEffects: ["Elevación de enzimas hepáticas", "Fatiga", "Disminución del apetito"],
        warnings: ["Monitorear toxicidad hepática", "Riesgo de trombosis", "Hipersensibilidad grave"]
    ),
    Medication(
        name: "Blincyto",
        genericName: "Blinatumomab",
        time: nil,
        dose: nil,
        emoji: "💉",
        description: "Anticuerpo biespecífico que ayuda al sistema inmunitario a reconocer y atacar células leucémicas B.",
        sideEffects: ["Fiebre", "Cefalea", "Edema"],
        warnings: ["Síndrome de liberación de citocinas (SRC)", "Toxicidad neurológica", "Riesgo de infecciones"]
    ),
    Medication(
        name: "Asparlas",
        genericName: "Calaspargasa pegol-mknl",
        time: nil,
        dose: nil,
        emoji: "💧",
        description: "Enzima asparaginasa de acción prolongada utilizada en regímenes de quimioterapia combinada.",
        sideEffects: ["Disfunción hepática", "Pancreatitis", "Diarrea"],
        warnings: ["Hemorragia grave", "Hepatotoxicidad", "Reacciones alérgicas"]
    ),
    Medication(
        name: "Ciclofosfamida",
        genericName: "Ciclofosfamida",
        time: nil,
        dose: nil,
        emoji: "💊",
        description: "Agente alquilante que interfiere con el crecimiento de las células cancerosas al dañar su ADN.",
        sideEffects: ["Caída de cabello", "Vómitos", "Supresión de la médula ósea"],
        warnings: ["Cistitis hemorrágica (mantener hidratación)", "Riesgo de infertilidad", "Inmunosupresión"]
    ),
    Medication(
        name: "Citarabina",
        genericName: "Citarabina",
        time: nil,
        dose: nil,
        emoji: "🏥",
        description: "Antimetabolito que inhibe la síntesis de ADN, deteniendo la replicación celular.",
        sideEffects: ["Recuento bajo de glóbulos blancos", "Estomatitis", "Fiebre"],
        warnings: ["Toxicidad cerebelosa a dosis altas", "Toxicidad ocular", "Síndrome de lisis tumoral"]
    ),
    Medication(
        name: "Revuforj",
        genericName: "Citrato de revumenib",
        time: nil,
        dose: nil,
        emoji: "🔬",
        description: "Inhibidor de la interacción menina-KMT2A para el tratamiento de ciertos tipos de leucemia genética.",
        sideEffects: ["Prolongación del intervalo QT", "Diferenciación celular", "Fatiga"],
        warnings: ["Monitoreo cardíaco (ECG)", "Síndrome de diferenciación", "Interacciones medicamentosas"]
    ),
    Medication(
        name: "Clolar",
        genericName: "Clofarabina",
        time: nil,
        dose: nil,
        emoji: "🩸",
        description: "Análogo de nucleósido purínico que inhibe la síntesis de ADN y ARN en células malignas.",
        sideEffects: ["Vómitos", "Anemia", "Erupciones cutáneas"],
        warnings: ["Síndrome de respuesta inflamatoria sistémica", "Hepatotoxicidad", "Nefrotoxicidad"]
    ),
    Medication(
        name: "Daunorrubicina",
        genericName: "Clorhidrato de daunorrubicina",
        time: nil,
        dose: nil,
        emoji: "❤️",
        description: "Antraciclina que se intercala en el ADN para bloquear la replicación y transcripción.",
        sideEffects: ["Orina rojiza (benigno)", "Mucositis", "Mielosupresión"],
        warnings: ["Cardiotoxicidad (daño al corazón)", "Extravasación grave", "Toxicidad hematológica"]
    ),
    Medication(
        name: "Sprycel",
        genericName: "Dasatinib",
        time: nil,
        dose: nil,
        emoji: "✨",
        description: "Inhibidor de la tirosina quinasa que bloquea las señales que permiten el crecimiento de células cancerosas.",
        sideEffects: ["Retención de líquidos", "Derrame pleural", "Dolor muscular"],
        warnings: ["Hipertensión pulmonar", "Riesgo de hemorragia", "Prolongación del intervalo QT"]
    ),
    Medication(
        name: "Purinethol",
        genericName: "Mercaptopurina",
        time: nil,
        dose: nil,
        emoji: "💊",
        description: "Antimetabolito que interfiere con el metabolismo de las purinas, esencial para la división celular.",
        sideEffects: ["Toxicidad hepática", "Náuseas", "Inmunosupresión"],
        warnings: ["Deficiencia de TPMT puede aumentar toxicidad", "Evitar vacunas vivas", "Monitoreo sanguíneo regular"]
    ),
    Medication(
        name: "Gleevec",
        genericName: "Mesilato de imatinib",
        time: nil,
        dose: nil,
        emoji: "🛡️",
        description: "Terapia dirigida que inhibe la proteína BCR-ABL producida por el cromosoma Filadelfia.",
        sideEffects: ["Edema periorbitario", "Calambres musculares", "Diarrea"],
        warnings: ["Toxicidad hepática", "Retención de líquidos grave", "Hipotiroidismo en algunos casos"]
    ),
    Medication(
        name: "Trexall",
        genericName: "Metotrexato de sodio",
        time: nil,
        dose: nil,
        emoji: "⚠️",
        description: "Antifolato que inhibe la dihidrofolato reductasa, impidiendo la síntesis de ADN.",
        sideEffects: ["Fotosensibilidad", "Úlceras bucales", "Malestar gástrico"],
        warnings: ["Hepatotoxicidad crónica", "Toxicidad pulmonar", "No usar con AINEs sin supervisión"]
    ),
    Medication(
        name: "Arranon",
        genericName: "Nelarabina",
        time: nil,
        dose: nil,
        emoji: "🧠",
        description: "Profármaco de nucleósido de guanina utilizado específicamente para neoplasias de células T.",
        sideEffects: ["Somnolencia", "Mareos", "Estreñimiento"],
        warnings: ["Toxicidad neurológica grave", "Convulsiones", "Neuropatía periférica"]
    ),
    Medication(
        name: "Oncaspar",
        genericName: "Pegaspargasa",
        time: nil,
        dose: nil,
        emoji: "💉",
        description: "Forma pegilada de la L-asparaginasa con una vida media más larga en el organismo.",
        sideEffects: ["Pancreatitis", "Trombosis", "Elevación de glucosa"],
        warnings: ["Anafilaxia", "Hepatotoxicidad", "Trastornos de la coagulación"]
    ),
    Medication(
        name: "Rituxan",
        genericName: "Rituximab",
        time: nil,
        dose: nil,
        emoji: "🎯",
        description: "Anticuerpo monoclonal dirigido contra el antígeno CD20 en la superficie de los linfocitos B.",
        sideEffects: ["Escalofríos", "Debilidad", "Reacciones a la infusión"],
        warnings: ["Reactivación de Hepatitis B", "Leucoencefalopatía multifocal progresiva (LMP)", "Reacciones cutáneas graves"]
    ),
    Medication(
        name: "Vincristina",
        genericName: "Sulfato de vincristina",
        time: nil,
        dose: nil,
        emoji: "🌱",
        description: "Alcaloide de la vinca que detiene la división celular al unirse a las proteínas de los microtúbulos.",
        sideEffects: ["Estreñimiento", "Caída de cabello", "Dolor en los dedos"],
        warnings: ["Solo para uso intravenoso (fatal por vía intratecal)", "Neuropatía periférica", "Extravasación"]
    ),
    Medication(
        name: "Kymriah",
        genericName: "Tisagenlecleucel",
        time: nil,
        dose: nil,
        emoji: "🧬",
        description: "Inmunoterapia de células T con receptores de antígenos quiméricos (CAR-T) personalizada.",
        sideEffects: ["Fiebre alta", "Hipotensión", "Hipogammaglobulinemia"],
        warnings: ["Síndrome de liberación de citocinas (SRC)", "Toxicidad neurológica (ICANS)", "Citopenias prolongadas"]
    )
]
