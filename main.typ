//todo distance between arrows and names
//move some things like spaces between text blocks from courceproject to
//масштаб для диаграмм прописать штоле
//переносы формул нормальные
//сделать j справа местами
//сделать x x красивее

#import "@local/typst-bsuir-core:1.15.42": *
#import "@preview/zap:0.5.0"

#set text(font: "Times New Roman", size: 14pt)
#show math.equation: set text(font: "STIX Two Math", size: 14pt)

#show: gost.with(
  title-template: custom-title-template.from-module(toec-typical-template),
  department: "Кафедра теоретических основ электротехники",
  work: (
    type: "",
    number: "",
    subject: "Расчет сложной цепи периодического синусоидального тока",
    variant: "558301-14",
  ),
  manager: (
    name: "Батюков С.В.",
  ),
  performer: (
    name: "Ермаков В. С.",
    group: "558301",
  ),
  footer: (city: "Минск", year: 2026),
  city: none,
  year: none,
  add-pagebreaks: false,
  text-size: 14pt,
)

#show: apply-toec-styling
#include complex-math

#show math.equation: eq => {
  show regex(",00"): none // Убираем лишние нули, если они появляются
  eq
}

// === ИСХОДНЫЕ ДАННЫЕ ВАРИАНТА ===
#let V = (
  R1: 98, XL1: 0, XC1: 0, J1_m: 2, J1_a: 42,
  R2: 68, XL2: 28, XC2: 19,
  R3: 31, XL3: 0, XC3: 88, E3_m: 89, E3_a: 319,
  R4: 46, XL4: 0, XC4: 15,
  R5: 0, XL5: 78, XC5: 0,
  R6: 0, XL6: 99, XC6: 0,
  R7: 0, XL7: 87, XC7: 22,
)

// Вычисление комплексов
#let J1 = polar(V.J1_m, V.J1_a)
#let E3 = polar(V.E3_m, V.E3_a)

#let Z1 = rect(V.R1, V.XL1 - V.XC1)
#let Z2 = rect(V.R2, V.XL2 - V.XC2)
#let Z3 = rect(V.R3, V.XL3 - V.XC3)
#let Z4 = rect(V.R4, V.XL4 - V.XC4)
#let Z5 = rect(V.R5, V.XL5 - V.XC5)
#let Z6 = rect(V.R6, V.XL6 - V.XC6)
#let Z7 = rect(V.R7, V.XL7 - V.XC7)

#let E01 = mul(J1, Z1)

#let Z156 = add(add(Z1, Z5), Z6)
#let Z234 = add(add(Z2, Z3), Z4)

#let Y156 = div(rect(1,0), Z156)
#let Y234 = div(rect(1,0), Z234)
#let Y7 = div(rect(1,0), Z7)

#let num = add(mul(rect(-1,0), mul(E01, Y156)), mul(E3, Y234))
#let den = add(add(Y156, Y234), Y7)
#let U34 = div(num, den)

#let I156 = div(add(U34, E01), Z156)
#let I234 = div(sub(E3, U34), Z234)
#let I7 = mul(div(U34, Z7), rect(-1,0))

#let I1 = sub(I156, J1)
#let I2 = I234
#let I3 = I234
#let I4 = I234
#let I5 = I156
#let I6 = I156


= Начертить схему согласно заданному варианту

Исходные данные варианта представлены в таблице @src-table, схема электрической цепи изображена на рисунке @src-circuit.

#figure(
  caption: [Исходные данные варианта],
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    align: center + horizon,
    table.header(
      table.cell(rowspan: 2)[Номер\ ветви],
      table.cell(rowspan: 2)[Начало-\ конец],
      table.cell(colspan: 3)[Сопротивления, Ом],
      table.cell(colspan: 2)[Источник ЭДС],
      table.cell(colspan: 2)[Источник тока],
      [$R$], [$X_L$], [$X_C$],
      [Мод., В], [Арг., $degree$], [Мод., А], [Арг., $degree$]
    ),
    [1], [6–4], [#V.R1], [#V.XL1], [#V.XC1], [0], [0], [#V.J1_m], [#V.J1_a],
    [2], [4–2], [#V.R2], [#V.XL2], [#V.XC2], [0], [0], [0], [0],
    [3], [2–5], [#V.R3], [#V.XL3], [#V.XC3], [#V.E3_m], [#V.E3_a], [0], [0],
    [4], [5–3], [#V.R4], [#V.XL4], [#V.XC4], [0], [0], [0], [0],
    [5], [3–1], [#V.R5], [#V.XL5], [#V.XC5], [0], [0], [0], [0],
    [6], [1–6], [#V.R6], [#V.XL6], [#V.XC6], [0], [0], [0], [0],
    [7], [4–3], [#V.R7], [#V.XL7], [#V.XC7], [0], [0], [0], [0],
  )
) <src-table>

#lab-figure(
  caption: [Исходная схема электрической цепи],
  above: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *

    // Опорные узлы (расстояние по вертикали 8 единиц для простора)
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "top-right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom"), visible: true)

    // Ветвь 5 (3 -> 1)
    inductor-better("L5", "3", "1", label: (content: $L_5$, anchor: "left"), arrow-label: $I_5$, arrow-side: "right", arrow-dir: "forward")

    // Ветвь 6 (1 -> 6)
    inductor-better("L6", "1", "6", label: (content: $L_6$, anchor: "top"), arrow-label: $I_6$, arrow-side: "bottom", arrow-dir: "forward")

    // Ветвь 1 (6 -> 4)
    resistor-better("R1", "6", "4", label: (content: $R_1$, anchor: "right"), arrow-label: $I_1$, arrow-side: "left", arrow-dir: "forward")

    // Источник тока J1 (параллельно ветви 6->4)
    wire("6", (17, 16))
    jsource-better("J1", (17, 16), (17, 8), arrow-dir: "forward", label: (content: $J_1$, anchor: "right"))
    wire((17, 8), "4")

    // Ветвь 2 (4 -> 2)
    resistor-better("R2", "4", (12, 4.2), label: (content: $R_2$, anchor: "right"), arrow-label: $I_2$, arrow-side: "left", arrow-dir: "forward")
    inductor-better("L2", (12, 4.2), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    // Ветвь 3 (2 -> 5)
    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"), arrow-label: $I_3$, arrow-side: "top", arrow-dir: "forward")
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    source-better("E3", (4, 0), "5", label: (content: $E_3$, anchor: "bottom"), arrow-dir: "forward")

    // Ветвь 4 (5 -> 3)
    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"), arrow-label: $I_4$, arrow-side: "right", arrow-dir: "forward")
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    // Ветвь 7 (4 -> 3)
    inductor-better("L7", "4", (6, 8), label: (content: $L_7$, anchor: "bottom"), arrow-label: $I_7$, arrow-side: "top", arrow-dir: "forward")
    capacitor-better("C7", (6, 8), "3", label: (content: $C_7$, anchor: "bottom"))
  })
) <src-circuit>

= Расчет токов в ветвях исходной цепи методом эквивалентных преобразований

Переведем заданные параметры источников тока и ЭДС в комплексную форму:

#mathtype-mimic[
  $ dot(J)_1 &= #V.J1_m e^(j #V.J1_a degree) = #display-complex(J1).rect " А"; $
  $ dot(E)_3 &= #V.E3_m e^(j #V.E3_a degree) = #display-complex(E3).rect " В". $
]

В соответствии с заданием, определим комплексные сопротивления всех ветвей, сразу подставляя заданные значения активных и реактивных элементов ($dot(Z)_k = R_k + j X_(L k) - j X_(C k)$):

#mathtype-mimic[
  $ dot(Z)_1 &= #V.R1 = #display-complex(Z1).rect " Ом"; $
  $ dot(Z)_2 &= #V.R2 + j #V.XL2 - j #V.XC2 = #display-complex(Z2).both " Ом"; $
  $ dot(Z)_3 &= #V.R3 - j #V.XC3 = #display-complex(Z3).both " Ом"; $
  $ dot(Z)_4 &= #V.R4 - j #V.XC4 = #display-complex(Z4).both " Ом"; $
  $ dot(Z)_5 &= j #V.XL5 = #display-complex(Z5).both " Ом"; $
  $ dot(Z)_6 &= j #V.XL6 = #display-complex(Z6).both " Ом"; $
  $ dot(Z)_7 &= j #V.XL7 - j #V.XC7 = #display-complex(Z7).both " Ом". $
]

Выполним эквивалентные преобразования цепи. Источник тока $dot(J)_1$, подключенный параллельно сопротивлению $dot(Z)_1$, преобразуем в эквивалентный источник ЭДС $dot(E)_01$, включенный последовательно с $dot(Z)_1$:

#mathtype-mimic[
  $ dot(E)_01 = dot(J)_1 dot dot(Z)_1 = (#display-complex(J1).polar) dot #V.R1 = #display-complex(E01).polar " В". $
]

После этого преобразования ветви 5, 6 и 1 оказываются соединенными последовательно, образуя единую эквивалентную ветвь $dot(Z)_156$. Аналогично, ветви 2, 3 и 4 соединяются последовательно, образуя ветвь $dot(Z)_234$. Найдем их эквивалентные сопротивления:

#mathtype-mimic[
  $ dot(Z)_156 &= dot(Z)_1 + dot(Z)_5 + dot(Z)_6 = #V.R1 + j #V.XL5 + j #V.XL6 = #display-complex(Z156).both " Ом"; $
  $ dot(Z)_234 &= dot(Z)_2 + dot(Z)_3 + dot(Z)_4 = (#display-complex(Z2).rect) + (#display-complex(Z3).rect) + (#display-complex(Z4).rect) = #display-complex(Z234).both " Ом". $
]

В результате эквивалентных преобразований исходная схема сводится к схеме с двумя узлами (3 и 4) и тремя параллельными ветвями (рис. @two-loop-circuit).

#lab-figure(
  caption: [Эквивалентная схема после преобразований],
  above: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *

    node-better("3", (0, 3), label: (content: "3", anchor: "left"), visible: true)
    node-better("4", (12, 3), label: (content: "4", anchor: "right"), visible: true)

    // Верхняя ветвь (156), обход 3 -> 4
    wire("3", (0, 6))
    source-better("E01", (0, 6), (4, 6), label: (content: $dot(E)_01$, anchor: "top"), arrow-dir: "forward")
    resistor-better("Z156", (4, 6), (12, 6), label: (content: $dot(Z)_156$, anchor: "top"), arrow-label: $dot(I)_156$, arrow-side: "bottom", arrow-dir: "forward")
    wire((12, 6), "4")

    // Средняя ветвь (7), обход 4 -> 3
    resistor-better("Z7", "4", "3", label: (content: $dot(Z)_7$, anchor: "bottom"), arrow-label: $dot(I)_7$, arrow-side: "top", arrow-dir: "forward")

    // Нижняя ветвь (234), обход 4 -> 3
    wire("4", (12, 0))
    resistor-better("Z234", (12, 0), (6, 0), label: (content: $dot(Z)_234$, anchor: "bottom"), arrow-label: $dot(I)_234$, arrow-side: "top", arrow-dir: "forward")
    source-better("E3", (6, 0), (0, 0), label: (content: $dot(E)_3$, anchor: "bottom"), arrow-dir: "forward")
    wire((0, 0), "3")
  })
) <two-loop-circuit>

Для расчета полученной схемы применим метод узловых напряжений (метод двух узлов). Определим напряжение между узлами 3 и 4 ($dot(U)_34 = dot(phi)_3 - dot(phi)_4$):

#mathtype-mimic[
  $ dot(U)_34 = (- dot(E)_01 / dot(Z)_156 + dot(E)_3 / dot(Z)_234) / (1 / dot(Z)_156 + 1 / dot(Z)_7 + 1 / dot(Z)_234) = #display-complex(U34).both " В". $
]

Определяем токи в ветвях эквивалентной схемы по обобщенному закону Ома:

#mathtype-mimic(receive: true)[
  $ dot(I)_156 &= (dot(U)_34 + dot(E)_01) / dot(Z)_156 = #display-complex(I156).polar " А"; $
  $ dot(I)_234 &= (-dot(U)_34 + dot(E)_3) / dot(Z)_234 = #display-complex(I234).polar " А"; $
  $ dot(I)_7 &= - dot(U)_34 / dot(Z)_7 = #display-complex(I7).polar " А". $
]

Определяем токи в ветвях исходной схемы.
Для ветвей 5 и 6 токи равны эквивалентному току $dot(I)_156$, а для ветвей 2, 3 и 4 — эквивалентному току $dot(I)_234$:

#mathtype-mimic[
  $ dot(I)_5 &= dot(I)_6 = dot(I)_156 = #display-complex(I156).rect " А"; $
  $ dot(I)_2 &= dot(I)_3 = dot(I)_4 = dot(I)_234 = #display-complex(I234).rect " А". $
]

Ток в первой ветви $dot(I)_1$, к которой был параллельно подключен источник $dot(J)_1$, находится по первому закону Кирхгофа (ток в пассивном элементе ветви $Z_1$):

#mathtype-mimic(receive: true)[
  $ dot(I)_1 = dot(I)_156 - dot(J)_1 = (#display-complex(I156).rect) - (#display-complex(J1).rect) = #display-complex(I1).polar " А". $
]

= Составление баланса мощностей
Проверим правильность вычислений, составив баланс комплексных мощностей. Полная мощность, отдаваемая источниками ($dot(S)_"ист"$), должна быть равна полной мощности, потребляемой пассивными элементами цепи ($dot(S)_"потр"$).

Мощность, отдаваемая источниками, определяется как сумма мощностей источника ЭДС $dot(E)_3$ и источника тока $dot(J)_1$. Для последнего необходимо предварительно найти напряжение на его зажимах $dot(U)_46$.

#let U46 = mul(rect(-1, 0), mul(I1, Z1))
#let S_E3 = mul(E3, complex-math.conjugate(I3))
#let S_J1 = mul(U46, complex-math.conjugate(J1))
#let S_source = add(S_E3, S_J1)

#mathtype-mimic(receive: true)[
  $ dot(S)_"ист" = dot(E)_3 dot(I)_3^* + (-dot(I)_1 dot(Z)_1) dot(J)_1^* = #display-complex(S_source).rect " ВА". $
]

Мощность, потребляемая пассивными элементами, рассчитывается как сумма мощностей на всех комплексных сопротивлениях цепи:

#let P_load = (
  calc.pow(to-polar(I1).mag, 2) * V.R1 + calc.pow(to-polar(I2).mag, 2) * V.R2 + calc.pow(to-polar(I3).mag, 2) * V.R3 +
  calc.pow(to-polar(I4).mag, 2) * V.R4 + calc.pow(to-polar(I5).mag, 2) * V.R5 + calc.pow(to-polar(I6).mag, 2) * V.R6 +
  calc.pow(to-polar(I7).mag, 2) * V.R7
)
#let Q_load = (
  calc.pow(to-polar(I1).mag, 2) * (V.XL1 - V.XC1) + calc.pow(to-polar(I2).mag, 2) * (V.XL2 - V.XC2) +
  calc.pow(to-polar(I3).mag, 2) * (V.XL3 - V.XC3) + calc.pow(to-polar(I4).mag, 2) * (V.XL4 - V.XC4) +
  calc.pow(to-polar(I5).mag, 2) * (V.XL5 - V.XC5) + calc.pow(to-polar(I6).mag, 2) * (V.XL6 - V.XC6) +
  calc.pow(to-polar(I7).mag, 2) * (V.XL7 - V.XC7)
)
#let S_load = rect(P_load, Q_load)

#mathtype-mimic[
  $ dot(S)_"потр" = sum_(k=1)^7 I_k^2 dot(Z)_k = P_"потр" + j Q_"потр" = #display-complex(S_load, p-digits: 3, r-digits: 3).rect " ВА". $
]

Полученные значения $dot(S)_"ист"$ и $dot(S)_"потр"$ практически совпадают, следовательно, баланс мощностей выполняется и расчеты токов верны.

= Построение векторной и топографической диаграмм
По результатам расчетов построим совмещенную векторную диаграмму токов и топографическую диаграмму напряжений (рис. @vector-topo-diagram). Для построения топографической диаграммы напряжений выбран замкнутый контур 4-2-5-3-4. Примем потенциал узла 4 за ноль ($dot(phi)_4 = 0$).

// Вычисляем потенциалы узлов последовательно по контуру:
// Ветвь 2 (4->2): phi_4 - phi_2 = I_2 * Z_2  =>  phi_2 = phi_4 - I_2 * Z_2
#let phi_4 = rect(0, 0)
#let phi_2 = sub(phi_4, mul(I2, Z2))

// Ветвь 3 (2->5): phi_2 - phi_5 + E_3 = I_3 * Z_3  =>  phi_5 = phi_2 + E_3 - I_3 * Z_3
#let phi_5 = sub(add(phi_2, E3), mul(I3, Z3))

// Ветвь 4 (5->3): phi_5 - phi_3 = I_4 * Z_4  =>  phi_3 = phi_5 - I_4 * Z_4
#let phi_3 = sub(phi_5, mul(I4, Z4))

// Проверка: замыкание через ветвь 7 (4->3): phi_4 - phi_3 = I_7 * Z_7 => phi_4 = phi_3 + I_7 * Z_7
#let phi_4_check = add(phi_3, mul(I7, Z7))

// Задаем масштабные коэффициенты
#let v_scale = 0.2
#let c_scale = 4 // Токи умножаем на 1.5 (чтобы поместились на графике)

// Функция для масштабирования точек на координатной плоскости
#let scale_pt(c, scale) = (to-rect(c).re * scale, to-rect(c).im * scale)

#let p_4 = scale_pt(phi_4, v_scale)
#let p_2 = scale_pt(phi_2, v_scale)
#let p_5 = scale_pt(phi_5, v_scale)
#let p_3 = scale_pt(phi_3, v_scale)
#let p_4_check = scale_pt(phi_4_check, v_scale) // Должна совпасть с p_4 (0,0)

#lab-figure(
  caption: [Векторная диаграмма токов и топографическая диаграмма напряжений],
  vector-diagram(
    chain-voltages: false, chain-currents: false,

    voltages: (
      (start: p_4, end: p_2, label: $dot(U)_2$, anchor: "north-west"),
      (start: p_2, end: p_5, label: $dot(U)_3 - dot(E)_3$, anchor: "west"),
      (start: p_5, end: p_3, label: $dot(U)_4$, anchor: "south-east"),
      (start: p_3, end: p_4_check, label: $dot(U)_7$, anchor: "south-west"),
    ),

    currents: (
      (start: (0,0), end: scale_pt(I1, c_scale), label: $dot(I)_1$, anchor: "north"),
      (start: (0,0), end: scale_pt(I2, c_scale), label: $dot(I)_2$, anchor: "south-west"),
      (start: (0,0), end: scale_pt(I3, c_scale), label: $dot(I)_3$, anchor: "south"),
      (start: (0,0), end: scale_pt(I5, c_scale), label: $dot(I)_5$, anchor: "south-east"),
      (start: (0,0), end: scale_pt(I6, c_scale), label: $dot(I)_6$, anchor: "north-west"),
      (start: (0,0), end: scale_pt(I7, c_scale), label: $dot(I)_7$, anchor: "north-east"),
    ),

    // Отключаем авто-суммирование
    sum-voltage: (enabled: false), sum-current: (enabled: false),

    axes: (x: 8, y: 15)
  )
) <vector-topo-diagram>

= Определение тока в ветви 5 методом эквивалентного генератора (МЭГН)
В соответствии с заданием, определим ток $dot(I)_5$ методом эквивалентного генератора. Для этого исключим ветвь 5 (с индуктивностью $L_5$) из исходной схемы.

== Определение напряжения холостого хода
В полученной схеме (рис. @meg-xx) ветвь 6 (с индуктивностью $L_6$) также оказывается разомкнутой с одной стороны. Поэтому ток в ней равен нулю ($dot(I)_6 = 0$), а потенциалы узлов 1 и 6 равны ($dot(phi)_1 = dot(phi)_6$).

Так как $dot(I)_6 = 0$, весь ток источника $dot(J)_1$ замыкается через ветвь 1. Следовательно, ток в первой ветви $dot(I)_(1 x x) = -dot(J)_1$.
Контур, образованный ветвями 7 и 2-3-4, оказывается полностью изолированным от внешних токов. Найдем циркулирующий в нем ток $dot(I)_(7 x x)$:

#let I7_xx = div(E3, add(Z7, Z234))
#mathtype-mimic[
  $ dot(I)_(7 x x) = dot(E)_3 / (dot(Z)_7 + dot(Z)_234) = (#display-complex(E3).polar) / (#display-complex(Z7).rect + (#display-complex(Z234).rect)) = #display-complex(I7_xx).polar " А". $
]

Напряжение холостого хода $dot(U)_(x x)$ между узлами 3 и 1 найдем как разность потенциалов:
#let U_xx = sub(mul(J1, Z1), mul(I7_xx, Z7))
#mathtype-mimic(receive: true)[
  $ dot(U)_(x x) &= dot(phi)_3 - dot(phi)_1 = dot(phi)_3 - dot(phi)_6 = (dot(phi)_4 - dot(I)_(7 x x) dot(Z)_7) - (dot(phi)_4 - dot(J)_1 dot(Z)_1) = \
  &= dot(J)_1 dot(Z)_1 - dot(I)_(7 x x) dot(Z)_7 = #display-complex(U_xx).polar " В". $
]

//todo улучшить первую схему и заменить эту той (ну типо чтобы токи сверху были)
#lab-figure(
  caption: [Схема для определения напряжения холостого хода],
  above: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top-left"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "top-right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom-right"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom-left"), visible: true)

    // Разорванная ветвь 5 (3 -> 1)
    open-branch-better("XX5", "3", "1", label: $dot(U)_(x x)$, arrow-side: "left", arrow-dir: "forward", show-terminals: true)

    // Ветвь 6 (1 -> 6)
    current-arrow("I6", "1", (4, 16), arrow-label: $I_6=0$, arrow-side: "bottom")
    inductor-better("L6", (4, 16), "6", label: (content: $L_6$, anchor: "top"))

    // Ветвь 1 (6 -> 4)
    current-arrow("I1", "6", (12, 13), arrow-label: $-dot(J)_1$, arrow-side: "left")
    resistor-better("R1", (12, 13), "4", label: (content: $R_1$, anchor: "right"))

    // Источник тока J1 (параллельно ветви 6->4)
    wire("6", (17, 16))
    jsource-better("J1", (17, 16), (17, 8), arrow-dir: "forward", label: (content: $J_1$, anchor: "right"))
    wire((17, 8), "4")

    // Ветвь 2 (4 -> 2)
    resistor-better("R2", "4", (12, 5.3), label: (content: $R_2$, anchor: "right"))
    inductor-better("L2", (12, 5.3), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    // Ветвь 3 (2 -> 5)
    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"))
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    source-better("E3", (4, 0), "5", label: (content: $E_3$, anchor: "bottom"), arrow-dir: "forward")

    // Ветвь 4 (5 -> 3)
    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"))
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    // Ветвь 7 (4 -> 3)
    current-arrow("I7xx", "4", (9, 8), arrow-label: $dot(I)_(7 x x)$, arrow-side: "top")
    inductor-better("L7", (9, 8), (4, 8), label: (content: $L_7$, anchor: "bottom"))
    capacitor-better("C7", (4, 8), "3", label: (content: $C_7$, anchor: "bottom"))
  })
) <meg-xx>

== Определение эквивалентного сопротивления генератора
Для нахождения эквивалентного сопротивления $dot(Z)_"ген"$ закоротим идеальный источник ЭДС $dot(E)_3$ и разорвем ветвь с источником тока $dot(J)_1$ (рис. @meg-zgen).
Входное сопротивление относительно зажимов 3 и 1 состоит из последовательно соединенных участков $dot(Z)_6$, $dot(Z)_1$ и параллельного участка, состоящего из ветви 7 и эквивалентной ветви 2-3-4:

#let Z43 = div(mul(Z7, Z234), add(Z7, Z234))
#let Z_gen = add(add(Z1, Z6), Z43)

#mathtype-mimic[
  $ dot(Z)_"ген" &= dot(Z)_6 + dot(Z)_1 + (dot(Z)_7 dot dot(Z)_234) / (dot(Z)_7 + dot(Z)_234) = \
  &= j #V.XL6 + #V.R1 + (#display-complex(Z7).rect dot (#display-complex(Z234).rect)) / (#display-complex(Z7).rect + (#display-complex(Z234).rect)) = #display-complex(Z_gen).both " Ом". $
]

#lab-figure(
  caption: [Схема для определения эквивалентного сопротивления],
  above: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top-left"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top-right"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom-right"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom-left"), visible: true)

    // Зажимы
    open-branch-better("ZGEN", "3", "1", label: $dot(Z)_"ген"$, arrow-side: "left", arrow-dir: "forward", show-terminals: true)

    // Ветвь 6
    inductor-better("L6", "1", "6", label: (content: $L_6$, anchor: "top"))

    // Ветвь 1 (J1 разорван)
    resistor-better("R1", "6", "4", label: (content: $R_1$, anchor: "right"))

    // Ветвь 2
    resistor-better("R2", "4", (12, 5.3), label: (content: $R_2$, anchor: "right"))
    inductor-better("L2", (12, 5.3), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    // Ветвь 3 (E3 закорочен)
    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"))
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    wire((4, 0), "5")

    // Ветвь 4
    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"))
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    // Ветвь 7
    inductor-better("L7", "4", (6, 8), label: (content: $L_7$, anchor: "bottom"))
    capacitor-better("C7", (6, 8), "3", label: (content: $C_7$, anchor: "bottom"))
  })
) <meg-zgen>

== Расчет искомого тока
По теореме об эквивалентном генераторе определим ток в пятой ветви:
#let I5_meg = div(U_xx, add(Z_gen, Z5))
#mathtype-mimic(receive: true)[
  $ dot(I)_5 = dot(U)_(x x) / (dot(Z)_"ген" + dot(Z)_5) = (#display-complex(U_xx).polar) / (#display-complex(Z_gen).rect + j #V.XL5) = #display-complex(I5_meg).polar " А". $
]
Полученное значение тока полностью совпадает со значением, вычисленным ранее методом эквивалентных преобразований.

/*
ПОЯСНЕНИЕ ДЛЯ ТЕБЯ: ЧТО ПРОИСХОДИТ В MATHCAD
------------------------------------------
Пункт 6: Метод законов Кирхгофа (МЗК)
Это самый прямой метод "в лоб". Матрица A1 — это "карта" схемы.
Первые 5 строк — это 1-й закон Кирхгофа (узлы). 1 означает, что ток выходит из узла, -1 — входит.
Последние 2 строки — это 2-й закон Кирхгофа (контуры). Мы суммируем падения напряжения (I*Z) по двум окнам схемы.
B1 — это столбец "движущих сил" (источники тока для узлов и ЭДС для контуров).
Решая x = A1^-1 * B1, мы находим токи во всех ветвях сразу.

Пункт 7: Метод контурных токов (МКТ)
Здесь мы вводим виртуальные "контурные токи", которые бегают по кругу в окнах схемы.
Матрица B показывает, какие ветви образуют эти окна.
IK — это сами контурные токи. Чтобы получить реальные токи (Imkt), мы смотрим,
какие контурные токи текут через конкретную ветвь. Если через ветвь 1 течет только
первый контурный ток, то I1 = IK1.

Пункт 8: Метод узловых напряжений (МУН)
Мы "заземляем" один узел (узел 6, потенциал = 0) и ищем потенциалы остальных узлов (вектор F).
Матрица A связывает ветви и узлы. G — это матрица проводимостей (1/Z).
Зная потенциалы узлов, мы находим напряжение на каждой ветви как разность потенциалов (U = A^T * F).
Затем по закону Ома для ветви находим токи: I = U/Z + J + E/Z.
*/

= Определение токов в ветвях исходной схемы методом законов Кирхгофа

Для проверки аналитических расчетов была составлена система уравнений по законам Кирхгофа и решена в среде Mathcad.
#figure(image("mathcad/mathcad6.png", width: 85%), numbering: none)

#block(breakable: false)[
#set par(spacing: 0.8em)
/*
Кратко для тебя:
Ikir — это итоговый результат, вектор токов во всех 7 ветвях.
A1 — матрица, объединяющая уравнения узлов (1-й закон) и контуров (2-й закон).
B1 — столбец, куда ушли все известные значения источников (токи и ЭДС).
*/
Где $I k i r$ – вектор действующих значений токов в ветвях цепи;

#h(1.7em) $A 1$ – матрица коэффициентов системы уравнений по первому и второму законам Кирхгофа;

#h(1.7em) $B 1$ – вектор правых частей системы уравнений (алгебраические суммы токов и ЭДС источников).
]

= Определение токов в ветвях исходной схемы методом контурных токов

#figure(image("mathcad/mathcad7.png", width: 65%), numbering: none)

#block(breakable: false)[
#set par(spacing: 0.8em)
Где $Z D = op("diag")(Z)$ – диагональная матрица комплексных сопротивлений;

#h(1.7em) $B$ – контурная матрица;

#h(1.7em) $E$ и $J$ – векторы источников ЭДС и тока;

#h(1.7em) $I K$ – вектор контурных токов;

#h(1.7em) $I m k t$ – итоговый вектор токов в ветвях цепи.
]


= Определение токов в ветвях исходной схемы методом узловых напряжений

#figure(image("mathcad/mathcad8.png", width: 65%), numbering: none)

#block(breakable: false)[
#set par(spacing: 0.8em)
Где $A$ – узловая матрица инциденций;

#h(1.7em) $G$ – диагональная матрица проводимостей ветвей;

#h(1.7em) $F$ – вектор узловых потенциалов относительно базисного узла;

#h(1.7em) $U$ – вектор напряжений на ветвях;

#h(1.7em) $I m u n$ – итоговый вектор токов в ветвях.
]

= Таблица ответов

// Хелпер для быстрой генерации строк таблицы
#let tbl_row(name, complex_val) = {
  let r = complex-math.to-rect(complex_val)
  let p = complex-math.to-polar(complex_val)
  (
    name,
    _fmt(r.re, digits: 3),
    _fmt(r.im, digits: 3),
    _fmt(p.mag, digits: 3),
    _fmt(p.ang, digits: 3)
  )
}

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    table.header(
      table.cell(rowspan: 2)[Параметр],
      table.cell(colspan: 2)[Алгебраическая форма],
      table.cell(colspan: 2)[Показательная форма],
      [$"Re"$], [$"Im"$], [Модуль], [Арг., град.]
    ),
    ..tbl_row([Ток $dot(I)_1$, А], I1),
    ..tbl_row([Ток $dot(I)_2$, А], I2),
    ..tbl_row([Ток $dot(I)_3$, А], I3),
    ..tbl_row([Ток $dot(I)_4$, А], I4),
    ..tbl_row([Ток $dot(I)_5$, А], I5),
    ..tbl_row([Ток $dot(I)_6$, А], I6),
    ..tbl_row([Ток $dot(I)_7$, А], I7),
    ..tbl_row([Мощность $dot(S)_"ист"$, ВА], S_source),
    ..tbl_row([Мощность $dot(S)_"потр"$, ВА], S_load),
    ..tbl_row([$dot(U)_(x x)$, В], U_xx),
    ..tbl_row([$dot(Z)_"ген"$, Ом], Z_gen),
  )
)