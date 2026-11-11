T = {
 'RAZA':[('id_raza','INT','PK'),('nombre','VARCHAR(50)','UQ'),('proposito','VARCHAR(20)',''),('peso_adulto_kg','DECIMAL(6,2)','')],
 'POTRERO':[('id_potrero','INT','PK'),('nombre','VARCHAR(50)','UQ'),('area_ha','DECIMAL(6,2)',''),('tipo_pasto','VARCHAR(40)',''),('capacidad','INT','')],
 'VETERINARIO':[('id_veterinario','INT','PK'),('cedula','CHAR(10)','UQ'),('nombres','VARCHAR(80)',''),('apellidos','VARCHAR(80)',''),('telefono','VARCHAR(15)','')],
 'ALIMENTO':[('id_alimento','INT','PK'),('nombre','VARCHAR(60)','UQ'),('tipo','VARCHAR(20)',''),('costo_kg','DECIMAL(8,2)','')],
 'ANIMAL':[('id_animal','INT','PK'),('arete','VARCHAR(15)','UQ'),('nombre','VARCHAR(40)',''),('sexo','CHAR(1)',''),('fecha_nacimiento','DATE',''),('peso_nacimiento_kg','DECIMAL(5,2)',''),('estado','VARCHAR(15)',''),('estado_reproductivo','VARCHAR(15)',''),('id_raza','INT','FK'),('id_potrero','INT','FK'),('id_madre','INT','FK'),('id_padre','INT','FK')],
 'CONSUMO_ALIMENTO':[('id_consumo','INT','PK'),('id_animal','INT','FK'),('id_alimento','INT','FK'),('fecha','DATE',''),('cantidad_kg','DECIMAL(6,2)','')],
 'CELO':[('id_celo','INT','PK'),('id_animal','INT','FK'),('fecha_inicio','DATE',''),('duracion_horas','INT',''),('intensidad','VARCHAR(10)',''),('observaciones','VARCHAR(150)',''),('fecha_proximo_celo','DATE (derivado)','')],
 'SERVICIO':[('id_servicio','INT','PK'),('id_hembra','INT','FK'),('id_toro','INT','FK'),('id_celo','INT','FK'),('fecha_servicio','DATE',''),('tipo','VARCHAR(25)',''),('resultado','VARCHAR(15)',''),('fecha_probable_parto','DATE (derivado)','')],
 'PARTO':[('id_parto','INT','PK'),('id_servicio','INT','FK,UQ'),('id_cria','INT','FK'),('fecha_parto','DATE',''),('tipo_parto','VARCHAR(15)','')],
 'CONTROL_SANITARIO':[('id_control','INT','PK'),('id_animal','INT','FK'),('id_veterinario','INT','FK'),('fecha','DATE',''),('tipo','VARCHAR(20)',''),('producto','VARCHAR(60)',''),('observaciones','VARCHAR(150)','')],
}
FK=[('ANIMAL','id_raza','RAZA'),('ANIMAL','id_potrero','POTRERO'),('ANIMAL','id_madre','ANIMAL'),('ANIMAL','id_padre','ANIMAL'),
 ('CONSUMO_ALIMENTO','id_animal','ANIMAL'),('CONSUMO_ALIMENTO','id_alimento','ALIMENTO'),('CELO','id_animal','ANIMAL'),
 ('SERVICIO','id_hembra','ANIMAL'),('SERVICIO','id_toro','ANIMAL'),('SERVICIO','id_celo','CELO'),
 ('PARTO','id_servicio','SERVICIO'),('PARTO','id_cria','ANIMAL'),('CONTROL_SANITARIO','id_animal','ANIMAL'),('CONTROL_SANITARIO','id_veterinario','VETERINARIO')]
L=['digraph G {','splines=line; outputorder=edgesfirst; bgcolor=white;','node [shape=plain, fontname="Helvetica", fontsize=11]; edge [color="#444444", arrowhead=crow, arrowtail=tee, dir=both, penwidth=1.2];']
H={'RAZA':100,'POTRERO':120,'VETERINARIO':120,'CONTROL_SANITARIO':160,'ALIMENTO':100,'CONSUMO_ALIMENTO':120,'ANIMAL':263,'CELO':160,'SERVICIO':180,'PARTO':120}
COLS=[(110,['RAZA','POTRERO','VETERINARIO','CONTROL_SANITARIO']),(450,['ALIMENTO','CONSUMO_ALIMENTO','ANIMAL']),(790,['CELO','SERVICIO','PARTO'])]
POS={}
for x,names in COLS:
    y=700
    for n in names:
        POS[n]=(x,y-H[n]/2); y-=H[n]+45
for t,cols in T.items():
    r=f'<TR><TD COLSPAN="3" BGCOLOR="#2f6b3a"><FONT COLOR="white"><B>{t}</B></FONT></TD></TR>'
    for n,ty,k in cols:
        bg='#fff3c4' if k.startswith('PK') else ('#dbe8fb' if 'FK' in k else 'white')
        nm=f'<B>{n}</B>' if k=='PK' else (f'<I>{n}</I>' if 'FK' in k else n)
        r+=f'<TR><TD ALIGN="LEFT" BGCOLOR="{bg}" PORT="{n}">{nm}</TD><TD ALIGN="LEFT" BGCOLOR="{bg}"><FONT POINT-SIZE="9">{ty}</FONT></TD><TD BGCOLOR="{bg}">{('<FONT POINT-SIZE="9">'+k+'</FONT>') if k else ' '}</TD></TR>'
    L.append(f'"{t}" [pos="{POS[t][0]},{POS[t][1]}", label=<<TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="3">{r}</TABLE>>];')
for a,c,b in FK:
    pk=T[b][0][0]
    L.append(f'"{b}" -> "{a}" [arrowhead=crow, arrowtail=tee, label=" {c}", fontname="Helvetica", fontsize=13, fontcolor="#1a4d8f"];')
L.append('}')
open('rel.dot','w').write('\n'.join(L))
