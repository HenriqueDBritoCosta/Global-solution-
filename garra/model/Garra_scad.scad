// ================================================
//   PARÂMETROS GERAIS (Ajuste o tamanho de tudo aqui)
// ================================================
$fn = 50;                  // Resolução das curvas
passo = 6;                 // Tamanho dos dentes (espaçamento)
alt_dente = 3;             // Altura do dente
larg_dente = 3.5;          // Largura da base do dente
espessura = 6;             // Espessura de todas as peças (Z)

// Configuração dos componentes do desenho
num_dentes_crem = 20;      // Comprimento da barra central
dentes_pinhao = 10;        // Engrenagens que tocam na cremalheira
dentes_motor = 16;         // Engrenagem grande do motor (esquerda)


// ================================================
//   MÓDULOS BASE (Geometria das Peças)
// ================================================

// 1. Perfil básico do dente
module dente() {
    linear_extrude(height=espessura, center=true)
    polygon(points=[
        [0, -larg_dente/2], 
        [alt_dente, -larg_dente/4], 
        [alt_dente, larg_dente/4], 
        [0, larg_dente/2]
    ]);
}

// 2. Engrenagem Paramétrica
module engrenagem(num_dentes) {
    r_base = (num_dentes * passo) / (2 * 3.14159);
    
    difference() {
        union() {
            cylinder(h=espessura, r=r_base, center=true); // Corpo
            for(i = [0 : num_dentes-1]) {                 // Dentes
                rotate([0, 0, i * (360 / num_dentes)])
                translate([r_base - 0.5, 0, 0])
                dente();
            }
        }
        cylinder(h=espessura+2, r=2.5, center=true);     // Furo do eixo/parafuso
    }
}

// 3. Cremalheira Dupla (Barra Central)
module cremalheira(num_dentes) {
    comp_base = num_dentes * passo;
    larg_barra = 10;
    
    difference() {
        union() {
            // Barra central
            cube([comp_base, larg_barra, espessura], center=true);
            
            // Dentes Superiores
            for(i = [0 : num_dentes-1]) {
                translate([-comp_base/2 + i*passo + passo/2, larg_barra/2, 0])
                rotate([0, 0, 90]) dente();
            }
            
            // Dentes Inferiores
            for(i = [0 : num_dentes-1]) {
                translate([-comp_base/2 + i*passo + passo/2, -larg_barra/2, 0])
                rotate([0, 0, -90]) dente();
            }
        }
        // Furos guia nas pontas da barra
        translate([-comp_base/2 + passo, 0, 0]) cylinder(h=espessura+2, r=1.5, center=true);
        translate([comp_base/2 - passo, 0, 0]) cylinder(h=espessura+2, r=1.5, center=true);
    }
}

// 4. Braço da Garra (Grip) com parâmetro de rotação extra para ajuste
module garra_curva(inverter = false, rot_extra = 0) {
    s = inverter ? -1 : 1;
    rotate([0, 0, (-15 + rot_extra) * s]) {
        hull() {
            cylinder(h=espessura, r=7, center=true);
            translate([25, 15*s, 0]) cylinder(h=espessura, r=5, center=true);
        }
        hull() {
            translate([25, 15*s, 0]) cylinder(h=espessura, r=5, center=true);
            translate([45, 40*s, 0]) cylinder(h=espessura, r=4, center=true);
        }
        hull() {
            translate([45, 40*s, 0]) cylinder(h=espessura, r=4, center=true);
            translate([35, 60*s, 0]) cylinder(h=espessura, r=2, center=true); // Ponta fina
        }
    }
}


// ================================================
//   MONTAGEM DO CONJUNTO CORRIGIDO
// ================================================

r_pinhao = (dentes_pinhao * passo) / (2 * 3.14159);
r_motor = (dentes_motor * passo) / (2 * 3.14159);
dist_barra_engrenagem = 5 + r_pinhao; 

// 1. Cremalheira Central
color("LightSlateGray") cremalheira(num_dentes_crem);

// 2. LADO ESQUERDO (Atuação / Motor)
translate([-50, dist_barra_engrenagem, 0]) {
    color("Tomato") engrenagem(dentes_pinhao); 
    
    translate([-(r_pinhao + r_motor), 0, 0])
    color("Crimson") engrenagem(dentes_motor);
}

// 3. LADO DIREITO SUPERIOR (CORRIGIDO)
translate([30, dist_barra_engrenagem, 0]) {
    color("DodgerBlue") engrenagem(dentes_pinhao);
    
    ang_afastamento = 45; 
    off_x = 2 * r_pinhao * cos(ang_afastamento);
    off_y = 2 * r_pinhao * sin(ang_afastamento); // CORREÇÃO: + para afastar para CIMA
    
    translate([off_x, off_y, 0]) {
        color("MediumPurple") engrenagem(dentes_pinhao);
        color("DeepSkyBlue") garra_curva(inverter=true, rot_extra=-35);
    } // CORREÇÃO: Fechamento do translate interno
} // CORREÇÃO: Fechamento do translate externo

// 4. LADO DIREITO INFERIOR 
translate([30, -dist_barra_engrenagem, 0]) {
    color("DodgerBlue") engrenagem(dentes_pinhao); 
    
    ang_afastamento = 45; 
    off_x = 2 * r_pinhao * cos(ang_afastamento);
    off_y = -2 * r_pinhao * sin(ang_afastamento); // Manteve - para afastar para BAIXO
    
    translate([off_x, off_y, 0]) {
        color("MediumPurple") engrenagem(dentes_pinhao);
        color("Orchid") garra_curva(inverter=false, rot_extra=-35); 
    }
}