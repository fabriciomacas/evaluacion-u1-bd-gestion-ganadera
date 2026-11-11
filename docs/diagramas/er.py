import subprocess
ents = {
 'RAZA':['*id_raza','nombre','proposito','peso_adulto_kg'],
 'POTRERO':['*id_potrero','nombre','area_ha','tipo_pasto','capacidad'],
 'VETERINARIO':['*id_veterinario','cedula','nombres','apellidos','telefono'],
 'ALIMENTO':['*id_alimento','nombre','tipo','costo_kg'],
 'ANIMAL':['*id_animal','arete','nombre','sexo','fecha_nacimiento','peso_nacimiento_kg','estado','estado_reproductivo'],
 'CELO':['*id_celo','fecha_inicio','duracion_horas','intensidad','observaciones','~fecha_proximo_celo'],
 'SERVICIO':['*id_servicio','fecha_servicio','tipo','resultado','~fecha_probable_parto'],
 'PARTO':['*id_parto','fecha_parto','tipo_parto'],
 'CONTROL_SANITARIO':['*id_control','fecha','tipo','producto','observaciones'],
}
rels = [ # name, a, card_a, b, card_b
 ('pertenece_a','ANIMAL','N','RAZA','1'),
 ('pastorea_en','ANIMAL','N','POTRERO','1'),
 ('es_madre_de','ANIMAL','1','ANIMAL','N'),
 ('consume','ANIMAL','N','ALIMENTO','M'),
 ('presenta','ANIMAL','1','CELO','N'),
 ('recibe (hembra)','ANIMAL','1','SERVICIO','N'),
 ('aporta (toro)','ANIMAL','1','SERVICIO','N'),
 ('se_origina_en','CELO','1','SERVICIO','1'),
 ('resulta_en','SERVICIO','1','PARTO','1'),
 ('nace_en','PARTO','1','ANIMAL','1'),
 ('recibe_control','ANIMAL','1','CONTROL_SANITARIO','N'),
 ('realiza','VETERINARIO','1','CONTROL_SANITARIO','N'),
]
L=['graph G {','layout=neato; overlap=false; splines=true; sep="+3"; outputorder=edgesfirst; bgcolor=white;',
 'node [fontname="Helvetica", fontsize=11]; edge [fontname="Helvetica", fontsize=11, color="#555555"];']
for e,attrs in ents.items():
    L.append(f'"{e}" [shape=box, style="filled,bold", fillcolor="#dfeedd", fontsize=20, margin="0.25,0.14", label=<<B>{e}</B>>];')
    for a in attrs:
        n=a.lstrip('*~'); nid=f'{e}.{n}'
        if a[0]=='*': lab=f'<<U>{n}</U>>'; sty='filled'
        elif a[0]=='~': lab=f'<{n}>'; sty='dashed,filled'
        else: lab=f'<{n}>'; sty='filled'
        L.append(f'"{nid}" [shape=ellipse, style="{sty}", fillcolor="#fff8dc", fontsize=14, label={lab}, margin="0.04,0.02"];')
        L.append(f'"{e}" -- "{nid}" [len=1.0, color="#888888", penwidth=0.8];')
for i,(n,a,ca,b,cb) in enumerate(rels):
    rid=f'R{i}'
    L.append(f'"{rid}" [shape=diamond, style=filled, fillcolor="#d9e6f7", fontsize=13, label="{n}", margin="0.02,0.02"];')
    ln=3.0 if n in ('realiza','consume','nace_en') else 2.0
    L.append(f'"{a}" -- "{rid}" [label="{ca}", len={ln}, penwidth=1.4, fontcolor="#b00000", fontsize=18];')
    L.append(f'"{rid}" -- "{b}" [label="{cb}", len={ln}, penwidth=1.4, fontcolor="#b00000", fontsize=18];')
for n in ['fecha','cantidad_kg']:
    L.append(f'"c.{n}" [shape=ellipse, style=filled, fillcolor="#fff8dc", fontsize=14, label="{n}", margin="0.04,0.02"];')
    L.append(f'"R3" -- "c.{n}" [len=0.9, color="#888888", penwidth=0.8];')
L.append('}')
open('er.dot','w').write('\n'.join(L))
