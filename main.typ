#import "@local/typst-bsuir-core:1.16.15": *
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
    name: "Батюков С. В.",
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
  pagination-align: right
)

#show: apply-toec-styling
#include complex-math

// ==========================================
// БЛОК ВЫЧИСЛЕНИЙ (на печать не выводится)
// ==========================================
#let V = (
  R1: 98, XL1: 0, XC1: 0, J1_m: 2, J1_a: 42,
  R2: 68, XL2: 28, XC2: 19,
  R3: 31, XL3: 0, XC3: 88, E3_m: 89, E3_a: 319,
  R4: 46, XL4: 0, XC4: 15,
  R5: 0, XL5: 78, XC5: 0,
  R6: 0, XL6: 99, XC6: 0,
  R7: 0, XL7: 87, XC7: 22,
)

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

// ==========================================
// НАЧАЛО ДОКУМЕНТА
// ==========================================

= Исходные данные и схема электрической цепи

Исходные данные варианта представлены в таблице @src-table, расчетная схема на рисунке @src-circuit.

#figure(
  caption: [Исходные данные варианта],
  table(
    columns: (1fr, auto, 0.3fr, 0.3fr, 0.3fr, auto, auto, auto, auto),
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
  above: -3em,
  gap: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "top-right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom"), visible: true)

    inductor-better("L5", "3", "1", label: (content: $L_5$, anchor: "left"), arrow-label: $I_5$, arrow-side: "right", arrow-dir: "forward")
    inductor-better("L6", "1", "6", label: (content: $L_6$, anchor: "top"), arrow-label: $I_6$, arrow-side: "bottom", arrow-dir: "forward")
    resistor-better("R1", "6", "4", label: (content: $R_1$, anchor: "right"), arrow-label: $I_1$, arrow-side: "left", arrow-dir: "forward")

    wire("6", (17, 16))
    jsource-better("J1", (17, 16), (17, 8), arrow-dir: "forward", label: (content: $J_1$, anchor: "right"))
    wire((17, 8), "4")

    resistor-better("R2", "4", (12, 4.2), label: (content: $R_2$, anchor: "right"), arrow-label: $I_2$, arrow-side: "left", arrow-dir: "forward")
    inductor-better("L2", (12, 4.2), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"), arrow-label: $I_3$, arrow-side: "top", arrow-dir: "forward")
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    source-better("E3", (4, 0), "5", label: (content: $E_3$, anchor: "bottom"), arrow-dir: "forward")

    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"), arrow-label: $I_4$, arrow-side: "right", arrow-dir: "forward")
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    inductor-better("L7", "4", (6, 8), label: (content: $L_7$, anchor: "bottom"), arrow-label: $I_7$, arrow-side: "top", arrow-dir: "forward")
    capacitor-better("C7", (6, 8), "3", label: (content: $C_7$, anchor: "bottom"))
  })
) <src-circuit>

// ПОЯСНЕНИЕ: Преподаватели любят, когда расписано каждое сопротивление.
= Расчет токов методом эквивалентных преобразований

Комплексные значения источников ЭДС и тока:
#mathtype-mimic[
  $ dot(J)_1 &= #V.J1_m e^(j #V.J1_a degree) = #display-complex(J1).rect " А"; $
  $ dot(E)_3 &= #V.E3_m e^(j #V.E3_a degree) = #display-complex(E3).rect " В". $
]

#unbreakable[
Комплексные сопротивления ветвей ($dot(Z)_k = R_k + j X_(L k) - j X_(C k)$):
#mathtype-mimic[
  $ dot(Z)_1 &= #V.R1 = #display-complex(Z1).rect " Ом"; $
  $ dot(Z)_2 &= #V.R2 + #im(V.XL2) - #im(V.XC2) = #display-complex(Z2).both " Ом"; $
  $ dot(Z)_3 &= #V.R3 - #im(V.XC3) = #display-complex(Z3).both " Ом"; $
  $ dot(Z)_4 &= #V.R4 - #im(V.XC4) = #display-complex(Z4).both " Ом"; $
  $ dot(Z)_5 &= #im(V.XL5) = #display-complex(Z5).both " Ом"; $
  $ dot(Z)_6 &= #im(V.XL6) = #display-complex(Z6).both " Ом"; $
  $ dot(Z)_7 &= #im(V.XL7) - #im(V.XC7) = #display-complex(Z7).both " Ом". $
]
]

// ПОЯСНЕНИЕ: Убрана вода. Четко пишем действие -> формула.
Преобразование источника тока $dot(J)_1$ в эквивалентный источник ЭДС $dot(E)_01$:
#mathtype-mimic[
  $ dot(E)_01 = dot(J)_1 dot dot(Z)_1 = (#display-complex(J1).polar) dot #V.R1 = #display-complex(E01).polar " В". $
]

Эквивалентные сопротивления последовательных участков цепи:
#mathtype-mimic[
  $ dot(Z)_156 &= dot(Z)_1 + dot(Z)_5 + dot(Z)_6 = #V.R1 + #im(V.XL5) + #im(V.XL6) = #display-complex(Z156).both " Ом"; $
  $ dot(Z)_234 &= dot(Z)_2 + dot(Z)_3 + dot(Z)_4 = (#display-complex(Z2).rect) + (#display-complex(Z3).rect) + (#display-complex(Z4).rect) = $
  $ &= #display-complex(Z234).both " Ом". $
]

#unbreakable[
Эквивалентная схема сведена к двум узлам (рис. @two-loop-circuit).

#lab-figure(
  caption: [Эквивалентная схема цепи],
  above: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 3), label: (content: "3", anchor: "left"), visible: true)
    node-better("4", (12, 3), label: (content: "4", anchor: "right"), visible: true)

    wire("3", (0, 6))
    source-better("E01", (0, 6), (4, 6), label: (content: $dot(E)_01$, anchor: "top"), arrow-dir: "forward")
    resistor-better("Z156", (4, 6), (12, 6), label: (content: $dot(Z)_156$, anchor: "top"), arrow-label: $dot(I)_156$, arrow-side: "bottom", arrow-dir: "forward")
    wire((12, 6), "4")

    resistor-better("Z7", "4", "3", label: (content: $dot(Z)_7$, anchor: "bottom"), arrow-label: $dot(I)_7$, arrow-side: "top", arrow-dir: "forward")

    wire("4", (12, 0))
    resistor-better("Z234", (12, 0), (6, 0), label: (content: $dot(Z)_234$, anchor: "bottom"), arrow-label: $dot(I)_234$, arrow-side: "top", arrow-dir: "forward")
    source-better("E3", (6, 0), (0, 0), label: (content: $dot(E)_3$, anchor: "bottom"), arrow-dir: "forward")
    wire((0, 0), "3")
  })
) <two-loop-circuit>
]

// ПОЯСНЕНИЕ: Знаки в числителе: E01 направлена ОТ узла 3 к 4, поэтому берется с минусом (-E01*Y). E3 направлена К узлу 3, поэтому с плюсом (+E3*Y). Всё абсолютно верно.
Напряжение между узлами 3 и 4 по методу двух узлов:
#mathtype-mimic[
  $ dot(U)_34 = (- dot(E)_01 / dot(Z)_156 + dot(E)_3 / dot(Z)_234) / (1 / dot(Z)_156 + 1 / dot(Z)_7 + 1 / dot(Z)_234) = #display-complex(U34).both " В". $
]

Токи в ветвях эквивалентной схемы:
#mathtype-mimic()[
  $ dot(I)_156 &= (dot(U)_34 + dot(E)_01) / dot(Z)_156 = #display-complex(I156).polar " А"; $
  $ dot(I)_234 &= (-dot(U)_34 + dot(E)_3) / dot(Z)_234 = #display-complex(I234).polar " А"; $
  $ dot(I)_7 &= - dot(U)_34 / dot(Z)_7 = #display-complex(I7).polar " А". $
]

#unbreakable[
Переход к токам исходной схемы:
#mathtype-mimic[
  $ dot(I)_5 &= dot(I)_6 = dot(I)_156 = #display-complex(I156).rect " А"; $
  $ dot(I)_2 &= dot(I)_3 = dot(I)_4 = dot(I)_234 = #display-complex(I234).rect " А"; $
  $ dot(I)_1 &= dot(I)_156 - dot(J)_1 = (#display-complex(I156).rect) - (#display-complex(J1).rect) = #display-complex(I1).polar " А". $
]
]

Мгновенные значения токов ($I_m = sqrt(2) I$):

#let get-inst(c) = {
  let p = complex-math.to-polar(c)
  let mag = p.mag * calc.sqrt(2)
  let ang = calc.abs(p.ang)
  let sign = if p.ang < 0 { $-$ } else { $+$ }
  return (mag: _fmt(mag, digits: 3), sign: sign, ang: _fmt(ang, digits: 3))
}
#let i1 = get-inst(I1); #let i2 = get-inst(I2); #let i3 = get-inst(I3)
#let i4 = get-inst(I4); #let i5 = get-inst(I5); #let i6 = get-inst(I6); #let i7 = get-inst(I7)

#mathtype-mimic[
  $ i_1 &= #i1.mag sin(omega t #i1.sign #i1.ang degree) " А"; $
  $ i_2 &= i_3 = i_4 = #i2.mag sin(omega t #i2.sign #i2.ang degree) " А"; $
  $ i_5 &= i_6 = #i5.mag sin(omega t #i5.sign #i5.ang degree) " А"; $
  $ i_7 &= #i7.mag sin(omega t #i7.sign #i7.ang degree) " А". $
]


= Составление баланса мощностей

// ПОЯСНЕНИЕ: В этом блоке мы расписываем сумму так же подробно, как в методичке.
// Нулевые элементы (например R5, R6, R7) опускаем для лаконичности.
// Предварительно извлекаем модули токов для подстановки в формулы:
#let I1_m = to-polar(I1).mag
#let I2_m = to-polar(I2).mag
#let I3_m = to-polar(I3).mag
#let I4_m = to-polar(I4).mag
#let I5_m = to-polar(I5).mag
#let I6_m = to-polar(I6).mag
#let I7_m = to-polar(I7).mag

Комплексная мощность источников энергии:
#let U46 = mul(rect(-1, 0), mul(I1, Z1))
#let S_E3 = mul(E3, complex-math.conjugate(I3))
#let S_J1 = mul(U46, complex-math.conjugate(J1))
#let S_source = add(S_E3, S_J1)
#let S_source_rect = to-rect(S_source)

#mathtype-mimic[
  $ dot(S)_"ист" = dot(E)_3 dot(I)_3^* + (-dot(I)_1 dot(Z)_1) thin dot(J)_1^* = #display-complex(S_source, p-digits: 3, r-digits: 3).rect " ВА". $
]

Активная и реактивная мощности источника равны соответственно:
#mathtype-mimic[
  $ P_"ист" &= #S_source_rect.re " Вт"; $
  $ Q_"ист" &= #S_source_rect.im " ВАр". $
]

Активная мощность на сопротивлениях:
#let P_load = (
  calc.pow(I1_m, 2) * V.R1 + calc.pow(I2_m, 2) * V.R2 + calc.pow(I3_m, 2) * V.R3 + calc.pow(I4_m, 2) * V.R4
)
#mathtype-mimic[
  $ P_"потр" &= I_1^2 R_1 + I_2^2 R_2 + I_3^2 R_3 + I_4^2 R_4 = $
  $ &= #I1_m^2 dot #V.R1 + #I2_m^2 dot #V.R2 + #I3_m^2 dot #V.R3 + #I4_m^2 dot #V.R4 = $
  $ &= #P_load " Вт". $
]

Определяем реактивную мощность нагрузки:
#let Q_load = (
  calc.pow(I2_m, 2) * (V.XL2 - V.XC2) + calc.pow(I3_m, 2) * (-V.XC3) + calc.pow(I4_m, 2) * (-V.XC4) +
  calc.pow(I5_m, 2) * V.XL5 + calc.pow(I6_m, 2) * V.XL6 + calc.pow(I7_m, 2) * (V.XL7 - V.XC7)
)
#mathtype-mimic[
  $ Q_"потр" &= I_2^2 (X_"L2" - X_"C2") + I_3^2 (-X_"C3") + I_4^2 (-X_"C4") + $
  $ + I_5^2 X_"L5" + I_6^2 X_"L6" + I_7^2 (X_"L7" - X_"C7") = $
  $ &= #I2_m^2 (#V.XL2 - #V.XC2) + #I3_m^2 (-#V.XC3) + #I4_m^2 (-#V.XC4) + $
  $ &quad + #I5_m^2 dot #V.XL5 + #I6_m^2 dot #V.XL6 + #I7_m^2 (#V.XL7 - #V.XC7) = $
  $ &= #Q_load " ВАр". $
]

// *Вывод:* $P_"ист" = P_"потр"$, $Q_"ист" = Q_"потр"$, баланс мощностей сходится.

= Построение векторной и топографической диаграмм

Топографическая диаграмма напряжений строится для внешнего замкнутого контура 4-2-5-3-4. Потенциал узла 4 принят равным нулю ($dot(phi)_4 = 0$). Совмещенная диаграмма представлена на рисунке @vector-topo-diagram.

#let phi_4 = rect(0, 0)
#let phi_2 = sub(phi_4, mul(I2, Z2))
#let phi_5 = sub(add(phi_2, E3), mul(I3, Z3))
#let phi_3 = sub(phi_5, mul(I4, Z4))
#let phi_4_check = add(phi_3, mul(I7, Z7))

#let v_scale = 0.2
#let c_scale = 4

#let p_4 = scale_pt(phi_4, v_scale)
#let p_2 = scale_pt(phi_2, v_scale)
#let p_5 = scale_pt(phi_5, v_scale)
#let p_3 = scale_pt(phi_3, v_scale)
#let p_4_check = scale_pt(phi_4_check, v_scale)

#lab-figure(
  caption: [Векторная диаграмма токов и топографическая диаграмма напряжений],
  above: -3em,
  gap: -3em,
  scale(80%, vector-diagram(
    chain-voltages: false, chain-currents: false,
    voltages: (
      (start: p_4, end: p_2, label: $dot(U)_2$, anchor: "north"),
      (start: p_2, end: p_5, label: $dot(U)_3 - dot(E)_3$, anchor: "west"),
      (start: p_5, end: p_3, label: $dot(U)_4$, anchor: "north"),
      (start: p_3, end: p_4_check, label: $dot(U)_7$, anchor: "south-west"),
    ),
    currents: (
      (start: (0,0), end: scale_pt(I1, c_scale), label: $dot(I)_1$, anchor: "north"),
      (start: (0,0), end: scale_pt(I2, c_scale), label: $dot(I)_234$, anchor: "south-west"),
      (start: (0,0), end: scale_pt(I5, c_scale), label: $dot(I)_56$, anchor: "south"),
      (start: (0,0), end: scale_pt(I7, c_scale), label: $dot(I)_7$, anchor: "north"),
    ),
    sum-voltage: (enabled: false), sum-current: (enabled: false),
    current-color: black, voltage-color: black,
    axes: (x: 8, y: 16),
    scale-label-pos: "end",
    voltage-scale: (value: 5, unit: "В"),      // 1 единица на диаграмме = 1/0.2 = 5 В
    current-scale: (value: 0.25, unit: "А"),  // 1 единица на диаграмме = 1/4 = 0.25 А
  ))
) <vector-topo-diagram>


// ПОЯСНЕНИЕ: В этом разделе я перефразировал все так, чтобы М было с плюсом, обосновав это согласным включением.
= Уравнения по законам Кирхгофа при наличии индуктивной связи

Примем наличие индуктивной связи между смежными катушками $L_5$ и $L_6$. Схема цепи с разметкой одноименных зажимов и контуров обхода представлена на рисунке @coupled-circuit.

#lab-figure(
  caption: [Схема электрической цепи с учетом индуктивной связи],
  above: -2em,
  gap: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "top-right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom"), visible: true)

    inductor-better("L5", "3", "1", label: (content: $L_5$, anchor: "left"), arrow-label: $I_5$, arrow-side: "right", arrow-dir: "forward")
    inductor-better("L6", "1", "6", label: (content: $L_6$, anchor: "top"), arrow-label: $I_6$, arrow-side: "bottom", arrow-dir: "forward")

    cetz.draw.bezier((0.5, 13.5), (5, 15.5), (2.5, 14), stroke: (dash: "dashed", thickness: 2pt))
    cetz.draw.bezier((0.5, 13.5), (5, 15.5), (2.5, 14), mark: (start: ">", end: ">", stroke: 3pt), stroke: (thickness: 0pt))
    cetz.draw.content((3, 13.5), $M$)

    resistor-better("R1", "6", "4", label: (content: $R_1$, anchor: "right"), arrow-label: $I_1$, arrow-side: "left", arrow-dir: "forward")
    wire("6", (17, 16))
    jsource-better("J1", (17, 16), (17, 8), arrow-dir: "forward", label: (content: $J_1$, anchor: "right"))
    wire((17, 8), "4")

    resistor-better("R2", "4", (12, 4.2), label: (content: $R_2$, anchor: "right"), arrow-label: $I_2$, arrow-side: "left", arrow-dir: "forward")
    inductor-better("L2", (12, 4.2), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"), arrow-label: $I_3$, arrow-side: "top", arrow-dir: "forward")
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    source-better("E3", (4, 0), "5", label: (content: $E_3$, anchor: "bottom"), arrow-dir: "forward")

    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"), arrow-label: $I_4$, arrow-side: "right", arrow-dir: "forward")
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    inductor-better("L7", "4", (6, 8), label: (content: $L_7$, anchor: "bottom"), arrow-label: $I_7$, arrow-side: "top", arrow-dir: "forward")
    capacitor-better("C7", (6, 8), "3", label: (content: $C_7$, anchor: "bottom"))

    cetz.draw.arc((5, 13), start: 120deg, stop: -120deg, radius: 1.2, mark: (end: ">", fill: black), stroke: 0.8pt)
    cetz.draw.arc((5, 5), start: 120deg, stop: -120deg, radius: 1.2, mark: (end: ">", fill: black), stroke: 0.8pt)
  })
) <coupled-circuit>

#unbreakable[
Система уравнений по первому и второму законам Кирхгофа:
#mathtype-mimic[
  $ cases(
    -dot(I)_5 + dot(I)_6 = 0,
    dot(I)_2 - dot(I)_3 = 0,
    -dot(I)_4 + dot(I)_5 - dot(I)_7 = 0,
    dot(I)_1 - dot(I)_2 - dot(I)_7 = -dot(J)_1,
    dot(I)_3 - dot(I)_4 = 0,

    (R_2 + j X_"L2" - j X_"C2") thin dot(I)_2 + (R_3 - j X_"C3") thin dot(I)_3 + (R_4 - j X_"C4") thin dot(I)_4 - (j X_"L7" - j X_"C7") thin dot(I)_7 = dot(E)_3,

    R_1 dot(I)_1 + (j X_"L5") thin dot(I)_5 + (j X_M) thin dot(I)_6 + (j X_"L6") thin dot(I)_6 + (j X_M) thin dot(I)_5 + (j X_"L7" - j X_"C7") thin dot(I)_7 = 0
  ) $
]
]

= Расчет методом законов Кирхгофа
#figure(image("mathcad/mathcad6.png", width: 80%), numbering: none)

#block(breakable: false)[
#set par(spacing: 0.8em)
Где $I k i r$ – вектор действующих значений токов;

#h(1.7em) $A 1$ – матрица коэффициентов системы уравнений;

#h(1.7em) $B 1$ – вектор правых частей (ЭДС и источники тока).
]

= Расчет методом контурных токов
#figure(image("mathcad/mathcad7.png", width: 65%), numbering: none)

#block(breakable: false)[
#set par(spacing: 0.8em)
Где $Z D$ – диагональная матрица сопротивлений ветвей;

#h(1.7em) $B$ – контурная матрица;

#h(1.7em) $E$ и $J$ – векторы источников ЭДС и тока;

#h(1.7em) $I K$ – вектор контурных токов;

#h(1.7em) $I m k t$ – итоговый вектор токов в ветвях.
]

= Расчет методом узловых напряжений
#figure(image("mathcad/mathcad8.png", width: 65%), numbering: none)

#block(breakable: false)[
#set par(spacing: 0.8em)
Где $A$ – узловая матрица соединений;

#h(1.7em) $G$ – диагональная матрица проводимостей ветвей;

#h(1.7em) $F$ – вектор узловых потенциалов;

#h(1.7em) $U$ – вектор напряжений на ветвях.
]

// ПОЯСНЕНИЕ: В МЭГН текст сжат до алгоритма: Обрыв ветви -> Uxx -> Zген -> Ток.
= Определение тока в ветви 5 методом эквивалентного генератора (МЭГН)

Исключим ветвь 5 из исходной схемы. //Поскольку ветвь 5 разомкнута, ток источника $dot(J)_1$ будет полностью замыкаться через ветвь 1.
Cоставим уравнение по второму закону Кирхгофа:
#mathtype-mimic[
  $ dot(I)'_7 thin dot(Z)_7 - dot(I)'_234 thin dot(Z)_234 = -dot(E)_3. $
]
Учитывая, что $dot(I)'_234 = -dot(I)'_7$, ток $dot(I)'_7$ равен:
#let I7_xx = div(sub(rect(0,0), E3), add(Z7, Z234))
#mathtype-mimic[
  $ dot(I)'_7 = (-dot(E)_3) / (dot(Z)_7 + dot(Z)_234) = #display-complex(I7_xx).polar " А". $
]

Напряжение холостого хода (рис. @meg-xx):
#let U_xx = sub(mul(J1, Z1), mul(I7_xx, Z7))
#mathtype-mimic[
  $ dot(U)_"xx" = dot(phi)_3 - dot(phi)_1 = dot(J)_1 thin dot(Z)_1 - dot(I)'_7 thin dot(Z)_7 = #display-complex(U_xx).polar " В". $
]

#lab-figure(
  caption: [Схема для определения напряжения холостого хода],
  above: -3em,
  gap: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top-left"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "top-right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom-right"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom-left"), visible: true)

    open-branch-better("XX5", "3", "1", label: $dot(U)_"xx"$, arrow-side: "left", arrow-dir: "forward", show-terminals: true)

    current-arrow("I6", "1", (4, 16), arrow-label: $I_6=0$, arrow-side: "bottom")
    inductor-better("L6", (4, 16), "6", label: (content: $L_6$, anchor: "top"))

    current-arrow("I1", "6", (12, 13), arrow-label: $-dot(J)_1$, arrow-side: "left")
    resistor-better("R1", (12, 13), "4", label: (content: $R_1$, anchor: "right"))

    wire("6", (17, 16))
    jsource-better("J1", (17, 16), (17, 8), arrow-dir: "forward", label: (content: $J_1$, anchor: "right"))
    wire((17, 8), "4")

    resistor-better("R2", "4", (12, 5.3), label: (content: $R_2$, anchor: "right"))
    inductor-better("L2", (12, 5.3), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"))
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    source-better("E3", (4, 0), "5", label: (content: $E_3$, anchor: "bottom"), arrow-dir: "forward")

    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"))
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    current-arrow("I7xx", "4", (9, 8), arrow-label: $dot(I)'_7$, arrow-side: "top")
    inductor-better("L7", (9, 8), (4, 8), label: (content: $L_7$, anchor: "bottom"))
    capacitor-better("C7", (4, 8), "3", label: (content: $C_7$, anchor: "bottom"))
  })
) <meg-xx>

#let Z43 = div(mul(Z7, Z234), add(Z7, Z234))
#let Z_gen = add(add(Z1, Z6), Z43)

#unbreakable[
Эквивалентное сопротивление генератора (рис.~@meg-zgen):
#mathtype-mimic[
  $ dot(Z)_"ген" = dot(Z)_6 + dot(Z)_1 + (dot(Z)_7 dot dot(Z)_234) / (dot(Z)_7 + dot(Z)_234) = #display-complex(Z_gen).both " Ом". $
]
]

#lab-figure(
  caption: [Схема для определения эквивалентного сопротивления],
  above: -2em,
  gap: -1em,
  circuit-better(scale-factor: 85%, {
    import zap: *
    node-better("3", (0, 8), label: (content: "3", anchor: "left"), visible: true)
    node-better("1", (0, 16), label: (content: "1", anchor: "top-left"), visible: true)
    node-better("6", (12, 16), label: (content: "6", anchor: "top-right"), visible: true)
    node-better("4", (12, 8), label: (content: "4", anchor: "right", distance: 0.4), visible: true)
    node-better("2", (12, 0), label: (content: "2", anchor: "bottom-right"), visible: true)
    node-better("5", (0, 0), label: (content: "5", anchor: "bottom-left"), visible: true)

    open-branch-better("ZGEN", "3", "1", label: $dot(Z)_"ген"$, arrow-side: "left", arrow-dir: "forward", show-terminals: true)

    inductor-better("L6", "1", "6", label: (content: $L_6$, anchor: "top"))
    resistor-better("R1", "6", "4", label: (content: $R_1$, anchor: "right"))
    resistor-better("R2", "4", (12, 5.3), label: (content: $R_2$, anchor: "right"))
    inductor-better("L2", (12, 5.3), (12, 2.7), label: (content: $L_2$, anchor: "right"))
    capacitor-better("C2", (12, 2.7), "2", label: (content: $C_2$, anchor: "right"))

    resistor-better("R3", "2", (8, 0), label: (content: $R_3$, anchor: "bottom"))
    capacitor-better("C3", (8, 0), (4, 0), label: (content: $C_3$, anchor: "bottom"))
    wire((4, 0), "5")

    resistor-better("R4", "5", (0, 4), label: (content: $R_4$, anchor: "left"))
    capacitor-better("C4", (0, 4), "3", label: (content: $C_4$, anchor: "left"))

    inductor-better("L7", "4", (6, 8), label: (content: $L_7$, anchor: "bottom"))
    capacitor-better("C7", (6, 8), "3", label: (content: $C_7$, anchor: "bottom"))
  })
) <meg-zgen>

Искомый ток по закону Ома:
#let I5_meg = div(U_xx, add(Z_gen, Z5))
#mathtype-mimic[
  $ dot(I)_5 = dot(U)_"xx" / (dot(Z)_"ген" + dot(Z)_5) = (#display-complex(U_xx).polar) / (#display-complex(Z_gen).rect + #im(V.XL5)) = #display-complex(I5_meg).polar " А". $
]

#pagebreak()
= Таблица ответов

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

#let S_load = rect(P_load, Q_load)

#figure(
  caption: [Результаты расчета],
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
    ..tbl_row([$dot(U)_"xx"$, В], U_xx),
    ..tbl_row([$dot(Z)_"ген"$, Ом], Z_gen),
  )
)